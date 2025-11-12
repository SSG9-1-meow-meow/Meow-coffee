-- DB 초기화
DROP DATABASE IF EXISTS meowcoffeedb;
CREATE DATABASE meowcoffeedb;
USE meowcoffeedb;

-- 1) 테이블 생성 (FK 없이)

-- vehicles
CREATE TABLE vehicles
(
    vehicleId    CHAR(10) PRIMARY KEY,
    vehicleModel ENUM ('5톤 윙바디','1톤 탑차','1.2톤 카고') NOT NULL,
    vehicleDesc  VARCHAR(255)                      NULL
);

-- users (FK 나중에 추가)
CREATE TABLE users
(
    userId          VARCHAR(30) PRIMARY KEY,
    userPwd         VARCHAR(255)                                                            NOT NULL,
    userCompanyName VARCHAR(30)                                                             NULL,
    userName        VARCHAR(30)                                                             NOT NULL,
    userPhone       VARCHAR(13)                                                             NOT NULL,
    userEmail       VARCHAR(50)                                                             NOT NULL,
    userCode        CHAR(12)                                                                NOT NULL,
    userRoadAddr    VARCHAR(100)                                                            NULL,
    userDetailAddr  VARCHAR(100)                                                            NULL,
    userJoinDate    DATE                                                                    NULL,
    userRole        ENUM ('COMPANY','MANAGER','ADMIN','DELIVERYMAN')                        NOT NULL,
    userStatus      ENUM ('APPROVAL','WAITING_APPROVAL','DEACTIVATED','WAITING_DEACTIVATE') NOT NULL,
    userLastLogin   DATE                                                                    NULL,
    userImgPath     VARCHAR(255)                                                            NULL,
    vehicleId       CHAR(10)                                                                NULL
);

-- coffee
CREATE TABLE coffee
(
    cfId       CHAR(12) PRIMARY KEY,
    cfName     VARCHAR(20) NOT NULL,
    cfOrigin   CHAR(3)     NOT NULL,
    cfCategory CHAR(3)     NOT NULL,
    cfGrade    VARCHAR(15) NOT NULL,
    cfType     VARCHAR(15) NOT NULL
);

-- warehouse
CREATE TABLE warehouse
(
    whId        BIGINT AUTO_INCREMENT PRIMARY KEY,
    whCode      VARCHAR(12)  NOT NULL,
    whName      VARCHAR(30)  NOT NULL,
    whAddress   VARCHAR(100) NOT NULL,
    whTelPhone  VARCHAR(13),
    whGrade     CHAR(5)      NOT NULL,
    whField     INT          NOT NULL,
    whTotalCapa INT          NOT NULL,
    whUseCapa   INT          NULL
);

-- stock (FK 나중에 추가)
CREATE TABLE stock
(
    stkId       CHAR(12) PRIMARY KEY,
    lpId        CHAR(40) NOT NULL,
    cfId        CHAR(12) NOT NULL,
    stkQuantity INT      NOT NULL
);

-- location_places
CREATE TABLE location_places
(
    lpId     CHAR(40) PRIMARY KEY,
    zoneId   CHAR(12) NOT NULL,
    zoneName CHAR(12) NOT NULL,
    rackId   CHAR(12) NOT NULL,
    rackName CHAR(12) NOT NULL,
    cellId   CHAR(12) NOT NULL,
    cellName CHAR(12) NOT NULL
);

-- locations (FK 나중에 추가)
CREATE TABLE locations
(
    locationId CHAR(12) PRIMARY KEY,
    whId       BIGINT   NOT NULL,
    lpId       CHAR(40) NOT NULL
);

-- inboundRequests (FK 나중에 추가)
CREATE TABLE inboundRequests
(
    inReqId    BIGINT AUTO_INCREMENT PRIMARY KEY,
    comId      VARCHAR(30) NOT NULL,
    managerId  VARCHAR(30) NULL,
    inDttmReq  DATETIME    NOT NULL,
    inDateWish DATE        NULL,
    inDttmAppr DATETIME    NULL,
    IsDelete   TINYINT     NULL,
    IsTempo    TINYINT     NULL
);

