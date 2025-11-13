
-- 가정5. 청구매월 1일에 청구
DROP PROCEDURE IF EXISTS create_invoice;
DELIMITER $$
CREATE PROCEDURE create_invoice(IN p_run_dt DATE)
BEGIN
    DECLARE v_start DATE;
    DECLARE v_end   DATE;

    DECLARE v_in    DECIMAL(9,4);
    DECLARE v_out   DECIMAL(9,4);
    DECLARE v_del   DECIMAL(9,4);
    DECLARE v_store DECIMAL(9,4);

    IF p_run_dt IS NULL THEN
        SET p_run_dt = CURDATE();
    END IF;

    -- 전월 [1일, 당월 1일)
    SET v_start = DATE_FORMAT(DATE_SUB(p_run_dt, INTERVAL 1 MONTH), '%Y-%m-01');
    SET v_end   = DATE_FORMAT(p_run_dt, '%Y-%m-01');

    -- 최신 수수료(배율)
    SELECT inFeeRatePct, outFeeRatePct, delFeeRatePct, storeFeeRatePct
    INTO v_in, v_out, v_del, v_store
    FROM feeRate
    ORDER BY feeRateId DESC
    LIMIT 1;

    -- 임시 테이블: 스키마 먼저 생성 후 INSERT … SELECT
    DROP TEMPORARY TABLE IF EXISTS _t_users;
    CREATE TEMPORARY TABLE _t_users (
                                        userId VARCHAR(30) PRIMARY KEY
    );

    INSERT INTO _t_users(userId)
    SELECT DISTINCT e.userId
    FROM expense e
    WHERE e.expenseDt >= v_start
      AND e.expenseDt <  v_end
      AND e.expenseCategory IN ('inboundCost','outboundCost','deliveryCost','storageCost')
      AND IFNULL(e.isDelete,0)=0;

    -- 같은 날 생성된 draft 정리
    DELETE i
    FROM invoice i
             JOIN _t_users u ON u.userId = i.userId
    WHERE i.invoiceStatus='draft'
      AND i.invoiceDt >= v_start AND i.invoiceDt < v_end;

    -- 거래처별 합계(배율 곱, /100 제거)
    INSERT INTO invoice (invoiceDt, totalAmt, invoiceStatus, userId)
    SELECT v_start,
           ROUND(SUM(
                         CASE e.expenseCategory
                             WHEN 'inboundCost'  THEN e.totalAmt * v_in
                             WHEN 'outboundCost' THEN e.totalAmt * v_out
                             WHEN 'deliveryCost' THEN e.totalAmt * v_del
                             WHEN 'storageCost'  THEN e.totalAmt * v_store
                             ELSE 0
                             END
                 ),2) AS totalAmt,
           'draft',
           e.userId
    FROM expense e
             JOIN _t_users u ON u.userId = e.userId
    WHERE e.expenseDt >= v_start
      AND e.expenseDt <  v_end
      AND e.expenseCategory IN ('inboundCost','outboundCost','deliveryCost','storageCost')
      AND IFNULL(e.isDelete,0)=0
    GROUP BY e.userId
    HAVING ROUND(SUM(
                         CASE e.expenseCategory
                             WHEN 'inboundCost'  THEN e.totalAmt * v_in
                             WHEN 'outboundCost' THEN e.totalAmt * v_out
                             WHEN 'deliveryCost' THEN e.totalAmt * v_del
                             WHEN 'storageCost'  THEN e.totalAmt * v_store
                             ELSE 0
                             END
                 ),2) > 0;
END$$
DELIMITER ;

-- 매월 1일 00:10 실행 이벤트
SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS ev_monthly_invoice_run;
CREATE EVENT ev_monthly_invoice_run
    ON SCHEDULE EVERY 1 MONTH
        STARTS '2025-01-01 00:10:00'
    ON COMPLETION PRESERVE
    DO CALL create_invoice(curdate());

-- 매월 15일 매출 정산
DROP PROCEDURE IF EXISTS create_revenue;
DELIMITER $$
CREATE PROCEDURE create_revenue(
    IN run_dt DATETIME
)
BEGIN
    DECLARE month_start DATE;
    DECLARE month_end DATETIME;
    DECLARE inv_total DECIMAL(18, 2) DEFAULT 0;
    DECLARE exp_total DECIMAL(18, 2) DEFAULT 0;

    -- 전월 기간
    SET month_start = DATE_FORMAT(DATE_SUB(run_dt, INTERVAL 1 MONTH), '%Y-%m-01');
    SET month_end = CONCAT(LAST_DAY(DATE_SUB(run_dt, INTERVAL 1 MONTH)), ' 23:59:59');

    -- 전월 청구 합계(지급 완료)
    SELECT IFNULL(SUM(totalAmt), 0)
    INTO inv_total
    FROM invoice
    WHERE invoiceDt BETWEEN month_start AND month_end
      AND invoiceStatus = 'paid';

    -- 전월 지출 합계(확정, 미삭제)
    SELECT IFNULL(SUM(totalAmt), 0)
    INTO exp_total
    FROM expense
    WHERE expenseDt BETWEEN month_start AND month_end
      AND expenseStatus = 'posted'
      AND IFNULL(isDelete,0) = 0;

    -- 이익 = 청구 − 지출
    INSERT INTO revenue (totalAmt, revenueDt)
    VALUES (ROUND(inv_total - exp_total, 2), run_dt);
