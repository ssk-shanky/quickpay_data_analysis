# Spreadsheet Data Cleaning & Transformation Summary

## Objective

The goal of this exercise was to clean, standardize, enrich, and transform raw transaction data into a structured format suitable for analysis. This included integrating exchange rates and merchant master data, and generating analytical flags.

---

## 1. Data Cleaning & Standardization

### 1.1 Merchant Name Standardization

Merchant names were standardized to ensure consistency across datasets.

**Formula used:**

```
=UPPER(TRIM(E2))
```

---

### 1.2 Status Standardization

Transaction status values were normalized to a consistent format.

**Formula used:**

```
=UPPER(TRIM(L3))
```

---

### 1.3 Risk Score Standardization

Risk scores were extracted from mixed formats such as `score:62` and `risk-83`.

**Formula used:**

```
=IFERROR(VALUE(RIGHT(N3, LEN(N3) - MAX(IFERROR(FIND(":",N3),0), IFERROR(FIND("-",N3),0)))), "MISSING")
```

---

### 1.4 Region Standardization

Gateway region values were standardized.

**Formula used:**

```
=IF(Q3="","MISSING",UPPER(TRIM(Q3)))
```

---

## 2. Currency Conversion (Amount to USD)

Transaction amounts were converted into USD using exchange rates based on date and currency.

**Formula used:**

```
=IFERROR(
H2 * INDEX(exchange_rates!C$2:C$100,
MATCH(1,
(exchange_rates!A$2:A$100=B2) *
(UPPER(TRIM(exchange_rates!B$2:B$100))=UPPER(TRIM(I2))),
0)
),
"MISSING")
```

**Logic:**

* Match on `date + currency`
* Multiply transaction amount by corresponding USD rate

---

## 3. Merchant Data Enrichment

Transactions were enriched using merchant master data.

### 3.1 Merchant ID

```
=IFERROR(
INDEX(merchants!A:A,
MATCH(UPPER(TRIM(E2)), UPPER(TRIM(merchants!B:B)), 0)
),
"MISSING")
```

---

### 3.2 Account Manager

```
=IFERROR(
INDEX(merchants!C:C,
MATCH(UPPER(TRIM(E2)), UPPER(TRIM(merchants!B:B)), 0)
),
"MISSING")
```

---

### 3.3 Merchant Category

```
=IFERROR(
INDEX(merchants!D:D,
MATCH(UPPER(TRIM(E3)), UPPER(TRIM(merchants!B:B)), 0)
),
"MISSING")
```

---

## 4. Derived Flags

### 4.1 High Value Flag

**Business Rules:**

* APAC and amount_usd > 5000
* EU and amount_usd > 6000
* US and amount_usd > 7000

**Formula used:**

```
=IF(AND(R2="APAC",J2>5000),1,
IF(AND(R2="EU",J2>6000),1,
IF(AND(R2="US",J2>7000),1,0)))
```

---

### 4.2 High Risk Flag

**Business Rules:**

* Risk score ≥ 70
* OR status contains "chargeback"

**Formula used:**

```
=IF(OR(AND(ISNUMBER(O3),O3>=70),ISNUMBER(SEARCH("chargeback",M3))),1,0)
```

---

## 5. Error Handling Strategy

* Used `IFERROR()` to handle:

  * Missing lookups
  * Invalid values
* Default fallback value:

```
"MISSING"
```

---

## 6. Key Learnings

* Data standardization is critical for accurate joins
* Hidden formatting issues (spaces, casing) significantly impact lookups
* `INDEX + MATCH` provides flexibility for multi-condition joins
* Array formulas require special handling in older Excel versions
* Combining cleaning + enrichment enables reliable analytics

---

## 7. Output Files

### 7.1 cleaned_transactions.csv

* Fully cleaned and enriched dataset
* Includes:

  * Standardized fields
  * USD amounts
  * Derived flags

### 7.2 merchant_risk_summary.csv

* Aggregated insights by merchant
* Used for analytical reporting

---

## Conclusion

The raw transaction dataset was successfully transformed into a clean, standardized, and enriched dataset. The applied transformations ensure consistency, accuracy, and readiness for downstream analytics and reporting.

---
