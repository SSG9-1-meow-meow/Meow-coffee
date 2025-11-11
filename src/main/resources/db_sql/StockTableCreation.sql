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
                       lpId CHAR(40) NOT NULL,
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

-- 창고 관리 테이블
create table warehouse_management(
    whManagementId bigint primary key auto_increment,
    whId bigint not null,
    userId varchar(30) not null,
    constraint fk_whId foreign key (whId) references warehouse(whId),
    constraint fk_userId foreign key (userId) references users(userId)
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

INSERT INTO warehouse_management(whId, userId)
values (1, 'manager_choi'),(1,'manager_kim'), (2, 'manager_lee'), (3, 'manager_park');


ALTER TABLE stock MODIFY lpId CHAR(40) NOT NULL;

desc stock;

SHOW CREATE TABLE stock;
ALTER TABLE stock DROP FOREIGN KEY fk_stock_location_places;
ALTER TABLE stock MODIFY lpId CHAR(40) NOT NULL;
ALTER TABLE stock
    ADD CONSTRAINT fk_stock_location_places
        FOREIGN KEY (lpId) REFERENCES location_places(lpId);

-- stock 프로시저 작성

use meowcoffeedb;

--  등록 프로시저
delimiter ##
create procedure insertDueDiligence(
    in stk_Id varchar(12),
    in real_StkQuantity int,
    in dd_Log varchar(255),
    in ma_Id varchar(30)
)
begin
    declare status varchar(10);
    declare quantity int;
select stk.stkQuantity into quantity
from stock stk
where stk.stkId = stk_Id;
if quantity = real_StkQuantity then set status = 'CORRECT';
else set status = 'INCORRECT';
end if;
insert into due_diligence (stkId, ddStatus, maId, ddLog, realStkQuantity)
values(stk_Id, status, ma_id, dd_Log, real_StkQuantity);

end ##
delimiter ;

 -- 수정 프로시저
delimiter ##
create procedure updateDueDiligence(
    in dd_Id BIGINT,
    in stk_Quantity int,
    in real_StkQuantity int,
    in dd_Log VARCHAR(255)
)
begin
    declare status varchar(10);

    if stk_Quantity = real_StkQuantity then set status = 'CORRECT';
else set status = 'INCORRECT';
end if;

update due_diligence set ddStatus=status, ddLog = dd_Log,
                         ddUpdateDate = now(), realStkQuantity = real_StkQuantity
where  ddId = dd_Id and isDelete = 0;

end ##
delimiter ;

 -- 총관리자 승인 프로시저
delimiter ##
create procedure updateApprovalStatus(
    in dd_Approval VARCHAR(10),
    in dd_Id BIGINT
)
begin
    declare real_quantity int;
    declare stk_id varchar(12);
    declare cur_status varchar(10);
    declare is_deleted tinyint;

select realStkQuantity, stkId, ddApproval, isDelete into real_quantity, stk_id, cur_status, is_deleted
from due_diligence where ddId = dd_Id;

if dd_Approval = 'APPROVED' and cur_status = 'PENDING' and is_deleted = 0 then
update stock set stkQuantity = real_quantity
where stkId = stk_id;
update due_diligence set ddApproval = dd_Approval
where ddId= dd_Id;
elseif dd_Approval = 'REJECTED' and cur_status= 'PENDING' and is_deleted = 0 then
update due_diligence set ddApproval = dd_Approval
where ddId= dd_Id;
end if;
end ##
delimiter ;
drop procedure if exists updateApprovalStatus;

-- 데이터 조금 더 추가
-- 🚚 1️⃣ 창고 (warehouse)
INSERT INTO warehouse (whCode, whName, whAddress, whTelPhone, whGrade, whField, whTotalCapa, whUseCapa)
VALUES
    ('WH004', '인천창고', '인천광역시 남동구 논현로 77', '032-222-3333', 'B', 160, 850, 500),
    ('WH005', '광주창고', '광주광역시 서구 상무대로 55', '062-444-5555', 'A', 210, 1000, 800);

INSERT INTO warehouse (whCode, whName, whAddress, whTelPhone, whGrade, whField, whTotalCapa, whUseCapa)
VALUES
    ('WH006', '대전창고', '대전광역시 유성구 대학로 45', '042-555-6666', 'A', 190, 950, 700),
    ('WH007', '울산창고', '울산광역시 남구 삼산로 88', '052-777-8888', 'B', 170, 870, 600),
    ('WH008', '제주창고', '제주특별자치도 제주시 연동 33', '064-333-4444', 'A', 160, 800, 500),
    ('WH009', '강릉창고', '강원도 강릉시 교동로 50', '033-444-5555', 'C', 120, 650, 350),
    ('WH010', '수원창고', '경기도 수원시 권선구 경수대로 100', '031-123-4567', 'A', 200, 1100, 900),
    ('WH011', '창원창고', '경상남도 창원시 의창구 중앙로 88', '055-222-3333', 'B', 150, 720, 500),
    ('WH012', '전주창고', '전라북도 전주시 완산구 기린대로 25', '063-222-3333', 'C', 140, 650, 400),
    ('WH013', '세종창고', '세종특별자치시 조치원읍 세종로 70', '044-777-9999', 'A', 180, 950, 800),
    ('WH014', '포항창고', '경상북도 포항시 남구 중앙로 20', '054-444-5555', 'B', 160, 880, 650),
    ('WH015', '춘천창고', '강원도 춘천시 효자동 77', '033-777-8888', 'C', 130, 600, 400);

-- 🧱 2️⃣ 보관위치 (location_places)
INSERT INTO location_places (lpId, zoneId, zoneName, rackId, rackName, cellId, cellName)
VALUES
    ('LP006', 'Z004', 'Zone-D', 'R006', 'Rack-D1', 'C006', 'Cell-6'),
    ('LP007', 'Z004', 'Zone-D', 'R007', 'Rack-D2', 'C007', 'Cell-7'),
    ('LP008', 'Z005', 'Zone-E', 'R008', 'Rack-E1', 'C008', 'Cell-8'),
    ('LP009', 'Z005', 'Zone-E', 'R009', 'Rack-E2', 'C009', 'Cell-9'),
    ('LP010', 'Z006', 'Zone-F', 'R010', 'Rack-F1', 'C010', 'Cell-10');

INSERT INTO location_places (lpId, zoneId, zoneName, rackId, rackName, cellId, cellName)
VALUES
    ('LP011', 'Z007', 'Zone-G', 'R011', 'Rack-G1', 'C011', 'Cell-11'),
    ('LP012', 'Z007', 'Zone-G', 'R012', 'Rack-G2', 'C012', 'Cell-12'),
    ('LP013', 'Z008', 'Zone-H', 'R013', 'Rack-H1', 'C013', 'Cell-13'),
    ('LP014', 'Z008', 'Zone-H', 'R014', 'Rack-H2', 'C014', 'Cell-14'),
    ('LP015', 'Z009', 'Zone-I', 'R015', 'Rack-I1', 'C015', 'Cell-15');

-- 📦 3️⃣ 보관위치지정 (locations)
INSERT INTO locations (locationId, whId, lpId)
VALUES
    ('LOC006', 4, 'LP006'),
    ('LOC007', 4, 'LP007'),
    ('LOC008', 5, 'LP008'),
    ('LOC009', 5, 'LP009'),
    ('LOC010', 2, 'LP010');

INSERT INTO locations (locationId, whId, lpId)
VALUES
    ('LOC011', 6, 'LP011'),
    ('LOC012', 7, 'LP012'),
    ('LOC013', 8, 'LP013'),
    ('LOC014', 9, 'LP014'),
    ('LOC015', 10, 'LP015');

-- ☕ 4️⃣ 커피 (coffee)
INSERT INTO coffee (cfId, cfName, cfOrigin, cfCategory, cfGrade, cfType)
VALUES
    ('CF006', '인도 몬순 말라바르', 'IND', 'B03', '스페셜티', '아라비카'),
    ('CF007', '탄자니아 킬리만자로', 'TAN', 'B02', '프리미엄', '아라비카'),
    ('CF008', '파푸아뉴기니 시그리', 'PNG', 'B01', '스페셜티', '아라비카'),
    ('CF009', '니카라과 마라카투라', 'NIC', 'B03', '레귤러', '로부스타'),
    ('CF010', '코스타리카 따라주', 'COS', 'B01', '프리미엄', '아라비카');

INSERT INTO coffee (cfId, cfName, cfOrigin, cfCategory, cfGrade, cfType)
VALUES
    ('CF011', '베트남 다크로스트', 'VIE', 'B02', '레귤러', '로부스타'),
    ('CF012', '멕시코 알투라', 'MEX', 'B01', '프리미엄', '아라비카'),
    ('CF013', '페루 차스키', 'PER', 'B03', '스페셜티', '아라비카'),
    ('CF014', '온두라스 마르칼라', 'HON', 'B02', '레귤러', '아라비카'),
    ('CF015', '엘살바도르 파카마라', 'ESA', 'B01', '스페셜티', '아라비카');

-- 📦 5️⃣ 재고 (stock)
INSERT INTO stock (stkId, lpId, cfId, stkQuantity)
VALUES
    ('STK006', 'LP006', 'CF006', 95),
    ('STK007', 'LP007', 'CF007', 180),
    ('STK008', 'LP008', 'CF008', 130),
    ('STK009', 'LP009', 'CF009', 70),
    ('STK010', 'LP010', 'CF010', 110);

INSERT INTO stock (stkId, lpId, cfId, stkQuantity)
VALUES
    ('STK011', 'LP011', 'CF011', 90),
    ('STK012', 'LP012', 'CF012', 150),
    ('STK013', 'LP013', 'CF013', 120),
    ('STK014', 'LP014', 'CF014', 80),
    ('STK015', 'LP015', 'CF015', 100);