-- inboundItems (FK 나중에 추가)
CREATE TABLE inboundItems
(
    inReqItemsId BIGINT AUTO_INCREMENT PRIMARY KEY,
    inReqId      BIGINT       NOT NULL,
    cfId         CHAR(12)     NOT NULL,
    locationId   CHAR(12)     NULL,
    status       VARCHAR(10)  NULL,
    inQtyReq     INT          NULL,
    inOrderAddr  VARCHAR(255) NULL,
    inQty        INT          NULL,
    inDttmSchd   DATETIME     NULL,
    inDttmInsp   DATETIME     NULL,
    inDttmRecv   DATETIME     NULL
);

-- outboundrequest (FK 나중에 추가)
CREATE TABLE outboundrequest
(
    outReqId    BIGINT AUTO_INCREMENT PRIMARY KEY,
    comId       VARCHAR(30) NOT NULL,
    managerID   VARCHAR(30) NULL,
    outDttmReq  DATETIME    NOT NULL,
    outDateWish DATE        NULL,
    outDttmAppr DATETIME    NULL,
    IsDelete    TINYINT     NULL,
    IsTempo     DATE        NULL
);

-- outboundItems (FK 나중에 추가)
CREATE TABLE outboundItems
(
    outReqItemsId BIGINT AUTO_INCREMENT PRIMARY KEY,
    outReqId      BIGINT       NOT NULL,
    stkId         CHAR(12)     NOT NULL,
    vehicleId     CHAR(10)     NULL,
    status        VARCHAR(10)  NULL,
    outQtyReq     INT          NOT NULL,
    outOrderAddr  VARCHAR(255) NULL,
    outDttmSchd   DATETIME     NULL,
    outDttmInsp   DATETIME     NULL,
    outDttmShip   DATETIME     NULL
);

-- due_diligence (FK 나중에 추가)
CREATE TABLE due_diligence
(
    ddId            BIGINT AUTO_INCREMENT PRIMARY KEY,
    stkId           CHAR(12)     NOT NULL,
    ddDate          DATETIME     NOT NULL DEFAULT NOW(),
    ddApproval      CHAR(10)     NOT NULL DEFAULT 'PENDING',
    ddStatus        CHAR(10)     NOT NULL,
    isDelete        TINYINT               DEFAULT 0,
    ddUpdateDate    DATETIME     NULL,
    maid            VARCHAR(30)  NOT NULL,
    ddLog           VARCHAR(255) NULL,
    realStkQuantity INT          NOT NULL
);

-- warehouse_management (FK 나중에 추가)
CREATE TABLE warehouse_management
(
    whManagementId BIGINT      NOT NULL,
    whId           BIGINT      NOT NULL,
    userId         VARCHAR(30) NOT NULL,
    PRIMARY KEY (whManagementId)
);

-- 2) 데이터 INSERT

-- vehicles
INSERT INTO vehicles (vehicleId, vehicleModel, vehicleDesc)
VALUES ('55가1001', '5톤 윙바디', '주력 운송 차량, 정비 완료'),
       ('55나2002', '5톤 윙바디', '차량 점검 필요, 다음 주 정비 예정'),
       ('55다3003', '5톤 윙바디', '서울-경기 지역 운행 중'),
       ('55라4004', '5톤 윙바디', '긴급 물류 요청 대비 예비 차량'),
       ('55마5005', '5톤 윙바디', '주로 부산/영남권 장거리 운행 담당'),
       ('55바6006', '5톤 윙바디', '운전자 변경 대기 중'),
       ('55사7007', '5톤 윙바디', '오전 운행 후 복귀'),
       ('55아8008', '5톤 윙바디', '새로 구매한 차량, 시범 운행 중'),
       ('55자9009', '5톤 윙바디', '창고 간 재고 이동 전용'),
       ('55차0010', '5톤 윙바디', '가장 최근에 정비 받은 차량');

-- users
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode,
                   userRoadAddr, userDetailAddr, userJoinDate, userRole, userStatus,
                   userLastLogin, userImgPath, vehicleId)
