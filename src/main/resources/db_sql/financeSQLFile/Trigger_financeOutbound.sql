USE meowcoffeedb;

-- 가정2. 출고 완료됐을때
DROP TRIGGER IF EXISTS trg_outboundItems_shipped_cost;
DELIMITER $$

CREATE TRIGGER trg_outboundItems_shipped_cost
    AFTER UPDATE
    ON outboundItems
    FOR EACH ROW
BEGIN
    DECLARE hours DECIMAL(10, 4) DEFAULT 0;
    DECLARE qty INT DEFAULT 0;

    DECLARE laborUnit DECIMAL(15, 2) DEFAULT 0;
    DECLARE pickUnit DECIMAL(15, 2) DEFAULT 0;
    DECLARE packUnit DECIMAL(15, 2) DEFAULT 0;

    DECLARE laborAmt DECIMAL(15, 2) DEFAULT 0;
    DECLARE pickingAmt DECIMAL(15, 2) DEFAULT 0;
    DECLARE packingAmt DECIMAL(15, 2) DEFAULT 0;

    DECLARE whId BIGINT;
    DECLARE userId VARCHAR(30);

    IF OLD.status <> NEW.status AND NEW.status = '승인완료' THEN
        -- 단가 테이블 필수
        IF (SELECT COUNT(*) FROM unitCost) = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'unitCost is empty';
        END IF;

        -- 소요시간, 수량
        SET hours = CASE
                        WHEN NEW.outDttmInsp IS NULL OR NEW.outDttmShip IS NULL THEN 0
                        ELSE TIMESTAMPDIFF(SECOND, NEW.outDttmInsp, NEW.outDttmShip) / 3600
            END;
        SET qty = IFNULL(NEW.outQtyReq, 0);

        -- 단가 로드: pickingUnitAmt가 없으면 inspectUnitAmt로 대체
        SELECT laborUnitAmt,
               COALESCE(inspectUnitAmt, inspectUnitAmt, 0),
               COALESCE(packingUnitAmt, 0)
        INTO laborUnit, pickUnit, packUnit
        FROM unitCost
        ORDER BY unitCostId DESC
        LIMIT 1;

        -- 금액 계산
        SET laborAmt = ROUND(laborUnit * hours, 2);
        SET pickingAmt = ROUND(pickUnit * qty, 2);
        SET packingAmt = ROUND(packUnit * qty, 2);

        -- 창고ID: stkId -> stock.lpId -> locations.whId
        -- 스칼라 서브쿼리 사용: 매칭 없으면 NULL로 반환되어 트리거가 실패하지 않음
        SELECT (SELECT L.whId
                FROM stock S
                         JOIN locations L ON L.lpId = S.lpId
                WHERE S.stkId = NEW.stkId
                LIMIT 1)
        INTO whId;

        -- 요청자: 거래처 ID로 저장
        SELECT ORQ.comId
        INTO userId
        FROM outboundrequest ORQ
        WHERE ORQ.outReqId = NEW.outReqId
        LIMIT 1;

        -- 1) 아이템별 출고비용 기록
        INSERT INTO outboundCost (pickingAmt, packingAmt, laborAmt, outReqId)
        VALUES (pickingAmt, packingAmt, laborAmt, NEW.outReqId);

        -- 2) 지출도 아이템 단위로 즉시 생성
        INSERT INTO expense
        (expenseDt, expenseCategory, totalAmt, expenseStatus, whId, userId)
        VALUES (CURDATE(), 'outboundCost',
                ROUND(pickingAmt + packingAmt + laborAmt, 2),
                'draft', whId, userId);
    END IF;
END$$
DELIMITER ;