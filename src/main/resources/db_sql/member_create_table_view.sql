use meowcoffeedb;

drop table if exists users;
CREATE TABLE users (
     userId	varchar(30)	NOT NULL,
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
     vehicleId	char(10)	NULL
);


# 원본 테이블인 users를 먼저 생성해야 관리자 뷰를 생성할 수 있습니다.
# erdcloud에서 생성된 sql문의 create table managers ~ 대신 아래의 create view문을 사용
# 로그인/회원관리 기능 제외 WMS의 다른 기능이 창고관리자/총관리자를 조회할 때는 아래 뷰를 사용
drop view if exists managers;
create view managers(
                     managerId, managerName, managerPwd, managerCode,
                     managerPhone, managerEmail, managerHireDate, managerRole,
                     managerStatus, managerLastLogin, managerImgPath
    )
as select
       userId, userName, userPwd, userCode,
       userPhone, userEmail, userJoinDate, userRole,
       userStatus, userLastLogin, userImgPath
from users
where userStatus = 'APPROVAL' and userRole in ('MANAGER', 'ADMIN');



# 원본 테이블인 users를 먼저 생성해야 거래처 뷰를 정상적으로 생성할 수 있습니다.
# erdcloud의 sql문에서 create table companies ~ 대신 아래의 create view문을 사용
# 로그인/회원관리 기능을 제외한 WMS의 다른 기능이 거래처를 조회할 때는 아래의 뷰를 사용
drop table if exists companies;
create view companies(
                      comId, comName, comCeoName, comPwd, comPhone,
                      comEmail, comCode, comRoadAddr, comDetailAddr,
                      comStartDate, comExpiredDate, comStatus, comLastLogin, comImgPath
    )
as select
       userId, userCompanyName, userName, userPwd, userPhone,
       userEmail, userCode, userRoadAddr, userDetailAddr,
       userJoinDate, date_add(userJoinDate, interval 1 year), userStatus, userLastLogin, userImgPath
from users
where userStatus = 'APPROVAL' and userRole = 'COMPANY';



# 차량정보 테이블 및 더미데이터 추가
CREATE TABLE `vehicles` (
    vehicleId   char(10)   PRIMARY KEY ,
    vehicleModel    ENUM('5톤 윙바디', '1톤 탑차', '1.2톤 카고') NOT NULL,
    vehicleDesc varchar(255)   NULL
);

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



# 원본 테이블인 users와 vehicles를 먼저 생성하셔야 배송기사 뷰를 생성할 수 있습니다.
# erdcloud의 sql문에서 create table companies ~ 대신 아래의 create view문을 사용
# 로그인/회원관리 기능을 제외한 WMS의 다른 기능이 배송기사를 조회할 때는 아래의 뷰를 사용
create view deliverymen (
    delivId, delivName, delivPwd, delivPhone,
    delivCode, delivVhcId, delivVhcModel, delivLastLogin,
    delivImgPath
) as select
 u.userId, u.userName, u.userPwd, u.userPhone,
 u.userCode, v.vehicleId, v.vehicleModel, u.userLastLogin,
 u.userImgPath
from users u join vehicles v on u.vehicleId = v.vehicleId
where userStatus = 'APPROVAL' and userRole = 'DELIVERYMAN';



-- users 테이블 더미 데이터 (총 20개)
-- 모든 사용자는 userStatus = 'APPROVAL' 상태입니다. userStatus가 'APPROVAL이 아니면 뷰에서 조회되지 않습니다.
truncate table users;

-- 총관리자 (ADMIN) - 2명
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userJoinDate, userRole, userStatus, userLastLogin, userImgPath, vehicleId)
VALUES
    ('admin_master', 'hashed_password_placeholder', NULL, '총관리자', '010-1111-1111', 'master@wms.com', 'ADM-00-00001', '서울특별시 강남구 테헤란로 142', '10층 (역삼동)', '2023-01-01', 'ADMIN', 'APPROVAL', '2025-11-06', 'C:\\study\\meowcoffeeFile\\profiles\\profile_admin_master_ADM-00-00001.jpg', NULL),
    ('admin_sub', 'hashed_password_placeholder', NULL, '부관리자', '010-1111-2222', 'sub@wms.com', 'ADM-00-00002', '서울특별시 강남구 테헤란로 142', '9층 (역삼동)', '2023-02-15', 'ADMIN', 'APPROVAL', '2025-11-05', 'C:\\study\\meowcoffeeFile\\profiles\\profile_admin_sub_ADM-00-00002.png', NULL);

