use railway;

# table 생성 순서
# [1] 무관계 테이블 생성
# 차량 정보(vehicles), 창고(warehouse), 보관위치(location_places), 커피(coffee), 수수료(feeRate), 단가(unitCost)

-- 1-1. 차량 정보
-- 1. 차량 테이블 생성
DROP TABLE IF EXISTS vehicles;
CREATE TABLE vehicles (
vehicleId	char(10)	PRIMARY KEY ,
vehicleModel	ENUM('5톤 윙바디', '1톤 탑차', '1.2톤 카고')	NOT NULL,
vehicleDesc	varchar(255)	NULL
);

-- 1-1. 차량데이터 생성
INSERT INTO vehicles
(vehicleId, vehicleModel, vehicleDesc)
VALUES
    ('88러1234', '5톤 윙바디', '주력 운송 차량으로, 최근 엔진 오일 및 브레이크 패드 교체를 완료하여 최상의 운행 상태를 유지하고 있습니다. 주로 수도권 핵심 물류를 담당합니다.'),
    ('71하5678', '5톤 윙바디', '차량 점검이 시급히 필요하며, 다음 주 수요일에 전체 정비소 입고가 예정되어 있습니다. 현재는 단거리 및 긴급하지 않은 운송에만 제한적으로 투입 중입니다.'),
    ('62호9012', '5톤 윙바디', '주로 서울-경기 지역의 대형 유통센터를 중심으로 운행하고 있으며, 온도 조절 기능이 강화되어 신선식품 운송에도 투입 가능합니다. 적재함 관리가 우수합니다.'),
    ('53모3456', '5톤 윙바디', '긴급 물류 요청에 대비하여 상시 대기 중인 예비 차량입니다. 운행 횟수가 적어 주행 거리가 짧으며, 언제든 장거리 운행에 투입될 수 있도록 철저하게 관리됩니다.'),
    ('44고7890', '5톤 윙바디', '주로 부산, 대구, 울산 등 영남권의 장거리 운행을 전문적으로 담당합니다. 장거리 운행 특성상 타이어와 서스펜션 관리에 특별히 신경 쓰고 있습니다.'),
    ('35누1122', '5톤 윙바디', '기존 운전자의 부재로 인해 현재 운전자 변경을 대기하고 있으며, 인계 교육 및 차량 상태 점검 후 새로운 운전자에게 배정될 예정입니다.'),
    ('26바3344', '5톤 윙바디', '오전 시간대 운행을 마치고 현재는 물류 창고로 복귀하여 다음 운행을 위해 적재물을 하역 중입니다. 차량 내부 청소 및 기본 점검을 완료했습니다.'),
    ('17사5566', '5톤 윙바디', '올해 새롭게 구매하여 현재 시범 운행 단계에 있는 최신 모델 차량입니다. 연비 및 안전 기능 테스트를 진행하며 데이터 수집 중에 있습니다.'),
    ('08아7788', '5톤 윙바디', '창고 A와 창고 B 간의 재고 이동만을 전담하는 내부 물류 전용 차량입니다. 외부 노출이 적어 외관 상태가 매우 깨끗하게 유지되고 있습니다.'),
    ('99자9900', '5톤 윙바디', '가장 최근인 지난주 금요일에 전체 오일류 교환 및 시스템 업데이트 정비를 완료한 차량입니다. 즉시 최고 성능으로 운행 가능합니다.');

-- 1-2. 창고

-- 창고 코드표
-- 강서 콘솔 : GSC
-- 의정부 콘솔 : UJB
-- 전주 콘솔 : JJC
-- 세종 콘솔 : SJC
-- 대구 콘솔 : DGC
-- 광주 콘솔 : GJC
-- 순천 콘솔 : SCC
-- 원주 콘솔 : WJC
-- 남양주 콘솔 : NYJ
-- 제주 콘솔 : JJU
-- 울산 콘솔 : USC
-- 부산 메인 : BU
-- 대덕 메인 : DD
-- 곤지암 메인 : GJ

-- whAddress
-- 부산 메인 : 부산광역시 강서구 봉림동 1042
-- 곤지암 메인 : 경기도 광주시 초월읍 독고개길48번길 32
-- 대덕 메인 : 대전광역시 대덕구 상서당3길 33
-- 강서 콘솔 : 서울특별시 강서구 과해동 66-1
-- 의정부 콘솔 : 경기도 의정부시 가능동 308
-- 전주 콘솔 : 전북특별자치도 전주시 완산구 삼천동2가 474-1
-- 세종 콘솔 : 세종특별자치시 조치원읍 번암리 161-2
-- 대구 콘솔 : 대구광역시 달성군 현풍읍 원교리 921-1
-- 광주 콘솔 : 광주광역시 북구 운암동 194-8
-- 순천 콘솔 : 전남 순천시 덕월동 12-10
-- 원주 콘솔 : 강원특별자치도 원주시 관설동 694
-- 남양주 콘솔 : 경기 남양주시 와부읍 월문리 산 326-1
-- 제주 콘솔 : 제주특별자치도 제주시 아라일동 676-1
-- 울산 콘솔 : 울산 북구 창평동 29

-- 지역별 전화번호 정보
-- 서울 강서: 02
-- 경기 (의정부, 광주, 남양주): 031
-- 강원 원주: 033
-- 대전 대덕: 042
-- 세종: 044
-- 부산: 051
-- 울산: 052
-- 대구: 053
-- 전남 순천: 061
-- 광주: 062
-- 전북 전주: 063
-- 제주: 064

CREATE TABLE warehouse (
whId BIGINT AUTO_INCREMENT PRIMARY KEY,
whCode VARCHAR(12) NOT NULL, -- 창고 코드 : 위 코드표 참고
whName VARCHAR(30) NOT NULL, -- 창고 이름 한글로 : 위 코드표 참고
whAddress VARCHAR(100) NOT NULL, -- 창고 상세 주소 한글 : 위 주소표 참고
whTelephone VARCHAR(13),     -- 창고 사무실 전화번호 (서울 : 02, 경기도 : 031, 전주, 세종, 대구, 광주, 순천, 원주, 제주, 울산, 부산, 대전 등)
whGrade CHAR(5) NOT NULL,    -- Main, Sub 둘 중 하나 Main 은 부산, 곤지암,대덕 창고만 해당
whField INT NOT NULL,        -- 곤지암(5,000평),부산(8,000평),대덕(3,000평), 나머지 sub 창고는 2,000평 통일
whTotalCapa INT NOT NULL,    -- 부산은 2,720 PLT, 곤지암은 1,700 PLT, 대덕은 1,020 PLT, 나머지 sub 창고는 680 PLT
whUseCapa INT default 0      -- 0 % ~ 80% 에서 임의로 설정 바람. 파레트 단위임
);

INSERT INTO warehouse (whCode, whName, whAddress, whTelephone, whGrade, whField, whTotalCapa, whUseCapa) VALUES
-- Main 창고
('BU', '부산 메인', '부산광역시 강서구 봉림동 1042', '051-123-4567', 'Main', 8000, 2720, 2040), -- 2720 * 75%
('GJ', '곤지암 메인', '경기도 광주시 초월읍 독고개길48번길 32', '031-234-5678', 'Main', 5000, 1700, 1156), -- 1700 * 68%
('DD', '대덕 메인', '대전광역시 대덕구 상서당3길 33', '042-345-6789', 'Main', 3000, 1020, 816),   -- 1020 * 80%
-- Sub 창고
('GSC', '강서 콘솔', '서울특별시 강서구 과해동 66-1', '02-456-7890', 'Sub', 2000, 680, 374),    -- 680 * 55%
('UJB', '의정부 콘솔', '경기도 의정부시 가능동 308', '031-567-8901', 'Sub', 2000, 680, 292),    -- 680 * 43%
('JJC', '전주 콘솔', '전북특별자치도 전주시 완산구 삼천동2가 474-1', '063-678-9012', 'Sub', 2000, 680, 490),    -- 680 * 72%
('SJC', '세종 콘솔', '세종특별자치시 조치원읍 번암리 161-2', '044-789-0123', 'Sub', 2000, 680, 204),    -- 680 * 30%
('DGC', '대구 콘솔', '대구광역시 달성군 현풍읍 원교리 921-1', '053-890-1234', 'Sub', 2000, 680, 442),    -- 680 * 65%
('GJC', '광주 콘솔', '광주광역시 북구 운암동 194-8', '062-901-2345', 'Sub', 2000, 680, 394),    -- 680 * 58%
('SCC', '순천 콘솔', '전남 순천시 덕월동 12-10', '061-112-3456', 'Sub', 2000, 680, 326),    -- 680 * 48%
('WJC', '원주 콘솔', '강원특별자치도 원주시 관설동 694', '033-223-4567', 'Sub', 2000, 680, 170),    -- 680 * 25%
('NYJ', '남양주 콘솔', '경기 남양주시 와부읍 월문리 산 326-1', '031-334-5678', 'Sub', 2000, 680, 530),    -- 680 * 78%
('JJU', '제주 콘솔', '제주특별자치도 제주시 아라일동 676-1', '064-445-6789', 'Sub', 2000, 680, 408),    -- 680 * 60%
('USC', '울산 콘솔', '울산 북구 창평동 29', '052-556-7890', 'Sub', 2000, 680, 354);     -- 680 * 52%


-- 1-3. 보관 위치
-- 테이블 초기화
DROP TABLE IF EXISTS location_places;
CREATE TABLE location_places (
          lpId CHAR(40) PRIMARY KEY,
          zoneId CHAR(12) NOT NULL,
          zoneName CHAR(20) NOT NULL,
          rackId CHAR(12) NOT NULL,
          rackName CHAR(12) NOT NULL,
          cellId CHAR(12) NOT NULL,
          cellName CHAR(12) NOT NULL
);

-- 대량 데이터 INSERT 쿼리 (MySQL 5.x 버전 호환)
INSERT INTO location_places (lpId, zoneId, zoneName, rackId, rackName, cellId, cellName)
SELECT
    CONCAT(w.whCode, '-', og.zoneId, '-', c.rackId, '-', og.cellId) AS lpId,
    og.zoneId,
    og.zoneName,
    c.rackId,
    c.rackName,
    og.cellId,
    og.cellName
FROM
    -- warehouses 서브쿼리
    (SELECT 'BU' as whCode UNION ALL SELECT 'GJ' UNION ALL SELECT 'DD' UNION ALL
     SELECT 'GSC' UNION ALL SELECT 'UJB' UNION ALL SELECT 'JJC' UNION ALL
     SELECT 'SJC' UNION ALL SELECT 'DGC' UNION ALL SELECT 'GJC' UNION ALL
     SELECT 'SCC' UNION ALL SELECT 'WJC' UNION ALL SELECT 'NYJ' UNION ALL
     SELECT 'JJU' UNION ALL SELECT 'USC') AS w
        CROSS JOIN
    -- companies 서브쿼리
        (SELECT 'ST' as rackId, '스타벅스' as rackName UNION ALL
         SELECT 'TW' as rackId, '투썸플레이스' as rackName) AS c
        CROSS JOIN
    -- origin_grades 서브쿼리
        (SELECT 'BS' as zoneId, '브라질(15도, 55%)' as zoneName, 'NO.2' as cellId, 'NO.2' as cellName UNION ALL
         SELECT 'YY', '예가체프(18도, 60%)', 'G3', 'G3' UNION ALL
         SELECT 'CE', '케냐(19도, 65%)', 'AA', 'AA' UNION ALL
         SELECT 'CLS', '콜롬비아(16도, 58%)', 'SM', 'SM' UNION ALL
         SELECT 'GTN', '과테말라(17도, 62%)', 'SHB', 'SHB' UNION ALL
         SELECT 'CT', '코스타리카(18도, 60%)', 'shb', 'shb' UNION ALL
         SELECT 'JB', '자메이카(20도, 68%)', 'NO.1', 'NO.1') AS og;


