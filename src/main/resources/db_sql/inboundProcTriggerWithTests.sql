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

drop trigger if exists trg_upsert_daily_capacity;
DELIMITER $$
CREATE TRIGGER trg_upsert_daily_capacity
    AFTER UPDATE ON inboundItems
    FOR EACH ROW
BEGIN
    -- [최종 조건] 상태가 '승인완료'가 아니었다가 '승인완료'로 변경되는 시점에만 발동
    IF OLD.status != '승인완료' AND NEW.status = '승인완료' THEN
        -- dailyCapacity 테이블에 해당 날짜 데이터가 있으면 UPDATE, 없으면 INSERT
        INSERT INTO dailyCapacity (
            dateId,
            maxCapa,
            usedCapa,
            staffAvailable,
            staffAssign,
            equipAvailable,
            equipAssign
        )
        VALUES (
                   DATE(NEW.inDttmSchd), -- 날짜 ID
                   50,                -- (기본값) 최대 처리량
                   NEW.inQtyReq,        -- (초기값) 사용 용량
                   10,                  -- (기본값) 가용 인원
                   NEW.inQtyReq * 2,    -- (초기값) 배정 인원
                   5,          -- (기본값) 가용 장비
                   NEW.inQtyReq         -- (초기값) 배정 장비
               )
        ON DUPLICATE KEY UPDATE
                             usedCapa = dailyCapacity.usedCapa + NEW.inQtyReq,
                             staffAssign = dailyCapacity.staffAssign + (NEW.inQtyReq * 2),
                             equipAssign = dailyCapacity.equipAssign + NEW.inQtyReq;
    END IF;
END$$

DELIMITER ;

-- 트리거 작동 확인! 코드
SELECT * FROM dailyCapacity WHERE dateId = '2025-11-09';
update inboundItems set inDttmSchd = null where inReqItemsId = 3;
UPDATE inboundItems SET inDttmSchd = '2025-11-09 10:00:00' WHERE inReqItemsId = 3;
SELECT * FROM dailyCapacity WHERE dateId = '2025-11-09';

-- 입고 예정일자에 따른 창고별 예정 수용량 트리거
DROP TRIGGER IF EXISTS trg_upsert_warehouse_capacity;

DELIMITER $$

CREATE TRIGGER trg_upsert_warehouse_capacity
    AFTER UPDATE ON inboundItems
    FOR EACH ROW
BEGIN
    DECLARE v_whId BIGINT; -- 조회된 창고 ID를 저장할 변수
    DECLARE v_total_capa INT; -- 조회된 창고의 총 수용량을 저장할 변수

-- [최종 조건] 상태가 '승인완료'가 아니었다가 '승인완료'로 변경되는 시점에만 발동 (locationId도 있어야 함)
    IF OLD.status != '승인완료' AND NEW.status = '승인완료' AND NEW.locationId IS NOT NULL THEN
        -- 1. locationId를 사용해 whId (창고 ID)를 조회
        SELECT whId INTO v_whId
        FROM locations
        WHERE locationId = NEW.locationId;

        -- 2. whId가 정상적으로 조회되었을 경우에만 로직 실행
        IF v_whId IS NOT NULL THEN

            -- 3. 조회된 whId로 warehouse 테이블에서 총 수용량(whTotalCapa)을 조회
            SELECT whTotalCapa INTO v_total_capa
            FROM warehouse
            WHERE whId = v_whId;

            -- 4. warehouseCapaSchedule 테이블에 해당 날짜, 해당 창고 데이터가 있으면 UPDATE, 없으면 INSERT
            INSERT INTO warehouseCapaSchedule (
                dateId,
                whId,
                used_capacity,
                available_capacity
            )
            VALUES (
                       DATE(NEW.inDttmSchd), -- 입고 예정일
                       v_whId, -- 창고 ID
                       NEW.inQtyReq, -- 사용할 용량 (입고 요청 수량)
                       v_total_capa - NEW.inQtyReq -- (새로 생성될 때) 남은 용량
                   )
            ON DUPLICATE KEY UPDATE
                                 used_capacity = warehouseCapaSchedule.used_capacity + VALUES(used_capacity),
                                 available_capacity = warehouseCapaSchedule.available_capacity - VALUES(used_capacity);
            -- VALUES(used_capacity)는 INSERT 하려던 NEW.inQtyReq 값을 의미합니다.
        END IF;
    END IF;