-- 창고관리자 (MANAGER) - 4명
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userJoinDate, userRole, userStatus, userLastLogin, userImgPath, vehicleId)
VALUES
    ('manager_kim', 'hashed_password_placeholder', NULL, '김창고', '010-2222-3333', 'manager.kim@wms.com', 'MAN-00-00001', '경기도 부천시 원미구', 'A동 1창고', '2023-03-01', 'MANAGER', 'APPROVAL', '2025-11-06', 'C:\\study\\meowcoffeeFile\\profiles\\profile_manager_kim_MAN-00-00001.jpg', NULL),
    ('manager_lee', 'hashed_password_placeholder', NULL, '이관리', '010-2222-4444', 'manager.lee@wms.com', 'MAN-00-00002', '경기도 이천시 마장면', 'B동 2창고', '2023-03-05', 'MANAGER', 'APPROVAL', '2025-11-04', 'C:\\study\\meowcoffeeFile\\profiles\\profile_manager_lee_MAN-00-00002.jpg', NULL),
    ('manager_park', 'hashed_password_placeholder', NULL, '박재고', '010-2222-5555', 'manager.park@wms.com', 'MAN-00-00003', '인천광역시 서구', 'C동 1창고', '2023-04-10', 'MANAGER', 'APPROVAL', '2025-11-06', 'C:\\study\\meowcoffeeFile\\profiles\\profile_manager_park_MAN-00-00003.png', NULL),
    ('manager_choi', 'hashed_password_placeholder', NULL, '최출고', '010-2222-6666', 'manager.choi@wms.com', 'MAN-00-00004', '경기도 용인시 처인구', 'D동 3창고', '2023-05-20', 'MANAGER', 'APPROVAL', '2025-11-03', 'C:\\study\\meowcoffeeFile\\profiles\\profile_manager_choi_MAN-00-00004.jpg', NULL);

-- 배송기사 (DELIVERYMAN) - 4명 (vehicleId 수정)
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userJoinDate, userRole, userStatus, userLastLogin, userImgPath, vehicleId)
VALUES
    ('delivery_park', 'hashed_password_placeholder', NULL, '박배송', '010-3333-1111', 'delivery.park@wms.com', '120-10-12345', '서울특별시 중구', '트럭 주차장', '2023-06-01', 'DELIVERYMAN', 'APPROVAL', '2025-11-06', 'C:\\study\\meowcoffeeFile\\profiles\\profile_delivery_park_120-10-12345.jpg', '55가1001'),
    ('delivery_oh', 'hashed_password_placeholder', NULL, '오신속', '010-3333-2222', 'delivery.oh@wms.com', '130-20-67890', '경기도 고양시 일산서구', '대화동', '2023-06-15', 'DELIVERYMAN', 'APPROVAL', '2025-11-06', 'C:\\study\\meowcoffeeFile\\profiles\\profile_delivery_oh_130-20-67890.png', '55나2002'),
    ('delivery_yoon', 'hashed_password_placeholder', NULL, '윤안전', '010-3333-3333', 'delivery.yoon@wms.com', '140-30-54321', '인천광역시 연수구', '송도동', '2023-07-01', 'DELIVERYMAN', 'APPROVAL', '2025-11-05', 'C:\\study\\meowcoffeeFile\\profiles\\profile_delivery_yoon_140-30-54321.jpg', '55다3003'),
    ('delivery_song', 'hashed_password_placeholder', NULL, '송정확', '010-3333-4444', 'delivery.song@wms.com', '150-40-11111', '경기도 수원시 장안구', '조원동', '2023-07-20', 'DELIVERYMAN', 'APPROVAL', '2025-11-06', 'C:\\study\\meowcoffeeFile\\profiles\\profile_delivery_song_150-40-11111.jpg', '55라4004');

