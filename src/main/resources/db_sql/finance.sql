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
VALUES ('coffeebiz01', 'manager01', '2025-01-02 09:00:00', '2025-01-05', '2025-11-02 10:00:00', 0, 0),
       ('coffeebiz02', 'manager01', '2025-02-02 10:30:00', '2025-10-06', NULL, 0, 1),
       ('coffeebiz01', 'manager02', '2025-03-03 14:15:00', '2025-11-07', '2025-11-04 09:00:00', 0, 0),
       ('coffeebiz03', 'manager03', '2025-04-04 08:45:00', '2025-11-08', NULL, 0, 1),
       ('coffeebiz02', 'manager01', '2025-05-05 11:00:00', '2025-11-09', '2025-11-06 13:00:00', 0, 0),
       ('coffeebiz01', 'manager01', '2025-06-01 09:00:00', '2025-11-05', '2025-11-02 10:00:00', 0, 0),
       ('coffeebiz02', 'manager01', '2025-07-02 10:30:00', '2025-11-06', NULL, 0, 1),
       ('coffeebiz01', 'manager02', '2025-08-03 14:15:00', '2025-11-07', '2025-11-04 09:00:00', 0, 0),
       ('coffeebiz03', 'manager03', '2025-09-04 08:45:00', '2025-11-08', NULL, 0, 1),
       ('coffeebiz01', 'manager01', '2025-10-05 11:00:00', '2025-11-09', '2025-11-06 13:00:00', 0, 0);

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

-- ============================
-- inboundRequests (11~40)
-- ============================
INSERT INTO inboundRequests (comId, managerId, inDttmReq, inDateWish, inDttmAppr, IsDelete, IsTempo)
VALUES
-- 2025-01 ~ 2025-12 균등 배치
('coffeebiz01', 'manager01', '2025-01-05 09:00:00', '2025-01-10', '2025-01-06 10:00:00', 0, 0), -- 11
('coffeebiz02', 'manager02', '2025-02-12 10:00:00', '2025-02-18', NULL, 0, 1),                  -- 12
('coffeebiz03', 'manager03', '2025-03-03 11:00:00', '2025-03-08', '2025-03-04 09:00:00', 0, 0), -- 13
('coffeebiz01', 'manager02', '2025-03-22 15:00:00', '2025-03-27', NULL, 0, 1),                  -- 14
('coffeebiz02', 'manager01', '2025-04-01 09:00:00', '2025-04-05', '2025-04-02 13:00:00', 0, 0), -- 15
('coffeebiz03', 'manager03', '2025-04-17 08:30:00', '2025-04-23', NULL, 0, 1),                  -- 16
('coffeebiz01', 'manager01', '2025-05-06 14:15:00', '2025-05-12', '2025-05-07 10:00:00', 0, 0), -- 17
('coffeebiz02', 'manager01', '2025-05-27 12:00:00', '2025-06-02', NULL, 0, 1),                  -- 18
('coffeebiz03', 'manager02', '2025-06-04 09:10:00', '2025-06-10', '2025-06-05 13:30:00', 0, 0), -- 19
('coffeebiz01', 'manager03', '2025-06-25 16:00:00', '2025-07-01', NULL, 0, 1),                  -- 20
('coffeebiz02', 'manager01', '2025-07-07 10:20:00', '2025-07-12', '2025-07-08 08:50:00', 0, 0), -- 21
('coffeebiz03', 'manager03', '2025-07-19 09:45:00', '2025-07-24', NULL, 0, 1),                  -- 22
('coffeebiz01', 'manager02', '2025-08-02 15:10:00', '2025-08-08', '2025-08-03 11:00:00', 0, 0), -- 23
('coffeebiz02', 'manager02', '2025-08-21 10:10:00', '2025-08-27', NULL, 0, 1),                  -- 24
('coffeebiz03', 'manager01', '2025-09-05 08:30:00', '2025-09-11', '2025-09-06 12:00:00', 0, 0), -- 25
('coffeebiz01', 'manager03', '2025-09-28 14:40:00', '2025-10-04', NULL, 0, 1),                  -- 26
('coffeebiz02', 'manager01', '2025-10-09 09:15:00', '2025-10-15', '2025-10-10 13:30:00', 0, 0), -- 27
('coffeebiz03', 'manager02', '2025-10-20 11:50:00', '2025-10-26', NULL, 0, 1),                  -- 28
('coffeebiz01', 'manager01', '2025-11-03 09:30:00', '2025-11-09', '2025-11-04 10:10:00', 0, 0), -- 29
('coffeebiz02', 'manager03', '2025-11-18 14:00:00', '2025-11-24', NULL, 0, 1),                  -- 30
('coffeebiz03', 'manager02', '2025-12-01 10:25:00', '2025-12-07', '2025-12-02 09:00:00', 0, 0), -- 31
('coffeebiz01', 'manager01', '2025-12-12 08:00:00', '2025-12-18', NULL, 0, 1),                  -- 32
('coffeebiz02', 'manager03', '2025-01-18 13:10:00', '2025-01-23', '2025-01-19 09:00:00', 0, 0), -- 33
('coffeebiz03', 'manager01', '2025-02-25 16:00:00', '2025-03-03', NULL, 0, 1),                  -- 34
('coffeebiz01', 'manager02', '2025-03-14 09:25:00', '2025-03-20', '2025-03-15 13:10:00', 0, 0), -- 35
('coffeebiz02', 'manager01', '2025-04-29 10:40:00', '2025-05-05', NULL, 0, 1),                  -- 36
('coffeebiz03', 'manager03', '2025-07-11 08:10:00', '2025-07-17', '2025-07-12 09:00:00', 0, 0), -- 37
('coffeebiz01', 'manager02', '2025-08-29 11:00:00', '2025-09-03', NULL, 0, 1),                  -- 38
('coffeebiz02', 'manager03', '2025-10-30 15:35:00', '2025-11-05', '2025-10-31 10:00:00', 0, 0), -- 39
('coffeebiz03', 'manager01', '2025-12-22 09:15:00', '2025-12-28', NULL, 0, 1);
-- 40


