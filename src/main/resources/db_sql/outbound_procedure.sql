USE meowcoffeedb;
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
