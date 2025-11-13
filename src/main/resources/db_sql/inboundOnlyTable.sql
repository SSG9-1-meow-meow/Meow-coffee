use meowcoffeedb;
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
ALTER TABLE inboundItems MODIFY status ENUM('승인대기', '승인완료', '입고완료', '반려');
ALTER TABLE inboundItems ADD CONSTRAINT FOREIGN KEY (inReqId) REFERENCES inboundRequests (inReqId);
ALTER TABLE inboundItems ADD CONSTRAINT FOREIGN KEY (cfId) REFERENCES Coffee(CFID);
ALTER TABLE inboundItems ADD adminMemo VARCHAR(500); -- 관리자 메모 데이터 추가



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


-- 13. 일별 처리용량
CREATE TABLE dailyCapacity (
                               dateId	date	PRIMARY KEY ,
                               maxCapa	INT	NULL,
                               usedCapa	INT	NULL,
                               staffAvailable	INT	NULL,
                               staffAssign	INT	NULL,
                               equipAvailable	INT	NULL,
                               equipAssign	INT	NULL
);

INSERT INTO dailyCapacity (dateId, maxCapa, usedCapa, staffAvailable, staffAssign, equipAvailable, equipAssign)
VALUES
    ('2025-11-08', 1000, 600, 10, 8, 5, 4),
    ('2025-11-09', 1000, 850, 10, 10, 5, 5),
    ('2025-11-10', 1000, 400, 12, 6, 6, 3),
    ('2025-11-11', 1000, 700, 9, 7, 4, 4),
    ('2025-11-12', 1000, 500, 11, 5, 5, 2);


-- 14. 창고별 예정 수용량
CREATE TABLE `warehouseCapaSchedule` (
                                         dateId	DATE	NOT NULL,
                                         whId	bigint	NOT NULL,
                                         used_capacity	INT	NULL,
                                         available_capacity	INT	NULL
);

INSERT INTO warehouseCapaSchedule (dateId, whId, used_capacity, available_capacity)
VALUES
    ('2025-11-08', 1, 300, 700),
    ('2025-11-08', 2, 500, 500),
    ('2025-11-09', 1, 600, 400),
    ('2025-11-10', 3, 200, 800),
    ('2025-11-11', 2, 400, 600);

ALTER TABLE `warehouseCapaSchedule` ADD CONSTRAINT `PK_WAREHOUSECAPASCHEDULE` PRIMARY KEY (`dateId`, `whId`);
ALTER TABLE `warehouseCapaSchedule` ADD CONSTRAINT `FK_warehouse_TO_warehouseCapaSchedule_1` FOREIGN KEY (`whId`) REFERENCES `warehouse` (`whId`);


-- 기존 dailyCapacity 데이터에 아래 내용을 추가하거나 수정합니다.
-- 제한 부하: 50 PLT
-- 위험(빨강) 기준: 50 초과 (신청 부하가 1만 더해져도 초과)
-- 경고(노랑) 기준: 40(80%) 초과
-- 안전(초록) 기준: 40 이하

-- 2025-11-13: 위험 (45 + 신청부하 > 50)
INSERT INTO dailyCapacity (dateId, maxCapa, usedCapa, staffAvailable, staffAssign, equipAvailable, equipAssign)
VALUES ('2025-11-13', 1000, 45, 10, 9, 5, 4) ON DUPLICATE KEY UPDATE usedCapa=45;

-- 2025-11-14: 경고 (35 + 신청부하 > 40)
INSERT INTO dailyCapacity (dateId, maxCapa, usedCapa, staffAvailable, staffAssign, equipAvailable, equipAssign)
VALUES ('2025-11-14', 1000, 35, 10, 7, 5, 3) ON DUPLICATE KEY UPDATE usedCapa=35;

-- 2025-11-15: 안전 (20 + 신청부하 <= 40)
INSERT INTO dailyCapacity (dateId, maxCapa, usedCapa, staffAvailable, staffAssign, equipAvailable, equipAssign)
VALUES ('2025-11-15', 1000, 20, 10, 4, 5, 2) ON DUPLICATE KEY UPDATE usedCapa=20;