END $$
DELIMITER ;

-- 이벤트 스케줄러
SET GLOBAL event_scheduler = ON;

-- 매월 15일 02:00 실행(서버시간)
DROP EVENT IF EXISTS ev_close_monthly_revenue_all;
CREATE EVENT ev_close_monthly_revenue_all
    ON SCHEDULE EVERY 1 MONTH
        STARTS '2025-01-15 00:10:00'
    ON COMPLETION PRESERVE
    DO CALL create_revenue(CURDATE());



/*
 회원의 입고 요청을 받고 DB 테이블에 저장하는 프로시저
 */

DROP PROCEDURE IF EXISTS CreateInReq;

DELIMITER //
CREATE PROCEDURE CreateInReq(
    IN _comId VARCHAR(30),
    IN _inDttmReq DATETIME,
    IN _inDateWish DATE,
    IN _inItemsJson JSON,
    IN _isTempo TINYINT,  -- 0: 정식 저장, 1: 임시 저장
    OUT generatedInReqId BIGINT
)
BEGIN
    DECLARE newInReqId BIGINT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error creating inbound request. Transaction rolled back.';
        END;

    START TRANSACTION;

-- 1. inboundRequests 테이블에 데이터 삽입
    INSERT INTO inboundRequests (comId, inDttmReq, inDateWish, IsTempo)
    VALUES (_comId, _inDttmReq, _inDateWish,  _isTempo); -- NULL로 삽입


-- 2. 삽입된 inbound_request의 ID 가져오기
-- LAST_INSERT_ID() 함수는 1개의 insert 쿼리에 대해서 성공시 마지막 auto_increment 값

    SET newInReqId = LAST_INSERT_ID();
    SET generatedInReqId = newInReqId;

    -- 3. inbound_request_items 테이블에 상세 항목 삽입 (JSON_TABLE 활용)
    IF _inItemsJson IS NOT NULL AND JSON_LENGTH(_inItemsJson) > 0 THEN
        INSERT INTO inboundItems (inReqId, cfId, inQtyReq, status)
        SELECT
            newInReqId,
            JSON_UNQUOTE(JSON_EXTRACT(item_data, '$.cfId')),
            JSON_UNQUOTE(JSON_EXTRACT(item_data, '$.inQtyReq')),
            '승인대기'
        FROM
            JSON_TABLE(
                    _inItemsJson,
                    '$[*]' COLUMNS (item_data JSON PATH '$')
            ) AS jt;

    END IF;

    COMMIT;
END //

DELIMITER ;

-- 회원 입고 요청 수정 프로시저
-- 기존 프로시저가 있다면 삭제
DROP PROCEDURE IF EXISTS ModifyInReq;

DELIMITER //

CREATE PROCEDURE ModifyInReq(
    IN _inReqId BIGINT,             -- 수정할 입고 요청 ID
    IN _comId VARCHAR(30),          -- 수정을 요청하는 회원 ID (소유권 검증용)
    IN _inDateWish DATE,            -- 새로 변경할 희망 입고일
    IN _inItemsJson JSON,           -- 새로 변경할 입고 상세 항목 목록
    IN _isTempo TINYINT             -- 임시저장 상태 변경 여부 (0: 정식, 1: 임시)
)
BEGIN
    DECLARE owner_check INT DEFAULT 0;

    -- 트랜잭션 중 오류 발생 시 롤백하고 에러 메시지를 반환
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error modifying inbound request. Transaction rolled back.';
        END;

    -- 트랜잭션 시작
    START TRANSACTION;

    -- 1. 소유권 검증: 요청한 회원이 해당 입고 요청의 소유주인지 확인
    SELECT COUNT(*) INTO owner_check
    FROM inboundRequests
    WHERE inReqId = _inReqId AND comId = _comId;

    IF owner_check = 0 THEN
        -- 소유주가 아니거나 요청이 존재하지 않으면 에러 발생시키고 롤백
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Request not found or permission denied.';
    ELSE
        -- 2. inboundRequests 테이블 업데이트
        -- 요청일시는 현재 시각으로 갱신하고, 승인 관련 정보는 초기화
        UPDATE inboundRequests
        SET
            inDttmReq = NOW(),
            inDateWish = _inDateWish,
            IsTempo = _isTempo,
            managerId = NULL,
            inDttmAppr = NULL
        WHERE
            inReqId = _inReqId;

        -- 3. 기존 inboundItems 상세 항목 전체 삭제
        DELETE FROM inboundItems WHERE inReqId = _inReqId;

        -- 4. 새로운 inboundItems 상세 항목 삽입 (CreateInReq와 동일한 로직)
        IF _inItemsJson IS NOT NULL AND JSON_LENGTH(_inItemsJson) > 0 THEN
            INSERT INTO inboundItems (inReqId, cfId, inQtyReq, status)
            SELECT
                _inReqId,
                JSON_UNQUOTE(JSON_EXTRACT(item_data, '$.cfId')),
                JSON_UNQUOTE(JSON_EXTRACT(item_data, '$.inQtyReq')),
                '승인대기' -- 상태는 '승인대기'로 초기화
            FROM
                JSON_TABLE(
                        _inItemsJson,
                        '$[*]' COLUMNS (
                            item_data JSON PATH '$'
                            )
                ) AS jt;
        END IF;

    END IF;

    -- 모든 작업이 성공하면 커밋
    COMMIT;

