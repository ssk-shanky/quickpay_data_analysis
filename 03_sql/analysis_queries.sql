-- Analysis Queries for Cleaned Transactions

-- Q1
select status, count(*) as transaction_count from merchant_risk_summary group by status;

-- Q2
SELECT 
    merchant_id,
    merchant_name,
    SUM(amount_usd) AS total_captured_gmv
FROM merchant_risk_summary
WHERE status = 'CAPTURED'
GROUP BY merchant_id, merchant_name;

-- Q3
SELECT 
    merchant_id,
    merchant_name,
    SUM(amount_usd) AS total_captured_gmv
FROM merchant_risk_summary
WHERE status = 'CAPTURED'
GROUP BY merchant_id, merchant_name
ORDER BY total_captured_gmv DESC
LIMIT 10;

-- Q4
SELECT 
    transaction_date,
    SUM(amount_usd) AS daily_gmv,
    COUNT(*) AS successful_transactions
FROM merchant_risk_summary
WHERE status = 'CAPTURED'
GROUP BY transaction_date
ORDER BY transaction_date;

-- Q5
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

-- Q6
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

-- Q7
SELECT 
    user_id,
    transaction_date,
    COUNT(*) AS risky_txn_count
FROM merchant_risk_summary
WHERE status IN ('FAILED E05 TIMEOUT', 'CHARGEBACK')
GROUP BY user_id, transaction_date
HAVING COUNT(*) >= 3;


-- Q8
SELECT 
    merchant_id,
    merchant_name,
    COUNT(*) AS chargeback_count,
    COUNT(DISTINCT user_id) AS affected_users,
    SUM(amount_usd) AS chargeback_amount
FROM merchant_risk_summary
WHERE status = 'CHARGEBACK'
GROUP BY merchant_id, merchant_name;