-- ============================
-- inboundItems (1개씩 30건)
-- 월/일 랜덤 분포
-- ============================
INSERT INTO inboundItems (inReqId, cfId, locationId, status,
                          inQtyReq, inOrderAddr, inQty,
                          inDttmSchd, inDttmInsp, inDttmRecv)
VALUES (11, 'CF001', 'LOC001', '승인완료', 120, '서울 강남센터', 120, '2025-01-11 09:00:00', '2025-01-10 13:00:00',
        '2025-01-11 09:40:00'),
       (12, 'CF002', 'LOC002', '승인대기', 80, '서울 마포센터', NULL, '2025-02-19 10:00:00', NULL, NULL),
       (13, 'CF003', 'LOC003', '승인완료', 60, '성남센터', 60, '2025-03-09 11:00:00', '2025-03-08 15:00:00',
        '2025-03-09 11:30:00'),
       (14, 'CF004', 'LOC004', '승인대기', 90, '부산센터', NULL, '2025-03-28 15:00:00', NULL, NULL),
       (15, 'CF005', 'LOC005', '승인완료', 110, '대구센터', 110, '2025-04-06 10:00:00', '2025-04-05 14:00:00',
        '2025-04-06 10:35:00'),
       (16, 'CF001', 'LOC001', '승인대기', 70, '서울 강북센터', NULL, '2025-04-24 08:30:00', NULL, NULL),
       (17, 'CF002', 'LOC002', '승인완료', 95, '광주센터', 95, '2025-05-13 14:00:00', '2025-05-12 17:00:00',
        '2025-05-13 14:35:00'),
       (18, 'CF003', 'LOC003', '승인대기', 50, '광주센터', NULL, '2025-06-03 09:00:00', NULL, NULL),
       (19, 'CF004', 'LOC004', '승인완료', 85, '인천센터', 85, '2025-06-11 16:00:00', '2025-06-10 13:00:00',
        '2025-06-11 16:40:00'),
       (20, 'CF005', 'LOC005', '승인대기', 40, '인천센터', NULL, '2025-07-02 10:00:00', NULL, NULL),
       (21, 'CF001', 'LOC001', '승인완료', 60, '서울 강남센터', 60, '2025-07-13 09:20:00', '2025-07-12 14:00:00',
        '2025-07-13 09:55:00'),
       (22, 'CF002', 'LOC002', '승인대기', 30, '서울 강남센터', NULL, '2025-07-25 11:00:00', NULL, NULL),
       (23, 'CF003', 'LOC003', '승인완료', 45, '성남센터', 45, '2025-08-09 10:00:00', '2025-08-08 16:00:00',
        '2025-08-09 10:25:00'),
       (24, 'CF004', 'LOC004', '승인대기', 55, '부산센터', NULL, '2025-08-28 15:30:00', NULL, NULL),
       (25, 'CF005', 'LOC005', '승인완료', 100, '대구센터', 100, '2025-09-12 09:00:00', '2025-09-11 13:00:00',
        '2025-09-12 09:40:00'),
       (26, 'CF001', 'LOC001', '승인대기', 40, '서울 강북센터', NULL, '2025-09-30 17:30:00', NULL, NULL),
       (27, 'CF002', 'LOC002', '승인완료', 70, '광주센터', 70, '2025-10-12 09:00:00', '2025-10-11 14:00:00',
        '2025-10-12 09:35:00'),
       (28, 'CF003', 'LOC003', '승인대기', 90, '광주센터', NULL, '2025-10-27 13:00:00', NULL, NULL),
       (29, 'CF004', 'LOC004', '승인완료', 55, '인천센터', 55, '2025-11-10 14:00:00', '2025-11-09 17:00:00',
        '2025-11-10 14:30:00'),
       (30, 'CF005', 'LOC005', '승인대기', 75, '인천센터', NULL, '2025-11-25 09:00:00', NULL, NULL),
       (31, 'CF001', 'LOC001', '승인완료', 120, '서울 강남센터', 120, '2025-12-08 10:00:00', '2025-12-07 14:00:00',
        '2025-12-08 10:40:00'),
       (32, 'CF002', 'LOC002', '승인대기', 80, '서울 마포센터', NULL, '2025-12-19 11:00:00', NULL, NULL),
       (33, 'CF003', 'LOC003', '승인완료', 60, '성남센터', 60, '2025-01-24 09:00:00', '2025-01-23 13:00:00',
        '2025-01-24 09:40:00'),
       (34, 'CF004', 'LOC004', '승인대기', 40, '부산센터', NULL, '2025-02-27 16:00:00', NULL, NULL),
       (35, 'CF005', 'LOC005', '승인완료', 90, '대구센터', 90, '2025-03-21 10:00:00', '2025-03-20 15:00:00',
        '2025-03-21 10:35:00'),
       (36, 'CF001', 'LOC001', '승인대기', 30, '서울 강북센터', NULL, '2025-05-08 13:00:00', NULL, NULL),
       (37, 'CF002', 'LOC002', '승인완료', 70, '광주센터', 70, '2025-07-18 09:00:00', '2025-07-17 16:00:00',
        '2025-07-18 09:30:00'),
       (38, 'CF003', 'LOC003', '승인대기', 50, '광주센터', NULL, '2025-08-31 11:00:00', NULL, NULL),
       (39, 'CF004', 'LOC004', '승인완료', 85, '인천센터', 85, '2025-11-07 15:00:00', '2025-11-06 13:00:00',
        '2025-11-07 15:25:00'),
       (40, 'CF005', 'LOC005', '승인대기', 45, '인천센터', NULL, '2025-12-27 14:00:00', NULL, NULL);