-- 1-4. 커피

-- 회사 코드 : ST, TW
-- 카테고리 코드 : RO, GC, DC (원두, 생두, 디카페인)
-- 원산지 코드 : BS, YY, CE, CLS, GTN, CT, JB (각각 브라질 산토스, 에티오피아 예가체프, 케냐, 콜롬비아 수프리모, 과테말라 안티구아, 코스타리카 타라주, 자메이카 블루마운틴)
-- 등급 코드 : NO.2, G3, AA, SM, SHB, shb, NO.1 (각각 브라질 산토스, 에티오피아 예가체프, 케냐, 콜롬비아 수프리모, 과테말라 안티구아, 코스타리카 타라주, 자메이카 블루마운틴 원산지별 등급에 해당)
DROP TABLE IF EXISTS coffee;
CREATE TABLE coffee (
cfId CHAR(20) PRIMARY KEY, -- "회사코드-카테고리코드-원산지코드-등급코드"로 구분
cfName VARCHAR(20) NOT NULL, -- 한글로
cfOrigin CHAR(3) NOT NULL, -- 원산지 코드로
cfCategory CHAR(4) NOT NULL, -- 원두/생두/디카페인 한글로
cfGrade VARCHAR(15) NOT NULL, -- 한글로
cfType VARCHAR(15) NOT NULL  -- 아라비카 통일
);

INSERT INTO coffee VALUES
('ST-RO-BS-NO.2', '브라질 산토스', 'BS', '원두', 'NO.2', '아라비카'),
('ST-RO-YY-G3', '에티오피아 예가체프', 'YY', '원두', 'G3', '아라비카'),
('ST-RO-CE-AA', '케냐', 'CE', '원두', 'AA', '아라비카'),
('ST-RO-CLS-SM', '콜롬비아 수프리모', 'CLS', '원두', 'SM', '아라비카'),
('ST-RO-GTN-SHB', '과테말라 안티구아', 'GTN', '원두', 'SHB', '아라비카'),
('ST-RO-CT-shb', '코스타리카 타라주', 'CT', '원두', 'shb', '아라비카'),
('ST-RO-JB-NO.1', '자메이카 블루마운틴', 'JB', '원두', 'NO.1', '아라비카'),

('TW-RO-BS-NO.2', '브라질 산토스', 'BS', '원두', 'NO.2', '아라비카'),
('TW-RO-YY-G3', '에티오피아 예가체프', 'YY', '원두', 'G3', '아라비카'),
('TW-RO-CE-AA', '케냐', 'CE', '원두', 'AA', '아라비카'),
('TW-RO-CLS-SM', '콜롬비아 수프리모', 'CLS', '원두', 'SM', '아라비카'),
('TW-RO-GTN-SHB', '과테말라 안티구아', 'GTN', '원두', 'SHB', '아라비카'),
('TW-RO-CT-shb', '코스타리카 타라주', 'CT', '원두', 'shb', '아라비카'),
('TW-RO-JB-NO.1', '자메이카 블루마운틴', 'JB', '원두', 'NO.1', '아라비카'),

('ST-GC-BS-NO.2', '브라질 산토스', 'BS', '생두', 'NO.2', '아라비카'),
('ST-GC-YY-G3', '에티오피아 예가체프', 'YY', '생두', 'G3', '아라비카'),
('ST-GC-CE-AA', '케냐', 'CE', '생두', 'AA', '아라비카'),
('ST-GC-CLS-SM', '콜롬비아 수프리모', 'CLS', '생두', 'SM', '아라비카'),
('ST-GC-GTN-SHB', '과테말라 안티구아', 'GTN', '생두', 'SHB', '아라비카'),

('TW-GC-CE-AA', '케냐', 'CE', '생두', 'AA', '아라비카'),
('TW-GC-CLS-SM', '콜롬비아 수프리모', 'CLS', '생두', 'SM', '아라비카'),
('TW-GC-GTN-SHB', '과테말라 안티구아', 'GTN', '생두', 'SHB', '아라비카'),

('ST-DC-CLS-SM', '콜롬비아 수프리모', 'CLS', '디카페인', 'SM', '아라비카'),
('ST-DC-GTN-SHB', '과테말라 안티구아', 'GTN', '디카페인', 'SHB', '아라비카'),
('ST-DC-BS-NO.2', '브라질 산토스', 'BS', '디카페인', 'NO.2', '아라비카'),

('TW-DC-YY-G3', '에티오피아 예가체프', 'YY', '디카페인', 'G3', '아라비카'),
('TW-DC-CE-AA', '케냐', 'CE', '디카페인', 'AA', '아라비카'),
('TW-DC-CLS-SM', '콜롬비아 수프리모', 'CLS', '디카페인', 'SM', '아라비카'),
('TW-DC-GTN-SHB', '과테말라 안티구아', 'GTN', '디카페인', 'SHB', '아라비카'),
('TW-DC-JB-NO.1', '자메이카 블루마운틴', 'JB', '디카페인', 'NO.1', '아라비카');



-- 1-5. 단가 테이블
CREATE TABLE unitCost
(
unitCostId     BIGINT AUTO_INCREMENT PRIMARY KEY,
laborUnitAmt   DECIMAL(15, 2) NOT NULL,
inspectUnitAmt DECIMAL(15, 2) NOT NULL,
packingUnitAmt DECIMAL(15, 2) NOT NULL,
transUnitAmt   DECIMAL(15, 2) NOT NULL,
storeUnitAmt   DECIMAL(15, 2) NOT NULL
);

INSERT INTO unitCost (laborUnitAmt, inspectUnitAmt, packingUnitAmt, transUnitAmt, storeUnitAmt)
VALUES (12000, 300, 5000, 300, 500);
SELECT * FROM unitCost;

-- 1-6. 수수료 테이블
CREATE TABLE feeRate
(
feeRateId       BIGINT AUTO_INCREMENT PRIMARY KEY,
inFeeRatePct    DECIMAL(5, 2) NOT NULL,
outFeeRatePct   DECIMAL(5, 2) NOT NULL,
storeFeeRatePct DECIMAL(5, 2) NOT NULL,
delFeeRatePct   DECIMAL(5, 2) NOT NULL
);

INSERT INTO feeRate (inFeeRatePct, outFeeRatePct, storeFeeRatePct, delFeeRatePct)
VALUES (1.2, 1.25, 1.1, 1.05);
SELECT *
FROM feeRate;


-- 1-7 영업 테이블
CREATE TABLE revenue
(
    revenueId BIGINT AUTO_INCREMENT PRIMARY KEY,
    totalAmt  DECIMAL(15, 2) NOT NULL, -- 매출은 연에 십억 정도로, 월마다 발생이라 12로 나눈 값 * 0.1~ 0.15 (이익률 10~15% 발생) 에 랜덤 변동
    revenueDt DATETIME       NOT NULL -- 매월 15일 임의의 시간에 발생 2024년 12월 ~ 2025년 11월 까지
);

-- 영업이익 샘플 데이터 INSERT (2024년 12월 ~ 2025년 11월)
INSERT INTO revenue (totalAmt, revenueDt) VALUES
(10458330.00, '2024-12-15 14:22:05'), -- 약 12.5% 이익률
(11783330.00, '2025-01-15 10:05:30'), -- 약 14.1% 이익률
(9241660.00,  '2025-02-15 17:45:11'), -- 약 11.1% 이익률
(12150000.00, '2025-03-15 09:18:46'), -- 약 14.6% 이익률
(8533330.00,  '2025-04-15 21:00:57'), -- 약 10.2% 이익률
(10991660.00, '2025-05-15 11:33:29'), -- 약 13.2% 이익률
(11241660.00, '2025-06-15 13:12:14'), -- 약 13.5% 이익률
(9825000.00,  '2025-07-15 18:04:44'), -- 약 11.8% 이익률
(8358330.00,  '2025-08-15 16:50:02'), -- 약 10.0% 이익률
(12450000.00, '2025-09-15 09:02:18'), -- 약 14.9% 이익률
(10016660.00, '2025-10-15 15:28:35'), -- 약 12.0% 이익률
(11575000.00, '2025-11-15 11:55:00'); -- 약 13.9% 이익률





# [2] 단일 이상 관계 테이블 생성
# 회원 테이블, 일별 창고별 수용량


-- 회원은 총관리자, 창고관리자, 거래처, 배송기사로 구분 : 각각 `COMPANY`, `MANAGER`, `ADMIN`, `DELIVERYMAN`
-- 2-1 회원 테이블
drop table if exists users;
CREATE TABLE users (
userId	varchar(30)	NOT NULL,     -- 총관리자는 2명 : admin_master, admin_sub, 창고 관리자는 메인 창고당 5명, 서브 창고당 3명 이하로 중복되지 않게
userPwd	varchar(255)	NOT NULL, -- 'hashed_password_placeholder' 로 전체 통일
userCompanyName	varchar(30)	NULL, -- 총관리자와 창고관리자는 NULL로 통일, 나머지는 스타벅스, 투썸플레이스 둘 중 하나
userName	varchar(30)	NOT NULL, -- 중복안되게 한글명으로
userPhone	varchar(13)	NOT NULL, -- 중복 안되게 010-XXXX-XXXX 으로
userEmail	varchar(50)	NOT NULL, -- 중복 안되게 이메일형식으로 하되, 관리자는 @meowCoffee.com, 나머지 회원은 @starbucks.com, @twosomeplace.com
userCode	char(12)	NOT NULL, -- 000-00-00000 형식으로 작성된 10개의 숫자, 총관리자: ADM-00-00000 과 같은 형식으로 작성, 창고관리자 : MAN-00-00000 과 같은 형식으로 작성, 배송기사: 거래처와 동일하게 사업자등록번호를 사용
userRoadAddr	varchar(100)	NULL,  -- 중복 안되게 도로명 주소로 ex. 서울특별시 강남구 테헤란로 142
userDetailAddr	varchar(100)	NULL,  -- 상세 주소
userImgPath	varchar(255)	NULL, -- C:\\study\\meowcoffeeFile\\profiles\\???.jpg 형식으로

userRole	enum('COMPANY', 'MANAGER', 'ADMIN', 'DELIVERYMAN')	NOT NULL,
userStatus	enum('APPROVAL', 'WAITING_APPROVAL', 'DEACTIVATED', 'WAITING_DEACTIVATE') DEFAULT 'WAITING_APPROVAL',
userJoinDate	date	NULL, -- 계정상태 속성값이 WAITING_APPROVAL 에서 APPROVAL로 변경된 날짜 (승인대기 중일 때는 이 속성값을 null로 지정, 승인 완료될 때 현재 날짜로 갱신)
userLastLogin	date	NULL, -- 스프링 시큐리티의 로그인 기능과 연계되어 갱신되는 속성값; 로그인에 성공할 때마다 현재시간으로 갱신

vehicleId	char(10)	NULL -- 차량정보 테이블에서 외래키로 가져온 값
);
ALTER TABLE users ADD CONSTRAINT PK_USERS PRIMARY KEY (userId);
ALTER TABLE users ADD CONSTRAINT FK_vehicles_TO_users FOREIGN KEY (vehicleId)
    REFERENCES vehicles (vehicleId);

