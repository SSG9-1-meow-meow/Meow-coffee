

drop database meowcoffeedb;
create database meowcoffeedb;
use meowcoffeedb;

-- 1. 차량 테이블 생성
DROP TABLE IF EXISTS vehicles;
CREATE TABLE vehicles (
                          vehicleId	char(10)	PRIMARY KEY ,
                          vehicleModel	ENUM('5톤 윙바디', '1톤 탑차', '1.2톤 카고')	NOT NULL,
                          vehicleDesc	varchar(255)	NULL
);

-- 1. 차량데이터 생성
INSERT INTO vehicles
(vehicleId, vehicleModel, vehicleDesc)
VALUES
    ('55가1001', '5톤 윙바디', '주력 운송 차량, 정비 완료'),
    ('55나2002', '5톤 윙바디', '차량 점검 필요, 다음 주 정비 예정'),
    ('55다3003', '5톤 윙바디', '서울-경기 지역 운행 중'),
    ('55라4004', '5톤 윙바디', '긴급 물류 요청 대비 예비 차량'),
    ('55마5005', '5톤 윙바디', '주로 부산/영남권 장거리 운행 담당'),
    ('55바6006', '5톤 윙바디', '운전자 변경 대기 중'),
    ('55사7007', '5톤 윙바디', '오전 운행 후 복귀'),
    ('55아8008', '5톤 윙바디', '새로 구매한 차량, 시범 운행 중'),
    ('55자9009', '5톤 윙바디', '창고 간 재고 이동 전용'),
    ('55차0010', '5톤 윙바디', '가장 최근에 정비 받은 차량');

-- 2. 회원 정보 생성
DROP TABLE IF EXISTS users;
CREATE TABLE users (
userId	varchar(30)	PRIMARY KEY ,
userPwd	varchar(255)	NOT NULL,
userCompanyName	varchar(30)	NULL,
userName	varchar(30)	NOT NULL,
userPhone	varchar(13)	NOT NULL,
userEmail	varchar(50)	NOT NULL,
userCode	char(12)	NOT NULL,
userRoadAddr	varchar(100)	NULL,
userDetailAddr	varchar(100)	NULL,
userJoinDate	date	NULL,
userRole	enum('COMPANY', 'MANAGER', 'ADMIN', 'DELIVERYMAN')	NOT NULL,
userStatus	enum('APPROVAL', 'WAITING_APPROVAL', 'DEACTIVATED', 'WAITING_DEACTIVATE')	NOT NULL,
userLastLogin	date	NULL,
userImgPath	varchar(255)	NULL,
vehicleId	char(10)	NULL,
CONSTRAINT fk_users_vehicles FOREIGN KEY (vehicleId) REFERENCES vehicles(vehicleId)

);


-- 2. 회원 데이터 생성
INSERT INTO users (
    userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode,
    userRoadAddr, userDetailAddr, userJoinDate, userRole, userStatus,
    userLastLogin, userImgPath, vehicleId
) VALUES
-- 거래처 회원
('coffeebiz01', 'hashedPwd1!', '메오커피', '김대표', '010-1234-5678', 'ceo1@meowcoffee.com', '123-45-67890',
 '서울시 강남구 테헤란로 123', '101호', '2025-01-10', 'COMPANY', 'APPROVAL',
 '2025-11-06', 'C:\\study\\meowcoffeeFile\\profiles\\profile_coffeebiz01_123-45-67890', NULL),

('coffeebiz02', 'hashedPwd2@', '블루빈스', '이대표', '010-2345-6789', 'ceo2@bluebeans.co.kr', '234-56-78901',
 '서울시 마포구 월드컵북로 45', '3층', NULL, 'COMPANY', 'WAITING_APPROVAL',
 NULL, NULL, NULL),