END //

DELIMITER ;

-- 관리자 입고요청 처리 프로시저 [수정. 25.11.12]
-- 기존 프로시저가 있다면 삭제
DROP PROCEDURE IF EXISTS FinalizeInboundItem;

DELIMITER //

CREATE PROCEDURE FinalizeInboundItem(
    IN _inReqItemsId BIGINT,
    IN _managerId VARCHAR(30),
    IN _newStatus VARCHAR(20),
    IN _confirmedDate DATE,
    IN _lpId CHAR(40),
    IN _isTempo TINYINT,
    IN _adminMemo VARCHAR(500) -- ★★★ [추가 1] 관리자 메모를 받을 파라미터 추가 ★★★
)
BEGIN
    -- ★★★ [핵심 수정] 모든 DECLARE 문을 BEGIN 바로 아래로 이동 ★★★

    -- 1. 변수 선언부
    DECLARE _parentInReqId BIGINT;
    DECLARE _locationId CHAR(12);
    DECLARE _inDttmSchd DATETIME;
    DECLARE _totalItems INT;
    DECLARE _approvedItems INT; -- '승인완료' 항목 수를 셀 변수

    DECLARE debug_msg VARCHAR(255);

    -- 2. 핸들러 선언부
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error finalizing inbound item.';
        END;

    -- ★★★ 선언 끝, 이제부터 일반 SQL 문 시작 ★★★

    IF _confirmedDate IS NOT NULL THEN
        SET _inDttmSchd = CONCAT(_confirmedDate, ' 09:00:00');
    END IF;

    IF _lpId IS NOT NULL THEN
        SELECT locationId INTO _locationId FROM locations WHERE lpId = _lpId LIMIT 1;
    END IF;


    START TRANSACTION;

    UPDATE inboundItems
    SET
        status = IF(_isTempo = 1, '승인대기', _newStatus),
        locationId = _locationId,
        inDttmSchd = _inDttmSchd,
        adminMemo = _adminMemo -- 관리자 메모 저장
    WHERE
        inReqItemsId = _inReqItemsId;

    SELECT inReqId INTO _parentInReqId FROM inboundItems WHERE inReqItemsId = _inReqItemsId;


    IF _parentInReqId IS NOT NULL THEN
        IF _isTempo = 0 THEN
            -- ★★★ [핵심 수정] managerId 업데이트를 항상 실행하도록 분리 ★★★
            UPDATE inboundRequests SET managerId = _managerId, IsTempo = 0 WHERE inReqId = _parentInReqId;

            -- '승인완료' 항목 수를 카운트하여 inDttmAppr만 조건부로 업데이트
            SELECT COUNT(*) INTO _totalItems FROM inboundItems WHERE inReqId = _parentInReqId;
            SELECT COUNT(*) INTO _approvedItems FROM inboundItems WHERE inReqId = _parentInReqId AND status = '승인완료';

            -- 3. 두 수가 같으면 (즉, 모든 항목이 '승인완료' 상태이면) 최종 승인 정보 업데이트
            IF _totalItems = _approvedItems THEN
                UPDATE inboundRequests SET inDttmAppr = NOW() WHERE inReqId = _parentInReqId;
            END IF;

        ELSE -- 임시 저장(_isTempo=1)인 경우
            UPDATE inboundRequests SET IsTempo = 1 WHERE inReqId = _parentInReqId;
        END IF;
    END IF;

    COMMIT;
END//

DELIMITER ;