END$$

DELIMITER ;

-- 트리거 작동 확인 코드!
SELECT * FROM warehouseCapaSchedule WHERE dateId = '2025-11-08' AND whId = 3;
select * from inboundItems where inReqItemsId = 9;
update inboundItems set inDttmSchd = null where inReqItemsId = 9;
UPDATE inboundItems SET inDttmSchd = '2025-11-08 13:00:00' WHERE inReqItemsId = 9;
SELECT * FROM warehouseCapaSchedule WHERE dateId = '2025-11-08' AND whId = 3;


-- 입고 완료로 상태가 바뀌는 경우 재고 테이블에 신규 재고로 들어가는 트리거
DROP TRIGGER IF EXISTS trg_add_stock_on_inbound_complete;

DELIMITER $$

CREATE TRIGGER trg_add_stock_on_inbound_complete
    AFTER UPDATE ON inboundItems
    FOR EACH ROW
BEGIN
    DECLARE v_lpId CHAR(40);
    DECLARE v_stock_count INT;

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
                -- 재고가 없으면, 새로 추가 (INSERT)
                INSERT INTO stock (stkId, lpId, cfId, stkQuantity)
                VALUES (
                           -- 참고: 실제 운영환경에서는 더 안전한 PK 생성 방식이 필요
                           CONCAT('STKNEW', LPAD(FLOOR(RAND() * 100000), 5, '0')),
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


-- 관리자 입고요청 처리 프로시저

DROP PROCEDURE IF EXISTS ProcessInboundItem;

DELIMITER //

CREATE PROCEDURE ProcessInboundItem(
    IN _inReqItemsId BIGINT,
    IN _managerId VARCHAR(30),
    IN _newStatus VARCHAR(20),
    IN _locationId CHAR(12),
    IN _inDttmSchd DATETIME,
    IN _isTempo TINYINT
)
BEGIN
    DECLARE _parentInReqId BIGINT;
    DECLARE _totalItems INT;
    DECLARE _processedItems INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error processing inbound item. Transaction rolled back.';
        END;

    START TRANSACTION;

    -- 1. 부모 입고 요청 ID 조회
    SELECT inReqId INTO _parentInReqId
    FROM inboundItems
    WHERE inReqItemsId = _inReqItemsId;

    IF _parentInReqId IS NOT NULL THEN
        -- 2. 현재 처리 중인 inboundItems 항목 업데이트
        UPDATE inboundItems
        SET
            status = IF(_isTempo = 1, '승인대기', _newStatus),
            locationId = _locationId,
            inDttmSchd = _inDttmSchd
        WHERE
            inReqItemsId = _inReqItemsId;

        -- 3. 최종 처리(_isTempo=0)인 경우에만 부모 요청 상태 변경 로직 실행
        IF _isTempo = 0 THEN
            -- ★★★ [새로운 핵심 로직] ★★★
            -- 3-1. 부모 요청에 속한 전체 상세 항목 수 조회
            SELECT COUNT(*) INTO _totalItems
            FROM inboundItems
            WHERE inReqId = _parentInReqId;

            -- 3-2. '승인대기'가 아닌 (즉, 처리가 완료된) 상세 항목 수 조회
            SELECT COUNT(*) INTO _processedItems
            FROM inboundItems
            WHERE inReqId = _parentInReqId AND status != '승인대기';

            -- 3-3. 두 수가 같으면, 모든 항목이 처리된 것이므로 부모 요청의 최종 승인 정보 업데이트
            IF _totalItems = _processedItems THEN
                UPDATE inboundRequests
                SET
                    managerId = _managerId,
                    inDttmAppr = NOW(),
                    IsTempo = 0
                WHERE
                    inReqId = _parentInReqId;
            ELSE
                -- 아직 '승인대기' 항목이 남아있으면, 승인 정보는 업데이트하지 않고 임시저장 상태만 해제
                UPDATE inboundRequests
                SET IsTempo = 0
                WHERE inReqId = _parentInReqId;
            END IF;

        ELSE -- 임시 저장(_isTempo=1)인 경우
            UPDATE inboundRequests
            SET IsTempo = 1
            WHERE inReqId = _parentInReqId;
        END IF;

    ELSE
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Inbound item not found.';
    END IF;

    COMMIT;
END //

DELIMITER ;