-- 창고 관리자
('manager01', 'hashedPwd3#', NULL, '박관리자', '010-3456-7890', 'manager1@meowcoffee.com', 'MAN-00-00001',
 '경기도 성남시 분당구 판교로 242', 'A동 5층', '2025-03-15', 'MANAGER', 'APPROVAL',
 '2025-11-05', 'C:\\study\\meowcoffeeFile\\profiles\\profile_manager01_MAN-00-00001', NULL),

('manager02', 'hashedPwd4$', NULL, '최관리자', '010-4567-8901', 'manager2@meowcoffee.com', 'MAN-00-00002',
 '서울시 송파구 중대로 12', '2층', NULL, 'MANAGER', 'WAITING_APPROVAL',
 NULL, NULL, NULL),

-- 총관리자
('admin01', 'hashedPwd5%', NULL, '정총관리자', '010-5678-9012', 'admin@meowcoffee.com', 'ADM-00-00001',
 '서울시 종로구 세종대로 175', '본관 7층', '2024-12-01', 'ADMIN', 'APPROVAL',
 '2025-11-06', 'C:\\study\\meowcoffeeFile\\profiles\\profile_admin01_ADM-00-00001', NULL),

-- 배송기사
('delivery01', 'hashedPwd6^', NULL, '이배송', '010-6789-0123', 'delivery1@meowcoffee.com', 'DEL-00-00001',
 '경기도 고양시 일산서구 중앙로 100', '1층 물류센터', '2025-06-20', 'DELIVERYMAN', 'APPROVAL',
 '2025-11-04', 'C:\\study\\meowcoffeeFile\\profiles\\profile_delivery01_DEL-00-00001', '55가1001'),

('delivery02', 'hashedPwd7&', NULL, '김배송', '010-7890-1234', 'delivery2@meowcoffee.com', 'DEL-00-00002',
 '인천시 부평구 경원대로 200', '지하 1층', NULL, 'DELIVERYMAN', 'WAITING_APPROVAL',
 NULL, NULL, '55나2002'),

-- 휴면 상태 회원
('coffeebiz03', 'hashedPwd8*', '카페봄날', '정대표', '010-8901-2345', 'ceo3@springcafe.kr', '345-67-89012',
 '부산시 해운대구 해운대로 321', '2층', '2023-11-01', 'COMPANY', 'DEACTIVATED',
 '2024-12-31', 'C:\\study\\meowcoffeeFile\\profiles\\profile_coffeebiz03_345-67-89012', NULL),

-- 승인대기 중인 관리자
('manager03', 'hashedPwd9(', NULL, '한관리자', '010-9012-3456', 'manager3@meowcoffee.com', 'MAN-00-00003',
 '대전시 유성구 대학로 99', '연구동 3층', NULL, 'MANAGER', 'WAITING_APPROVAL',
 NULL, NULL, NULL),

-- 휴면대기 중인 배송기사 (vehicleId를 '55다3003'으로 수정)
('delivery03', 'hashedPwd10)', NULL, '오배송', '010-0123-4567', 'delivery3@meowcoffee.com', 'DEL-00-00003',
 '광주시 북구 무등로 88', '물류센터 2층', '2024-08-15', 'DELIVERYMAN', 'WAITING_DEACTIVATE',
 '2025-10-28', 'C:\\study\\meowcoffeeFile\\profiles\\profile_delivery03_DEL-00-00003', '55다3003');;


-- 3. 커피 (Coffee) 테이블 생성
DROP TABLE IF EXISTS Coffee;
CREATE TABLE coffee (
cfId CHAR(12) PRIMARY KEY,
cfName VARCHAR(20) NOT NULL,
cfOrigin CHAR(3) NOT NULL,
cfCategory CHAR(3) NOT NULL,
cfGrade VARCHAR(15) NOT NULL,
cfType VARCHAR(15) NOT NULL
);

