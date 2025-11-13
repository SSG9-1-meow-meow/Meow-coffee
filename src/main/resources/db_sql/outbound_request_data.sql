use meowcoffeedb;

USE meowcoffeedb;

-- 안전 초기화
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE outboundItems;
TRUNCATE TABLE outboundrequest;
SET FOREIGN_KEY_CHECKS = 1;

START TRANSACTION;

-- =========================
-- 1) 출고요청 헤더 (outboundrequest)
--    IsTempo 컬럼이 스키마에선 NULL 허용이므로 0/NULL 혼용
--    managerID 컬럼명을 DDL에 맞춰 사용
-- =========================
INSERT INTO outboundrequest
(comId,        managerID,     outDttmReq,             outDateWish,   outDttmAppr,              IsDelete, IsTempo)
VALUES
    ('company_good',   'manager_kim',  '2025-11-08 09:00:00', '2025-11-10',  '2025-11-08 13:00:00',   0,        NULL), -- 승인완료
    ('company_bean',   'manager_lee',  '2025-11-08 10:20:00', '2025-11-11',  NULL,                    0,        1   ), -- 임시저장 느낌
    ('company_fresh',  'manager_park', '2025-11-09 08:40:00', '2025-11-12',  '2025-11-09 14:10:00',   0,        0   ), -- 일부 완료
    ('company_daily',  'manager_choi', '2025-11-09 11:05:00', '2025-11-13',  NULL,                    0,        0   ), -- 승인대기
    ('company_global', 'manager_kim',  '2025-11-10 09:15:00', '2025-11-14',  '2025-11-10 12:30:00',   0,        0   ), -- 승인완료
    ('company_happy',  'manager_lee',  '2025-11-10 16:25:00', '2025-11-12',  '2025-11-10 17:00:00',   0,        0   ), -- 전량 출고완료
    ('company_quick',  'manager_park', '2025-11-11 08:10:00', '2025-11-13',  NULL,                    0,        0   ), -- 승인대기(대량)
    ('company_smart',  'manager_choi', '2025-11-11 13:35:00', '2025-11-15',  '2025-11-11 15:20:00',   1,        NULL); -- 논리삭제 케이스

-- 방금 생성된 outReqId 범위 캐치 (자동증가값 환경마다 다를 수 있음)
SET @o1 = (SELECT MIN(outReqId) FROM outboundrequest);
SET @o2 = @o1 + 1;
SET @o3 = @o1 + 2;
SET @o4 = @o1 + 3;
SET @o5 = @o1 + 4;
SET @o6 = @o1 + 5;
SET @o7 = @o1 + 6;
SET @o8 = @o1 + 7;

-- =========================
-- 2) 출고요청 상세 (outboundItems)
--    status: '승인대기' | '승인완료' | '출고완료'
--    stkId: STK001 ~ STK005
--    vehicleId: vehicles 테이블 값 사용
-- =========================

-- @o1: 승인완료(차량 배정 완료)
INSERT INTO outboundItems
(outReqId, stkId,  vehicleId,  status,      outQtyReq, outOrderAddr,                 outDttmSchd,             outDttmInsp,             outDttmShip)
VALUES
    (@o1,    'STK001', '55가1001', '승인완료',  40,       '서울시 영등포구 101호',     '2025-11-10 09:00:00',  '2025-11-09 16:00:00',  NULL),
    (@o1,    'STK002', '55가1001', '승인완료',  20,       '서울시 영등포구 101호',     '2025-11-10 09:00:00',  '2025-11-09 16:00:00',  NULL);

-- @o2: 임시저장 느낌(상세는 승인대기)
INSERT INTO outboundItems VALUES
    (NULL,@o2,'STK003','55나2002','승인대기',  30,'서울시 종로구 본사 5층', '2025-11-11 10:00:00', NULL, NULL);

-- @o3: 일부 출고완료, 일부 승인완료
INSERT INTO outboundItems VALUES
                              (NULL,@o3,'STK004','55다3003','출고완료',  25,'부산 해운대구 321',   '2025-11-12 11:00:00','2025-11-11 14:30:00','2025-11-12 11:40:00'),
                              (NULL,@o3,'STK005','55다3003','승인완료',  35,'부산 해운대구 321',   '2025-11-12 11:00:00','2025-11-11 14:30:00', NULL);

-- @o4: 전부 승인대기
INSERT INTO outboundItems VALUES
    (NULL,@o4,'STK001',NULL,'승인대기', 50,'경기 성남시 판교로 242', '2025-11-13 09:30:00', NULL, NULL);

-- @o5: 승인완료 2건(차량 서로 다르게)
INSERT INTO outboundItems VALUES
                              (NULL,@o5,'STK002','55라4004','승인완료', 30,'대구 수성구 동대구로', '2025-11-14 10:30:00','2025-11-11 17:20:00', NULL),
                              (NULL,@o5,'STK003','55마5005','승인완료', 20,'대구 수성구 동대구로', '2025-11-14 10:30:00','2025-11-11 17:20:00', NULL);

-- @o6: 전량 출고완료
INSERT INTO outboundItems VALUES
    (NULL,@o6,'STK004','55마5005','출고완료',  40,'인천공항 물류센터 A', '2025-11-12 08:30:00','2025-11-11 18:10:00','2025-11-12 09:10:00');