VALUES ('coffeebiz01', 'hashedPwd1!', '메오커피', '김대표', '010-1234-5678', 'ceo1@meowcoffee.com', '123-45-67890',
        '서울시 강남구 테헤란로 123', '101호', '2025-01-10', 'COMPANY', 'APPROVAL',
        '2025-11-06', 'C:\\study\\meowcoffeeFile\\profiles\\profile_coffeebiz01_123-45-67890', NULL),
       ('coffeebiz02', 'hashedPwd2@', '블루빈스', '이대표', '010-2345-6789', 'ceo2@bluebeans.co.kr', '234-56-78901',
        '서울시 마포구 월드컵북로 45', '3층', NULL, 'COMPANY', 'WAITING_APPROVAL',
        NULL, NULL, NULL),
       ('manager01', 'hashedPwd3#', NULL, '박관리자', '010-3456-7890', 'manager1@meowcoffee.com', 'MAN-00-00001',
        '경기도 성남시 분당구 판교로 242', 'A동 5층', '2025-03-15', 'MANAGER', 'APPROVAL',
        '2025-11-05', 'C:\\study\\meowcoffeeFile\\profiles\\profile_manager01_MAN-00-00001', NULL),
       ('manager02', 'hashedPwd4$', NULL, '최관리자', '010-4567-8901', 'manager2@meowcoffee.com', 'MAN-00-00002',
        '서울시 송파구 중대로 12', '2층', NULL, 'MANAGER', 'WAITING_APPROVAL',
        NULL, NULL, NULL),
       ('admin01', 'hashedPwd5%', NULL, '정총관리자', '010-5678-9012', 'admin@meowcoffee.com', 'ADM-00-00001',
        '서울시 종로구 세종대로 175', '본관 7층', '2024-12-01', 'ADMIN', 'APPROVAL',
        '2025-11-06', 'C:\\study\\meowcoffeeFile\\profiles\\profile_admin01_ADM-00-00001', NULL),
       ('delivery01', 'hashedPwd6^', NULL, '이배송', '010-6789-0123', 'delivery1@meowcoffee.com', 'DEL-00-00001',
        '경기도 고양시 일산서구 중앙로 100', '1층 물류센터', '2025-06-20', 'DELIVERYMAN', 'APPROVAL',
        '2025-11-04', 'C:\\study\\meowcoffeeFile\\profiles\\profile_delivery01_DEL-00-00001', '55가1001'),
       ('delivery02', 'hashedPwd7&', NULL, '김배송', '010-7890-1234', 'delivery2@meowcoffee.com', 'DEL-00-00002',
        '인천시 부평구 경원대로 200', '지하 1층', NULL, 'DELIVERYMAN', 'WAITING_APPROVAL',
        NULL, NULL, '55나2002'),
       ('coffeebiz03', 'hashedPwd8*', '카페봄날', '정대표', '010-8901-2345', 'ceo3@springcafe.kr', '345-67-89012',
        '부산시 해운대구 해운대로 321', '2층', '2023-11-01', 'COMPANY', 'DEACTIVATED',
        '2024-12-31', 'C:\\study\\meowcoffeeFile\\profiles\\profile_coffeebiz03_345-67-89012', NULL),
       ('manager03', 'hashedPwd9(', NULL, '한관리자', '010-9012-3456', 'manager3@meowcoffee.com', 'MAN-00-00003',
        '대전시 유성구 대학로 99', '연구동 3층', NULL, 'MANAGER', 'WAITING_APPROVAL',
        NULL, NULL, NULL),
       ('delivery03', 'hashedPwd10)', NULL, '오배송', '010-0123-4567', 'delivery3@meowcoffee.com', 'DEL-00-00003',
        '광주시 북구 무등로 88', '물류센터 2층', '2024-08-15', 'DELIVERYMAN', 'WAITING_DEACTIVATE',
        '2025-10-28', 'C:\\study\\meowcoffeeFile\\profiles\\profile_delivery03_DEL-00-00003', '55다3003');

-- coffee
INSERT INTO coffee (cfId, cfName, cfOrigin, cfCategory, cfGrade, cfType)
VALUES ('CF001', '에티오피아 예가체프', 'ETH', 'B01', '스페셜티', '아라비카'),
       ('CF002', '콜롬비아 수프리모', 'COL', 'B02', '프리미엄', '아라비카'),
       ('CF003', '브라질 산토스', 'BRA', 'B03', '레귤러', '로부스타'),
       ('CF004', '케냐 AA', 'KEN', 'B01', '스페셜티', '아라비카'),
       ('CF005', '과테말라 안티구아', 'GUA', 'B02', '프리미엄', '아라비카');