-- 3. 커피 (coffee) 데이터 생성
INSERT INTO coffee (cfId, cfName, cfOrigin, cfCategory, cfGrade, cfType)
VALUES
    ('CF001', '에티오피아 예가체프', 'ETH', '원두', '스페셜티', '아라비카'),
    ('CF002', '콜롬비아 수프리모', 'COL', '원두', '프리미엄', '아라비카'),
    ('CF003', '브라질 산토스', 'BRA', '생두', '레귤러', '로부스타'),
    ('CF004', '케냐 AA', 'KEN', '생두', '스페셜티', '아라비카'),
    ('CF005', '과테말라 안티구아', 'GUA', 'DCF', '프리미엄', '아라비카');

-- 4. 창고 (warehouse) 테이블 생성
DROP TABLE IF EXISTS warehouse;
CREATE TABLE warehouse (
whId BIGINT AUTO_INCREMENT PRIMARY KEY,
whCode VARCHAR(12) NOT NULL,
whName VARCHAR(30) NOT NULL,
whAddress VARCHAR(100) NOT NULL,
whTelPhone VARCHAR(13),
whGrade CHAR(5) NOT NULL,
whField INT NOT NULL,
whTotalCapa INT NOT NULL,
whUseCapa INT NULL
);

-- 4. 창고 (warehouse) 데이터 생성
INSERT INTO warehouse (whCode, whName, whAddress, whTelPhone, whGrade, whField, whTotalCapa, whUseCapa)
VALUES
    ('WH001', '서울창고', '서울특별시 강남구 테헤란로 123', '02-111-2222', 'A', 200, 1000, 600),
    ('WH002', '부산창고', '부산광역시 해운대구 해운대로 45', '051-333-4444', 'B', 150, 800, 500),
    ('WH003', '대구창고', '대구광역시 수성구 동대구로 88', '053-555-6666', 'A', 180, 900, 700);

-- 5. 보관위치 (location_places) 테이블 생성
DROP TABLE IF EXISTS location_places;
CREATE TABLE location_places (
                                 lpId CHAR(40) PRIMARY KEY,
                                 zoneId CHAR(12) NOT NULL,
                                 zoneName CHAR(12) NOT NULL,
                                 rackId CHAR(12) NOT NULL,
                                 rackName CHAR(12) NOT NULL,
                                 cellId CHAR(12) NOT NULL,
                                 cellName CHAR(12) NOT NULL
);

-- 5. 보관위치 (location_places) 데이터 생성
INSERT INTO location_places (lpId, zoneId, zoneName, rackId, rackName, cellId, cellName)
VALUES
    ('LP001', 'Z001', 'Zone-A', 'R001', 'Rack-A1', 'C001', 'Cell-1'),
    ('LP002', 'Z001', 'Zone-A', 'R002', 'Rack-A2', 'C002', 'Cell-2'),
    ('LP003', 'Z002', 'Zone-B', 'R003', 'Rack-B1', 'C003', 'Cell-3'),
    ('LP004', 'Z002', 'Zone-B', 'R004', 'Rack-B2', 'C004', 'Cell-4'),
    ('LP005', 'Z003', 'Zone-C', 'R005', 'Rack-C1', 'C005', 'Cell-5');


-- 6. 재고 (stock) 테이블 생성
DROP TABLE IF EXISTS stock;
CREATE TABLE stock (
stkId CHAR(12) PRIMARY KEY,
lpId CHAR(40) NOT NULL,
cfId CHAR(12) NOT NULL,
stkQuantity INT NOT NULL,
CONSTRAINT fk_stock_location_places FOREIGN KEY (lpId) REFERENCES location_places(lpId),
CONSTRAINT fk_stock_coffee FOREIGN KEY (cfId) REFERENCES coffee(cfId)
);


-- 6. 재고 (stock) 샘플 데이터 생성
INSERT INTO stock (stkId, lpId, cfId, stkQuantity)
VALUES
    ('STK001', 'LP001', 'CF001', 120),
    ('STK002', 'LP002', 'CF002', 200),
    ('STK003', 'LP003', 'CF003', 150),
    ('STK004', 'LP004', 'CF004', 80),
    ('STK005', 'LP005', 'CF005', 60);



