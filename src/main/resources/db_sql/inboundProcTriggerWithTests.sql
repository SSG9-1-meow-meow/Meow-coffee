use meowcoffeedb;

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

-- `inReqId`가 1번인 요청을 'coffeebiz01' 회원이 수정한다고 가정
SET @inReqIdToModify = 1;
SET @requestingUser = 'coffeebiz01';
SET @newWishDate = '2025-12-20';
SET @newItems = '[{"cfId": "CF003", "inQtyReq": 50}, {"cfId": "CF004", "inQtyReq": 75}]';

-- 프로시저 확인
select * from inboundRequests;
CALL ModifyInReq(@inReqIdToModify, @requestingUser, @newWishDate, @newItems, 0);
select * from inboundItems where inReqId = @inReqIdToModify;


--





-- 입고 예정일자 업데이트에 따른 일별 처리용량 트리거

-- 기존 두 트리거를 모두 삭제 .. 이거 안해서 한시간 반쯤 날림 ㅎㅎ
DROP TRIGGER IF EXISTS trg_upsert_daily_capacity;
DROP TRIGGER IF EXISTS trg_upsert_warehouse_capacity;

DROP TRIGGER IF EXISTS trg_update_daily_warehouse_capacity;

DELIMITER $$

CREATE TRIGGER trg_update_daily_warehouse_capacity
    AFTER UPDATE ON inboundItems
    FOR EACH ROW
BEGIN
    DECLARE _whId BIGINT;
    DECLARE _total_storage_capa INT;

    -- [통합 조건] 상태가 '승인완료'로 변경되고, locationId가 지정된 경우에만 발동
    IF OLD.status != '승인완료' AND NEW.status = '승인완료' AND NEW.locationId IS NOT NULL THEN

        -- 1. locationId를 통해 whId (창고 ID) 조회
        SELECT whId INTO _whId
        FROM locations
        WHERE locationId = NEW.locationId;

        -- 2. whId가 정상적으로 조회되었을 경우에만 실행
        IF _whId IS NOT NULL THEN

            -- 3. 해당 창고의 총 보관 용량(whTotalCapa) 조회
            SELECT whTotalCapa INTO _total_storage_capa
            FROM warehouse
            WHERE whId = _whId;

            -- 4. [통합 로직] daily_warehouse_capacity 테이블에 모든 정보를 UPSERT
            INSERT INTO daily_warehouse_capacity (
                dateId,
                whId,
                -- 보관 용량 컬럼
                used_storage_capacity,
                available_storage_capacity,
                -- 처리/인력/장비 부하 컬럼
                max_processing_capacity,
                used_processing_capacity,
                staff_available,
                staff_assigned,
                equip_available,
                equip_assigned
            )
            VALUES (
                       DATE(NEW.inDttmSchd), -- 날짜 ID
                       _whId,               -- 창고 ID

                       -- 보관 용량 값
                       NEW.inQtyReq,        -- (초기값) 사용할 보관 용량
                       _total_storage_capa - NEW.inQtyReq, -- (초기값) 남은 보관 용량

                       -- 처리/인력/장비 부하 값
                       50,                  -- (기본값) 최대 처리량
                       NEW.inQtyReq,        -- (초기값) 사용 처리량
                       100,                  -- (기본값) 가용 인원
                       NEW.inQtyReq * 2,    -- (초기값) 배정 인원
                       20,                   -- (기본값) 가용 장비
                       NEW.inQtyReq         -- (초기값) 배정 장비
                   )
            ON DUPLICATE KEY UPDATE
                                 -- 보관 용량 업데이트
                                 used_storage_capacity = daily_warehouse_capacity.used_storage_capacity + NEW.inQtyReq,
                                 available_storage_capacity = daily_warehouse_capacity.available_storage_capacity - NEW.inQtyReq,

                                 -- 처리/인력/장비 부하 업데이트
                                 used_processing_capacity = daily_warehouse_capacity.used_processing_capacity + NEW.inQtyReq,
                                 staff_assigned = daily_warehouse_capacity.staff_assigned + (NEW.inQtyReq * 2),
                                 equip_assigned = daily_warehouse_capacity.equip_assigned + NEW.inQtyReq;
        END IF;
    END IF;
