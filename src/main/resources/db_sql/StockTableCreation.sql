create database meowcoffeedb;

use meowcoffeedb;

-- 1. 창고 (warehouse)
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

-- 2. 보관위치 (location_places)
CREATE TABLE location_places (
                                 lpId CHAR(40) PRIMARY KEY,
                                 zoneId CHAR(12) NOT NULL,
                                 zoneName CHAR(12) NOT NULL,
                                 rackId CHAR(12) NOT NULL,
                                 rackName CHAR(12) NOT NULL,
                                 cellId CHAR(12) NOT NULL,
                                 cellName CHAR(12) NOT NULL
);

-- 3. 보관위치지정 (locations)
CREATE TABLE locations (
                           locationId CHAR(12) PRIMARY KEY,
                           whId BIGINT NOT NULL,
                           lpId CHAR(40) NOT NULL,
                           CONSTRAINT fk_locations_warehouse FOREIGN KEY (whId) REFERENCES warehouse(whId),
                           CONSTRAINT fk_locations_location_places FOREIGN KEY (lpId) REFERENCES location_places(lpId)
);
-- 4. 커피 (Coffee)
CREATE TABLE coffee (
                        cfId CHAR(12) PRIMARY KEY,
                        cfName VARCHAR(20) NOT NULL,
                        cfOrigin CHAR(3) NOT NULL,
                        cfCategory CHAR(3) NOT NULL,
                        cfGrade VARCHAR(15) NOT NULL,
                        cfType VARCHAR(15) NOT NULL
);

-- 5. 재고 (stock)
CREATE TABLE stock (
                       stkId CHAR(12) PRIMARY KEY,
                       lpId CHAR(30) NOT NULL,
                       cfId CHAR(12) NOT NULL,
                       stkQuantity INT NOT NULL,
                       CONSTRAINT fk_stock_location_places FOREIGN KEY (lpId) REFERENCES location_places(lpId),
                       CONSTRAINT fk_stock_coffee FOREIGN KEY (cfId) REFERENCES coffee(cfId)
);
-- 6. 실사 (due_diligence)
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

-- 더미데이터 넣음
-- 🚀 0. 데이터베이스 선택
USE meowcoffeedb;

-- 1️⃣ 창고 (warehouse)
INSERT INTO warehouse (whCode, whName, whAddress, whTelPhone, whGrade, whField, whTotalCapa, whUseCapa)
VALUES
    ('WH001', '서울창고', '서울특별시 강남구 테헤란로 123', '02-111-2222', 'A', 200, 1000, 600),
    ('WH002', '부산창고', '부산광역시 해운대구 해운대로 45', '051-333-4444', 'B', 150, 800, 500),
    ('WH003', '대구창고', '대구광역시 수성구 동대구로 88', '053-555-6666', 'A', 180, 900, 700);

-- 2️⃣ 보관위치 (location_places)
INSERT INTO location_places (lpId, zoneId, zoneName, rackId, rackName, cellId, cellName)
VALUES
    ('LP001', 'Z001', 'Zone-A', 'R001', 'Rack-A1', 'C001', 'Cell-1'),
    ('LP002', 'Z001', 'Zone-A', 'R002', 'Rack-A2', 'C002', 'Cell-2'),
    ('LP003', 'Z002', 'Zone-B', 'R003', 'Rack-B1', 'C003', 'Cell-3'),
    ('LP004', 'Z002', 'Zone-B', 'R004', 'Rack-B2', 'C004', 'Cell-4'),
    ('LP005', 'Z003', 'Zone-C', 'R005', 'Rack-C1', 'C005', 'Cell-5');

-- 3️⃣ 보관위치지정 (locations)
INSERT INTO locations (locationId, whId, lpId)
VALUES
    ('LOC001', 1, 'LP001'),
    ('LOC002', 1, 'LP002'),
    ('LOC003', 2, 'LP003'),
    ('LOC004', 3, 'LP004'),
    ('LOC005', 3, 'LP005');

-- 4️⃣ 커피 (coffee)
INSERT INTO coffee (cfId, cfName, cfOrigin, cfCategory, cfGrade, cfType)
VALUES
    ('CF001', '에티오피아 예가체프', 'ETH', 'B01', '스페셜티', '아라비카'),
    ('CF002', '콜롬비아 수프리모', 'COL', 'B02', '프리미엄', '아라비카'),
    ('CF003', '브라질 산토스', 'BRA', 'B03', '레귤러', '로부스타'),
    ('CF004', '케냐 AA', 'KEN', 'B01', '스페셜티', '아라비카'),
    ('CF005', '과테말라 안티구아', 'GUA', 'B02', '프리미엄', '아라비카');

-- 5️⃣ 재고 (stock)
INSERT INTO stock (stkId, lpId, cfId, stkQuantity)
VALUES
    ('STK001', 'LP001', 'CF001', 120),
    ('STK002', 'LP002', 'CF002', 200),
    ('STK003', 'LP003', 'CF003', 150),
    ('STK004', 'LP004', 'CF004', 80),
    ('STK005', 'LP005', 'CF005', 60);

-- 6️⃣ 실사 (due_diligence)
INSERT INTO due_diligence (stkId, ddDate, ddApproval, ddStatus, maid, ddLog, realStkQuantity)
VALUES
    ('STK001', NOW(), 'APPROVED', 'CORRECT', 'admin', '정상 수량 확인', 120),
    ('STK002', NOW(), 'PENDING', 'INCORRECT', 'manager01', '수량 확인 중', 195),
    ('STK003', NOW(), 'REJECTED', 'INCORRECT', 'manager02', '수량 차이 발생', 140),
    ('STK004', NOW(), 'APPROVED', 'CORRECT', 'admin', '검수 완료', 80),
    ('STK005', NOW(), 'PENDING', 'INCORRECT', 'manager03', '실사 대기 중', 0);

ALTER TABLE stock MODIFY lpId CHAR(40) NOT NULL;

desc stock;

SHOW CREATE TABLE stock;
ALTER TABLE stock DROP FOREIGN KEY fk_stock_location_places;
ALTER TABLE stock MODIFY lpId CHAR(40) NOT NULL;
ALTER TABLE stock
    ADD CONSTRAINT fk_stock_location_places
        FOREIGN KEY (lpId) REFERENCES location_places(lpId);