-- warehouse
INSERT INTO warehouse (whCode, whName, whAddress, whTelPhone, whGrade, whField, whTotalCapa, whUseCapa)
VALUES ('WH001', '서울창고', '서울특별시 강남구 테헤란로 123', '02-111-2222', 'A', 200, 1000, 600),
       ('WH002', '부산창고', '부산광역시 해운대구 해운대로 45', '051-333-4444', 'B', 150, 800, 500),
       ('WH003', '대구창고', '대구광역시 수성구 동대구로 88', '053-555-6666', 'A', 180, 900, 700);

-- location_places
INSERT INTO location_places (lpId, zoneId, zoneName, rackId, rackName, cellId, cellName)
VALUES ('LP001', 'Z001', 'Zone-A', 'R001', 'Rack-A1', 'C001', 'Cell-1'),
       ('LP002', 'Z001', 'Zone-A', 'R002', 'Rack-A2', 'C002', 'Cell-2'),
       ('LP003', 'Z002', 'Zone-B', 'R003', 'Rack-B1', 'C003', 'Cell-3'),
       ('LP004', 'Z002', 'Zone-B', 'R004', 'Rack-B2', 'C004', 'Cell-4'),
       ('LP005', 'Z003', 'Zone-C', 'R005', 'Rack-C1', 'C005', 'Cell-5');

-- stock
INSERT INTO stock (stkId, lpId, cfId, stkQuantity)
VALUES ('STK001', 'LP001', 'CF001', 120),
       ('STK002', 'LP002', 'CF002', 200),
       ('STK003', 'LP003', 'CF003', 150),
       ('STK004', 'LP004', 'CF004', 80),
       ('STK005', 'LP005', 'CF005', 60);

-- locations
INSERT INTO locations (locationId, whId, lpId)
VALUES ('LOC001', 1, 'LP001'),
       ('LOC002', 1, 'LP002'),
       ('LOC003', 2, 'LP003'),
       ('LOC004', 3, 'LP004'),
       ('LOC005', 3, 'LP005');

-- inboundRequests
INSERT INTO inboundRequests (comId, managerId, inDttmReq, inDateWish, inDttmAppr, IsDelete, IsTempo)
VALUES ('coffeebiz01', 'manager01', '2025-11-01 09:00:00', '2025-11-05', '2025-11-02 10:00:00', 0, 0),
       ('coffeebiz02', 'manager01', '2025-11-02 10:30:00', '2025-11-06', NULL, 0, 1),
       ('coffeebiz01', 'manager02', '2025-11-03 14:15:00', '2025-11-07', '2025-11-04 09:00:00', 0, 0),
       ('coffeebiz03', 'manager03', '2025-11-04 08:45:00', '2025-11-08', NULL, 0, 1),
       ('coffeebiz01', 'manager01', '2025-11-05 11:00:00', '2025-11-09', '2025-11-06 13:00:00', 0, 0);

-- inboundItems
INSERT INTO inboundItems (inReqId, cfId, locationId, status, inQtyReq, inOrderAddr, inQty, inDttmSchd, inDttmInsp,
                          inDttmRecv)
VALUES (1, 'CF001', 'LOC001', '승인대기', 100, '서울 강남 물류센터', NULL, '2025-11-05 10:00:00', NULL, NULL),
       (1, 'CF002', 'LOC001', '승인대기', 50, '서울 강남 물류센터', NULL, '2025-11-05 10:00:00', NULL, NULL),
       (2, 'CF003', 'LOC002', '승인대기', 80, '서울 마포 물류센터', NULL, '2025-11-06 11:00:00', NULL, NULL),
       (2, 'CF004', 'LOC002', '승인대기', 120, '서울 마포 물류센터', NULL, '2025-11-06 11:00:00', NULL, NULL),
       (3, 'CF005', 'LOC003', '승인완료', 60, '경기 성남 물류센터', 60, '2025-11-07 09:00:00', '2025-11-06 15:00:00',
        '2025-11-07 10:00:00'),
       (3, 'CF001', 'LOC003', '승인완료', 30, '경기 성남 물류센터', 30, '2025-11-07 09:00:00', '2025-11-06 15:00:00',
        '2025-11-07 10:00:00'),
       (3, 'CF002', 'LOC003', '승인완료', 40, '경기 성남 물류센터', 40, '2025-11-07 09:00:00', '2025-11-06 15:00:00',
        '2025-11-07 10:00:00'),
       (4, 'CF003', 'LOC004', '승인대기', 90, '부산 해운대 물류센터', NULL, '2025-11-08 13:00:00', NULL, NULL),
       (4, 'CF004', 'LOC004', '승인대기', 70, '부산 해운대 물류센터', NULL, '2025-11-08 13:00:00', NULL, NULL),
       (5, 'CF005', 'LOC005', '승인완료', 110, '대구 수성 물류센터', 110, '2025-11-09 14:00:00', '2025-11-08 16:00:00',
        '2025-11-09 15:00:00');

