# Credit Risk Analytics — Insights & Business Recommendations

## 1. Executive summary

This analysis uses the **cleaned synthetic dataset** supplied with the Credit Risk Analytics project. It contains **2,500 loan records** linked to **1,200 borrower profiles**, covering application dates from **1 January 2023 to 30 December 2025**.

| Portfolio metric | Result |
|---|---:|
| Loan records | 2,500 |
| Unique borrowers represented in the loan table | 1,048 |
| Total originated loan amount | 769,509,001.45 |
| Total outstanding exposure | 378,885,972.30 |
| Average interest rate | 10.56% |
| Loans with `default_flag = 1` | 137 |
| Overall observed default rate | 5.48% |
| Loans with 90+ days past due (DPD) | 64 |
| Outstanding exposure on 90+ DPD loans | 14,125,540.03 |

**Interpretation:** The dataset contains a substantial outstanding balance and a range of loan performance outcomes. The 5.48% observed default rate is a descriptive metric based on the supplied `default_flag`; it is not a modelled Probability of Default (PD).

> **Currency note:** The source files do not explicitly establish a currency label in the data fields. The monetary figures above are therefore shown in dataset units. Add a currency symbol only after confirming the source data's currency.

## 2. Credit score analysis

Observed default rates by credit score band:

| Credit score band | Loans | Defaulted loans | Observed default rate | Outstanding exposure | Average interest rate |
|---|---:|---:|---:|---:|---:|
| Below 580 | 120 | 19 | 15.83% | 17,663,467.05 | 15.33% |
| 580–669 | 835 | 48 | 5.75% | 130,539,833.71 | 12.29% |
| 670–739 | 1,044 | 48 | 4.60% | 156,349,581.87 | 10.00% |
| 740+ | 501 | 22 | 4.39% | 74,333,089.67 | 7.70% |

### Insight
- The **Below 580** group has the highest observed default rate at **15.83%**.
- Its average interest rate (**15.33%**) is also higher than the other score bands.
- The **580–669** band has the largest exposure among the lower-score segments, at approximately **130.54 million dataset units**.

### Business implication
Credit score bands can help risk teams compare historical loan performance and pricing. The lowest-score group may merit closer review, but its smaller sample size (120 loans) should be considered. These patterns are descriptive and do not prove that credit score alone caused a default.

## 3. Debt-to-income ratio (DTI) analysis

| DTI band | Loans | Defaulted loans | Observed default rate | Outstanding exposure |
|---|---:|---:|---:|---:|
| Below 20% | 854 | 40 | 4.68% | 131,861,667.20 |
| 20%–39.99% | 1,161 | 59 | 5.08% | 176,904,136.27 |
| 40%–59.99% | 434 | 35 | 8.06% | 62,846,735.16 |
| 60%+ | 51 | 3 | 5.88% | 7,273,433.67 |

### Insight
- The **40%–59.99% DTI** group has the highest observed default rate at **8.06%**.
- The **60%+ DTI** group has only 51 loans, so its 5.88% rate is less stable and should not be interpreted as lower risk than the 40%–59.99% group.
- The 20%–39.99% DTI segment has the largest exposure, at approximately **176.90 million dataset units**.

### Business implication
DTI is useful for segmenting affordability-related risk. Review high-DTI accounts alongside credit score, payment history, and sample size rather than using a single metric as a decision rule.

## 4. Regional analysis

| Region | Loans | Defaulted loans | Observed default rate | Outstanding exposure |
|---|---:|---:|---:|---:|
| Central | 428 | 28 | 6.54% | 69,927,915.02 |
| East | 393 | 26 | 6.62% | 63,443,454.27 |
| North | 506 | 38 | 7.51% | 76,191,489.51 |
| South | 595 | 16 | 2.69% | 86,177,099.38 |
| West | 578 | 29 | 5.02% | 83,146,014.12 |

### Insight
- **North** has the highest observed regional default rate at **7.51%**.
- **South** has the lowest observed regional default rate at **2.69%** and the highest outstanding exposure in this dataset, at approximately **86.18 million units**.
- North and South differ in observed rates, but the dataset does not provide evidence explaining why.

### Business implication
Regional differences are useful monitoring signals, not proof of regional causes. Validate the pattern with additional periods and relevant portfolio mix information before making business recommendations.

## 5. Employment-type analysis

| Employment type | Loans | Defaulted loans | Observed default rate | Outstanding exposure |
|---|---:|---:|---:|---:|
| Business Owner | 456 | 20 | 4.39% | 63,243,871.01 |
| Contract | 230 | 9 | 3.91% | 34,899,919.12 |
| Salaried | 1,348 | 82 | 6.08% | 211,617,625.03 |
| Self-Employed | 466 | 26 | 5.58% | 69,124,557.14 |