-- @o7: 승인대기(대량)
INSERT INTO outboundItems VALUES
    (NULL,@o7,'STK005',NULL,'승인대기',  120,'광주 서구 302호',       '2025-11-13 13:30:00', NULL, NULL);

-- @o8: 헤더가 IsDelete=1 (논리삭제) – 상세는 참고용
INSERT INTO outboundItems VALUES
    (NULL,@o8,'STK001',NULL,'승인대기',  15,'경기 평택 비닐하우스', '2025-11-15 09:00:00', NULL, NULL);

COMMIT;

-- =========================
-- 3) 빠른 확인용 쿼리 (리스트 바인딩 확인)
-- =========================
SELECT
    o.outReqId                                    AS 요청ID,
    COALESCE(c.comName, o.comId)                  AS 거래처,
    u.userName                                    AS 담당자명,
    DATE_FORMAT(o.outDttmReq, '%Y-%m-%d %H:%i')   AS 요청일시,
    o.outDateWish                                 AS 희망일,
    DATE_FORMAT(o.outDttmAppr, '%Y-%m-%d %H:%i')  AS 승인일시,
    o.IsDelete                                    AS 삭제,
    o.IsTempo                                     AS 임시여부,
    i.stkId, i.outQtyReq, i.status, i.vehicleId
FROM outboundrequest o
         JOIN outboundItems i ON i.outReqId = o.outReqId
         LEFT JOIN companies c ON c.comId = o.comId
         LEFT JOIN users u ON u.userId = o.managerID
ORDER BY o.outReqId DESC, i.outReqItemsId ASC;



USE meowcoffeedb;

-- 출고요청 메인
INSERT INTO outboundrequest (comId, managerId, outDttmReq, outDateWish, outDttmAppr, IsDelete, IsTempo)
VALUES
    ('company_good', 'manager_kim', '2025-11-10 09:00:00', '2025-11-15', NULL, 0, NULL),
    ('company_good', 'manager_kim', '2025-11-11 10:20:00', '2025-11-17', NULL, 0, NULL),
    ('company_good', 'manager_kim', '2025-11-12 13:40:00', '2025-11-18', NULL, 0, NULL),
    ('company_good', 'manager_kim', '2025-11-13 15:10:00', '2025-11-20', NULL, 0, NULL),
    ('company_good', 'manager_kim', '2025-11-14 08:45:00', '2025-11-21', NULL, 0, NULL);

--  출고 상세 품목 (재고ID, 수량, 주소)
INSERT INTO outbounditems (outReqId, stkId, status, outQtyReq, outOrderAddr, outDttmSchd)
VALUES
    -- 1번 요청: 서울 본사 납품
    (1, 'STK001', '승인대기', 40, '서울시 강남구 테헤란로 123', '2025-11-15 09:00:00'),
    (1, 'STK002', '승인대기', 25, '서울시 강남구 테헤란로 123', '2025-11-15 09:00:00'),

    -- 2번 요청: 인천 매장 납품
    (2, 'STK003', '승인대기', 60, '인천시 연수구 송도국제대로 45', '2025-11-17 10:00:00'),

    -- 3번 요청: 부산 거래처 납품
    (3, 'STK004', '승인대기', 50, '부산광역시 해운대구 해운대로 300', '2025-11-18 11:00:00'),
    (3, 'STK005', '승인대기', 30, '부산광역시 해운대구 해운대로 300', '2025-11-18 11:00:00'),

    -- 4번 요청: 대구 거래처 납품
    (4, 'STK003', '승인대기', 20, '대구광역시 수성구 동대구로 88', '2025-11-20 14:00:00'),

    -- 5번 요청: 경기 물류창고 납품
    (5, 'STK002', '승인대기', 15, '경기도 용인시 처인구 물류단지로 55', '2025-11-21 13:00:00'),
    (5, 'STK005', '승인대기', 25, '경기도 용인시 처인구 물류단지로 55', '2025-11-21 13:00:00');
commit ;

SELECT * FROM outboundrequest ORDER BY outReqId DESC LIMIT 10;
SELECT * FROM outbounditems   ORDER BY outReqId DESC, stkId LIMIT 20;


SELECT
    o.outReqId, o.comId, c.comName, o.outDateWish, o.outDttmReq, o.outDttmAppr,
    o.IsTempo, o.IsDelete,
    CASE
        WHEN SUM(CASE WHEN i.status='출고완료' THEN 1 ELSE 0 END) > 0 THEN '출고완료'
        WHEN SUM(CASE WHEN i.status='승인완료' THEN 1 ELSE 0 END) > 0 THEN '승인완료'
        WHEN SUM(CASE WHEN i.status='반려'     THEN 1 ELSE 0 END) > 0 THEN '반려'
        ELSE '승인대기'
        END AS status
FROM outboundrequest o
         LEFT JOIN companies c     ON c.comId = o.comId
         LEFT JOIN outbounditems i ON i.outReqId = o.outReqId
WHERE o.IsDelete = 0
GROUP BY o.outReqId, o.comId, c.comName, o.outDateWish, o.outDttmReq, o.outDttmAppr, o.IsTempo, o.IsDelete
ORDER BY o.outDttmReq DESC;

SELECT * FROM outboundrequest ORDER BY outReqId DESC LIMIT 3;
SELECT * FROM outbounditems  ORDER BY outReqItemsId DESC LIMIT 5;