-- 7. 보관위치지정 (locations) 테이블 생성
DROP TABLE IF EXISTS locations;
CREATE TABLE locations (
locationId CHAR(12) PRIMARY KEY,
whId BIGINT NOT NULL,
lpId CHAR(40) NOT NULL,
CONSTRAINT fk_locations_warehouse FOREIGN KEY (whId) REFERENCES warehouse(whId),
CONSTRAINT fk_locations_location_places FOREIGN KEY (lpId) REFERENCES location_places(lpId)
);

-- 7. 보관위치지정 (locations) 데이터 생성
INSERT INTO locations (locationId, whId, lpId)
VALUES
    ('LOC001', 1, 'LP001'),
    ('LOC002', 1, 'LP002'),
    ('LOC003', 2, 'LP003'),
    ('LOC004', 3, 'LP004'),
    ('LOC005', 3, 'LP005');


-- 8. 입고요청 테이블 생성
DROP TABLE if exists inboundRequests;

CREATE TABLE inboundRequests (
inReqId	bigint AUTO_INCREMENT PRIMARY KEY ,
comId	varchar(30)	NOT NULL,
managerId	varchar(30)	NULL,
inDttmReq	datetime	NOT NULL,
inDateWish	date	NULL,
inDttmAppr	datetime	NULL,
IsDelete	tinyint	NULL,
IsTempo	tinyint	NULL
);

ALTER TABLE inboundRequests ADD CONSTRAINT FK_users_TO_inboundRequests_1 FOREIGN KEY (comId)
    REFERENCES users (userId);

ALTER TABLE `inboundRequests` ADD CONSTRAINT `FK_users_TO_inboundRequests_2` FOREIGN KEY (managerId)
    REFERENCES users (userId);

-- 7. 입고요청 샘플 데이터
INSERT INTO inboundRequests (comId, managerId, inDttmReq, inDateWish, inDttmAppr, IsDelete, IsTempo)
VALUES
    ('coffeebiz01', 'manager01', '2025-11-01 09:00:00', '2025-11-05', '2025-11-02 10:00:00', 0, 0),
    ('coffeebiz02', 'manager01', '2025-11-02 10:30:00', '2025-11-06', NULL, 0, 1),
    ('coffeebiz01', 'manager02', '2025-11-03 14:15:00', '2025-11-07', '2025-11-04 09:00:00', 0, 0),
    ('coffeebiz03', 'manager03', '2025-11-04 08:45:00', '2025-11-08', NULL, 0, 1),
    ('coffeebiz01', 'manager01', '2025-11-05 11:00:00', '2025-11-09', '2025-11-06 13:00:00', 0, 0);



-- 8. 입고상세 테이블 생성

DROP TABLE if exists inboundItems;
CREATE TABLE inboundItems (
inReqItemsId	bigint AUTO_INCREMENT PRIMARY KEY ,
inReqId	bigint	NOT NULL,
cfId	char(12)	NOT NULL,
locationId	char(12)	NULL,
status	ENUM('승인대기', '승인완료', '입고완료', '반려')	NOT NULL,
inQtyReq	integer	NULL,
inOrderAddr	varchar(255)	NULL,
inQty	integer	NULL,
inDttmSchd	datetime	NULL,
inDttmInsp	datetime	NULL,
inDttmRecv	datetime	NULL
);

ALTER TABLE inboundItems ADD CONSTRAINT FOREIGN KEY (inReqId) REFERENCES inboundRequests (inReqId);
ALTER TABLE inboundItems ADD CONSTRAINT FOREIGN KEY (cfId) REFERENCES Coffee(CFID);
ALTER TABLE inboundItems ADD adminMemo VARCHAR(500);