-- outboundrequest
INSERT INTO outboundrequest (comId, managerID, outDttmReq, outDateWish, outDttmAppr, IsDelete, IsTempo)
VALUES ('coffeebiz01', 'manager01', '2025-11-06 09:00:00', '2025-11-08', '2025-11-06 14:00:00', 0, NULL),
       ('coffeebiz02', 'manager01', '2025-11-06 10:30:00', '2025-11-09', NULL, 0, NULL),
       ('coffeebiz01', 'manager02', '2025-11-07 11:15:00', '2025-11-10', '2025-11-07 16:00:00', 0, NULL),
       ('coffeebiz03', 'manager03', '2025-11-07 13:45:00', '2025-11-11', NULL, 0, NULL),
       ('coffeebiz01', 'manager01', '2025-11-08 08:20:00', '2025-11-12', '2025-11-08 12:00:00', 0, NULL);
INSERT INTO outboundrequest (comId, managerID, outDttmReq, outDateWish, outDttmAppr, IsDelete, IsTempo)
VALUES ('coffeebiz01', 'manager01', '2025-01-04 09:10:00', '2025-01-06', '2025-01-04 13:20:00', 0, NULL), -- 6
       ('coffeebiz02', 'manager02', '2025-01-15 10:40:00', '2025-01-18', NULL, 0, NULL),                  -- 7
       ('coffeebiz03', 'manager03', '2025-02-05 11:00:00', '2025-02-09', '2025-02-05 16:00:00', 0, NULL), -- 8
       ('coffeebiz01', 'manager02', '2025-02-22 14:15:00', '2025-02-27', NULL, 0, NULL),                  -- 9
       ('coffeebiz02', 'manager01', '2025-03-01 09:00:00', '2025-03-05', '2025-03-01 12:30:00', 0, NULL), -- 10
       ('coffeebiz03', 'manager03', '2025-03-18 08:30:00', '2025-03-22', NULL, 0, NULL),                  -- 11
       ('coffeebiz01', 'manager01', '2025-04-03 13:00:00', '2025-04-07', '2025-04-03 17:00:00', 0, NULL), -- 12
       ('coffeebiz02', 'manager02', '2025-04-26 10:25:00', '2025-04-30', NULL, 0, NULL),                  -- 13
       ('coffeebiz03', 'manager01', '2025-05-06 09:40:00', '2025-05-10', '2025-05-06 14:00:00', 0, NULL), -- 14
       ('coffeebiz01', 'manager03', '2025-05-27 16:20:00', '2025-06-01', NULL, 0, NULL),                  -- 15
       ('coffeebiz02', 'manager01', '2025-06-04 10:00:00', '2025-06-08', '2025-06-04 13:10:00', 0, NULL), -- 16
       ('coffeebiz03', 'manager02', '2025-06-18 11:15:00', '2025-06-23', NULL, 0, NULL),                  -- 17
       ('coffeebiz01', 'manager02', '2025-07-02 09:00:00', '2025-07-05', '2025-07-02 12:00:00', 0, NULL), -- 18
       ('coffeebiz02', 'manager03', '2025-07-14 13:40:00', '2025-07-18', NULL, 0, NULL),                  -- 19
       ('coffeebiz03', 'manager01', '2025-08-03 08:30:00', '2025-08-07', '2025-08-03 11:50:00', 0, NULL), -- 20
       ('coffeebiz01', 'manager03', '2025-08-23 15:00:00', '2025-08-28', NULL, 0, NULL),                  -- 21
       ('coffeebiz02', 'manager02', '2025-09-05 10:30:00', '2025-09-10', '2025-09-05 14:00:00', 0, NULL), -- 22
       ('coffeebiz03', 'manager01', '2025-09-26 11:00:00', '2025-10-02', NULL, 0, NULL),                  -- 23
       ('coffeebiz01', 'manager01', '2025-10-02 09:15:00', '2025-10-06', '2025-10-02 13:20:00', 0, NULL), -- 24
       ('coffeebiz02', 'manager02', '2025-10-15 10:20:00', '2025-10-19', NULL, 0, NULL),                  -- 25
       ('coffeebiz03', 'manager03', '2025-11-04 09:40:00', '2025-11-08', '2025-11-04 12:50:00', 0, NULL), -- 26
       ('coffeebiz01', 'manager02', '2025-11-21 14:00:00', '2025-11-26', NULL, 0, NULL),                  -- 27
       ('coffeebiz02', 'manager03', '2025-12-03 10:05:00', '2025-12-08', '2025-12-03 14:00:00', 0, NULL), -- 28
       ('coffeebiz03', 'manager01', '2025-12-18 08:30:00', '2025-12-23', NULL, 0, NULL),                  -- 29
       ('coffeebiz01', 'manager03', '2025-01-22 16:00:00', '2025-01-27', '2025-01-22 18:30:00', 0, NULL), -- 30
       ('coffeebiz02', 'manager01', '2025-02-26 09:30:00', '2025-03-03', NULL, 0, NULL),                  -- 31
       ('coffeebiz03', 'manager02', '2025-03-14 10:50:00', '2025-03-18', '2025-03-14 15:40:00', 0, NULL), -- 32
       ('coffeebiz01', 'manager01', '2025-04-29 11:00:00', '2025-05-04', NULL, 0, NULL),                  -- 33
       ('coffeebiz02', 'manager02', '2025-07-09 08:20:00', '2025-07-14', '2025-07-09 12:00:00', 0, NULL), -- 34
       ('coffeebiz03', 'manager03', '2025-10-29 13:10:00', '2025-11-03', NULL, 0, NULL);
