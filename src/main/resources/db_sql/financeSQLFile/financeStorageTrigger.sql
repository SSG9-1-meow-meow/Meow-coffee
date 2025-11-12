USE meowcoffeedb;

-- 가정4. 실사 완료됐을때
DROP TRIGGER IF EXISTS trg_due_diligence_storage_cost;
DELIMITER $$

CREATE TRIGGER trg_due_diligence_storage_cost
    AFTER UPDATE
    ON due_diligence
    FOR EACH ROW
BEGIN
    DECLARE v_storeUnit DECIMAL(15, 2) DEFAULT 0; -- 보관 단가
    DECLARE v_qty BIGINT DEFAULT 0; -- 재고 수량
    DECLARE v_amt DECIMAL(15, 2) DEFAULT 0; -- 보관비
    DECLARE v_whId BIGINT;
    DECLARE v_comId VARCHAR(30);

    IF OLD.ddApproval <> NEW.ddApproval AND NEW.ddApproval = 'APPROVED' THEN

        -- 최신 보관단가
        SELECT storeUnitAmt
        INTO v_storeUnit
        FROM unitCost
        ORDER BY unitCostId DESC
        LIMIT 1;

        -- 재고 수량
        SELECT stkQuantity
        INTO v_qty
        FROM stock
        WHERE stkId = NEW.stkId
        LIMIT 1;

        -- 창고ID: stock.lpId -> locations.whId
        SELECT L.whId
        INTO v_whId
        FROM stock S
                 JOIN locations L ON L.lpId = S.lpId
        WHERE S.stkId = NEW.stkId
        LIMIT 1;

        -- 거래처ID 우선순위 2: 같은 stkId의 최신 출고요청의 comId
        IF v_comId IS NULL OR v_comId = '' THEN
            SELECT ORQ.comId
            INTO v_comId
            FROM outboundItems OI
                     JOIN outboundrequest ORQ ON ORQ.outReqId = OI.outReqId
            WHERE OI.stkId = NEW.stkId
            ORDER BY COALESCE(OI.outDttmShip, OI.outDttmInsp, OI.outDttmSchd) DESC
            LIMIT 1;
        END IF;

        -- 최종 검증
        IF v_comId IS NULL OR v_comId = '' THEN
            SIGNAL SQLSTATE '45021' SET MESSAGE_TEXT = 'cannot resolve comId for due_diligence.stkId';
        END IF;

        -- 금액
        SET v_amt = ROUND(IFNULL(v_qty, 0) * v_storeUnit, 2);

        -- 1) 보관비용 적재 (파일 기준: storageCost(storeAmt, ddId))
        INSERT INTO storageCost (storeAmt, ddId)
        VALUES (v_amt, NEW.ddId);

        -- 2) 지출 생성: userId=거래처ID
        INSERT INTO expense
        (expenseDt, expenseCategory, totalAmt, expenseStatus, whId, userId)
        VALUES (CURDATE(), 'storageCost', v_amt, 'draft', v_whId, v_comId);
    END IF;
END$$
DELIMITER ;

-- 가정4. 실사 완료됐을때
SELECT * FROM due_diligence;

UPDATE due_diligence
SET ddApproval = 'APPROVED'
WHERE ddId = 2;

SELECT * FROM storageCost;
SELECT * FROM expense;