-- 출고 프로시저

DROP PROCEDURE IF EXISTS CreateOutReq;
DELIMITER $$

CREATE PROCEDURE CreateOutReq(
    IN p_comId VARCHAR(30),
    IN p_managerId VARCHAR(30),
    IN p_outDateWish DATE,
    IN p_isTempo TINYINT,
    IN p_outItemsJson JSON,
    IN p_outDttmReq DATETIME,
    OUT p_outReqId BIGINT
)
BEGIN
    --  출고 요청 저장
    INSERT INTO outboundrequest (comId, managerId, outDttmReq, outDateWish, IsTempo)
    VALUES (p_comId, p_managerId, p_outDttmReq, p_outDateWish, p_isTempo);

    --  새로 생성된 출고요청 ID 가져오기
    SET p_outReqId = LAST_INSERT_ID();

    -- JSON 파싱해서 outbounditems 에 추가 (간단 예시)
    INSERT INTO outbounditems (outReqId, stkId, vehicleId, status, outQtyReq)
    SELECT
        p_outReqId,
        jt.stkId,
        jt.vehicleId,
        '승인대기',
        jt.outQtyReq
    FROM JSON_TABLE(p_outItemsJson, '$[*]'
                    COLUMNS (
                        stkId CHAR(12) PATH '$.stkId',
                        outQtyReq INT PATH '$.outQtyReq',
                        vehicleId CHAR(10) PATH '$.vehicleId'
                        )
         ) AS jt;
END$$

DELIMITER ;






DROP PROCEDURE IF EXISTS ModifyOutReq;
DELIMITER $$

CREATE PROCEDURE ModifyOutReq(
    IN in_outReqId BIGINT,
    IN in_outDateWish DATE
)
BEGIN
    UPDATE outboundrequest
    SET outDateWish = in_outDateWish
    WHERE outReqId = in_outReqId AND IsDelete = 0;
END$$

DELIMITER ;





DROP PROCEDURE IF EXISTS SoftDeleteOutReq;
DELIMITER $$

CREATE PROCEDURE SoftDeleteOutReq(
    IN in_outReqId BIGINT,
    IN in_comId VARCHAR(30)
)
BEGIN
    UPDATE outboundrequest
    SET IsDelete = 1
    WHERE outReqId = in_outReqId AND comId = in_comId;

    UPDATE outbounditems
    SET status = '반려'
    WHERE outReqId = in_outReqId;
END$$

DELIMITER ;





DROP PROCEDURE IF EXISTS ApproveOutReq;
DELIMITER $$

CREATE PROCEDURE ApproveOutReq(
    IN in_outReqId BIGINT,
    IN in_managerId VARCHAR(30)
)
BEGIN
    UPDATE outboundrequest
    SET outDttmAppr = NOW(), managerId = in_managerId
    WHERE outReqId = in_outReqId;

    UPDATE outbounditems
    SET status = '승인완료'
    WHERE outReqId = in_outReqId;
END$$

DELIMITER ;




DROP PROCEDURE IF EXISTS RegisterDispatch;
DELIMITER $$

CREATE PROCEDURE RegisterDispatch(
    IN in_outReqId BIGINT,
    IN in_vehicleId CHAR(10)
)
BEGIN
    UPDATE outbounditems
    SET vehicleId = in_vehicleId
    WHERE outReqId = in_outReqId;
END$$

DELIMITER ;




DROP PROCEDURE IF EXISTS CancelDispatch;
DELIMITER $$

CREATE PROCEDURE CancelDispatch(
    IN in_outReqId BIGINT
)
BEGIN
    UPDATE outbounditems
    SET vehicleId = NULL
    WHERE outReqId = in_outReqId;
END$$

DELIMITER ;




DROP PROCEDURE IF EXISTS CreateOrder;
DELIMITER $$

CREATE PROCEDURE CreateOrder(
    IN in_outReqId BIGINT
)
BEGIN
    UPDATE outbounditems
    SET status = '승인완료'
    WHERE outReqId = in_outReqId;
END$$

DELIMITER ;




DROP PROCEDURE IF EXISTS CreateWaybill;
DELIMITER $$

CREATE PROCEDURE CreateWaybill(
    IN in_outReqId BIGINT
)
BEGIN
    UPDATE outbounditems
    SET status = '출고완료'
    WHERE outReqId = in_outReqId;
END$$

DELIMITER ;




DROP PROCEDURE IF EXISTS MarkReceived;
DELIMITER $$

CREATE PROCEDURE MarkReceived(
    IN in_outReqId BIGINT
)
BEGIN
    UPDATE outbounditems
    SET status = '출고완료',
        outDttmShip = NOW()
    WHERE outReqId = in_outReqId;
END$$

DELIMITER ;