-- 35

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
INSERT INTO outboundItems (outReqId, stkId, vehicleId, status, outQtyReq, outOrderAddr,
                           outDttmSchd, outDttmInsp, outDttmShip)
VALUES (6, 'STK001', '55가1001', '승인완료', 40, '서울 강남구 테헤란로 10',
        '2025-01-06 09:00:00', '2025-01-05 15:00:00', '2025-01-06 10:00:00'),

       (7, 'STK002', '55나2002', '승인대기', 30, '서울 마포구 서교동 123',
        '2025-01-18 10:00:00', NULL, NULL),

       (8, 'STK003', '55다3003', '승인완료', 50, '경기 성남시 분당구 88',
        '2025-02-09 11:00:00', '2025-02-08 14:00:00', '2025-02-09 12:00:00'),

       (9, 'STK004', '55라4004', '승인대기', 25, '부산 해운대구 111',
        '2025-02-27 14:00:00', NULL, NULL),

       (10, 'STK005', '55마5005', '승인완료', 20, '대구 동구 44',
        '2025-03-05 10:00:00', '2025-03-04 13:00:00', '2025-03-05 11:00:00'),

       (11, 'STK001', '55가1001', '승인대기', 45, '서울 강북구 55',
        '2025-03-22 09:30:00', NULL, NULL),

       (12, 'STK002', '55나2002', '승인완료', 60, '서울 용산구 77',
        '2025-04-07 13:00:00', '2025-04-06 16:10:00', '2025-04-07 14:00:00'),

       (13, 'STK003', '55다3003', '승인대기', 35, '서울 영등포구 88',
        '2025-04-30 11:00:00', NULL, NULL),

       (14, 'STK004', '55라4004', '승인완료', 30, '경기 성남시 판교 101',
        '2025-05-10 09:00:00', '2025-05-09 14:00:00', '2025-05-10 09:50:00'),

       (15, 'STK005', '55마5005', '승인대기', 55, '대구 중구 22',
        '2025-06-02 15:00:00', NULL, NULL),

       (16, 'STK001', '55가1001', '승인완료', 40, '서울 광진구 33',
        '2025-06-08 09:00:00', '2025-06-07 16:00:00', '2025-06-08 10:00:00'),

       (17, 'STK002', '55나2002', '승인대기', 20, '서울 성동구 101',
        '2025-06-23 11:00:00', NULL, NULL),

       (18, 'STK003', '55다3003', '승인완료', 70, '경기 고양시 88',
        '2025-07-05 10:00:00', '2025-07-04 14:00:00', '2025-07-05 11:00:00'),

       (19, 'STK004', '55라4004', '승인대기', 30, '부산 중구 44',
        '2025-07-18 13:00:00', NULL, NULL),

       (20, 'STK005', '55마5005', '승인완료', 45, '대구 달서구 77',
        '2025-08-07 09:00:00', '2025-08-06 13:00:00', '2025-08-07 09:40:00'),

       (21, 'STK001', '55가1001', '승인대기', 25, '서울 강남구 55',
        '2025-08-28 15:00:00', NULL, NULL),

       (22, 'STK002', '55나2002', '승인완료', 65, '서울 송파구 88',
        '2025-09-10 09:00:00', '2025-09-09 16:00:00', '2025-09-10 10:00:00'),

       (23, 'STK003', '55다3003', '승인대기', 35, '서울 관악구 12',
        '2025-10-02 11:00:00', NULL, NULL),

       (24, 'STK004', '55라4004', '승인완료', 80, '경기 부천시 19',
        '2025-10-06 13:00:00', '2025-10-05 15:00:00', '2025-10-06 14:00:00'),

       (25, 'STK005', '55마5005', '승인대기', 50, '대구 수성구 55',
        '2025-10-19 12:00:00', NULL, NULL),

       (26, 'STK001', '55가1001', '승인완료', 90, '서울 강남구 10',
        '2025-11-08 09:00:00', '2025-11-07 13:40:00', '2025-11-08 10:00:00'),

       (27, 'STK002', '55나2002', '승인대기', 30, '서울 마포구 33',
        '2025-11-26 11:00:00', NULL, NULL),

       (28, 'STK003', '55다3003', '승인완료', 55, '경기 성남시 22',
        '2025-12-08 10:00:00', '2025-12-07 15:00:00', '2025-12-08 11:00:00'),

       (29, 'STK004', '55라4004', '승인대기', 40, '부산 해운대구 44',
        '2025-12-23 13:00:00', NULL, NULL),

       (30, 'STK005', '55마5005', '승인완료', 20, '대구 남구 11',
        '2025-01-27 10:00:00', '2025-01-26 14:00:00', '2025-01-27 11:00:00'),

       (31, 'STK001', '55가1001', '승인대기', 35, '서울 서초구 66',
        '2025-03-03 09:00:00', NULL, NULL),

       (32, 'STK002', '55나2002', '승인완료', 45, '서울 은평구 77',
        '2025-03-18 10:00:00', '2025-03-17 15:00:00', '2025-03-18 10:50:00'),

       (33, 'STK003', '55다3003', '승인대기', 60, '경기 용인시 101',
        '2025-05-04 13:00:00', NULL, NULL),

       (34, 'STK004', '55라4004', '승인완료', 70, '부산 영도구 99',
        '2025-07-14 09:00:00', '2025-07-13 14:00:00', '2025-07-14 10:00:00'),

       (35, 'STK005', '55마5005', '승인대기', 80, '대구 동구 88',
        '2025-11-03 13:00:00', NULL, NULL);


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

    IF NEW.status = '승인완료' AND (OLD.status IS NULL OR OLD.status <> '승인완료') THEN
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