-- users 테이블 샘플 데이터 삽입

truncate users;
-- 2-1-1. 총관리자 (ADMIN) 데이터 (2명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
('admin_master', 'hashed_password_placeholder', NULL, '김관리', '010-1111-1111', 'admin_master@meowCoffee.com', 'ADM-00-00001', '서울특별시 강남구 테헤란로 142', 'A동 101호', 'C:\\study\\meowcoffeeFile\\profiles\\admin_master.jpg', 'ADMIN', 'APPROVAL', '2024-01-01'),
('admin_sub', 'hashed_password_placeholder', NULL, '이부장', '010-2222-2222', 'admin_sub@meowCoffee.com', 'ADM-00-00002', '서울특별시 서초구 서초대로 77길 54', 'B동 202호', 'C:\\study\\meowcoffeeFile\\profiles\\admin_sub.jpg', 'ADMIN', 'APPROVAL', '2024-01-02');

-- 2-1-2. 창고관리자 (MANAGER) 데이터 (일부 샘플)
-- 부산 메인 (3명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
('bu_manager_01', 'hashed_password_placeholder', NULL, '박부산', '010-3001-0001', 'bu_manager_01@meowCoffee.com', 'MAN-00-00001', '부산광역시 강서구', '1층 사무실', 'C:\\study\\meowcoffeeFile\\profiles\\bu_manager_01.jpg', 'MANAGER', 'APPROVAL', '2024-02-01'),
('bu_manager_02', 'hashed_password_placeholder', NULL, '최경남', '010-3001-0002', 'bu_manager_02@meowCoffee.com', 'MAN-00-00002', '부산광역시 사하구', '2층 사무실', 'C:\\study\\meowcoffeeFile\\profiles\\bu_manager_02.jpg', 'MANAGER', 'APPROVAL', '2024-02-02'),
('bu_manager_03', 'hashed_password_placeholder', NULL, '정부산', '010-3001-0003', 'bu_manager_03@meowCoffee.com', 'MAN-00-00003', '부산광역시 해운대구', '3층 사무실', 'C:\\study\\meowcoffeeFile\\profiles\\bu_manager_03.jpg', 'MANAGER', 'APPROVAL', NULL);
-- 강서 콘솔 (2명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
('gsc_manager_01', 'hashed_password_placeholder', NULL, '강서울', '010-4001-0001', 'gsc_manager_01@meowCoffee.com', 'MAN-00-00016', '서울특별시 강서구', '사무실 1', 'C:\\study\\meowcoffeeFile\\profiles\\gsc_manager_01.jpg', 'MANAGER', 'APPROVAL', '2024-03-01'),
('gsc_manager_02', 'hashed_password_placeholder', NULL, '서마포', '010-4001-0002', 'gsc_manager_02@meowCoffee.com', 'MAN-00-00017', '서울특별시 마포구', '사무실 2', 'C:\\study\\meowcoffeeFile\\profiles\\gsc_manager_02.jpg', 'MANAGER', 'APPROVAL', '2024-03-02');


-- 부산 메인 (추가 2명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
                                                                                                                                                                                  ('bu_manager_04', 'hashed_password_placeholder', NULL, '윤대호', '010-3001-0004', 'bu_manager_04@meowCoffee.com', 'MAN-00-00004', '부산광역시 수영구', '4층 사무실', 'C:\\study\\meowcoffeeFile\\profiles\\bu_manager_04.jpg', 'MANAGER', 'APPROVAL', '2024-02-04'),
                                                                                                                                                                                  ('bu_manager_05', 'hashed_password_placeholder', NULL, '장미래', '010-3001-0005', 'bu_manager_05@meowCoffee.com', 'MAN-00-00005', '부산광역시 금정구', '5층 사무실', 'C:\\study\\meowcoffeeFile\\profiles\\bu_manager_05.jpg', 'MANAGER', 'WAITING_APPROVAL', NULL);

-- 곤지암 메인 (5명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
                                                                                                                                                                                  ('gj_manager_01', 'hashed_password_placeholder', NULL, '오광주', '010-3002-0001', 'gj_manager_01@meowCoffee.com', 'MAN-00-00006', '경기도 광주시', 'A동', 'C:\\study\\meowcoffeeFile\\profiles\\gj_manager_01.jpg', 'MANAGER', 'APPROVAL', '2024-02-05'),
                                                                                                                                                                                  ('gj_manager_02', 'hashed_password_placeholder', NULL, '권경기', '010-3002-0002', 'gj_manager_02@meowCoffee.com', 'MAN-00-00007', '경기도 성남시', 'B동', 'C:\\study\\meowcoffeeFile\\profiles\\gj_manager_02.jpg', 'MANAGER', 'APPROVAL', '2024-02-06'),
                                                                                                                                                                                  ('gj_manager_03', 'hashed_password_placeholder', NULL, '황이천', '010-3002-0003', 'gj_manager_03@meowCoffee.com', 'MAN-00-00008', '경기도 이천시', 'C동', 'C:\\study\\meowcoffeeFile\\profiles\\gj_manager_03.jpg', 'MANAGER', 'APPROVAL', '2024-02-07'),
                                                                                                                                                                                  ('gj_manager_04', 'hashed_password_placeholder', NULL, '안성실', '010-3002-0004', 'gj_manager_04@meowCoffee.com', 'MAN-00-00009', '경기도 용인시', 'D동', 'C:\\study\\meowcoffeeFile\\profiles\\gj_manager_04.jpg', 'MANAGER', 'APPROVAL', '2024-02-08'),
                                                                                                                                                                                  ('gj_manager_05', 'hashed_password_placeholder', NULL, '송하늘', '010-3002-0005', 'gj_manager_05@meowCoffee.com', 'MAN-00-00010', '경기도 수원시', 'E동', 'C:\\study\\meowcoffeeFile\\profiles\\gj_manager_05.jpg', 'MANAGER', 'WAITING_APPROVAL', NULL);

-- 대덕 메인 (5명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
                                                                                                                                                                                  ('dd_manager_01', 'hashed_password_placeholder', NULL, '고대덕', '010-3003-0001', 'dd_manager_01@meowCoffee.com', 'MAN-00-00011', '대전광역시 대덕구', '1팀', 'C:\\study\\meowcoffeeFile\\profiles\\dd_manager_01.jpg', 'MANAGER', 'APPROVAL', '2024-02-10'),
                                                                                                                                                                                  ('dd_manager_02', 'hashed_password_placeholder', NULL, '문대전', '010-3003-0002', 'dd_manager_02@meowCoffee.com', 'MAN-00-00012', '대전광역시 서구', '2팀', 'C:\\study\\meowcoffeeFile\\profiles\\dd_manager_02.jpg', 'MANAGER', 'APPROVAL', '2024-02-11'),
                                                                                                                                                                                  ('dd_manager_03', 'hashed_password_placeholder', NULL, '허유성', '010-3003-0003', 'dd_manager_03@meowCoffee.com', 'MAN-00-00013', '대전광역시 유성구', '3팀', 'C:\\study\\meowcoffeeFile\\profiles\\dd_manager_03.jpg', 'MANAGER', 'APPROVAL', '2024-02-12'),
                                                                                                                                                                                  ('dd_manager_04', 'hashed_password_placeholder', NULL, '신탄진', '010-3003-0004', 'dd_manager_04@meowCoffee.com', 'MAN-00-00014', '대전광역시 동구', '4팀', 'C:\\study\\meowcoffeeFile\\profiles\\dd_manager_04.jpg', 'MANAGER', 'APPROVAL', '2024-02-13'),
                                                                                                                                                                                  ('dd_manager_05', 'hashed_password_placeholder', NULL, '방충청', '010-3003-0005', 'dd_manager_05@meowCoffee.com', 'MAN-00-00015', '충청북도 청주시', '5팀', 'C:\\study\\meowcoffeeFile\\profiles\\dd_manager_05.jpg', 'MANAGER', 'WAITING_APPROVAL', NULL);

-- 강서 콘솔 (추가 1명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
    ('gsc_manager_03', 'hashed_password_placeholder', NULL, '김김포', '010-4001-0003', 'gsc_manager_03@meowCoffee.com', 'MAN-00-00018', '경기도 김포시', '사무실 3', 'C:\\study\\meowcoffeeFile\\profiles\\gsc_manager_03.jpg', 'MANAGER', 'APPROVAL', '2024-03-03');

-- 의정부 콘솔 (3명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
                                                                                                                                                                                  ('ujb_manager_01', 'hashed_password_placeholder', NULL, '나의정', '010-4002-0001', 'ujb_manager_01@meowCoffee.com', 'MAN-00-00019', '경기도 의정부시', '관리실', 'C:\\study\\meowcoffeeFile\\profiles\\ujb_manager_01.jpg', 'MANAGER', 'APPROVAL', '2024-03-04'),
                                                                                                                                                                                  ('ujb_manager_02', 'hashed_password_placeholder', NULL, '조양주', '010-4002-0002', 'ujb_manager_02@meowCoffee.com', 'MAN-00-00020', '경기도 양주시', '창고A', 'C:\\study\\meowcoffeeFile\\profiles\\ujb_manager_02.jpg', 'MANAGER', 'APPROVAL', '2024-03-05'),
                                                                                                                                                                                  ('ujb_manager_03', 'hashed_password_placeholder', NULL, '유포천', '010-4002-0003', 'ujb_manager_03@meowCoffee.com', 'MAN-00-00021', '경기도 포천시', '창고B', 'C:\\study\\meowcoffeeFile\\profiles\\ujb_manager_03.jpg', 'MANAGER', 'WAITING_APPROVAL', NULL);

-- 전주 콘솔 (3명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
                                                                                                                                                                                  ('jjc_manager_01', 'hashed_password_placeholder', NULL, '오전주', '010-4003-0001', 'jjc_manager_01@meowCoffee.com', 'MAN-00-00022', '전라북도 전주시', '1번 구역', 'C:\\study\\meowcoffeeFile\\profiles\\jjc_manager_01.jpg', 'MANAGER', 'APPROVAL', '2024-03-06'),
                                                                                                                                                                                  ('jjc_manager_02', 'hashed_password_placeholder', NULL, '완산구', '010-4003-0002', 'jjc_manager_02@meowCoffee.com', 'MAN-00-00023', '전라북도 익산시', '2번 구역', 'C:\\study\\meowcoffeeFile\\profiles\\jjc_manager_02.jpg', 'MANAGER', 'APPROVAL', '2024-03-07'),
                                                                                                                                                                                  ('jjc_manager_03', 'hashed_password_placeholder', NULL, '덕진구', '010-4003-0003', 'jjc_manager_03@meowCoffee.com', 'MAN-00-00024', '전라북도 군산시', '3번 구역', 'C:\\study\\meowcoffeeFile\\profiles\\jjc_manager_03.jpg', 'MANAGER', 'APPROVAL', '2024-03-08');

-- (이하 나머지 8개 서브 창고 관리자 데이터도 동일한 패턴으로 생성) ...
-- 세종 콘솔 (3명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
                                                                                                                                                                                  ('sjc_manager_01', 'hashed_password_placeholder', NULL, '세종대', '010-4004-0001', 'sjc_manager_01@meowCoffee.com', 'MAN-00-00025', '세종특별자치시', '조치원읍', 'C:\\study\\meowcoffeeFile\\profiles\\sjc_manager_01.jpg', 'MANAGER', 'APPROVAL', '2024-03-09'),
                                                                                                                                                                                  ('sjc_manager_02', 'hashed_password_placeholder', NULL, '이성계', '010-4004-0002', 'sjc_manager_02@meowCoffee.com', 'MAN-00-00026', '세종특별자치시', '나성동', 'C:\\study\\meowcoffeeFile\\profiles\\sjc_manager_02.jpg', 'MANAGER', 'APPROVAL', '2024-03-10'),
                                                                                                                                                                                  ('sjc_manager_03', 'hashed_password_placeholder', NULL, '공주시', '010-4004-0003', 'sjc_manager_03@meowCoffee.com', 'MAN-00-00027', '충청남도 공주시', '반포면', 'C:\\study\\meowcoffeeFile\\profiles\\sjc_manager_03.jpg', 'MANAGER', 'WAITING_APPROVAL', NULL);


-- 대구 콘솔 (3명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
                                                                                                                                                                                  ('dgc_manager_01', 'hashed_password_placeholder', NULL, '김대구', '010-4005-0001', 'dgc_manager_01@meowCoffee.com', 'MAN-00-00028', '대구광역시 달성군', '현풍읍', 'C:\\study\\meowcoffeeFile\\profiles\\dgc_manager_01.jpg', 'MANAGER', 'APPROVAL', '2024-03-11'),
                                                                                                                                                                                  ('dgc_manager_02', 'hashed_password_placeholder', NULL, '이달성', '010-4005-0002', 'dgc_manager_02@meowCoffee.com', 'MAN-00-00029', '대구광역시 수성구', '범어동', 'C:\\study\\meowcoffeeFile\\profiles\\dgc_manager_02.jpg', 'MANAGER', 'APPROVAL', '2024-03-12'),
                                                                                                                                                                                  ('dgc_manager_03', 'hashed_password_placeholder', NULL, '박현풍', '010-4005-0003', 'dgc_manager_03@meowCoffee.com', 'MAN-00-00030', '대구광역시 중구', '동성로', 'C:\\study\\meowcoffeeFile\\profiles\\dgc_manager_03.jpg', 'MANAGER', 'APPROVAL', '2024-03-13');
-- 광주 콘솔 (3명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
                                                                                                                                                                                  ('gjc_manager_01', 'hashed_password_placeholder', NULL, '최광주', '010-4006-0001', 'gjc_manager_01@meowCoffee.com', 'MAN-00-00031', '광주광역시 북구', '운암동', 'C:\\study\\meowcoffeeFile\\profiles\\gjc_manager_01.jpg', 'MANAGER', 'APPROVAL', '2024-03-14'),
                                                                                                                                                                                  ('gjc_manager_02', 'hashed_password_placeholder', NULL, '정북구', '010-4006-0002', 'gjc_manager_02@meowCoffee.com', 'MAN-00-00032', '광주광역시 서구', '치평동', 'C:\\study\\meowcoffeeFile\\profiles\\gjc_manager_02.jpg', 'MANAGER', 'APPROVAL', '2024-03-15'),
                                                                                                                                                                                  ('gjc_manager_03', 'hashed_password_placeholder', NULL, '윤운암', '010-4006-0003', 'gjc_manager_03@meowCoffee.com', 'MAN-00-00033', '광주광역시 동구', '충장로', 'C:\\study\\meowcoffeeFile\\profiles\\gjc_manager_03.jpg', 'MANAGER', 'WAITING_APPROVAL', NULL);
-- 순천 콘솔 (3명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
                                                                                                                                                                                  ('scc_manager_01', 'hashed_password_placeholder', NULL, '강순천', '010-4007-0001', 'scc_manager_01@meowCoffee.com', 'MAN-00-00034', '전라남도 순천시', '덕월동', 'C:\\study\\meowcoffeeFile\\profiles\\scc_manager_01.jpg', 'MANAGER', 'APPROVAL', '2024-03-16'),
                                                                                                                                                                                  ('scc_manager_02', 'hashed_password_placeholder', NULL, '조여수', '010-4007-0002', 'scc_manager_02@meowCoffee.com', 'MAN-00-00035', '전라남도 여수시', '학동', 'C:\\study\\meowcoffeeFile\\profiles\\scc_manager_02.jpg', 'MANAGER', 'APPROVAL', '2024-03-17'),
                                                                                                                                                                                  ('scc_manager_03', 'hashed_password_placeholder', NULL, '한광양', '010-4007-0003', 'scc_manager_03@meowCoffee.com', 'MAN-00-00036', '전라남도 광양시', '중동', 'C:\\study\\meowcoffeeFile\\profiles\\scc_manager_03.jpg', 'MANAGER', 'APPROVAL', '2024-03-18');


-- 남양주 콘솔 (3명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
                                                                                                                                                                                  ('nyj_manager_01', 'hashed_password_placeholder', NULL, '신남양', '010-4009-0001', 'nyj_manager_01@meowCoffee.com', 'MAN-00-00040', '경기도 남양주시', '와부읍', 'C:\\study\\meowcoffeeFile\\profiles\\nyj_manager_01.jpg', 'MANAGER', 'APPROVAL', '2024-03-21'),
                                                                                                                                                                                  ('nyj_manager_02', 'hashed_password_placeholder', NULL, '임하남', '010-4009-0002', 'nyj_manager_02@meowCoffee.com', 'MAN-00-00041', '경기도 하남시', '미사동', 'C:\\study\\meowcoffeeFile\\profiles\\nyj_manager_02.jpg', 'MANAGER', 'APPROVAL', '2024-03-22'),
                                                                                                                                                                                  ('nyj_manager_03', 'hashed_password_placeholder', NULL, '천구리', '010-4009-0003', 'nyj_manager_03@meowCoffee.com', 'MAN-00-00042', '경기도 구리시', '인창동', 'C:\\study\\meowcoffeeFile\\profiles\\nyj_manager_03.jpg', 'MANAGER', 'APPROVAL', '2024-03-23');
-- 제주 콘솔 (3명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
                                                                                                                                                                                  ('jju_manager_01', 'hashed_password_placeholder', NULL, '고제주', '010-4010-0001', 'jju_manager_01@meowCoffee.com', 'MAN-00-00043', '제주특별자치도 제주시', '아라일동', 'C:\\study\\meowcoffeeFile\\profiles\\jju_manager_01.jpg', 'MANAGER', 'APPROVAL', '2024-03-24'),
                                                                                                                                                                                  ('jju_manager_02', 'hashed_password_placeholder', NULL, '부서귀', '010-4010-0002', 'jju_manager_02@meowCoffee.com', 'MAN-00-00044', '제주특별자치도 서귀포시', '법환동', 'C:\\study\\meowcoffeeFile\\profiles\\jju_manager_02.jpg', 'MANAGER', 'APPROVAL', '2024-03-25'),
                                                                                                                                                                                  ('jju_manager_03', 'hashed_password_placeholder', NULL, '양한라', '010-4010-0003', 'jju_manager_03@meowCoffee.com', 'MAN-00-00045', '제주특별자치도 제주시', '연동', 'C:\\study\\meowcoffeeFile\\profiles\\jju_manager_03.jpg', 'MANAGER', 'WAITING_APPROVAL', NULL);
-- 울산 콘솔 (3명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
                                                                                                                                                                                  ('usc_manager_01', 'hashed_password_placeholder', NULL, '김울산', '010-4011-0001', 'usc_manager_01@meowCoffee.com', 'MAN-00-00046', '울산광역시 북구', '창평동', 'C:\\study\\meowcoffeeFile\\profiles\\usc_manager_01.jpg', 'MANAGER', 'APPROVAL', '2024-03-26'),
                                                                                                                                                                                  ('usc_manager_02', 'hashed_password_placeholder', NULL, '이남구', '010-4011-0002', 'usc_manager_02@meowCoffee.com', 'MAN-00-00047', '울산광역시 남구', '삼산동', 'C:\\study\\meowcoffeeFile\\profiles\\usc_manager_02.jpg', 'MANAGER', 'APPROVAL', '2024-03-27'),
                                                                                                                                                                                  ('usc_manager_03', 'hashed_password_placeholder', NULL, '박동구', '010-4011-0003', 'usc_manager_03@meowCoffee.com', 'MAN-00-00048', '울산광역시 동구', '전하동', 'C:\\study\\meowcoffeeFile\\profiles\\usc_manager_03.jpg', 'MANAGER', 'APPROVAL', '2024-03-28');




-- 2-1-3. 거래처 (COMPANY) 데이터 (일부 샘플)
-- 스타벅스 (3명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
('sb_contact_01', 'hashed_password_placeholder', '스타벅스', '김스타', '010-5001-0001', 'sb_contact_01@starbucks.com', '120-81-03232', '서울특별시 중구 소공동', '본사 1팀', 'C:\\study\\meowcoffeeFile\\profiles\\sb_contact_01.jpg', 'COMPANY', 'APPROVAL', '2024-04-01'),
('sb_contact_02', 'hashed_password_placeholder', '스타벅스', '이벅스', '010-5001-0002', 'sb_contact_02@starbucks.com', '120-81-03232', '서울특별시 중구 소공동', '본사 2팀', 'C:\\study\\meowcoffeeFile\\profiles\\sb_contact_02.jpg', 'COMPANY', 'APPROVAL', '2024-04-02'),
('sb_contact_03', 'hashed_password_placeholder', '스타벅스', '박별다', '010-5001-0003', 'sb_contact_03@starbucks.com', '120-81-03232', '서울특별시 강남구', '강남지점', 'C:\\study\\meowcoffeeFile\\profiles\\sb_contact_03.jpg', 'COMPANY', 'APPROVAL', NULL);
-- 투썸플레이스 (3명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate) VALUES
('tw_contact_01', 'hashed_password_placeholder', '투썸플레이스', '김투썸', '010-6001-0001', 'tw_contact_01@twosomeplace.com', '214-87-77981', '서울특별시 중구 을지로', '본사 구매팀', 'C:\\study\\meowcoffeeFile\\profiles\\tw_contact_01.jpg', 'COMPANY', 'APPROVAL', '2024-05-01'),                                                                                                                                                                               ('tw_contact_02', 'hashed_password_placeholder', '투썸플레이스', '이플레이', '010-6001-0002', 'tw_contact_02@twosomeplace.com', '214-87-77981', '서울특별시 중구 을지로', '본사 운영팀', 'C:\\study\\meowcoffeeFile\\profiles\\tw_contact_02.jpg', 'COMPANY', 'APPROVAL', '2024-05-02'),
('tw_contact_03', 'hashed_password_placeholder', '투썸플레이스', '박케익', '010-6001-0003', 'tw_contact_03@twosomeplace.com', '214-87-77981', '경기도 성남시 분당구', '분당지점', 'C:\\study\\meowcoffeeFile\\profiles\\tw_contact_03.jpg', 'COMPANY', 'APPROVAL', NULL);

-- 2-1-4. 배송기사 (DELIVERYMAN) 데이터 (10명, 제공된 차량 할당)
-- 스타벅스 배송기사 (4명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate, vehicleId) VALUES
           ('sb_driver_01', 'hashed_password_placeholder', '스타벅스', '배송일', '010-7001-0001', 'sb_driver_01@starbucks.com', '120-81-03232', '경기도 광주시', '차고지 A', 'C:\\study\\meowcoffeeFile\\profiles\\sb_driver_01.jpg', 'DELIVERYMAN', 'APPROVAL', '2024-06-01', '88러1234'),
           ('sb_driver_02', 'hashed_password_placeholder', '스타벅스', '배송이', '010-7001-0002', 'sb_driver_02@starbucks.com', '120-81-03232', '경기도 이천시', '차고지 B', 'C:\\study\\meowcoffeeFile\\profiles\\sb_driver_02.jpg', 'DELIVERYMAN', 'APPROVAL', '2024-06-02', '71하5678'),
           ('sb_driver_03', 'hashed_password_placeholder', '스타벅스', '배송삼', '010-7001-0003', 'sb_driver_03@starbucks.com', '120-81-03232', '인천광역시 서구', '차고지 C', 'C:\\study\\meowcoffeeFile\\profiles\\sb_driver_03.jpg', 'DELIVERYMAN', 'APPROVAL', '2024-06-03', '62호9012'),
           ('sb_driver_04', 'hashed_password_placeholder', '스타벅스', '배송사', '010-7001-0004', 'sb_driver_04@starbucks.com', '120-81-03232', '부산광역시 강서구', '차고지 D', 'C:\\study\\meowcoffeeFile\\profiles\\sb_driver_04.jpg', 'DELIVERYMAN', 'APPROVAL', '2024-06-04', '53모3456');

-- 투썸플레이스 배송기사 (4명)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userImgPath, userRole, userStatus, userJoinDate, vehicleId) VALUES
           ('tw_driver_01', 'hashed_password_placeholder', '투썸플레이스', '나기사', '010-8001-0001', 'tw_driver_01@twosomeplace.com', '214-87-77981', '대전광역시 대덕구', '주차장 1', 'C:\\study\\meowcoffeeFile\\profiles\\tw_driver_01.jpg', 'DELIVERYMAN', 'APPROVAL', '2024-07-01', '35누1122'),
           ('tw_driver_02', 'hashed_password_placeholder', '투썸플레이스', '하기사', '010-8001-0002', 'tw_driver_02@twosomeplace.com', '214-87-77981', '광주광역시 북구', '주차장 2', 'C:\\study\\meowcoffeeFile\\profiles\\tw_driver_02.jpg', 'DELIVERYMAN', 'APPROVAL', '2024-07-02', '26바3344'),
           ('tw_driver_03', 'hashed_password_placeholder', '투썸플레이스', '송기사', '010-8001-0003', 'tw_driver_03@twosomeplace.com', '214-87-77981', '울산광역시 남구', '주차장 3', 'C:\\study\\meowcoffeeFile\\profiles\\tw_driver_03.jpg', 'DELIVERYMAN', 'APPROVAL', '2024-07-03', '17사5566'),
           ('tw_driver_04', 'hashed_password_placeholder', '투썸플레이스', '오기사', '010-8001-0004', 'tw_driver_04@twosomeplace.com', '214-87-77981', '세종특별자치시', '주차장 4', 'C:\\study\\meowcoffeeFile\\profiles\\tw_driver_04.jpg', 'DELIVERYMAN', 'APPROVAL', '2024-07-04', '08아7788');

-- 2-2. 일별 창고별 수용량 테이블

DROP TABLE IF EXISTS daily_warehouse_capacity;
CREATE TABLE daily_warehouse_capacity (
dateId              DATE    NOT NULL, -- 매출이 발생한 2024년 12월부터 미래 예상되는 2026년 2월까지
whId                BIGINT  NOT NULL, -- 창고 ID 외래키
used_storage_capacity   INT     NULL, -- PLT 단위로 창고 테이블에서 넣은 값 기준으로 랜덤
available_storage_capacity INT  NULL, -- PLT 단위로 창고 테이블의 총 용량에서 사용량 제외량
max_processing_capacity   INT     NULL, -- 일별 최대 처리 부하로, PLT 단위로 하며 메인 창고, 서브 창고의 총 용량에 따라 비례하게 설정
used_processing_capacity  INT     NULL, -- 일별 예정 혹은 사용된 처리 부하
staff_available     INT     NULL, -- 창고별 최대 사용 가능 인력(명) 단위로, 창고 수용량에 따라 비례하게 설정
staff_assigned      INT     NULL, -- 일별 예정 혹은 사용된 인력 명
equip_available     INT     NULL, -- 일별 최대 지게차의 수이며 단위는 1대, 창고 수용량에 비례하게 설정
equip_assigned      INT     NULL, -- 일별 예정 혹은 사용된 지게차 대수
    -- 제약조건
PRIMARY KEY (dateId, whId),
FOREIGN KEY (whId) REFERENCES warehouse(whId)
);

-- 테이블이 이미 있다면 기존 데이터 삭제
TRUNCATE TABLE daily_warehouse_capacity;

-- 샘플 데이터 INSERT (수정된 규칙 적용)
-- ==========================================================
-- 창고 정보: 부산 메인 (whId=1, 총 용량 2720 PLT, 최대 처리량 680 PLT)
-- 규칙: 가용인력(680/25=28명), 가용장비(680/100=7대)
-- ==========================================================
INSERT INTO daily_warehouse_capacity VALUES
('2024-12-01', 1, 2045, 675, 680, 450, 28, 22, 7, 5),
('2024-12-02', 1, 2110, 610, 680, 580, 28, 26, 7, 6),
('2024-12-03', 1, 2080, 640, 680, 490, 28, 23, 7, 6),
('2024-12-04', 1, 2150, 570, 680, 610, 28, 27, 7, 7);

-- ==========================================================
-- 창고 정보: 강서 콘솔 (whId=4, 총 용량 680 PLT, 최대 처리량 204 PLT)
-- 규칙: 가용인력(204/25=9명), 가용장비(204/100=3대)
-- ==========================================================
INSERT INTO daily_warehouse_capacity VALUES
('2024-12-01', 4, 370, 310, 204, 130, 9, 6, 3, 2),
('2024-12-02', 4, 395, 285, 204, 180, 9, 8, 3, 3),
('2024-12-03', 4, 380, 300, 204, 155, 9, 7, 3, 2),
('2024-12-04', 4, 410, 270, 204, 190, 9, 9, 3, 3);

-- 기존 프로시저가 있다면 삭제
DROP PROCEDURE IF EXISTS GenerateDailyCapacityData;

-- 프로시저 생성 Delimiter 변경
DELIMITER $$

CREATE PROCEDURE GenerateDailyCapacityData()
BEGIN
    -- =============================================================
    -- [수정] 모든 변수를 프로시저 최상단에 선언
    -- =============================================================
    -- 루프 제어용 변수
    DECLARE currentDate DATE;
    DECLARE endDate DATE;
    DECLARE done INT DEFAULT FALSE;

    -- 커서(Cursor)에서 읽어올 창고 정보 변수
    DECLARE wh_id_cursor BIGINT;
    DECLARE wh_total_capa_cursor INT;
    DECLARE wh_grade_cursor CHAR(5);

    -- 루프 내에서 계산에 사용할 변수
    DECLARE v_used_storage INT;
    DECLARE v_max_processing INT;
    DECLARE v_used_processing INT;
    DECLARE v_staff_avail INT;
    DECLARE v_staff_assign INT;
    DECLARE v_equip_avail INT;
    DECLARE v_equip_assign INT;

    -- 모든 창고 정보를 가져오는 커서(Cursor) 선언
    DECLARE warehouse_cursor CURSOR FOR SELECT whId, whTotalCapa, whGrade FROM warehouse;
    -- 커서의 마지막 행에 도달했을 때 done 변수를 TRUE로 설정
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- 날짜 범위 설정
    SET currentDate = '2024-12-01';
    SET endDate = '2026-02-28';

    -- 기존 데이터 삭제 (중복 실행 방지)
    TRUNCATE TABLE daily_warehouse_capacity;

    -- 커서 열기
    OPEN warehouse_cursor;

    -- 루프 시작: 모든 창고를 순회
    warehouse_loop: LOOP
        FETCH warehouse_cursor INTO wh_id_cursor, wh_total_capa_cursor, wh_grade_cursor;
        IF done THEN
            LEAVE warehouse_loop;
        END IF;

        -- 내부 루프 시작: 설정된 기간의 모든 날짜를 순회
        SET currentDate = '2024-12-01'; -- 창고가 바뀔 때마다 날짜를 초기화
        WHILE currentDate <= endDate DO

                -- 1. 창고 등급(Main/Sub)에 따른 최대 처리량 설정
                IF wh_grade_cursor = 'Main' THEN
                    SET v_max_processing = FLOOR(wh_total_capa_cursor * 0.25);
                ELSE
                    SET v_max_processing = FLOOR(wh_total_capa_cursor * 0.30);
                END IF;

                -- 2. 일일 최대 처리량을 기준으로 가용 인력/장비 계산
                SET v_staff_avail = CEIL(v_max_processing / 25.0);
                SET v_equip_avail = CEIL(v_max_processing / 100.0);

                -- 3. 랜덤 값 생성 (통상적인 부하 고려)
                SET v_used_storage = FLOOR(wh_total_capa_cursor * (0.3 + RAND() * 0.65));
                SET v_used_processing = FLOOR(v_max_processing * (0.4 + RAND() * 0.6));
                SET v_staff_assign = FLOOR(v_staff_avail * (0.5 + RAND() * 0.5));
                SET v_equip_assign = FLOOR(v_equip_avail * (0.5 + RAND() * 0.5));

                -- 주말 부하 감소 로직
                IF DAYOFWEEK(currentDate) IN (1, 7) THEN
                    SET v_used_processing = FLOOR(v_used_processing * 0.5);
                    SET v_staff_assign = CEIL(v_staff_assign * 0.6);
                    SET v_equip_assign = CEIL(v_equip_assign * 0.6);
                END IF;

                -- 최소값 보정 (0이 되지 않도록)
                IF v_staff_assign = 0 THEN SET v_staff_assign = 1; END IF;
                IF v_equip_assign = 0 THEN SET v_equip_assign = 1; END IF;

                -- 4. 데이터 INSERT
                INSERT INTO daily_warehouse_capacity (
                    dateId, whId, used_storage_capacity, available_storage_capacity,
                    max_processing_capacity, used_processing_capacity,
                    staff_available, staff_assigned, equip_available, equip_assigned
                ) VALUES (
                             currentDate, wh_id_cursor, v_used_storage, (wh_total_capa_cursor - v_used_storage),
                             v_max_processing, v_used_processing, v_staff_avail, v_staff_assign,
                             v_equip_avail, v_equip_assign
                         );

                -- 날짜 하루 증가
                SET currentDate = DATE_ADD(currentDate, INTERVAL 1 DAY);
            END WHILE;
    END LOOP;

    -- 커서 닫기
    CLOSE warehouse_cursor;
END$$

-- Delimiter 원복
DELIMITER ;

-- 프로시저 호출 (데이터 생성 실행)
CALL GenerateDailyCapacityData();


-- 2-3 보관위치지정 (locations) 테이블 생성
DROP TABLE IF EXISTS locations;
CREATE TABLE locations (
locationId CHAR(50) PRIMARY KEY, -- ex. lpId+00000...1 선입선출을 위해 1씩 증가되게
whId BIGINT NOT NULL,
lpId CHAR(40) NOT NULL,
CONSTRAINT fk_locations_warehouse FOREIGN KEY (whId) REFERENCES warehouse(whId),
CONSTRAINT fk_locations_location_places FOREIGN KEY (lpId) REFERENCES location_places(lpId)
);

-- 자동 데이터 생성 쿼리 (각 lpId 당 5개의 하위 로케이션 생성)
INSERT INTO locations (locationId, whId, lpId)
SELECT
    -- lpId에 5자리 순번을 붙여 새로운 locationId 생성
    -- 예: 'BU-BS-ST-NO.2' + '-00001' => 'BU-BS-ST-NO.2-00001'
    CONCAT(lp.lpId, '-', LPAD(seq.num, 5, '0')) AS locationId,
    w.whId,
    lp.lpId
FROM
    warehouse AS w
-- lpId의 창고 코드 부분과 whCode를 기준으로 JOIN
        JOIN
    location_places AS lp ON SUBSTRING_INDEX(lp.lpId, '-', 1) = w.whCode
-- 각 조합에 대해 1~5까지의 숫자를 생성하는 서브쿼리와 CROSS JOIN
        CROSS JOIN
    (SELECT 1 AS num UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5) AS seq
ORDER BY
    w.whId, lp.lpId, seq.num;


-- 2-4 재고 테이블
-- 재고 (stock) 테이블 생성
DROP TABLE IF EXISTS stock;
CREATE TABLE stock (
stkId CHAR(20) PRIMARY KEY, -- 'stk' + YYYYMMDD + 5자리 순번 (예: stk2025111300001)
lpId CHAR(40) NOT NULL,
cfId CHAR(20) NOT NULL,
stkQuantity INT NOT NULL,

CONSTRAINT fk_stock_location_places FOREIGN KEY (lpId) REFERENCES location_places(lpId),
CONSTRAINT fk_stock_coffee FOREIGN KEY (cfId) REFERENCES coffee(cfId)
);

-- ====================================================================
-- [수정된 자동 생성 쿼리] 1000개의 재고 샘플 데이터 생성 (중복 허용)
-- ====================================================================
INSERT INTO stock (stkId, lpId, cfId, stkQuantity)
WITH ValidPairs AS (
    -- 1. 먼저 DB에 존재하는 유효한 (lpId, cfId) 조합을 모두 찾습니다.
    SELECT
        lp.lpId,
        cf.cfId
    FROM
        location_places lp
            JOIN
        coffee cf ON
            SUBSTRING_INDEX(SUBSTRING_INDEX(lp.lpId, '-', 3), '-', -1) = SUBSTRING_INDEX(cf.cfId, '-', 1)
                AND
            SUBSTRING_INDEX(SUBSTRING_INDEX(lp.lpId, '-', 2), '-', -1) = SUBSTRING_INDEX(SUBSTRING_INDEX(cf.cfId, '-', 3), '-', -1)
                AND
            SUBSTRING_INDEX(lp.lpId, '-', -1) = SUBSTRING_INDEX(cf.cfId, '-', -1)
    ORDER BY RAND()
    LIMIT 250 -- 250개의 기본 조합을 무작위로 선택
),
     Sequence AS (
         -- 2. 데이터를 복제하기 위한 숫자 시퀀스를 만듭니다. (1~4까지, 즉 4번 복제)
         SELECT 1 AS num UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
     )
SELECT
    -- 3. 최종 데이터 생성
    CONCAT(
            'stk',
            DATE_FORMAT(DATE_SUB(NOW(), INTERVAL FLOOR(RAND() * 365) DAY), '%Y%m%d'),
            LPAD(ROW_NUMBER() OVER (ORDER BY vp.lpId, s.num), 5, '0') -- ROW_NUMBER()를 이용해 항상 고유한 순번 보장
    ) AS stkId,
    vp.lpId,
    vp.cfId,
    FLOOR(20 + RAND() * 100) AS stkQuantity -- 수량은 20~120 사이로 조절
FROM
    ValidPairs vp
        CROSS JOIN
    Sequence s; -- 찾은 조합(250개)과 숫자 시퀀스(4개)를 CROSS JOIN하여 250 * 4 = 1000개의 행을 만듦


-- 2-5 보관 비용 테이블 생성문
CREATE TABLE storageCost
(
    storeCostId BIGINT AUTO_INCREMENT PRIMARY KEY,
    storeAmt    DECIMAL(15, 2) NOT NULL,
    ddId        bigint         NOT NULL
);


-- 2-6 실사 테이블
CREATE TABLE due_diligence (
ddId BIGINT AUTO_INCREMENT PRIMARY KEY,
stkId CHAR(20) NOT NULL,
ddDate DATETIME NOT NULL default now(), -- 창고 샘플 데이터 안에 있는 날짜와 시간으로
ddApproval CHAR(10) NOT NULL DEFAULT 'PENDING', -- 'PENDING', 'APPROVED', 'REJECTED' 중에 하나
ddStatus CHAR(10) NOT NULL, -- 'CORRECT', 'INCORRECT' 중 하나
isDelete TINYINT DEFAULT 0, -- 0 과 1중 하나
ddUpdateDate DATETIME NULL, -- ddDate 에 넣을 데이터보다는 조금 뒤에 임의로 지정
maid VARCHAR(30) NOT NULL, -- 총 관리자는 아니고 User Role 이 MANAGER 인 창고관리자의 id로만 만들어줘
ddLog VARCHAR(255) NULL,   -- 관리자 메모 내용으로
realStkQuantity INT NOT NULL, -- 재고 테이블의 수량 기준으로 조금 많거나 적게 임의로
CONSTRAINT fk_due_diligence_stock FOREIGN KEY (stkId) REFERENCES stock(stkId)
);

-- ====================================================================
-- [자동 생성 쿼리] 존재하는 데이터를 기반으로 재고 실사 샘플 데이터 50개 생성
-- ====================================================================
INSERT INTO due_diligence (stkId, ddDate, ddApproval, ddStatus, isDelete, ddUpdateDate, maid, ddLog, realStkQuantity)
WITH BaseData AS (
    -- 1. 실사 대상 재고(stock) 50개를 무작위로 선정하고,
    --    해당 재고가 위치한 창고의 관리자(MANAGER) 중 한 명을 임의로 배정합니다.
    SELECT
        s.stkId,
        s.stkQuantity,
        -- 서브쿼리를 사용하여, 해당 재고(s.lpId)가 속한 창고(w.whCode)의
        -- 관리자(u.userId) 중 한 명을 무작위로 선택합니다.
        (SELECT u.userId
         FROM users u
                  JOIN warehouse w ON SUBSTRING_INDEX(u.userId, '_', 1) = LOWER(w.whCode)
         WHERE u.userRole = 'MANAGER'
           AND w.whCode = SUBSTRING_INDEX(s.lpId, '-', 1) -- 재고 위치의 창고 코드와 일치하는
         ORDER BY RAND()
         LIMIT 1) AS managerId
    FROM
        stock s
    ORDER BY
        RAND()
    LIMIT 1000
),
     AuditLogic AS (
         -- 2. 선정된 재고에 대해 실사 로직(수량, 상태, 날짜 등)을 적용합니다.
         SELECT
             bd.stkId,
             bd.stkQuantity,
             bd.managerId,
             -- realStkQuantity: 80% 확률로 전산 수량과 일치, 20% 확률로 불일치 (± 1~5개 차이)
             IF(RAND() < 0.8, bd.stkQuantity, bd.stkQuantity + (FLOOR(1 + RAND() * 5) * IF(RAND() > 0.5, 1, -1))) AS calculatedRealStk,
             -- ddApproval: 70%는 승인, 20%는 보류, 10%는 반려
             CASE
                 WHEN RAND() < 0.7 THEN 'APPROVED'
                 WHEN RAND() < 0.9 THEN 'PENDING'
                 ELSE 'REJECTED'
                 END AS approvalStatus,
             -- ddDate: 최근 30일 이내의 임의 날짜와 시간으로 실사 일자 생성
             TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 30) DAY), MAKETIME(FLOOR(RAND() * 24), FLOOR(RAND() * 60), FLOOR(RAND() * 60))) AS auditDate
         FROM
             BaseData bd
         -- 담당 관리자가 배정되지 않은 경우(예: 해당 창고에 관리자가 없는 경우)는 제외
         WHERE bd.managerId IS NOT NULL
     )
-- 3. 최종적으로 계산된 값들을 조합하여 INSERT할 데이터를 완성합니다.
SELECT
    al.stkId,
    al.auditDate AS ddDate,
    al.approvalStatus AS ddApproval,
    -- ddStatus: 전산 수량과 실사 수량이 같으면 'CORRECT', 다르면 'INCORRECT'
    IF(al.stkQuantity = al.calculatedRealStk, 'CORRECT', 'INCORRECT') AS ddStatus,
    -- isDelete: 2% 확률로 삭제(1) 처리
    IF(RAND() < 0.02, 1, 0) AS isDelete,
    -- ddUpdateDate: 승인 상태가 'PENDING'이 아니면, 실사일로부터 1~48시간 후의 임의 시간으로 업데이트 날짜 설정
    IF(al.approvalStatus != 'PENDING', TIMESTAMPADD(HOUR, FLOOR(1 + RAND() * 48), al.auditDate), NULL) AS ddUpdateDate,
    al.managerId AS maid,
    -- ddLog: 상태에 따라 적절한 관리자 메모 생성
    CASE
        WHEN al.stkQuantity = al.calculatedRealStk THEN '전산 재고와 실사 재고 수량 일치 확인 완료.'
        WHEN al.approvalStatus = 'REJECTED' THEN '실사 반려: 재실사 필요. 사유 확인 요망.'
        ELSE CONCAT('수량 불일치 보고. 전산: ', al.stkQuantity, ', 실사: ', al.calculatedRealStk, '. 차이: ', al.calculatedRealStk - al.stkQuantity)
        END AS ddLog,
    al.calculatedRealStk AS realStkQuantity
FROM
    AuditLogic al;


-- 2-7 입고 요청 테이블

DROP TABLE if exists inboundRequests;

CREATE TABLE inboundRequests (
inReqId	bigint AUTO_INCREMENT PRIMARY KEY ,
comId	varchar(30)	NOT NULL, -- 회원 테이블의 거래처의 userId
managerId	varchar(30)	NULL, -- 회원 테이블의 ADMIN 이나 MANAGER 의 userId
inDttmReq	datetime	NOT NULL, -- 회원의 입고 요청 시간
inDateWish	date	NULL,         -- 회원의 입고 희망 날짜
inDttmAppr	datetime	NULL,     -- 관리자의 최종 승인 날짜
IsDelete	tinyint	NULL,         -- 요청 취소 여부 0 혹은 1
IsTempo	tinyint	NULL              -- 승인대기 상태일 때 임시 저장 여부
);

ALTER TABLE inboundRequests ADD CONSTRAINT FK_users_TO_inboundRequests_1 FOREIGN KEY (comId)
    REFERENCES users (userId);

ALTER TABLE `inboundRequests` ADD CONSTRAINT `FK_users_TO_inboundRequests_2` FOREIGN KEY (managerId)
    REFERENCES users (userId);

-- ====================================================================
-- [자동 생성 쿼리] 존재하는 데이터를 기반으로 입고 요청 샘플 데이터 40개 생성
-- ====================================================================
select count(*) from inboundRequests;
INSERT INTO inboundRequests (comId, managerId, inDttmReq, inDateWish, inDttmAppr, IsDelete, IsTempo)
WITH BaseData AS (
    -- 1. 'COMPANY' 역할의 사용자 40명을 무작위로 선택하여 기본 요청 데이터를 생성합니다.
    SELECT
        u.userId AS requestingCompany,
        -- 최근 30일 이내의 임의의 시간으로 '입고 요청 시간' 생성
        TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 365) DAY), MAKETIME(FLOOR(RAND() * 24), FLOOR(RAND() * 60), FLOOR(RAND() * 60))) AS requestTime,
        -- 요청의 상태를 결정할 랜덤 플래그 생성
        RAND() AS approvalChance, -- 승인 여부 결정용
        RAND() AS deleteChance,   -- 삭제 여부 결정용
        RAND() AS tempoChance     -- 임시 저장 여부 결정용
    FROM
        users u
    WHERE
        u.userRole = 'COMPANY'
    ORDER BY
        RAND()
    LIMIT 1000
),
     ProcessedRequests AS (
         -- 2. 기본 데이터를 가공하여 최종 삽입할 데이터를 완성합니다.
         SELECT
             bd.requestingCompany AS comId,
             bd.requestTime AS inDttmReq,
             -- '입고 희망 날짜'는 요청일로부터 1~7일 후로 설정
             DATE_ADD(DATE(bd.requestTime), INTERVAL FLOOR(1 + RAND() * 14) DAY) AS inDateWish,
             -- 70% 확률로 요청을 '승인' 처리하고, 임의의 관리자를 배정
             CASE
                 WHEN bd.approvalChance < 0.7 THEN (SELECT userId FROM users WHERE userRole IN ('ADMIN', 'MANAGER') ORDER BY RAND() LIMIT 1)
                 ELSE NULL
                 END AS managerId,
             -- '승인'된 경우, 요청 시간으로부터 8~56시간 후를 '관리자 최종 승인 날짜'로 설정
             CASE
                 WHEN bd.approvalChance < 0.7 THEN TIMESTAMPADD(HOUR, FLOOR(8 + RAND() * 48), bd.requestTime)
                 ELSE NULL
                 END AS inDttmAppr,
             -- 10% 확률로 '요청 취소'(IsDelete=1) 처리
             IF(bd.deleteChance < 0.1, 1, 0) AS IsDelete,
             -- '승인 대기' 상태인 요청 중 30%를 '임시 저장'(IsTempo=1) 상태로 설정
             IF(bd.approvalChance >= 0.7 AND bd.tempoChance < 0.3, 1, 0) AS IsTempo
         FROM
             BaseData bd
     )
-- 3. 최종 가공된 데이터를 테이블에 삽입합니다.
SELECT
    pr.comId,
    pr.managerId,
    pr.inDttmReq,
    pr.inDateWish,
    pr.inDttmAppr,
    pr.IsDelete,
    pr.IsTempo
FROM
    ProcessedRequests pr;



-- 2-8 입고 상세 테이블
DROP TABLE if exists inboundItems;
CREATE TABLE inboundItems (
inReqItemsId	bigint AUTO_INCREMENT PRIMARY KEY ,
inReqId	bigint	NOT NULL,
cfId	char(20)	NOT NULL, -- 커피 id 외래키
locationId	char(50)	NULL, -- 보관위치지정 id 외래키
status	ENUM('승인대기', '승인완료', '입고완료', '반려')	NOT NULL,
inQtyReq	integer	NULL, -- 1 ~ 100 에서 임의 지정
inOrderAddr	varchar(255)	NULL, -- 없어도 됨 null로 두기
inQty	integer	NULL,    -- inQty 보다는 작아야 되고, 승인 대기 상태는 0, 승인 완료 상태는 0 이상, 입고 완료 상태의 경우는 inQty와 수량 일치
inDttmSchd	datetime	NULL, -- 관리자가 지정한 입고 예정 일자 및 시간으로 입고 요청 테이블의 회원의 입고 요청 시간 보다 뒤여야 함.
inDttmInsp	datetime	NULL, -- 검수자가 입력한 입고 상세 품목의 검수 시간으로 입고 예정일자 및 시간과 비슷하게 설정
inDttmRecv	datetime	NULL  -- 검수가 끝나고 최종 입고 완료된 시간으로 검수 시간보다 무조건 늦어야 함.
);
ALTER TABLE inboundItems MODIFY status ENUM('승인대기', '승인완료', '입고완료', '반려');
ALTER TABLE inboundItems ADD CONSTRAINT FOREIGN KEY (inReqId) REFERENCES inboundRequests (inReqId);
ALTER TABLE inboundItems ADD CONSTRAINT FOREIGN KEY (cfId) REFERENCES coffee(CFID);
ALTER TABLE inboundItems ADD CONSTRAINT FK_locations_TO_inboundItems_1 FOREIGN KEY (locationId) REFERENCES locations (locationId);
ALTER TABLE inboundItems ADD adminMemo VARCHAR(500); -- 관리자 메모 데이터로 관리자는 승인, 반려를 할 수 있고, 그에 따라 구체적인 의견을 추가할 수 있음.

-- ====================================================================
-- [자동 생성 쿼리] 입고 상세 테이블 샘플 데이터 생성
-- ====================================================================
INSERT INTO inboundItems (inReqId, cfId, locationId, status, inQtyReq, inOrderAddr, inQty, inDttmSchd, inDttmInsp, inDttmRecv, adminMemo)
WITH BaseData AS (
    -- 1. 입고 요청(inboundRequests) 40개를 무작위로 선택하고,
    --    각 요청에 대해 임의의 커피(coffee) 품목을 할당합니다.
    SELECT
        ir.inReqId,
        cf.cfId,
        -- 상태를 결정할 랜덤 값 생성
        RAND() AS statusRandomValue
    FROM
        inboundRequests ir
            CROSS JOIN (SELECT cfId FROM coffee ORDER BY RAND() LIMIT 5) AS cf -- 각 요청 당 최대 5개의 품목
    ORDER BY ir.inReqId, RAND()
    LIMIT 1000
),
     EnrichedData AS (
         -- 2. 기본 데이터에 상세 정보를 추가합니다.
         SELECT
             bd.inReqId,
             bd.cfId,
             -- 1~100 사이의 임의의 요청 수량 할당
             FLOOR(1 + RAND() * 100) AS inQtyReq,
             -- 배송 주소는 임의로 생성하거나 NULL로 둘 수 있습니다.
             IF(RAND() < 0.7, CONCAT('샘플 주소 ', FLOOR(1 + RAND() * 10)), NULL) AS inOrderAddr,
             -- 4가지 상태 중 하나를 무작위로 할당
             CASE
                 WHEN bd.statusRandomValue < 0.1 THEN '반려'
                 WHEN bd.statusRandomValue < 0.4 THEN '입고완료'
                 WHEN bd.statusRandomValue < 0.7 THEN '승인완료'
                 ELSE '승인대기'
                 END AS status,
             bd.statusRandomValue
         FROM
             BaseData bd
     ),
     RelatedData AS (
         -- 3. 상태, 수량, 시간 관련 값들을 설정합니다.
         SELECT
             ed.inReqId,
             ed.cfId,
             ed.inQtyReq,
             ed.inOrderAddr,
             ed.status,
             -- (서브쿼리) lpId와 cfId 속성이 일치하는 locationId를 찾습니다.
             (SELECT l.locationId
              FROM locations l
              WHERE
                -- locationId가 존재해야 함
                  l.lpId LIKE CONCAT('%', SUBSTRING_INDEX(ed.cfId, '-', 1), '%') AND l.lpId LIKE CONCAT('%', SUBSTRING_INDEX(ed.cfId, '-', 3), '%') AND l.lpId LIKE CONCAT('%', SUBSTRING_INDEX(ed.cfId, '-', -1), '%')
              ORDER BY RAND() LIMIT 1) AS locationId,
             -- 상태별로 inQty 값을 다르게 설정
             CASE
                 WHEN ed.status = '승인대기' THEN 0
                 WHEN ed.status = '반려' THEN 0
                 ELSE FLOOR(1 + RAND() * ed.inQtyReq) -- 1 ~ inQtyReq 사이의 값
                 END AS inQty,
             -- 스케쥴 시간은 요청 시간보다 1~7일 뒤로 설정
             DATE_ADD((SELECT inDttmReq FROM inboundRequests WHERE inReqId = ed.inReqId), INTERVAL FLOOR(1 + RAND() * 7) DAY) AS inDttmSchd,
             ed.statusRandomValue
         FROM
             EnrichedData ed
     ),
     FinalData AS (
         -- 4. 시간 및 관리자 메모를 설정합니다.
         SELECT
             rd.inReqId,
             rd.cfId,
             rd.locationId,
             rd.status,
             rd.inQtyReq,
             rd.inOrderAddr,
             rd.inQty,
             rd.inDttmSchd,
             -- 검수 시간은 스케쥴 시간보다 0~24시간 뒤로 설정
             CASE WHEN rd.status IN ('입고완료', '반려') THEN DATE_ADD(rd.inDttmSchd, INTERVAL FLOOR(RAND() * 24) HOUR) ELSE NULL END AS inDttmInsp,
             -- 입고 완료 시간은 검수 시간보다 0~24시간 뒤로 설정
             CASE WHEN rd.status = '입고완료' THEN DATE_ADD(DATE_ADD(rd.inDttmSchd, INTERVAL FLOOR(RAND() * 24) HOUR), INTERVAL FLOOR(RAND() * 24) HOUR) ELSE NULL END AS inDttmRecv,
             -- 상태에 따라 관리자 메모를 설정
             CASE
                 WHEN rd.status = '승인완료' THEN '요청 확인 후 승인 처리 완료.'
                 WHEN rd.status = '반려' THEN '수량 부족으로 요청을 반려합니다.'
                 ELSE NULL
                 END AS adminMemo
         FROM RelatedData rd
     )
-- 5. 최종 결과를 삽입합니다.
SELECT
    fd.inReqId,
    fd.cfId,
    fd.locationId,
    fd.status,
    fd.inQtyReq,
    fd.inOrderAddr,
    fd.inQty,
    fd.inDttmSchd,
    fd.inDttmInsp,
    fd.inDttmRecv,
    fd.adminMemo
FROM
    FinalData fd;


-- 2-9 출고요청 테이블
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
);

-- 기본값/NOT NULL 설정
ALTER TABLE outboundrequest
    MODIFY IsDelete TINYINT NOT NULL DEFAULT 0,
    MODIFY IsTempo  TINYINT NOT NULL DEFAULT 0;


-- users 테이블에 대한 외래 키 제약조건 추가 (DDL에 없어서 추가하려 했으나 혹시 몰라 일단 배제; 박기웅)
-- ALTER TABLE outboundrequest ADD CONSTRAINT FK_users_TO_outboundrequest_1 FOREIGN KEY (comId) REFERENCES users (userId);
-- ALTER TABLE outboundrequest ADD CONSTRAINT FK_users_TO_outboundrequest_2 FOREIGN KEY (managerId) REFERENCES users (userId);


-- ====================================================================
-- [자동 생성 쿼리] 존재하는 데이터를 기반으로 출고 요청 샘플 데이터 40개 생성
-- ====================================================================
select count(*) from outboundrequest;
INSERT INTO outboundrequest (comId, managerId, outDttmReq, outDateWish, outDttmAppr, IsDelete, IsTempo)
WITH BaseData AS (
    -- 1. 'COMPANY' 역할의 사용자(거래처) 40명을 무작위로 선택하여 기본 요청 데이터를 생성합니다.
    SELECT
        u.userId AS requestingCompany,
        -- 최근 30일 이내의 임의의 시간으로 '출고 요청 시간' 생성
        TIMESTAMP(DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND() * 365) DAY), MAKETIME(FLOOR(RAND() * 24), FLOOR(RAND() * 60), FLOOR(RAND() * 60))) AS requestTime,
        -- 요청의 상태를 결정할 랜덤 플래그 생성
        RAND() AS approvalChance, -- 승인 여부 결정용
        RAND() AS deleteChance,   -- 삭제 여부 결정용
        RAND() AS tempoChance     -- 임시 저장 여부 결정용
    FROM
        users u
    WHERE
        u.userRole = 'COMPANY'
    ORDER BY
        RAND()
    LIMIT 1000
),
     ProcessedRequests AS (
         -- 2. 기본 데이터를 가공하여 최종 삽입할 데이터를 완성합니다.
         SELECT
             bd.requestingCompany AS comId,
             bd.requestTime AS outDttmReq,
             -- '출고 희망 날짜'는 요청일로부터 1~7일 후로 설정
             DATE_ADD(DATE(bd.requestTime), INTERVAL FLOOR(1 + RAND() * 7) DAY) AS outDateWish,
             -- 70% 확률로 요청을 '승인' 처리하고, 임의의 관리자를 배정
             CASE
                 WHEN bd.approvalChance < 0.7 THEN (SELECT userId FROM users WHERE userRole IN ('ADMIN', 'MANAGER') ORDER BY RAND() LIMIT 1)
                 ELSE NULL
                 END AS managerId,
             -- '승인'된 경우, 요청 시간으로부터 8~56시간 후를 '관리자 최종 승인 날짜'로 설정
             CASE
                 WHEN bd.approvalChance < 0.7 THEN TIMESTAMPADD(HOUR, FLOOR(8 + RAND() * 48), bd.requestTime)
                 ELSE NULL
                 END AS outDttmAppr,
             -- 10% 확률로 '요청 취소'(IsDelete=1) 처리
             IF(bd.deleteChance < 0.1, 1, 0) AS IsDelete,
             -- '승인 대기' 상태인 요청 중 30%를 '임시 저장'(IsTempo=1) 상태로 설정
             IF(bd.approvalChance >= 0.7 AND bd.tempoChance < 0.3, 1, 0) AS IsTempo
         FROM
             BaseData bd
     )
-- 3. 최종 가공된 데이터를 테이블에 삽입합니다.
SELECT
    pr.comId,
    pr.managerId,
    pr.outDttmReq,
    pr.outDateWish,
    pr.outDttmAppr,
    pr.IsDelete,
    pr.IsTempo
FROM
    ProcessedRequests pr;



-- 2-10 출고요청상세 테이블
DROP TABLE IF EXISTS outboundItems;
CREATE TABLE outboundItems (
outReqItemsId BIGINT AUTO_INCREMENT PRIMARY KEY,
outReqId      BIGINT       NOT NULL,   -- outboundrequest FK
stkId         CHAR(20)     NOT NULL,   -- stock ID
vehicleId     CHAR(10)     NULL,       -- vehicle ID
status        ENUM('승인대기', '승인완료', '출고완료', '반려') NOT NULL,
outQtyReq     INTEGER      NOT NULL,   -- 회원 출고 요청 수량 1~100 임의로
outOrderAddr  VARCHAR(255) NULL,       -- Null로 비워두자
outDttmSchd   DATETIME     NULL,       -- 관리자가 지정한 출고 예정 시각
outDttmInsp   DATETIME     NULL,       -- 관리자가 출고 승인 후 출고 물품을 검수한 시각
outDttmShip   DATETIME     NULL,       -- 최종 검수 후 물품이 출고가 완료된 시각
CONSTRAINT fk_outboundItems_outboundrequest FOREIGN KEY (outReqId) REFERENCES outboundrequest(outReqId)
);

-- 외래 키 제약조건 추가 (DDL에 누락된 부분 포함; 마찬가지로 일단 주석 처리)
# ALTER TABLE outboundItems ADD CONSTRAINT fk_outboundItems_outboundrequest FOREIGN KEY (outReqId) REFERENCES outboundrequest(outReqId);
# ALTER TABLE outboundItems ADD CONSTRAINT fk_outboundItems_stock FOREIGN KEY (stkId) REFERENCES stock(stkId);
# ALTER TABLE outboundItems ADD CONSTRAINT fk_outboundItems_vehicles FOREIGN KEY (vehicleId) REFERENCES vehicles(vehicleId);


-- ====================================================================
-- [자동 생성 쿼리] 존재하는 데이터를 기반으로 출고 상세 샘플 데이터 50개 생성
-- ====================================================================
INSERT INTO outboundItems (outReqId, stkId, vehicleId, status, outQtyReq, outOrderAddr, outDttmSchd, outDttmInsp, outDttmShip)
WITH BaseData AS (
    -- 1. 유효한 [출고 요청-재고] 쌍을 50개 무작위로 찾습니다.
    --    - 요청한 회사의 재고만 출고하도록 논리적 일관성을 맞춥니다.
    --    - 요청 수량이 실제 재고 수량을 초과하지 않도록 합니다.
    SELECT
        o.outReqId,
        s.stkId,
        o.outDttmReq,
        s.stkQuantity,
        u.userCompanyName
    FROM
        outboundrequest o
            JOIN
        users u ON o.comId = u.userId -- 요청한 회사의 정보를 가져오기 위해 JOIN
            JOIN
        stock s ON 1=1 -- 모든 재고와 일단 연결
            JOIN
        coffee cf ON s.cfId = cf.cfId -- 재고의 커피 정보를 가져오기 위해 JOIN
    WHERE
       -- [중요] 요청한 회사의 종류와 재고 커피의 종류가 일치하는 경우만 필터링
        (u.userCompanyName = '스타벅스' AND SUBSTRING_INDEX(cf.cfId, '-', 1) = 'ST')
       OR (u.userCompanyName = '투썸플레이스' AND SUBSTRING_INDEX(cf.cfId, '-', 1) = 'TW')
    ORDER BY
        RAND()
    LIMIT 1000
),
     ProcessedData AS (
         -- 2. 기본 데이터에 상태, 수량, 차량, 시간 등 상세 정보를 가공하여 추가합니다.
         SELECT
             bd.outReqId,
             bd.stkId,
             bd.outDttmReq,
             -- status: 4가지 상태를 임의로 분배
             CASE
                 WHEN RAND() < 0.35 THEN '출고완료'
                 WHEN RAND() < 0.70 THEN '승인완료'
                 WHEN RAND() < 0.90 THEN '승인대기'
                 ELSE '반려'
                 END AS `status`,
             -- outQtyReq: 1~100 사이의 값을 요청하되, 실제 재고(stkQuantity)를 초과하지 않도록 설정
             LEAST(FLOOR(1 + RAND() * 100), bd.stkQuantity) AS outQtyReq
         FROM
             BaseData bd
     )
-- 3. 최종적으로 계산된 값들을 조합하여 INSERT할 데이터를 완성합니다.
SELECT
    pd.outReqId,
    pd.stkId,
    -- vehicleId: '승인완료' 또는 '출고완료' 상태일 때만 임의의 차량을 배정
    CASE
        WHEN pd.status IN ('승인완료', '출고완료') THEN (SELECT vehicleId FROM vehicles ORDER BY RAND() LIMIT 1)
        ELSE NULL
        END AS vehicleId,
    pd.status,
    pd.outQtyReq,
    NULL AS outOrderAddr, -- 주석에 따라 NULL로 설정
    -- outDttmSchd: '승인대기'가 아닌 경우, 요청 시간으로부터 12~60시간 후를 출고 예정 시각으로 설정
    CASE
        WHEN pd.status != '승인대기' THEN TIMESTAMPADD(HOUR, FLOOR(12 + RAND() * 48), pd.outDttmReq)
        ELSE NULL
        END AS outDttmSchd,
    -- outDttmInsp: '출고완료'인 경우, 예정 시각으로부터 1~12시간 후를 검수 시각으로 설정
    CASE
        WHEN pd.status = '출고완료' THEN TIMESTAMPADD(HOUR, FLOOR(1 + RAND() * 12), TIMESTAMPADD(HOUR, FLOOR(12 + RAND() * 48), pd.outDttmReq))
        ELSE NULL
        END AS outDttmInsp,
    -- outDttmShip: '출고완료'인 경우, 검수 시각으로부터 1~6시간 후를 최종 출고 시각으로 설정
    CASE
        WHEN pd.status = '출고완료' THEN TIMESTAMPADD(HOUR, FLOOR(1 + RAND() * 6), TIMESTAMPADD(HOUR, FLOOR(1 + RAND() * 12), TIMESTAMPADD(HOUR, FLOOR(12 + RAND() * 48), pd.outDttmReq)))
        ELSE NULL
        END AS outDttmShip
FROM
    ProcessedData pd;

-- 2-11 지출 테이블 생성
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

-- 2-11 청구 테이블 생성
CREATE TABLE `invoice`
(
    `invoiceId`     BIGINT AUTO_INCREMENT PRIMARY KEY,
    `invoiceDt`     DATETIME                                     NOT NULL,
    `totalAmt`      DECIMAL(15, 2)                               NOT NULL,
    `invoiceStatus` ENUM ('draft', 'issued', 'paid', 'canceled') NOT NULL,
    `depositDt`     DATETIME                                     NULL,
    `userId`        varchar(30)                                  NOT NULL
);

-- 2-12 입고 비용 테이블 생성
CREATE TABLE `inboundCost`
(
    `inCostId`   BIGINT AUTO_INCREMENT PRIMARY KEY,
    `laborAmt`   DECIMAL(15, 2) NOT NULL,
    `inspectAmt` DECIMAL(15, 2) NOT NULL,
    `inReqId`    bigint         NOT NULL
);

-- 2-13 출고 비용 테이블 생성
CREATE TABLE `outboundCost`
(
    `outCostId`  BIGINT AUTO_INCREMENT PRIMARY KEY,
    `pickingAmt` DECIMAL(15, 2) NOT NULL,
    `packingAmt` DECIMAL(15, 2) NOT NULL,
    `laborAmt`   DECIMAL(15, 2) NOT NULL,
    `outReqId`   bigint         NOT NULL
);

-- 2-14 배송 비용 테이블 생성
CREATE TABLE `deliveryCost`
(
    `delCostId`    BIGINT AUTO_INCREMENT PRIMARY KEY,
    `transportAmt` DECIMAL(15, 2) NOT NULL,
    `outReqId`     bigint         NOT NULL
);

