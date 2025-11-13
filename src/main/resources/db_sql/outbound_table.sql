create database meowcoffeedb;

use meowcoffeedb;

-- 출고요청 테이블
DROP TABLE IF EXISTS outboundrequest;
CREATE TABLE outboundrequest (
    outReqId      BIGINT       PRIMARY KEY auto_increment,
    comId         VARCHAR(30)  NOT NULL,   -- companies 뷰 참조
    managerId     VARCHAR(30)  NULL,       -- managers 뷰 참조
    outDttmReq    DATETIME     NOT NULL,
    outDateWish   DATE         NULL,
    outDttmAppr   DATETIME     NULL,
    IsDelete      TINYINT      NULL,
    IsTempo       TINYINT      NULL
    -- ※ companies, managers는 VIEW라 FK 직접 연결 불가
);

-- 출고요청상세 테이블
DROP TABLE IF EXISTS outboundItems;
CREATE TABLE outboundItems (
    outReqItemsId BIGINT AUTO_INCREMENT PRIMARY KEY,
    outReqId      BIGINT       NOT NULL,   -- outboundrequest FK
    stkId         CHAR(12)     NOT NULL,   -- stock 뷰 참조
    vehicleId     CHAR(10)     NULL,       -- vehicle 뷰 참조
    status        ENUM('승인대기', '승인완료', '출고완료', '반려') NOT NULL,
    outQtyReq     INTEGER      NOT NULL,
    outOrderAddr  VARCHAR(255) NULL,
    outDttmSchd   DATETIME     NULL,
    outDttmInsp   DATETIME     NULL,
    outDttmShip   DATETIME     NULL,
    CONSTRAINT fk_outboundItems_outboundrequest FOREIGN KEY (outReqId) REFERENCES outboundrequest(outReqId)
);

-- 기본값/NOT NULL 설정
ALTER TABLE outboundrequest
    MODIFY IsDelete TINYINT NOT NULL DEFAULT 0,
    MODIFY IsTempo  TINYINT NOT NULL DEFAULT 0;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE outboundItems;
TRUNCATE TABLE outboundrequest;
SET FOREIGN_KEY_CHECKS = 1;

-- 여기까지 넣어주세요
------------------------------------------------------------

-- 기존 데이터 정리
UPDATE outboundrequest SET IsDelete = 0 WHERE IsDelete IS NULL;
UPDATE outboundrequest SET IsTempo  = 0 WHERE IsTempo  IS NULL;


INSERT INTO outboundrequest (outReqId, comId, managerId, outDttmReq, outDateWish)
VALUES
    (1, 'COM001', 'MG001', NOW(), DATE_ADD(CURDATE(), INTERVAL 2 DAY)),
    (2, 'COM002', 'MG002', NOW(), DATE_ADD(CURDATE(), INTERVAL 3 DAY));


INSERT INTO outbounditems (outReqId, stkId, vehicleId, status, outQtyReq, outOrderAddr)
VALUES
    (1, 'STK001', 'VEH001', '승인대기', 10, '서울시 강남구'),
    (1, 'STK002', 'VEH002', '승인대기', 5, '서울시 강남구'),
    (2, 'STK003', 'VEH003', '승인대기', 7, '서울시 송파구');