-- 가정1. 입고가 완료됐을때
SELECT *
FROM inboundItems;
SELECT *
FROM inboundCost;

UPDATE inboundItems
SET status     = '승인완료',
    inQty      = 100,
    inDttmInsp = '2025-10-05 15:00:00',
    inDttmRecv = '2025-10-07 11:00:00'
WHERE inreqId = 2;

SELECT *
FROM inboundCost;
SELECT *
FROM expense;

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

-- 가정2.3. 출고가 완료됐을때
SELECT *
FROM outboundItems;
SELECT *
FROM outboundCost;
SELECT *
FROM deliveryCost;

UPDATE outboundItems
SET status      = '승인완료',
    outDttmInsp = '2025-10-10 15:00:00',
    outDttmShip = '2025-10-12 11:00:00'
WHERE outreqId = 2;

SELECT *
FROM outboundCost;
SELECT *
FROM deliveryCost;
SELECT *
FROM expense;

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
SELECT *
FROM due_diligence;

UPDATE due_diligence
SET ddApproval = 'APPROVED'
WHERE ddId = 2;

SELECT *
FROM storageCost;
SELECT *
FROM expense;

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
SELECT *
FROM outboundItems;
SELECT *
FROM outboundCost;
SELECT *
FROM deliveryCost;