-- 샘플 데이터 추가
-- 1. 입고 요청 (inboundRequests) 샘플 데이터
INSERT INTO inboundRequests (inReqId, comId, managerId, inDttmReq, inDateWish, inDttmAppr, IsDelete, IsTempo) VALUES
                                                                                                                  (101, 'coffeebiz01', 'manager01', '2025-11-01 10:00:00', '2025-11-15', '2025-11-02 14:00:00', 0, 0), -- 전체 승인 완료된 건
                                                                                                                  (102, 'coffeebiz02', 'manager01', '2025-11-03 11:30:00', '2025-11-18', NULL, 0, 0), -- 일부만 처리된 건 (승인일시 NULL)
                                                                                                                  (103, 'coffeebiz01', NULL, '2025-11-05 09:00:00', '2025-11-20', NULL, 0, 0), -- 전체 승인대기 건
                                                                                                                  (104, 'coffeebiz02', 'manager02', '2025-11-06 15:00:00', '2025-11-22', '2025-11-07 10:00:00', 0, 0), -- 반려된 건 포함
                                                                                                                  (105, 'coffeebiz01', NULL, '2025-11-08 14:00:00', '2025-11-25', NULL, 0, 1), -- 임시저장 건
                                                                                                                  (106, 'coffeebiz03', NULL, '2025-10-20 10:00:00', '2025-11-05', '2025-10-21 11:00:00', 0, 0)  -- 입고 완료된 건
ON DUPLICATE KEY UPDATE comId=VALUES(comId); -- 중복 ID 있을 경우 덮어쓰기


-- 2. 입고 상세 항목 (inboundItems) 샘플 데이터
INSERT INTO inboundItems (inReqItemsId, inReqId, cfId, locationId, status, inQtyReq, inOrderAddr, inQty, inDttmSchd, inDttmInsp, inDttmRecv) VALUES
-- 요청 101번 (전체 승인 완료)
(201, 101, 'CF001', 'LOC001', '승인완료', 30, '서울 강남', NULL, '2025-11-15 10:00:00', NULL, NULL),
(202, 101, 'CF002', 'LOC001', '승인완료', 15, '서울 강남', NULL, '2025-11-15 10:00:00', NULL, NULL),

-- 요청 102번 (일부 처리)
(203, 102, 'CF003', 'LOC002', '승인완료', 25, '서울 마포', NULL, '2025-11-18 14:00:00', NULL, NULL),
(204, 102, 'CF004', 'LOC002', '승인대기', 20, '서울 마포', NULL, NULL, NULL, NULL),

-- 요청 103번 (전체 승인대기)
(205, 103, 'CF005', NULL, '승인대기', 40, '경기 성남', NULL, NULL, NULL, NULL),

-- 요청 104번 (반려 포함)
(206, 104, 'CF001', NULL, '반려', 10, '부산 해운대', NULL, NULL, NULL, NULL),
(207, 104, 'CF002', 'LOC003', '승인완료', 10, '부산 해운대', NULL, '2025-11-22 09:00:00', NULL, NULL),

-- 요청 105번 (임시저장)
(208, 105, 'CF003', 'LOC004', '승인대기', 35, '대구 수성', NULL, '2025-11-25 11:00:00', NULL, NULL), -- 관리자가 위치/일정은 임시저장

-- 요청 106번 (입고 완료)
(209, 106, 'CF004', 'LOC005', '입고완료', 50, '인천 부평', 50, '2025-11-05 13:00:00', '2025-11-05 14:00:00', '2025-11-05 15:00:00'),
(210, 106, 'CF005', 'LOC005', '입고완료', 25, '인천 부평', 24, '2025-11-05 13:00:00', '2025-11-05 14:00:00', '2025-11-05 15:30:00')
ON DUPLICATE KEY UPDATE inReqId=VALUES(inReqId);

-- 창고 부하 테이블 다시 만들기
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