-- 8. 입고 상세 샘플 데이터
INSERT INTO inboundItems (inReqId, cfId, locationId, status, inQtyReq, inOrderAddr, inQty, inDttmSchd, inDttmInsp, inDttmRecv)
VALUES
    (1, 'CF001', 'LOC001', '승인대기', 100, '서울 강남 물류센터', NULL, '2025-11-05 10:00:00', NULL, NULL),
    (1, 'CF002', 'LOC001', '승인대기', 50, '서울 강남 물류센터', NULL, '2025-11-05 10:00:00', NULL, NULL),
    (2, 'CF003', 'LOC002', '승인대기', 80, '서울 마포 물류센터', NULL, '2025-11-06 11:00:00', NULL, NULL),
    (2, 'CF004', 'LOC002', '승인대기', 120, '서울 마포 물류센터', NULL, '2025-11-06 11:00:00', NULL, NULL),
    (3, 'CF005', 'LOC003', '입고완료', 60, '경기 성남 물류센터', 60, '2025-11-07 09:00:00', '2025-11-06 15:00:00', '2025-11-07 10:00:00'),
    (3, 'CF001', 'LOC003', '승인완료', 30, '경기 성남 물류센터', 30, '2025-11-07 09:00:00', '2025-11-06 15:00:00', '2025-11-07 10:00:00'),
    (3, 'CF002', 'LOC003', '승인완료', 40, '경기 성남 물류센터', 40, '2025-11-07 09:00:00', '2025-11-06 15:00:00', '2025-11-07 10:00:00'),
    (4, 'CF003', 'LOC004', '승인대기', 90, '부산 해운대 물류센터', NULL, '2025-11-08 13:00:00', NULL, NULL),
    (4, 'CF004', 'LOC004', '승인대기', 70, '부산 해운대 물류센터', NULL, '2025-11-08 13:00:00', NULL, NULL),
    (5, 'CF005', 'LOC005', '승인완료', 110, '대구 수성 물류센터', 110, '2025-11-09 14:00:00', '2025-11-08 16:00:00', '2025-11-09 15:00:00');



-- 9. 출고 요청 테이블 생성
DROP TABLE IF EXISTS outboundrequest;
CREATE TABLE `outboundrequest` (
outReqId	bigint	AUTO_INCREMENT PRIMARY KEY ,
comId	varchar(30)	NOT NULL,
managerID	varchar(30)	NULL,
outDttmReq	datetime	NOT NULL,
outDateWish	date	NULL,
outDttmAppr	datetime	NULL,
IsDelete	tinyint	NULL,
IsTempo	date	NULL
);

ALTER TABLE outboundRequest ADD CONSTRAINT FK_users_TO_outboundRequest_1 FOREIGN KEY (comId) REFERENCES users (userId);

ALTER TABLE `outboundRequest` ADD CONSTRAINT `FK_users_TO_outboundRequest_2` FOREIGN KEY (managerId) REFERENCES users (userId);

-- 9. 출고 요청 샘플 데이터
INSERT INTO outboundRequest (comId, managerID, outDttmReq, outDateWish, outDttmAppr, IsDelete, IsTempo)
VALUES
    ('coffeebiz01', 'manager01', '2025-11-06 09:00:00', '2025-11-08', '2025-11-06 14:00:00', 0, NULL),
    ('coffeebiz02', 'manager01', '2025-11-06 10:30:00', '2025-11-09', NULL, 0, NULL),
    ('coffeebiz01', 'manager02', '2025-11-07 11:15:00', '2025-11-10', '2025-11-07 16:00:00', 0, NULL),
    ('coffeebiz03', 'manager03', '2025-11-07 13:45:00', '2025-11-11', NULL, 0, NULL),
    ('coffeebiz01', 'manager01', '2025-11-08 08:20:00', '2025-11-12', '2025-11-08 12:00:00', 0, NULL);



-- 10. 출고 상세 테이블 생성
DROP TABLE IF EXISTS outboundItems;
CREATE TABLE `outboundItems` (
outReqItemsId	bigint	AUTO_INCREMENT PRIMARY KEY,
outReqId	bigint	NOT NULL,
stkId	char(12)	NOT NULL,
vehicleId	char(10)	NULL,
status	ENUM('승인대기', '승인완료', '출고완료')	NOT NULL,
outQtyReq	int	NOT NULL,
outOrderAddr	varchar(255)	NULL,
outDttmSchd	datetime	NULL,
outDttmInsp	datetime	NULL,
outDttmShip	datetime	NULL
);

