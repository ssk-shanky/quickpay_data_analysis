# SQL Answers

All results computed from `01_data/processed/merchant_risk_summary.csv`.

## Q1
### Query
```sql
SELECT status,
		 COUNT(*) AS transaction_count
FROM merchant_risk_summary
GROUP BY status
ORDER BY transaction_count DESC;
```
### Result Summary
```text
status | transaction_count
CAPTURED | 19
FAILED E05 TIMEOUT | 7
CHARGEBACK | 4
```

## Q2
### Query
```sql
SELECT merchant_id,
		 merchant_name,
		 SUM(amount) AS total_captured_gmv
FROM merchant_risk_summary
WHERE status = 'CAPTURED'
GROUP BY merchant_id, merchant_name
ORDER BY total_captured_gmv DESC;
```
### Result Summary
```text
merchant_id | merchant_name | total_captured_gmv
M001 | ALPHA MART | 29984.5
M002 | BETA STORES | 33431
M003 | CITY PHARMA | 8640
M004 | DELTA TRAVELS | 10300
```

## Q3
### Query
```sql
SELECT merchant_id,
		 merchant_name,
		 SUM(amount) AS total_captured_gmv
FROM merchant_risk_summary
WHERE status = 'CAPTURED'
GROUP BY merchant_id, merchant_name
ORDER BY total_captured_gmv DESC
LIMIT 10;
```
### Result Summary
```text
merchant_id | merchant_name | total_captured_gmv
M002 | BETA STORES | 33431
M001 | ALPHA MART | 29984.5
M004 | DELTA TRAVELS | 10300
M003 | CITY PHARMA | 8640
```

## Q4
### Query
```sql
SELECT DATE(transaction_date) AS transaction_date,
		 SUM(amount) AS daily_gmv,
		 COUNT(*) AS successful_transactions
FROM merchant_risk_summary
WHERE status = 'CAPTURED'
GROUP BY DATE(transaction_date)
ORDER BY transaction_date;
```
### Result Summary
```text
transaction_date | daily_gmv | successful_transactions
01-03-2026 | 26382 | 5
02-03-2026 | 11080 | 3
03-03-2026 | 16031.5 | 4
04-03-2026 | 13920 | 4
05-03-2026 | 6136 | 1
06-03-2026 | 8806 | 2
```

## Q5
### Query
```sql
SELECT merchant_id,
		 merchant_name,
		 SUM(CASE WHEN status = 'CHARGEBACK' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS chargeback_ratio
FROM merchant_risk_summary
GROUP BY merchant_id, merchant_name
HAVING SUM(CASE WHEN status = 'CHARGEBACK' THEN 1 ELSE 0 END) * 1.0 / COUNT(*) > 0.01
ORDER BY chargeback_ratio DESC;
```
### Result Summary
```text
merchant_id | merchant_name | chargeback_ratio
M001 | ALPHA MART | 0.09090909090909091
M002 | BETA STORES | 0.09090909090909091
M004 | DELTA TRAVELS | 0.25
M005 | ECO HOME | 0.5
```

## Q6
### Query
```sql
SELECT gateway_region,
		 COUNT(*) AS total_transactions,
		 AVG(risk_score) AS avg_risk_score
FROM merchant_risk_summary
WHERE gateway_region != 'MISSING'
GROUP BY gateway_region
HAVING COUNT(*) > 20
	AND AVG(risk_score) > 50;
```
### Result Summary
```text
gateway_region | total_transactions | avg_risk_score
(0 rows)
```

## Q7
### Query
```sql
SELECT user_id,
		 DATE(transaction_date) AS transaction_date,
		 COUNT(*) AS risky_txn_count
FROM merchant_risk_summary
WHERE status IN ('FAILED E05 TIMEOUT','CHARGEBACK')
GROUP BY user_id, DATE(transaction_date)
HAVING COUNT(*) >= 3
ORDER BY risky_txn_count DESC;
```
### Result Summary
```text
user_id | transaction_date | risky_txn_count
U008 | 05-03-2026 | 4
```

## Q8
### Query
```sql
SELECT merchant_id,
		 merchant_name,
		 COUNT(*) AS chargeback_count,
		 COUNT(DISTINCT user_id) AS affected_users,
		 SUM(amount) AS chargeback_amount
FROM merchant_risk_summary
WHERE status = 'CHARGEBACK'
GROUP BY merchant_id, merchant_name
ORDER BY chargeback_amount DESC;
```
### Result Summary
```text
merchant_id | merchant_name | chargeback_count | affected_users | chargeback_amount
M001 | ALPHA MART | 1 | 1 | 5400
M002 | BETA STORES | 1 | 1 | 1711
M004 | DELTA TRAVELS | 1 | 1 | 2500
M005 | ECO HOME | 1 | 1 | 6649
```

Computed from 30 rows in `01_data/processed/merchant_risk_summary.csv`.

