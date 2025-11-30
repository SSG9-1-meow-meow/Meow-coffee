USE meowcoffeedb;

-- 가정1. 입고완료됐을때
DROP TRIGGER IF EXISTS trg_inboundItems_received_cost;
DELIMITER $$

CREATE TRIGGER trg_inboundItems_received_cost
    AFTER UPDATE
    ON inboundItems
    FOR EACH ROW
BEGIN
    DECLARE hours DECIMAL(10, 4) DEFAULT 0;
    DECLARE qty INT DEFAULT 0;
    DECLARE laborUnit DECIMAL(15, 2) DEFAULT 0;
    DECLARE inspectUnit DECIMAL(15, 2) DEFAULT 0;
    DECLARE laborAmt DECIMAL(15, 2) DEFAULT 0;
    DECLARE inspectAmt DECIMAL(15, 2) DEFAULT 0;
    DECLARE inReqId BIGINT;
    DECLARE whId BIGINT;
    DECLARE userId VARCHAR(30);

    IF NEW.status = '입고완료' AND (OLD.status IS NULL OR OLD.status <> '입고완료') THEN
        -- 소요시간(시간단위). 초→시간
        SET hours =
                CASE
                    WHEN NEW.inDttmInsp IS NULL OR NEW.inDttmRecv IS NULL THEN 0
                    ELSE TIMESTAMPDIFF(SECOND, NEW.inDttmInsp, NEW.inDttmRecv) / 3600
                    END;

        -- 입고수량 기져오고
        SET qty = IFNULL(NEW.inQty, 0);

        -- 단가 마지막 행 가져오고
        SELECT laborUnitAmt, inspectUnitAmt
        INTO laborUnit, inspectUnit
        FROM unitCost
        ORDER BY unitCostId DESC
        LIMIT 1;

        -- 금액 계산했어
        SET laborAmt = ROUND(laborUnit * hours, 2);
        SET inspectAmt = ROUND(inspectUnit * qty, 2);

        -- 참조 키 가져오고
        SET inReqId = NEW.inReqId;

        -- 창고 ID 가져오고
        SELECT l.whId
        INTO whId
        FROM locations l
        WHERE l.locationId = NEW.locationId
        LIMIT 1;

        -- 회원 ID 가져오고
        SELECT ir.comId
        INTO userId
        FROM inboundRequests ir
        WHERE ir.inReqId = inReqId
        LIMIT 1;

        -- 입고비용에 넣어.
        INSERT INTO inboundCost (laborAmt, inspectAmt, inReqId)
        VALUES (laborAmt, inspectAmt, inReqId);

        -- 지출 넣었어. 근데 왜 안나와!!!!!
        INSERT INTO expense
        (expenseDt, expenseCategory, totalAmt, expenseStatus, whId, userId)
        VALUES (CURDATE(), 'inboundCost', ROUND(laborAmt + inspectAmt, 2), 'draft', whId, userId);
    END IF;
END$$
DELIMITER ;

SELECT * FROM inboundItems;

UPDATE inboundItems SET status='입고완료', inQty=50, inDttmInsp='2025-11-08 10:00:00', inDttmRecv='2025-11-09 10:00:00' WHERE inReqId = 1 OR inReqId = 2 OR inReqId = 3;

SELECT * FROM inboundCost;

 SELECT * FROM expense;