INSERT INTO daily_warehouse_capacity
(dateId, whId, used_storage_capacity, available_storage_capacity, max_processing_capacity, used_processing_capacity, staff_available, staff_assigned, equip_available, equip_assigned)
VALUES
-- 2025-11-18 데이터
('2025-11-11', 1, 500, 500, 30, 25, 8, 6, 4, 3), -- 서울창고: 처리량 경고
('2025-11-11', 2, 300, 500, 20, 5, 5, 1, 3, 1),  -- 부산창고: 처리량 안전
('2025-11-11', 3, 700, 200, 25, 10, 6, 2, 3, 1), -- 대구창고: 처리량 안전

-- 2025-11-19 데이터
('2025-11-12', 1, 800, 200, 30, 28, 8, 8, 4, 4), -- 서울창고: 처리량 위험
('2025-11-13', 2, 600, 200, 20, 18, 5, 4, 3, 3), -- 부산창고: 처리량 경고
('2025-11-14', 3, 700, 200, 25, 10, 6, 2, 3, 1), -- 대구창고: 처리량 안전

-- 2025-11-20 데이터
('2025-11-25', 1, 100, 900, 30, 5, 8, 1, 4, 1);  -- 서울창고: 처리량 안전


INSERT INTO stock (stkId, lpId, cfId, stkQuantity) VALUES
-- Zone-A (LP001, LP002) - 서울창고
-- LP001에 10, LP002에 5 -> Zone-A의 총 재고는 15
('STK001', 'LP001', 'CF001', 10),
('STK002', 'LP002', 'CF002', 5),

-- Zone-B (LP003, LP004) - 부산창고
-- LP003에만 8 -> Zone-B의 총 재고는 8
('STK003', 'LP003', 'CF003', 8),
-- LP004는 비어있음

-- Zone-C (LP005) - 대구창고
-- LP005에 18 -> Zone-C의 총 재고는 18 (거의 꽉 참)
('STK005', 'LP005', 'CF005', 18)

ON DUPLICATE KEY UPDATE stkQuantity = VALUES(stkQuantity);


-- 적치 위치 동적 쿼리 테스트를 위한 샘플 데이터
-- 1. daily_warehouse_capacity 데이터 추가 (2026년 2월)
-- 2026-02-10: 서울창고는 처리 부하가 거의 꽉 참, 부산/대구는 여유
INSERT INTO daily_warehouse_capacity (dateId, whId, used_storage_capacity, available_storage_capacity, max_processing_capacity, used_processing_capacity, staff_available, staff_assigned, equip_available, equip_assigned) VALUES
('2026-02-10', 1, 500, 500, 50, 48, 10, 8, 5, 4), -- 서울: 처리 부하 위험
('2026-02-10', 2, 300, 500, 50, 10, 8, 2, 4, 1), -- 부산: 여유
('2026-02-10', 3, 200, 700, 50, 5, 8, 1, 4, 1)   -- 대구: 여유
ON DUPLICATE KEY UPDATE used_processing_capacity=VALUES(used_processing_capacity), used_storage_capacity=VALUES(used_storage_capacity);

-- 2. outboundrequest 테이블 (외래키용)
INSERT INTO outboundrequest (outReqId, comId, outDttmReq) VALUES (302, 'coffeebiz01', '2026-01-15 10:00:00')
ON DUPLICATE KEY UPDATE comId=VALUES(comId);

-- 3. outboundItems 데이터 추가 (2026-02-10에 출고 예정)
-- LP001에서 5 PLT 출고 예정
INSERT INTO outboundItems (outReqItemsId, outReqId, stkId, status, outQtyReq, outDttmSchd) VALUES (402, 302, 'STK001', '승인완료', 5, '2026-02-10 14:00:00')
ON DUPLICATE KEY UPDATE outQtyReq=VALUES(outQtyReq);

-- 4. inboundItems 데이터 추가 (2026-02-10에 입고 예정)
-- LP001로 8 PLT 입고 예정, LP003으로 15 PLT 입고 예정
INSERT INTO inboundItems (inReqItemsId, inReqId, cfId, locationId, status, inQtyReq, inDttmSchd) VALUES
(213, 101, 'CF001', 'LOC001', '승인완료', 8, '2026-02-10 10:00:00'), -- LP001
(214, 102, 'CF003', 'LOC003', '승인완료', 15, '2026-02-10 11:00:00') -- LP003
ON DUPLICATE KEY UPDATE inQtyReq=VALUES(inQtyReq);