-- outboundrequest
INSERT INTO outboundrequest (comId, managerID, outDttmReq, outDateWish, outDttmAppr, IsDelete, IsTempo)
VALUES ('coffeebiz01', 'manager01', '2025-11-06 09:00:00', '2025-11-08', '2025-11-06 14:00:00', 0, NULL),
       ('coffeebiz02', 'manager01', '2025-11-06 10:30:00', '2025-11-09', NULL, 0, NULL),
       ('coffeebiz01', 'manager02', '2025-11-07 11:15:00', '2025-11-10', '2025-11-07 16:00:00', 0, NULL),
       ('coffeebiz03', 'manager03', '2025-11-07 13:45:00', '2025-11-11', NULL, 0, NULL),
       ('coffeebiz01', 'manager01', '2025-11-08 08:20:00', '2025-11-12', '2025-11-08 12:00:00', 0, NULL);

-- outboundItems
INSERT INTO outboundItems (outReqId, stkId, vehicleId, status, outQtyReq, outOrderAddr, outDttmSchd, outDttmInsp,
                           outDttmShip)
VALUES (1, 'STK001', '55가1001', '승인완료', 50, '서울 강남구 테헤란로 123', '2025-11-08 09:00:00', '2025-11-07 15:00:00',
        '2025-11-08 10:00:00'),
       (1, 'STK002', '55가1001', '승인완료', 30, '서울 강남구 테헤란로 123', '2025-11-08 09:00:00', '2025-11-07 15:00:00',
        '2025-11-08 10:00:00'),
       (2, 'STK003', '55나2002', '승인대기', 40, '서울 마포구 월드컵북로 45', '2025-11-09 10:00:00', NULL, NULL),
       (2, 'STK004', '55나2002', '승인대기', 20, '서울 마포구 월드컵북로 45', '2025-11-09 10:00:00', NULL, NULL),
       (3, 'STK005', '55다3003', '승인완료', 25, '경기 성남시 판교로 242', '2025-11-10 11:00:00', '2025-11-09 14:00:00',
        '2025-11-10 12:00:00'),
       (3, 'STK001', '55다3003', '승인완료', 15, '경기 성남시 판교로 242', '2025-11-10 11:00:00', '2025-11-09 14:00:00',
        '2025-11-10 12:00:00'),
       (4, 'STK002', '55라4004', '승인대기', 35, '부산 해운대구 해운대로 321', '2025-11-11 13:00:00', NULL, NULL),
       (4, 'STK003', '55라4004', '승인대기', 45, '부산 해운대구 해운대로 321', '2025-11-11 13:00:00', NULL, NULL),
       (5, 'STK004', '55마5005', '승인완료', 20, '대구 수성구 동대구로 88', '2025-11-12 14:00:00', '2025-11-11 16:00:00',
        '2025-11-12 15:00:00'),
       (5, 'STK005', '55마5005', '승인완료', 40, '대구 수성구 동대구로 88', '2025-11-12 14:00:00', '2025-11-11 16:00:00',
        '2025-11-12 15:00:00');

-- due_diligence
INSERT INTO due_diligence (stkId, ddDate, ddApproval, ddStatus, maid, ddLog, realStkQuantity)
VALUES ('STK001', NOW(), 'APPROVED', 'CORRECT', 'admin', '정상 수량 확인', 120),
       ('STK002', NOW(), 'PENDING', 'INCORRECT', 'manager01', '수량 확인 중', 195),
       ('STK003', NOW(), 'REJECTED', 'INCORRECT', 'manager02', '수량 차이 발생', 140),
       ('STK004', NOW(), 'APPROVED', 'CORRECT', 'admin', '검수 완료', 80),
       ('STK005', NOW(), 'PENDING', 'INCORRECT', 'manager03', '실사 대기 중', 0);