ALTER TABLE outboundItems ADD CONSTRAINT FOREIGN KEY (outReqId) REFERENCES outboundrequest(outReqId);
ALTER TABLE outboundItems ADD CONSTRAINT FOREIGN KEY (stkId) REFERENCES stock(stkId);

-- 10. 출고 상세 샘플 데이터 10건
INSERT INTO outboundItems (outReqId, stkId, vehicleId, status, outQtyReq, outOrderAddr, outDttmSchd, outDttmInsp, outDttmShip)
VALUES
    (1, 'STK001', '55가1001', '승인완료', 50, '서울 강남구 테헤란로 123', '2025-11-08 09:00:00', '2025-11-07 15:00:00', '2025-11-08 10:00:00'),
    (1, 'STK002', '55가1001', '승인완료', 30, '서울 강남구 테헤란로 123', '2025-11-08 09:00:00', '2025-11-07 15:00:00', '2025-11-08 10:00:00'),
    (2, 'STK003', '55나2002', '승인대기', 40, '서울 마포구 월드컵북로 45', '2025-11-09 10:00:00', NULL, NULL),
    (2, 'STK004', '55나2002', '승인대기', 20, '서울 마포구 월드컵북로 45', '2025-11-09 10:00:00', NULL, NULL),
    (3, 'STK005', '55다3003', '승인완료', 25, '경기 성남시 판교로 242', '2025-11-10 11:00:00', '2025-11-09 14:00:00', '2025-11-10 12:00:00'),
    (3, 'STK001', '55다3003', '승인완료', 15, '경기 성남시 판교로 242', '2025-11-10 11:00:00', '2025-11-09 14:00:00', '2025-11-10 12:00:00'),
    (4, 'STK002', '55라4004', '승인대기', 35, '부산 해운대구 해운대로 321', '2025-11-11 13:00:00', NULL, NULL),
    (4, 'STK003', '55라4004', '승인대기', 45, '부산 해운대구 해운대로 321', '2025-11-11 13:00:00', NULL, NULL),
    (5, 'STK004', '55마5005', '승인완료', 20, '대구 수성구 동대구로 88', '2025-11-12 14:00:00', '2025-11-11 16:00:00', '2025-11-12 15:00:00'),
    (5, 'STK005', '55마5005', '승인완료', 40, '대구 수성구 동대구로 88', '2025-11-12 14:00:00', '2025-11-11 16:00:00', '2025-11-12 15:00:00');


-- 11. 실사 (due_diligence) 테이블 생성
CREATE TABLE due_diligence (
ddId BIGINT AUTO_INCREMENT PRIMARY KEY,
stkId CHAR(12) NOT NULL,
ddDate DATETIME NOT NULL default now(),
ddApproval CHAR(10) NOT NULL DEFAULT 'PENDING',
ddStatus CHAR(10) NOT NULL,
isDelete TINYINT DEFAULT 0,
ddUpdateDate DATETIME NULL,
maid VARCHAR(30) NOT NULL,
ddLog VARCHAR(255) NULL,
realStkQuantity INT NOT NULL,
CONSTRAINT fk_due_diligence_stock FOREIGN KEY (stkId) REFERENCES stock(stkId)
);

-- 11. 실사 (due_diligence) 데이터 생성
INSERT INTO due_diligence (stkId, ddDate, ddApproval, ddStatus, maid, ddLog, realStkQuantity)
VALUES
    ('STK001', NOW(), 'APPROVED', 'CORRECT', 'admin', '정상 수량 확인', 120),
    ('STK002', NOW(), 'PENDING', 'INCORRECT', 'manager01', '수량 확인 중', 195),
    ('STK003', NOW(), 'REJECTED', 'INCORRECT', 'manager02', '수량 차이 발생', 140),
    ('STK004', NOW(), 'APPROVED', 'CORRECT', 'admin', '검수 완료', 80),
    ('STK005', NOW(), 'PENDING', 'INCORRECT', 'manager03', '실사 대기 중', 0);