-- 거래처 (COMPANY) - 10명
INSERT INTO users (userId, userPwd, userCompanyName, userName, userPhone, userEmail, userCode, userRoadAddr, userDetailAddr, userJoinDate, userRole, userStatus, userLastLogin, userImgPath, vehicleId)
VALUES
    ('company_good', 'hashed_password_placeholder', '(주)좋은상사', '이대표', '010-4444-1111', 'ceo@good.com', '210-81-12345', '서울특별시 영등포구', '101호', '2023-08-01', 'COMPANY', 'APPROVAL', '2025-11-01', 'C:\\study\\meowcoffeeFile\\profiles\\profile_company_good_210-81-12345.png', NULL),
    ('company_bean', 'hashed_password_placeholder', '커피빈코리아', '박원두', '010-4444-2222', 'master@coffeebean.com', '220-82-67890', '서울특별시 종로구', '본사 5층', '2023-08-10', 'COMPANY', 'APPROVAL', '2025-10-30', 'C:\\study\\meowcoffeeFile\\profiles\\profile_company_bean_220-82-67890.jpg', NULL),
    ('company_fresh', 'hashed_password_placeholder', '신선식품(주)', '최신선', '010-4444-3333', 'fresh@fresh.co.kr', '230-83-54321', '부산광역시 해운대구', 'B동 203호', '2023-09-01', 'COMPANY', 'APPROVAL', '2025-11-03', 'C:\\study\\meowcoffeeFile\\profiles\\profile_company_fresh_230-83-54321.jpg', NULL),
    ('company_daily', 'hashed_password_placeholder', '데일리물산', '정일상', '010-4444-4444', 'daily@daily.com', '240-84-11111', '대구광역시 수성구', '1층', '2023-09-15', 'COMPANY', 'APPROVAL', '2025-10-29', 'C:\\study\\meowcoffeeFile\\profiles\\profile_company_daily_240-84-11111.png', NULL),
    ('company_global', 'hashed_password_placeholder', '글로벌로지스', '김글로벌', '010-5555-1111', 'global@logis.com', '310-81-22222', '인천광역시 중구', '물류센터 A', '2023-10-01', 'COMPANY', 'APPROVAL', '2025-11-02', 'C:\\study\\meowcoffeeFile\\profiles\\profile_company_global_310-81-22222.jpg', NULL),
    ('company_happy', 'hashed_password_placeholder', '해피유통', '박행복', '010-5555-2222', 'happy@happy.net', '320-82-33333', '광주광역시 서구', '302호', '2023-10-20', 'COMPANY', 'APPROVAL', '2025-11-01', 'C:\\study\\meowcoffeeFile\\profiles\\profile_company_happy_320-82-33333.jpg', NULL),
    ('company_quick', 'hashed_password_placeholder', '퀵커머스', '손빠름', '010-5555-3333', 'quick@qcom.com', '330-83-44444', '대전광역시 유성구', '연구소 2층', '2023-11-01', 'COMPANY', 'APPROVAL', '2025-10-28', 'C:\\study\\meowcoffeeFile\\profiles\\profile_company_quick_330-83-44444.png', NULL),
    ('company_smart', 'hashed_password_placeholder', '스마트팜', '오채소', '010-5555-4444', 'smart@farm.com', '340-84-55555', '경기도 평택시', '비닐하우스 10동', '2023-11-15', 'COMPANY', 'APPROVAL', '2025-11-04', 'C:\\study\\meowcoffeeFile\\profiles\\profile_company_smart_340-84-55555.jpg', NULL),
    ('company_basic', 'hashed_password_placeholder', '베이직웨어', '나의류', '010-6666-1111', 'basic@wear.com', '410-81-66666', '서울특별시 동대문구', '평화시장 1가', '2023-12-01', 'COMPANY', 'APPROVAL', '2025-11-05', 'C:\\study\\meowcoffeeFile\\profiles\\profile_company_basic_410-81-66666.png', NULL),
    ('company_kitchen', 'hashed_password_placeholder', '(주)키친아트', '한주방', '010-6666-2222', 'kitchen@art.com', '420-82-77777', '경기도 파주시', '공단 1로', '2023-12-10', 'COMPANY', 'APPROVAL', '2025-11-02', 'C:\\study\\meowcoffeeFile\\profiles\\profile_company_kitchen_420-82-77777.jpg', NULL);

select * from managers;
select * from companies;
select * from deliverymen;