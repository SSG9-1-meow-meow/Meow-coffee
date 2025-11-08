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
            '$[*]' COLUMNS (
                        item_data JSON PATH '$'
                        )
    ) AS jt;

END IF;

COMMIT;
END //

DELIMITER ;

-- 회원 입고관리 메인 조회용
-- 입고 요청ID, 커피상품명, 카테고리, 요청 수량, 입고 수량, 상태, 요청날짜, 승인 날짜, 임시저장여부

SELECT
    ir.inReqId,
    c.cfName AS coffeeName,
    c.cfCategory AS category,
    ii.inQtyReq AS requestedQty,
    ii.inQty AS receivedQty,
    ii.status,
    ir.inDttmReq AS requestDate,
    ir.inDttmAppr AS approvalDate,
    ir.IsTempo AS isTemporary
FROM inboundRequests ir
         JOIN inboundItems ii ON ir.inReqId = ii.inReqId
         JOIN coffee c ON ii.cfId = c.cfId;