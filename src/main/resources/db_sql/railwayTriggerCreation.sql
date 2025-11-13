-- 실사 완료됐을때 보관 단가 테이블 업데이트 트리거
-- 기존 트리거 삭제
DROP TRIGGER IF EXISTS trg_due_diligence_storage_cost;
DELIMITER $$

CREATE TRIGGER trg_due_diligence_storage_cost
    AFTER UPDATE
    ON due_diligence
    FOR EACH ROW
BEGIN
    -- 변수 선언
    DECLARE v_storeUnit DECIMAL(15, 2) DEFAULT 0;
    DECLARE v_qty BIGINT DEFAULT 0;
    DECLARE v_amt DECIMAL(15, 2) DEFAULT 0;
    DECLARE v_whId BIGINT;
    DECLARE v_lpId CHAR(40);
    DECLARE v_company_code CHAR(2);
    DECLARE v_company_name VARCHAR(30);
    DECLARE v_comId VARCHAR(30);

    -- 실사가 'APPROVED'로 변경되었을 때만 실행
    IF OLD.ddApproval <> 'APPROVED' AND NEW.ddApproval = 'APPROVED' THEN

        -- 최신 보관단가 조회
        SELECT storeUnitAmt INTO v_storeUnit FROM unitCost ORDER BY unitCostId DESC LIMIT 1;

        -- 재고 수량 조회
        SELECT stkQuantity, lpId INTO v_qty, v_lpId FROM stock WHERE stkId = NEW.stkId LIMIT 1;

        -- 창고 ID 조회 (stock.lpId -> locations.whId)
        SELECT L.whId INTO v_whId FROM locations L WHERE L.lpId = v_lpId LIMIT 1;

        -- ====================================================================
        -- [수정된 부분] lpId를 기반으로 comId를 찾는 안정적인 로직
        -- ====================================================================
        -- 1. lpId에서 회사 코드('ST' 또는 'TW')를 추출
        SET v_company_code = SUBSTRING_INDEX(SUBSTRING_INDEX(v_lpId, '-', 3), '-', -1);

        -- 2. 추출한 코드를 실제 회사 이름으로 변환
        IF v_company_code = 'ST' THEN
            SET v_company_name = '스타벅스';
        ELSEIF v_company_code = 'TW' THEN
            SET v_company_name = '투썸플레이스';
        END IF;

        -- 3. 변환된 회사 이름을 기준으로 users 테이블에서 대표 comId를 하나 찾아옴
        IF v_company_name IS NOT NULL THEN
            SELECT userId INTO v_comId
            FROM users
            WHERE userCompanyName = v_company_name AND userRole = 'COMPANY'
            LIMIT 1;
        END IF;
        -- ====================================================================

        -- [중요] 모든 정보가 정상적으로 조회되었을 때만 비용/지출을 INSERT
        IF v_qty > 0 AND v_whId IS NOT NULL AND v_comId IS NOT NULL THEN
            -- 보관비 계산
            SET v_amt = ROUND(v_storeUnit * v_qty, 2);

            -- 1) 보관비용 적재 (파일 기준: storageCost(storeAmt, ddId))
            INSERT INTO storageCost (storeAmt, ddId)
            VALUES (v_amt, NEW.ddId);

            -- 2) 지출 생성: userId=거래처ID
            INSERT INTO expense
            (expenseDt, expenseCategory, totalAmt, expenseStatus, whId, userId)
            VALUES (CURDATE(), 'storageCost', v_amt, 'draft', v_whId, v_comId);

        END IF;

    END IF;
END$$
DELIMITER ;

-- 기존 트리거 삭제
DROP TRIGGER IF EXISTS trg_inboundItems_received_cost;
DELIMITER $$

CREATE TRIGGER trg_inboundItems_received_cost
    AFTER UPDATE
    ON inboundItems
    FOR EACH ROW
BEGIN
    -- 변수 선언
    DECLARE hours DECIMAL(10, 4) DEFAULT 0;
    DECLARE qty INT DEFAULT 0;
    DECLARE laborUnit DECIMAL(15, 2) DEFAULT 0;
    DECLARE inspectUnit DECIMAL(15, 2) DEFAULT 0;
    DECLARE laborAmt DECIMAL(15, 2) DEFAULT 0;
    DECLARE inspectAmt DECIMAL(15, 2) DEFAULT 0;
    DECLARE inReqId BIGINT;
    DECLARE whId BIGINT;
    DECLARE userId VARCHAR(30);

    -- 상태가 '입고완료'로 변경되었을 때만 실행
    IF NEW.status = '입고완료' AND (OLD.status IS NULL OR OLD.status <> '입고완료') THEN

        -- ==========================================================
        -- [수정된 부분] IF ... THEN ... END IF; 구조로 변경하여 안정성 확보
        -- ==========================================================
        -- locationId가 유효한(NULL이 아닌) 경우에만 비용 계산 및 INSERT 로직을 실행합니다.
        IF NEW.locationId IS NOT NULL THEN

            -- 창고 ID 가져오기
            SELECT l.whId INTO whId FROM locations l WHERE l.locationId = NEW.locationId LIMIT 1;

            -- 회원 ID 가져오기
            SELECT ir.comId INTO userId FROM inboundRequests ir WHERE ir.inReqId = NEW.inReqId LIMIT 1;

            -- 조회된 whId와 userId가 유효한지 최종적으로 확인합니다.
            IF whId IS NOT NULL AND userId IS NOT NULL THEN
                -- 소요시간(시간단위). 초→시간
                SET hours = CASE WHEN NEW.inDttmInsp IS NULL OR NEW.inDttmRecv IS NULL THEN 0 ELSE TIMESTAMPDIFF(SECOND, NEW.inDttmInsp, NEW.inDttmRecv) / 3600 END;

                -- 입고수량 가져오기
                SET qty = IFNULL(NEW.inQty, 0);

                -- 단가 마지막 행 가져오기
                SELECT IFNULL(laborUnitAmt, 0), IFNULL(inspectUnitAmt, 0)
                INTO laborUnit, inspectUnit
                FROM unitCost
                ORDER BY unitCostId DESC
                LIMIT 1;

                -- 금액 계산
                SET laborAmt = ROUND(laborUnit * hours, 2);
                SET inspectAmt = ROUND(inspectUnit * qty, 2);
                SET inReqId = NEW.inReqId;

                -- 입고비용 테이블에 INSERT
                INSERT INTO inboundCost (laborAmt, inspectAmt, inReqId)
                VALUES (laborAmt, inspectAmt, inReqId);

                -- 지출 테이블에 INSERT (expense 테이블의 모든 NOT NULL 컬럼을 포함해야 함)
                INSERT INTO expense (expenseDt, expenseCategory, totalAmt, expenseStatus, whId, userId)
                VALUES (CURDATE(), 'inboundCost', ROUND(laborAmt + inspectAmt, 2), 'draft', whId, userId);
            END IF;

        END IF; -- IF NEW.locationId IS NOT NULL THEN

    END IF; -- IF NEW.status = '입고완료' THEN
END$$
DELIMITER ;


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
    IF OLD.status <> NEW.status AND NEW.status = '출고완료' THEN

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

    IF OLD.status <> NEW.status AND NEW.status = '출고완료' THEN
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