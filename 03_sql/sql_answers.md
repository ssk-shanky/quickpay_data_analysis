All results computed from `01_data/processed/merchant_risk_summary.csv`.

**Query 1: Count of transactions by status**
```text
status | transaction_count
CAPTURED | 19
FAILED E05 TIMEOUT | 7
CHARGEBACK | 4
```

**Query 2: Total GMV (Gross Merchandise Value) captured by each merchant**
(status = 'CAPTURED')
```text
merchant_id | merchant_name | total_captured_gmv
M001 | ALPHA MART | 29984.5
M002 | BETA STORES | 33431
M003 | CITY PHARMA | 8640
M004 | DELTA TRAVELS | 10300
```

**Query 3: Top 10 merchants by captured GMV**
(ordered by `total_captured_gmv` DESC)
```text
merchant_id | merchant_name | total_captured_gmv
M002 | BETA STORES | 33431
M001 | ALPHA MART | 29984.5
M004 | DELTA TRAVELS | 10300
M003 | CITY PHARMA | 8640
```

**Query 4: Daily GMV and count of successful transactions**
(status = 'CAPTURED', ordered by `transaction_date`)
```text
transaction_date | daily_gmv | successful_transactions
01-03-2026 | 26382 | 5
02-03-2026 | 11080 | 3
03-03-2026 | 16031.5 | 4
04-03-2026 | 13920 | 4
05-03-2026 | 6136 | 1
06-03-2026 | 8806 | 2
```

**Query 5: Chargeback ratio for each merchant**
(only rows with `chargeback_ratio` > 0.01)
```text
merchant_id | merchant_name | chargeback_ratio
M001 | ALPHA MART | 0.09090909090909091
M002 | BETA STORES | 0.09090909090909091
M004 | DELTA TRAVELS | 0.25
M005 | ECO HOME | 0.5
```

**Query 6: Average risk score by gateway_region**
(WHERE `gateway_region` != 'MISSING' HAVING `COUNT(*)` > 20 AND `AVG(risk_score)` > 50)
```text
gateway_region | total_transactions | avg_risk_score
(0 rows)
```

**Query 7: Users with multiple risky transactions**
(status IN ('FAILED E05 TIMEOUT','CHARGEBACK'), HAVING `COUNT(*)` >= 3)
```text
user_id | transaction_date | risky_txn_count
U008 | 05-03-2026 | 4
```

**Query 8: Merchants with the highest chargeback amounts**
(status = 'CHARGEBACK')
```text
merchant_id | merchant_name | chargeback_count | affected_users | chargeback_amount
M001 | ALPHA MART | 1 | 1 | 5400
M002 | BETA STORES | 1 | 1 | 1711
M004 | DELTA TRAVELS | 1 | 1 | 2500
M005 | ECO HOME | 1 | 1 | 6649
```

Computed from 30 rows in `01_data/processed/merchant_risk_summary.csv`.