-- warehouse_management
INSERT INTO warehouse_management (whManagementId, whId, userId)
VALUES (1, 1, 'manager01'),
       (2, 2, 'manager02'),
       (3, 3, 'manager03'),
       (4, 1, 'admin01'),
       (5, 2, 'admin01');

-- 3) FK 일괄 추가 (맨 마지막)

ALTER TABLE users
    ADD CONSTRAINT fk_users_vehicles
        FOREIGN KEY (vehicleId) REFERENCES vehicles (vehicleId);

ALTER TABLE stock
    ADD CONSTRAINT fk_stock_location_places FOREIGN KEY (lpId) REFERENCES location_places (lpId),
    ADD CONSTRAINT fk_stock_coffee FOREIGN KEY (cfId) REFERENCES coffee (cfId);

ALTER TABLE locations
    ADD CONSTRAINT fk_locations_warehouse FOREIGN KEY (whId) REFERENCES warehouse (whId),
    ADD CONSTRAINT fk_locations_location_places FOREIGN KEY (lpId) REFERENCES location_places (lpId);

ALTER TABLE inboundRequests
    ADD CONSTRAINT FK_users_TO_inboundRequests_1 FOREIGN KEY (comId) REFERENCES users (userId),
    ADD CONSTRAINT FK_users_TO_inboundRequests_2 FOREIGN KEY (managerId) REFERENCES users (userId);

ALTER TABLE inboundItems
    ADD CONSTRAINT fk_inboundItems_inReq FOREIGN KEY (inReqId) REFERENCES inboundRequests (inReqId),
    ADD CONSTRAINT fk_inboundItems_coffee FOREIGN KEY (cfId) REFERENCES coffee (cfId),
    ADD CONSTRAINT fk_inboundItems_loc FOREIGN KEY (locationId) REFERENCES locations (locationId);

ALTER TABLE outboundrequest
    ADD CONSTRAINT FK_users_TO_outboundrequest_1 FOREIGN KEY (comId) REFERENCES users (userId),
    ADD CONSTRAINT FK_users_TO_outboundrequest_2 FOREIGN KEY (managerID) REFERENCES users (userId);

ALTER TABLE outboundItems
    ADD CONSTRAINT fk_outboundItems_outReq FOREIGN KEY (outReqId) REFERENCES outboundrequest (outReqId),
    ADD CONSTRAINT fk_outboundItems_stk FOREIGN KEY (stkId) REFERENCES stock (stkId),
    ADD CONSTRAINT fk_outboundItems_vhc FOREIGN KEY (vehicleId) REFERENCES vehicles (vehicleId);

ALTER TABLE due_diligence
    ADD CONSTRAINT fk_due_diligence_stock FOREIGN KEY (stkId) REFERENCES stock (stkId);

ALTER TABLE warehouse_management
    ADD CONSTRAINT FK_warehouse_TO_warehouse_management_1 FOREIGN KEY (whId) REFERENCES warehouse (whId),
    ADD CONSTRAINT FK_users_TO_warehouse_management_1 FOREIGN KEY (userId) REFERENCES users (userId);

CREATE TABLE `expense`
(
    `expenseId`       BIGINT AUTO_INCREMENT PRIMARY KEY,
    `expenseDt`       DATETIME                                                                          NOT NULL,
    `expenseCategory` ENUM ('inboundCost', 'outboundCost', 'deliveryCost', 'storageCost', 'management') NOT NULL,
    `totalAmt`        DECIMAL(15, 2)                                                                    NOT NULL,
    `expenseStatus`   ENUM ('draft', 'posted')                                                          NOT NULL,
    `confirmDt`       DATETIME                                                                          NULL,
    `isDelete`        BOOLEAN                                                                           NOT NULL DEFAULT FALSE,
    `whId`            bigint                                                                            NOT NULL,
    `userId`          varchar(30)                                                                       NULL
);

CREATE TABLE `invoice`
(
    `invoiceId`     BIGINT AUTO_INCREMENT PRIMARY KEY,
    `invoiceDt`     DATETIME                                     NOT NULL,
    `totalAmt`      DECIMAL(15, 2)                               NOT NULL,
    `invoiceStatus` ENUM ('draft', 'issued', 'paid', 'canceled') NOT NULL,
    `depositDt`     DATETIME                                     NULL,
    `userId`        varchar(30)                                  NOT NULL
);

