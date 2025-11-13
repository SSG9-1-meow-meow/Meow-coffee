-- 가정6. 매월 15일 매출 집계
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
      AND IFNULL(isDelete,0) = 0;

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