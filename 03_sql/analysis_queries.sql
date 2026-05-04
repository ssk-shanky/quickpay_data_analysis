-- Analysis Queries for Cleaned Transactions

--Query 1: Count of transactions by status
select status, count(*) as transaction_count from merchant_risk_summary group by status;


--Query 2: Total GMV (Gross Merchandise Value) captured by each merchant
SELECT 
    merchant_id,
    merchant_name,
    SUM(amount_usd) AS total_captured_gmv
FROM merchant_risk_summary
WHERE status = 'CAPTURED'
GROUP BY merchant_id, merchant_name;


--Query 3: Top 10 merchants by captured GMV
SELECT 
    merchant_id,
    merchant_name,
    SUM(amount_usd) AS total_captured_gmv
FROM merchant_risk_summary
WHERE status = 'CAPTURED'
GROUP BY merchant_id, merchant_name
ORDER BY total_captured_gmv DESC
LIMIT 10;


-- Query 4: Daily GMV and count of successful transactions
SELECT 
    transaction_date,
    SUM(amount_usd) AS daily_gmv,
    COUNT(*) AS successful_transactions
FROM merchant_risk_summary
WHERE status = 'CAPTURED'
GROUP BY transaction_date
ORDER BY transaction_date;


-- Query 5: Chargeback ratio for each merchant
SELECT 
    merchant_id,
    merchant_name,
    COUNT(CASE WHEN status = 'CHARGEBACK' THEN 1 END) * 1.0 
        / COUNT(*) AS chargeback_ratio
FROM merchant_risk_summary
GROUP BY merchant_id, merchant_name
HAVING 
    COUNT(CASE WHEN status = 'CHARGEBACK' THEN 1 END) * 1.0 
        / COUNT(*) > 0.01;


-- Query 6: Average risk score by gateway region for transactions with sufficient data
SELECT 
    gateway_region,
    COUNT(*) AS total_transactions,
    AVG(risk_score) AS avg_risk_score
FROM merchant_risk_summary
WHERE gateway_region != 'MISSING'
GROUP BY gateway_region
HAVING 
    COUNT(*) > 20
    AND AVG(risk_score) > 50;


-- Query 7: Users with multiple risky transactions
SELECT 
    user_id,
    transaction_date,
    COUNT(*) AS risky_txn_count
FROM merchant_risk_summary
WHERE status IN ('FAILED E05 TIMEOUT', 'CHARGEBACK')
GROUP BY user_id, transaction_date
HAVING COUNT(*) >= 3;



-- Query 8: Merchants with the highest chargeback amounts
SELECT 
    merchant_id,
    merchant_name,
    COUNT(*) AS chargeback_count,
    COUNT(DISTINCT user_id) AS affected_users,
    SUM(amount_usd) AS chargeback_amount
FROM merchant_risk_summary
WHERE status = 'CHARGEBACK'
GROUP BY merchant_id, merchant_name;