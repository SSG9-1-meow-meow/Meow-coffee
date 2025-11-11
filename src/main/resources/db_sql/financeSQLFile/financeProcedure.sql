USE meowcoffeedb;

SELECT *
FROM expense;

-- 가정5. 청구매월 1일에 청구
DROP PROCEDURE IF EXISTS create_invoice;
DELIMITER $$
CREATE PROCEDURE create_invoice(IN p_run_dt DATE)
BEGIN
    DECLARE v_start DATE;
    DECLARE v_end   DATE;

    DECLARE v_in    DECIMAL(9,4);
    DECLARE v_out   DECIMAL(9,4);
    DECLARE v_del   DECIMAL(9,4);
    DECLARE v_store DECIMAL(9,4);

    IF p_run_dt IS NULL THEN
        SET p_run_dt = CURDATE();
    END IF;

    -- 전월 [1일, 당월 1일)
    SET v_start = DATE_FORMAT(DATE_SUB(p_run_dt, INTERVAL 1 MONTH), '%Y-%m-01');
    SET v_end   = DATE_FORMAT(p_run_dt, '%Y-%m-01');

    -- 최신 수수료(배율)
    SELECT inFeeRatePct, outFeeRatePct, delFeeRatePct, storeFeeRatePct
    INTO v_in, v_out, v_del, v_store
    FROM feeRate
    ORDER BY feeRateId DESC
    LIMIT 1;

    -- 임시 테이블: 스키마 먼저 생성 후 INSERT … SELECT
    DROP TEMPORARY TABLE IF EXISTS _t_users;
    CREATE TEMPORARY TABLE _t_users (
                                        userId VARCHAR(30) PRIMARY KEY
    );

    INSERT INTO _t_users(userId)
    SELECT DISTINCT e.userId
    FROM expense e
    WHERE e.expenseDt >= v_start
      AND e.expenseDt <  v_end
      AND e.expenseCategory IN ('inboundCost','outboundCost','deliveryCost','storageCost')
      AND IFNULL(e.isDelete,0)=0;

    -- 같은 날 생성된 draft 정리
    DELETE i
    FROM invoice i
             JOIN _t_users u ON u.userId = i.userId
    WHERE i.invoiceStatus='draft'
      AND i.invoiceDt >= v_start AND i.invoiceDt < v_end;

    -- 거래처별 합계(배율 곱, /100 제거)
    INSERT INTO invoice (invoiceDt, totalAmt, invoiceStatus, userId)
    SELECT v_start,
           ROUND(SUM(
                         CASE e.expenseCategory
                             WHEN 'inboundCost'  THEN e.totalAmt * v_in
                             WHEN 'outboundCost' THEN e.totalAmt * v_out
                             WHEN 'deliveryCost' THEN e.totalAmt * v_del
                             WHEN 'storageCost'  THEN e.totalAmt * v_store
                             ELSE 0
                             END
                 ),2) AS totalAmt,
           'draft',
           e.userId
    FROM expense e
             JOIN _t_users u ON u.userId = e.userId
    WHERE e.expenseDt >= v_start
      AND e.expenseDt <  v_end
      AND e.expenseCategory IN ('inboundCost','outboundCost','deliveryCost','storageCost')
      AND IFNULL(e.isDelete,0)=0
    GROUP BY e.userId
    HAVING ROUND(SUM(
                         CASE e.expenseCategory
                             WHEN 'inboundCost'  THEN e.totalAmt * v_in
                             WHEN 'outboundCost' THEN e.totalAmt * v_out
                             WHEN 'deliveryCost' THEN e.totalAmt * v_del
                             WHEN 'storageCost'  THEN e.totalAmt * v_store
                             ELSE 0
                             END
                 ),2) > 0;
END$$
DELIMITER ;

-- 매월 1일 00:10 실행 이벤트
SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS ev_monthly_invoice_run;
CREATE EVENT ev_monthly_invoice_run
    ON SCHEDULE EVERY 1 MONTH
        STARTS '2025-01-01 00:10:00'
    ON COMPLETION PRESERVE
    DO CALL create_invoice(curdate());

CALL create_invoice('2025-12-01');

SELECT * FROM expense;
SELECT * FROM invoice;


-- 매월 15일 매출 정산
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
    DO CALL create_revenue(NOW());


-- 수동 테스트
UPDATE expense SET expenseStatus = 'posted' WHERE expenseStatus = 'draft';
UPDATE invoice SET invoiceStatus = 'paid' WHERE invoiceStatus = 'draft';

CALL create_revenue('2025-12-15 00:10:00');

SELECT * FROM expense;
SELECT * FROM invoice;
SELECT * FROM revenue;
