select count(*) from inboundCost;
select count(*) from expense;
-- '승인완료' 상태의 입고 항목 중 5개를 '입고완료'로 상태 변경 및 시간 기록

select count(*) from inboundRequests;
select count(*) from inboundItems;
-- '승인완료' 상태의 입고 항목 중, 보관 위치(locationId)가 지정된 5개를 '입고완료'로 변경
UPDATE inboundItems
SET
    status = '승인완료',

    -- 검수 시간(inDttmInsp)을 입고 예정 시간(inDttmSchd)으로부터 1~12시간 후의 임의의 시간으로 설정하고,
    -- 이 값을 @insp_time 변수에 저장합니다.
    inDttmInsp = (@insp_time := TIMESTAMPADD(HOUR, FLOOR(1 + RAND() * 12), inDttmSchd)),

    -- 최종 입고 완료 시간(inDttmRecv)을 방금 계산한 검수 시간(@insp_time)으로부터
    -- 30분~2시간(120분) 후의 임의의 시간으로 설정합니다.
    inDttmRecv = TIMESTAMPADD(MINUTE, FLOOR(30 + RAND() * 120), @insp_time)

WHERE
  -- 현재 상태가 '승인완료'인 항목들 중에서
    status = '승인대기'
  AND
  -- 입고 예정 시간이 지정된 유효한 항목만 대상으로 함
    inDttmSchd IS NOT NULL
  AND
  -- [수정된 부분] locationId가 NULL이 아닌 항목만 대상으로 하여 트리거 오류 방지
    locationId IS NOT NULL

-- 모든 항목을 한 번에 바꾸지 않고, 5개만 임의로 선택하여 처리
ORDER BY RAND()
LIMIT 5;

-- 처리 결과 확인용 SELECT 쿼리
SELECT
    inReqItemsId,
    locationId,
    status,
    inDttmSchd,
    inDttmInsp,
    inDttmRecv
FROM
    inboundItems
WHERE
    status = '입고완료'
ORDER BY
    inDttmRecv DESC
LIMIT 5;

select count(*) from due_diligence;

select count(*) from storageCost;


-- 'PENDING' 상태의 재고 실사 항목 중 5개를 'APPROVED'로 상태 변경 및 관련 정보 업데이트
UPDATE due_diligence
SET
    ddApproval = 'APPROVED',

    -- 승인 처리된 시각을 현재 시간으로 기록
    ddUpdateDate = NOW(),

    -- 기존 로그에 승인 처리 기록을 추가 (기존 로그가 NULL이면 새로 작성)
    ddLog = CONCAT(
            IFNULL(ddLog, ''),
            ' / 시스템에 의해 최종 승인 처리됨.'
            )

WHERE
    -- 현재 상태가 'PENDING'인 항목들 중에서
    ddApproval = 'PENDING'

-- 모든 보류 건을 한 번에 바꾸지 않고, 5개만 임의로 선택하여 처리
ORDER BY RAND()
LIMIT 5;

-- 처리 결과 확인용 SELECT 쿼리
SELECT
    ddId,
    stkId,
    ddApproval,
    ddDate,
    ddUpdateDate,
    ddLog
FROM
    due_diligence
WHERE
    ddApproval = 'APPROVED'
ORDER BY
    ddUpdateDate DESC
LIMIT 5;