### Insight
- Salaried borrowers account for the highest number of flagged defaults (**82**) and the largest exposure (**211.62 million units**).
- Their observed default rate is **6.08%**, compared with **3.91%** for Contract borrowers.
- Salaried borrowers are also the largest group in the dataset (1,348 loans), so their larger default count partly reflects their larger representation.

### Business implication
Always compare both the **number of defaults** and the **default rate**. A segment with the most defaults is not automatically the segment with the highest relative risk.

## 6. Delinquency and outstanding exposure

| Days-past-due bucket | Loans | Outstanding exposure | Loans with `default_flag = 1` |
|---|---:|---:|---:|
| Current (0 DPD) | 1,557 | 236,073,721.89 | 0 |
| 1–30 DPD | 603 | 88,035,299.72 | 7 |
| 31–60 DPD | 239 | 33,961,197.07 | 29 |
| 61–90 DPD | 37 | 6,690,213.59 | 37 |
| 90+ DPD | 64 | 14,125,540.03 | 64 |

### Insight
- There are **340 loans with more than 30 DPD** (239 + 37 + 64), representing approximately **54.78 million units** in outstanding exposure.
- The 90+ DPD bucket contains 64 loans and approximately **14.13 million units** of outstanding exposure.
- In the supplied data, every loan in the 61–90 DPD and 90+ DPD buckets has `default_flag = 1`.

### Business implication
DPD buckets are useful for arrears monitoring and prioritizing account review. The exact operational meaning of delinquency and default should be defined consistently with the organization's policy and reporting rules.

## 7. Portfolio and trend observations

- The dataset includes **2,500 loans** across 2023, 2024, and 2025, with annual application counts of **808**, **837**, and **855**, respectively.
- The month with the highest total originated amount is **October 2024**, at **25,603,598.56 dataset units** across 76 loans.
- The month with the lowest total originated amount is **April 2023**, at **16,038,571.99 dataset units** across 57 loans.
- **748 borrowers** have more than one loan in the loan table. The maximum number of loans linked to a single borrower is **9**.

### Business implication
Monthly originations can help track lending activity, while multiple-loan analysis can help examine borrower-level exposure concentration. Do not interpret a change in originations as a change in credit quality without analyzing loan performance as well.

## 8. Data quality and reconciliation checks

The structured CSVs were checked for basic relational and completeness issues:

- The borrowers table contains **1,200 rows** and no duplicate `borrower_id` values.
- The loan table contains **2,500 rows** and no duplicate `loan_id` values.
- No missing values were found in the structured CSV columns checked.
- Every `borrower_id` in the loan table matched a borrower record in the borrower table.

### Important reconciliation item
The `default_flag` and `loan_status` fields are not identical measures in the supplied data:

- `loan_status = 'Default'`: **61 loans**
- `default_flag = 1`: **137 loans**
- The additional flagged defaults appear in the `Delinquent` status group.

This may be intentional in the synthetic dataset, but it must be confirmed before reporting. Define whether `default_flag` represents a formal default event, a delinquency threshold, or another rule. Do not use `loan_status = 'Default'` and `default_flag = 1` interchangeably until reconciled.

## 9. Recommended Power BI dashboard visuals

1. **KPI cards:** Total loans, total originated amount, outstanding exposure, observed default rate.
2. **Bar chart:** Observed default rate by credit score band.
3. **Column chart:** Outstanding exposure by DPD bucket.
4. **Bar chart:** Observed default rate by DTI band.
5. **Regional bar chart or map:** Loan count, exposure, and observed default rate by region.
6. **Matrix:** Employment type by region with loan count, exposure, and observed default rate.
7. **Line chart:** Monthly originations and month-over-month change.
8. **Detail table:** Loan ID, borrower ID, credit score, DTI, DPD, outstanding balance, and status for review.

For the dashboard, label rates as **Observed Default Rate** and clearly state the denominator used. Consider suppressing or flagging segments with very small sample sizes.

## 10. Limitations

- This is synthetic learning data, not actual lender or customer information.
- Observed segment rates are descriptive and do not establish causation.
- This project does not estimate a validated PD, Loss Given Default (LGD), or Expected Credit Loss (ECL).
- No recovery amounts, collateral values, or validated loss assumptions are supplied for LGD/ECL calculations.
- Monetary units and the formal default definition should be confirmed in the data dictionary before using currency labels or interpreting default metrics.

## 11. Final conclusion

The analysis demonstrates how SQL can be used to profile a loan portfolio, validate data quality, measure outstanding exposure, compare observed default rates across credit score and DTI bands, examine delinquency, and track monthly originations. The key portfolio signals in this synthetic dataset are the elevated observed default rate in the lowest credit-score band, the higher rate in the 40%–59.99% DTI segment, and the concentration of overdue exposure in loans above 30 DPD.

The next step is to reproduce these metrics in PostgreSQL, verify them against the queries, and build a Power BI dashboard that allows users to filter by date, region, credit score, DTI, loan status, and delinquency bucket.