CREATE TABLE `revenue`
(
    `revenueId` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `totalAmt`  DECIMAL(15, 2) NOT NULL,
    `revenueDt` DATETIME       NOT NULL
);

CREATE TABLE `unitCost`
(
    `unitCostId`     BIGINT AUTO_INCREMENT PRIMARY KEY,
    `laborUnitAmt`   DECIMAL(15, 2) NOT NULL,
    `inspectUnitAmt` DECIMAL(15, 2) NOT NULL,
    `packingUnitAmt` DECIMAL(15, 2) NOT NULL,
    `transUnitAmt`   DECIMAL(15, 2) NOT NULL,
    `storeUnitAmt`   DECIMAL(15, 2) NOT NULL
);

CREATE TABLE `feeRate`
(
    `feeRateId`       BIGINT AUTO_INCREMENT PRIMARY KEY,
    `inFeeRatePct`    DECIMAL(5, 2) NOT NULL,
    `outFeeRatePct`   DECIMAL(5, 2) NOT NULL,
    `storeFeeRatePct` DECIMAL(5, 2) NOT NULL,
    `delFeeRatePct`   DECIMAL(5, 2) NOT NULL
);

CREATE TABLE `inboundCost`
(
    `inCostId`   BIGINT AUTO_INCREMENT PRIMARY KEY,
    `laborAmt`   DECIMAL(15, 2) NOT NULL,
    `inspectAmt` DECIMAL(15, 2) NOT NULL,
    `inReqId`    bigint         NOT NULL
);

CREATE TABLE `outboundCost`
(
    `outCostId`  BIGINT AUTO_INCREMENT PRIMARY KEY,
    `pickingAmt` DECIMAL(15, 2) NOT NULL,
    `packingAmt` DECIMAL(15, 2) NOT NULL,
    `laborAmt`   DECIMAL(15, 2) NOT NULL,
    `outReqId`   bigint         NOT NULL
);

CREATE TABLE `storageCost`
(
    `storeCostId` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `storeAmt`    DECIMAL(15, 2) NOT NULL,
    `ddId`        bigint         NOT NULL
);

CREATE TABLE `deliveryCost`
(
    `delCostId`    BIGINT AUTO_INCREMENT PRIMARY KEY,
    `transportAmt` DECIMAL(15, 2) NOT NULL,
    `outReqId`     bigint         NOT NULL
);

ALTER TABLE expense
    ADD CONSTRAINT FK_warehouse_TO_expense FOREIGN KEY (whId) REFERENCES warehouse (whId),
    ADD CONSTRAINT FK_users_TO_expense FOREIGN KEY (userId) REFERENCES users (userId);

ALTER TABLE invoice
    ADD CONSTRAINT FK_users_TO_invoice FOREIGN KEY (userId) REFERENCES users (userId);

ALTER TABLE inboundCost
    ADD CONSTRAINT FK_inboundItems_TO_inboundCost FOREIGN KEY (inReqId) REFERENCES inboundItems (inReqId);

ALTER TABLE outboundCost
    ADD CONSTRAINT FK_outboundItems_TO_outboundCost FOREIGN KEY (outReqId) REFERENCES outboundItems (outReqId);

ALTER TABLE storageCost
    ADD CONSTRAINT FK_due_diligence_TO_storageCost FOREIGN KEY (ddId) REFERENCES due_diligence (ddId);

ALTER TABLE deliveryCost
    ADD CONSTRAINT FK_outboundItems_TO_deliveryCost FOREIGN KEY (outReqId) REFERENCES outboundItems (outReqId);


SELECT *
FROM inboundItems;
SELECT *
FROM outboundItems;


SELECT *
FROM inboundCost;
SELECT *
FROM outboundCost;
SELECT *
FROM expense;

-- 단가와, 수수료 입력하기!
INSERT INTO unitCost (laborUnitAmt, inspectUnitAmt, packingUnitAmt, transUnitAmt, storeUnitAmt)
VALUES (12000, 300, 5000, 300, 500);
SELECT *
FROM unitCost;

INSERT INTO feeRate (inFeeRatePct, outFeeRatePct, storeFeeRatePct, delFeeRatePct)
VALUES (1.2, 1.25, 1.1, 1.05);
SELECT *
FROM feeRate;
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