UPDATE outboundItems
SET status      = '승인완료',
    outDttmInsp = '2025-10-10 15:00:00',
    outDttmShip = '2025-10-12 11:00:00'
WHERE outreqId = 2;

SELECT *
FROM outboundCost;
SELECT *
FROM deliveryCost;
SELECT *
FROM expense;

USE meowcoffeedb;

SELECT *
FROM expense;

-- 가정5. 청구매월 1일에 청구
DROP PROCEDURE IF EXISTS create_invoice;
DELIMITER $$
CREATE PROCEDURE create_invoice(IN p_run_dt DATE)
BEGIN
    DECLARE v_start DATE;
    DECLARE v_end DATE;

    DECLARE v_in DECIMAL(9, 4);
    DECLARE v_out DECIMAL(9, 4);
    DECLARE v_del DECIMAL(9, 4);
    DECLARE v_store DECIMAL(9, 4);

    IF p_run_dt IS NULL THEN
        SET p_run_dt = CURDATE();
    END IF;

    -- 전월 [1일, 당월 1일)
    SET v_start = DATE_FORMAT(DATE_SUB(p_run_dt, INTERVAL 1 MONTH), '%Y-%m-01');
    SET v_end = DATE_FORMAT(p_run_dt, '%Y-%m-01');

    -- 최신 수수료(배율)
    SELECT inFeeRatePct, outFeeRatePct, delFeeRatePct, storeFeeRatePct
    INTO v_in, v_out, v_del, v_store
    FROM feeRate
    ORDER BY feeRateId DESC
    LIMIT 1;

    -- 임시 테이블: 스키마 먼저 생성 후 INSERT … SELECT
    DROP TEMPORARY TABLE IF EXISTS _t_users;
    CREATE TEMPORARY TABLE _t_users
    (
        userId VARCHAR(30) PRIMARY KEY
    );

    INSERT INTO _t_users(userId)
    SELECT DISTINCT e.userId
    FROM expense e
    WHERE e.expenseDt >= v_start
      AND e.expenseDt < v_end
      AND e.expenseCategory IN ('inboundCost', 'outboundCost', 'deliveryCost', 'storageCost')
      AND IFNULL(e.isDelete, 0) = 0;

    -- 같은 날 생성된 draft 정리
    DELETE i
    FROM invoice i
             JOIN _t_users u ON u.userId = i.userId
    WHERE i.invoiceStatus = 'draft'
      AND i.invoiceDt >= v_start
      AND i.invoiceDt < v_end;

    -- 거래처별 합계(배율 곱, /100 제거)
    INSERT INTO invoice (invoiceDt, totalAmt, invoiceStatus, userId)
    SELECT v_start,
           ROUND(SUM(
                         CASE e.expenseCategory
                             WHEN 'inboundCost' THEN e.totalAmt * v_in
                             WHEN 'outboundCost' THEN e.totalAmt * v_out
                             WHEN 'deliveryCost' THEN e.totalAmt * v_del
                             WHEN 'storageCost' THEN e.totalAmt * v_store
                             ELSE 0
                             END
                 ), 2) AS totalAmt,
           'draft',
           e.userId
    FROM expense e
             JOIN _t_users u ON u.userId = e.userId
    WHERE e.expenseDt >= v_start
      AND e.expenseDt < v_end
      AND e.expenseCategory IN ('inboundCost', 'outboundCost', 'deliveryCost', 'storageCost')
      AND IFNULL(e.isDelete, 0) = 0
    GROUP BY e.userId
    HAVING ROUND(SUM(
                         CASE e.expenseCategory
                             WHEN 'inboundCost' THEN e.totalAmt * v_in
                             WHEN 'outboundCost' THEN e.totalAmt * v_out
                             WHEN 'deliveryCost' THEN e.totalAmt * v_del
                             WHEN 'storageCost' THEN e.totalAmt * v_store
                             ELSE 0
                             END
                 ), 2) > 0;