END$$

DELIMITER ;




-- 입고 완료로 상태가 바뀌는 경우 재고 테이블에 신규 재고로 들어가는 트리거
DROP TRIGGER IF EXISTS trg_add_stock_on_inbound_complete;

DELIMITER $$

CREATE TRIGGER trg_add_stock_on_inbound_complete
    AFTER UPDATE ON inboundItems
    FOR EACH ROW
BEGIN
    DECLARE v_lpId CHAR(40);
    DECLARE v_stock_count INT;
    DECLARE v_today_prefix CHAR(11);
    DECLARE v_next_seq INT;
    DECLARE v_new_stkId CHAR(20);

    -- status가 '입고완료'로 변경되었고, 실제 입고수량(inQty)이 0보다 큰 경우에만 실행
    IF OLD.status != '입고완료' AND NEW.status = '입고완료' AND NEW.inQty > 0 THEN

        -- 1. inboundItems의 locationId를 이용해 locations 테이블에서 lpId를 조회
        SELECT lpId INTO v_lpId
        FROM locations
        WHERE locationId = NEW.locationId;

        -- 2. lpId가 정상적으로 조회되었을 경우에만 아래 로직을 실행
        IF v_lpId IS NOT NULL THEN

            -- 3. stock 테이블에 해당 lpId와 cfId로 등록된 재고가 있는지 확인
            SELECT COUNT(*) INTO v_stock_count
            FROM stock
            WHERE lpId = v_lpId AND cfId = NEW.cfId;

            -- 4. 재고 존재 여부에 따라 INSERT 또는 UPDATE 수행
            IF v_stock_count > 0 THEN
                -- 이미 재고가 있으면, 수량을 더해줌 (UPDATE)
                UPDATE stock
                SET stkQuantity = stkQuantity + NEW.inQty
                WHERE lpId = v_lpId AND cfId = NEW.cfId;
            ELSE
                -- ==========================================================
                -- [수정된 부분] 새로운 stkId 생성 로직
                -- ==========================================================
                -- 오늘 날짜 기반으로 접두사 생성 (예: 'stk20251113')
                SET v_today_prefix = CONCAT('stk', DATE_FORMAT(CURDATE(), '%Y%m%d'));

                -- 오늘 날짜로 입고된 재고 중 가장 큰 순번 + 1을 다음 순번으로 결정
                SELECT IFNULL(MAX(CAST(SUBSTRING(stkId, 12) AS UNSIGNED)), 0) + 1
                INTO v_next_seq
                FROM stock
                WHERE stkId LIKE CONCAT(v_today_prefix, '%');

                -- 새로운 stkId 조합 (예: 'stk20251113' + '00001')
                SET v_new_stkId = CONCAT(v_today_prefix, LPAD(v_next_seq, 5, '0'));
                -- ==========================================================

                -- 재고가 없으면, 새로 추가 (INSERT)
                INSERT INTO stock (stkId, lpId, cfId, stkQuantity)
                VALUES (
                           v_new_stkId, -- 생성된 신규 ID 사용
                           v_lpId,
                           NEW.cfId,
                           NEW.inQty
                       );
            END IF;
        END IF;
    END IF;
END$$

DELIMITER ;


-- 재고 반영 트리거 확인 코드
select * from inboundItems where inReqItemsId = 1;
SELECT * FROM stock WHERE lpId = 'LP001' AND cfId = 'CF001';

UPDATE inboundItems SET status = '입고완료', inQty = 100, inDttmRecv = NOW() -- 입고완료 시각 기록
WHERE inReqItemsId = 1;

select * from inboundItems where inReqItemsId = 2;
SELECT * FROM stock WHERE lpId = 'LP001' AND cfId = 'CF002'; -- 원래 재고가 없던 경우
UPDATE inboundItems SET status = '입고완료', inQty = 50, inDttmRecv = NOW() WHERE inReqItemsId = 2;-- 입고완료 시각 기록
SELECT * FROM stock WHERE lpId = 'LP001' AND cfId = 'CF002'; -- 원래 재고가 없던 경우


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