-- 5. stock (현재 물리 재고) 데이터 추가 (기존 데이터와 동일하게 사용)
INSERT INTO stock (stkId, lpId, cfId, stkQuantity) VALUES
('STK001', 'LP001', 'CF001', 10), -- Zone-A (서울), 현재 10
('STK002', 'LP002', 'CF002', 5),  -- Zone-A (서울), 현재 5
('STK003', 'LP003', 'CF003', 2),  -- Zone-B (부산), 현재 2
('STK004', 'LP004', 'CF004', 0),  -- Zone-B (부산), 현재 0
('STK005', 'LP005', 'CF005', 18)  -- Zone-C (대구), 현재 18
ON DUPLICATE KEY UPDATE stkQuantity = VALUES(stkQuantity);


WITH
    -- 1. 선택된 날짜의 '예정된 입고량' (lpId 기준)
    scheduled_inbounds AS (
        SELECT L.lpId, SUM(II.inQtyReq) as total_in_qty
        FROM inboundItems II JOIN locations L ON II.locationId = L.locationId
        WHERE II.status = '승인완료'
          -- ★★★ [수정 1] DATE() 함수를 사용하여 날짜 부분만 비교 ★★★
          AND DATE(II.inDttmSchd) = '20260211'
        GROUP BY L.lpId
    ),
    -- 2. 선택된 날짜의 '예정된 출고량' (lpId 기준)
    scheduled_outbounds AS (
        SELECT S.lpId, SUM(OI.outQtyReq) as total_out_qty
        FROM outboundItems OI JOIN stock S ON OI.stkId = S.stkId
        WHERE OI.status = '승인완료'
          -- ★★★ [수정 1] DATE() 함수를 사용하여 날짜 부분만 비교 ★★★
          AND DATE(OI.outDttmSchd) = '20260211'
        GROUP BY S.lpId
    )
-- 3. 메인 쿼리: 모든 정보를 결합하여 최종 필터링
SELECT
    LP.lpId,
    LP.zoneName,
    W.whName,
    (IFNULL(S.stkQuantity, 0) + IFNULL(SI.total_in_qty, 0) - IFNULL(SO.total_out_qty, 0)) AS projected_stock
FROM
    location_places LP
        JOIN locations L ON LP.lpId = L.lpId
        JOIN warehouse W ON L.whId = W.whId
        -- ★★★ [수정 2] daily_warehouse_capacity를 LEFT JOIN으로 변경하여 모든 창고를 대상으로 함 ★★★
        LEFT JOIN daily_warehouse_capacity DWC ON W.whId = DWC.whId AND DWC.dateId = '20260211'
                                                                        LEFT JOIN stock S ON LP.lpId = S.lpId
        LEFT JOIN scheduled_inbounds SI ON LP.lpId = SI.lpId
        LEFT JOIN scheduled_outbounds SO ON LP.lpId = SO.lpId
WHERE
    -- 4. 조건 필터링 1: 창고의 처리 부하가 초과되지 않는가?
    -- IFNULL을 사용하여 DWC 데이터가 없으면 used=0, max=50으로 간주
    (IFNULL(DWC.used_processing_capacity, 0) + 3) <= IFNULL(DWC.max_processing_capacity, 50)
    -- 5. 조건 필터링 2: 창고의 수용 능력이 초과되지 않는가?
    -- IFNULL을 사용하여 DWC 데이터가 없으면 used=0으로 간주
        AND (IFNULL(DWC.used_storage_capacity, 0) + 3) <= W.whTotalCapa
            HAVING
            -- 6. 조건 필터링 3: 보관 위치(lpId)의 수용 능력(20 PLT)이 초과되지 않는가?
            (projected_stock + 3) <= 20
            ORDER BY
            W.whName, LP.zoneName, LP.lpId;