END$$
DELIMITER ;

-- 매월 1일 00:10 실행 이벤트
SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS ev_monthly_invoice_run;
CREATE EVENT ev_monthly_invoice_run
    ON SCHEDULE EVERY 1 MONTH
        STARTS '2025-01-01 00:10:00'
    ON COMPLETION PRESERVE
    DO CALL create_invoice(curdate());


CALL create_invoice('2025-12-01');


-- 매월 15일 매출 정산
DROP PROCEDURE IF EXISTS create_revenue;
DELIMITER $$
CREATE PROCEDURE create_revenue(
    IN run_dt DATETIME
)
BEGIN
    DECLARE month_start DATE;
    DECLARE month_end DATETIME;
    DECLARE inv_total DECIMAL(18, 2) DEFAULT 0;
    DECLARE exp_total DECIMAL(18, 2) DEFAULT 0;

    -- 전월 기간
    SET month_start = DATE_FORMAT(DATE_SUB(run_dt, INTERVAL 1 MONTH), '%Y-%m-01');
    SET month_end = CONCAT(LAST_DAY(DATE_SUB(run_dt, INTERVAL 1 MONTH)), ' 23:59:59');

    -- 전월 청구 합계(지급 완료)
    SELECT IFNULL(SUM(totalAmt), 0)
    INTO inv_total
    FROM invoice
    WHERE invoiceDt BETWEEN month_start AND month_end
      AND invoiceStatus = 'paid';

    -- 전월 지출 합계(확정, 미삭제)
    SELECT IFNULL(SUM(totalAmt), 0)
    INTO exp_total
    FROM expense
    WHERE expenseDt BETWEEN month_start AND month_end
      AND expenseStatus = 'posted'
      AND IFNULL(isDelete, 0) = 0;

    -- 이익 = 청구 − 지출
    INSERT INTO revenue (totalAmt, revenueDt)
    VALUES (ROUND(inv_total - exp_total, 2), run_dt);
END $$
DELIMITER ;

-- 이벤트 스케줄러
SET GLOBAL event_scheduler = ON;

-- 매월 15일 02:00 실행(서버시간)
DROP EVENT IF EXISTS ev_close_monthly_revenue_all;
CREATE EVENT ev_close_monthly_revenue_all
    ON SCHEDULE EVERY 1 MONTH
        STARTS '2025-01-15 00:10:00'
    ON COMPLETION PRESERVE
    DO CALL create_revenue(CURDATE());

INSERT INTO revenue (totalAmt, revenueDt)
VALUES (300000.00, '2025-01-15'),
       (200000.00, '2025-02-15'),
       (100000.00, '2025-03-15'),
       (250000.00, '2025-04-15'),
       (300000.00, '2025-05-15'),
       (150000.00, '2025-06-15'),
       (200000.00, '2025-07-15'),
       (250000.00, '2025-08-15'),
       (200000.00, '2025-09-15'),
       (400000.00, '2025-10-15'),
       (500000.00, '2025-11-15');