-- 12. 창고관리 테이블 생성
drop table if exists warehouse_management;
CREATE TABLE `warehouse_management` (
`whManagementId`	bigint	NOT NULL,
`whId`	bigint	NOT NULL,
`userId`	varchar(30)	NOT NULL
);

ALTER TABLE `warehouse_management` ADD CONSTRAINT `PK_WAREHOUSE_MANAGEMENT` PRIMARY KEY (`whManagementId`);
ALTER TABLE `warehouse_management` ADD CONSTRAINT `FK_warehouse_TO_warehouse_management_1` FOREIGN KEY (`whId`) REFERENCES `warehouse` (`whId`);
ALTER TABLE `warehouse_management` ADD CONSTRAINT `FK_users_TO_warehouse_management_1` FOREIGN KEY (`userId`) REFERENCES `users` (`userId`);

-- 12. 창고관리 테이블 샘플 데이터 생성
INSERT INTO warehouse_management (whManagementId, whId, userId)
VALUES
    (1, 1, 'manager01'),  -- 서울창고 → 박관리자
    (2, 2, 'manager02'),  -- 부산창고 → 최관리자
    (3, 3, 'manager03'),  -- 대구창고 → 한관리자
    (4, 1, 'admin01'),    -- 서울창고 → 정총관리자 (총관리자도 관리 가능)
    (5, 2, 'admin01');    -- 부산창고 → 정총관리자 (복수 창고 관리 가능)


-- 1. 기존 테이블 삭제 (데이터 백업 후 진행)
DROP TABLE IF EXISTS dailyCapacity;
DROP TABLE IF EXISTS warehouseCapaSchedule;

-- 2. 창고별 일일 수용량/부하 통합 테이블 생성
CREATE TABLE daily_warehouse_capacity (
dateId              DATE    NOT NULL,
whId                BIGINT  NOT NULL,

    -- 기존 warehouseCapaSchedule의 컬럼들 (보관 용량)
used_storage_capacity   INT     NULL,
available_storage_capacity INT  NULL,

    -- 기존 dailyCapacity의 컬럼들 (처리/인력/장비 부하)
max_processing_capacity   INT     NULL,
used_processing_capacity  INT     NULL,
staff_available     INT     NULL,
staff_assigned      INT     NULL,
equip_available     INT     NULL,
equip_assigned      INT     NULL,

    -- 제약조건
PRIMARY KEY (dateId, whId),
FOREIGN KEY (whId) REFERENCES warehouse(whId)
);

INSERT INTO daily_warehouse_capacity
(dateId, whId, used_storage_capacity, available_storage_capacity, max_processing_capacity, used_processing_capacity, staff_available, staff_assigned, equip_available, equip_assigned)
VALUES
-- 2025-11-18 데이터
('2025-11-18', 1, 500, 500, 30, 25, 8, 6, 4, 3), -- 서울창고: 처리량 경고
('2025-11-18', 2, 300, 500, 20, 5, 5, 1, 3, 1),  -- 부산창고: 처리량 안전

-- 2025-11-19 데이터
('2025-11-19', 1, 800, 200, 30, 28, 8, 8, 4, 4), -- 서울창고: 처리량 위험
('2025-11-19', 2, 600, 200, 20, 18, 5, 4, 3, 3), -- 부산창고: 처리량 경고
('2025-11-19', 3, 700, 200, 25, 10, 6, 2, 3, 1), -- 대구창고: 처리량 안전

-- 2025-11-20 데이터
('2025-11-20', 1, 100, 900, 30, 5, 8, 1, 4, 1);  -- 서울창고: 처리량 안전


-- 회원 입고관리 메인에 표시되는 리스트 데이터 select 문
-- 입고 요청 ID, 커피상품명, 카테고리, 요청 수량, 입고 수량, 상태, 요청날짜, 승인날짜, 임시저장여부
