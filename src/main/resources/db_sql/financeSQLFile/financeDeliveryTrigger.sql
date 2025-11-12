-- 가정3. 배송 완료 시(출고아이템 상태 = SHIPPED)
DROP TRIGGER IF EXISTS trg_outboundItems_delivery_cost;
DELIMITER $$

CREATE TRIGGER trg_outboundItems_delivery_cost
    AFTER UPDATE
    ON outboundItems
    FOR EACH ROW
BEGIN
    DECLARE v_transportUnit DECIMAL(15, 2) DEFAULT 0; -- 배송 단가(원/km)
    DECLARE v_transportAmt DECIMAL(15, 2) DEFAULT 0; -- 배송비(= 50km * 단가)
    DECLARE v_whId BIGINT;
    DECLARE v_userId VARCHAR(30);

    -- 상태 변경 감지 + 완료 상태
    IF OLD.status <> NEW.status AND NEW.status = '승인완료' THEN

        -- 단가 필수
        IF (SELECT COUNT(*) FROM unitCost) = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'unitCost is empty';
        END IF;

        -- 최신 배송단가 로드
        SELECT COALESCE(transUnitAmt, 0)
        INTO v_transportUnit
        FROM unitCost
        ORDER BY unitCostId DESC
        LIMIT 1;

        -- 고정 거리 50km 적용
        SET v_transportAmt = ROUND(50 * v_transportUnit, 2);

        -- 창고ID 해석: stkId -> stock.lpId -> locations.whId
        SELECT (SELECT L.whId
                FROM stock S
                         JOIN locations L ON L.lpId = S.lpId
                WHERE S.stkId = NEW.stkId
                LIMIT 1)
        INTO v_whId;

        -- 회원ID: 거래처 ID로 저장
        SELECT ORQ.comId
        INTO v_userId
        FROM outboundrequest ORQ
        WHERE ORQ.outReqId = NEW.outReqId
        LIMIT 1;

        -- 1) 배송비용 기록
        -- 스키마에 맞춰 컬럼명 조정: deliveryCost(transportAmt, outReqId) 가정
        INSERT INTO deliveryCost (transportAmt, outReqId)
        VALUES (v_transportAmt, NEW.outReqId);

        -- 2) 지출 생성
        INSERT INTO expense
        (expenseDt, expenseCategory, totalAmt, expenseStatus, whId, userId)
        VALUES (CURDATE(), 'deliveryCost', v_transportAmt, 'draft', v_whId, v_userId);

    END IF;
END$$
DELIMITER ;

-- 가정2.3. 출고가 완료됐을때
SELECT * FROM outboundItems;
SELECT * FROM outboundCost;
SELECT * FROM deliveryCost;

UPDATE outboundItems
SET status      = '승인완료',
    outDttmInsp = '2025-10-10 15:00:00',
    outDttmShip = '2025-10-12 11:00:00'
WHERE outreqId = 2;

SELECT * FROM outboundCost;
SELECT * FROM deliveryCost;
SELECT * FROM expense;