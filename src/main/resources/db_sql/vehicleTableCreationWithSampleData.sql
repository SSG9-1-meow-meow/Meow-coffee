use meowcoffeedb;




DROP TABLE IF EXISTS vehicles;
CREATE TABLE vehicles (
vehicleId	char(10)	PRIMARY KEY ,
vehicleModel	ENUM('5톤 윙바디', '1톤 탑차', '1.2톤 카고')	NOT NULL,
vehicleDesc	varchar(255)	NULL
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


select * from vehicles;