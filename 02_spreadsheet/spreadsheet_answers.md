# Spreadsheet Answers

## Cleaning Steps
- Remove duplicates and nulls; trim whitespace and normalize casing.
- Parse and coerce numeric fields (e.g., `amount_usd`); convert dates to ISO 8601 UTC.
- Extract numeric risk scores from mixed text (e.g., `score:62`, `risk-83`) and mark missing values as `MISSING`.
- Convert amounts to USD using `exchange_rates` matched on date + currency.
- Standardize merchant identifiers, enrich from merchant master, and derive analytic flags.

## Standardization Rules
- Merchant names: uppercase and trimmed.
- Status values: normalized to canonical set (e.g., APPROVED, CAPTURED, CHARGEBACK).
- Risk score: numeric; extract from text patterns and coerce to numbers.
- Regions: canonical codes (APAC, EU, US), uppercase and trimmed.
- Currency codes: ISO 4217 uppercase.
- Dates: ISO 8601 in UTC.

## Lookup and Enrichment Logic
- Merchant enrichment: match normalized merchant name to `merchant_master` to get `merchant_id`, category, account manager.
- Exchange rates: join on `date` + `currency` to compute `amount_usd`.
- Use robust lookups (INDEX/MATCH or left joins) with `IFERROR`/fallback `"MISSING"` for unmatched rows.
- Derived flags:
  - High value: APAC & amount_usd > 5000; EU & amount_usd > 6000; US & amount_usd > 7000.
  - High risk: `risk_score >= 70` OR `status` contains `"chargeback"`.

## Final Answers
- Total raw rows: 30
- Total cleaned rows: 30
- Invalid or missing rows handled: 0
- Top region by GMV: APAC (50,177.50 USD)
- Number of high value transactions: 6
- Number of high risk transactions: 9
- Top merchant by captured GMV: BETA STORES (41,782.00 USD)

## Formula Samples
- Merchant name normalization:
```
=UPPER(TRIM(E2))
```
- Currency lookup (date + currency):
```
=INDEX(exchange_rates!$C:$C, MATCH(1, (exchange_rates!$A:$A = A2) * (UPPER(TRIM(exchange_rates!$B:$B)) = UPPER(TRIM(I2))), 0))
```
- High value flag:
```
=IF(AND(R2=\"APAC\",J2>5000),1, IF(AND(R2=\"EU\",J2>6000),1, IF(AND(R2=\"US\",J2>7000),1,0)))
```
- High risk flag:
```
=IF(OR(AND(ISNUMBER(O3),O3>=70), ISNUMBER(SEARCH(\"chargeback\",M3))),1,0)
```
