# Credit Risk Analytics | SQL & Power BI

## Project Overview
This project analyses a loan portfolio to understand credit risk, borrower characteristics, repayment behaviour, delinquency, and outstanding exposure. Using PostgreSQL for data validation and analysis and Power BI for visual reporting, the project turns loan-level data into insights that can support portfolio monitoring and risk-based decision-making.

> **Dataset note:** The project dataset is synthetic and intended for portfolio demonstration. Monetary values are shown in dataset units because the source data does not specify a currency. Observed default rates are descriptive metrics, not calibrated probabilities of default.

## Business Objectives
- Measure portfolio size, originated amount, and outstanding exposure.
- Analyse observed default rates across credit-score, debt-to-income (DTI), employment, and regional segments.
- Monitor delinquency by days-past-due (DPD) buckets and identify loans more than 30 days past due.
- Track monthly loan originations and changes over time.
- Review data quality, borrower-level loan concentration, and consistency between loan status and default indicators.
- Present the findings in a decision-oriented Power BI dashboard.

## Tools & Technologies
- **PostgreSQL** — SQL analysis, joins, aggregations, CTEs, window functions, ranking, date analysis, and data-quality checks.
- **Power BI** — KPI cards, segment comparisons, trend analysis, slicers, and portfolio-risk visualisations.
- **Excel / CSV** — source data review and dataset handling.

## Dataset
The project contains borrower-profile and loan-application data.

| Dataset | Purpose |
|---|---|
| `borrowers.csv` | Borrower attributes such as credit score, income, employment, DTI, and region |
| `loan_applications.csv` | Loan attributes such as loan amount, interest rate, status, outstanding balance, DPD, and default indicator |
| Raw CSV files | Intentionally messy source versions for data-cleaning practice |

See `02_structured_data/DATA_DICTIONARY.md` for field definitions and `01_raw_data/` for the raw source files.

## Key Analysis
1. **Portfolio overview** — loan count, total originated amount, outstanding exposure, and average interest rate.
2. **Credit-score risk segmentation** — compare observed default rates and exposure across score bands.
3. **Affordability analysis** — examine default patterns by DTI bands.
4. **Delinquency monitoring** — assess loan counts and exposure across DPD buckets, including accounts over 30 DPD.
5. **Segment analysis** — compare outcomes by region and employment type.
6. **Origination trends** — review monthly lending volume and month-over-month changes.
7. **Borrower concentration** — identify borrowers with multiple loans and analyse loan-level concentration.
8. **Data-quality controls** — test for duplicate identifiers, missing values, unmatched borrower records, and inconsistent status/default indicators.

## Selected Findings
The current structured dataset contains **2,500 loans** and **1,200 borrower records**. Analysis identified the following descriptive patterns:

- **5.48% observed default-flag rate** across the loan records.
- Loans with **more than 30 days past due** account for 340 records and approximately **54.78 million dataset units** in outstanding exposure.
- The below-580 credit-score segment has a **15.83% observed default rate**, higher than the other score bands in this dataset.
- The 40–59.99% DTI segment has an **8.06% observed default rate**, compared with **4.68%** for borrowers below 20% DTI.
- The North region has a **7.51% observed default rate**, while the South region has **2.69%**.
- A data consistency check found **61 loans marked `Default` by loan status versus 137 loans with `default_flag = 1`**. This should be investigated before using the metrics for operational decisions.

These findings describe the synthetic dataset and should not be interpreted as evidence of real-world credit performance or causation. See `04_insights/INSIGHTS.md` for detailed segment results, caveats, and dashboard recommendations.

## Project Structure
```text
credit-risk-analytics/
├── 01_raw_data/
│   ├── raw_borrower_profiles.csv
│   └── raw_loan_applications.csv
├── 02_structured_data/
│   ├── borrowers.csv
│   ├── loan_applications.csv
│   └── DATA_DICTIONARY.md
├── 03_sql/
│   ├── 00_staging_schema.sql
│   ├── 01_schema.sql
│   ├── 02_credit_risk_queries.sql
│   └── RUN_GUIDE.md
├── 04_insights/
│   └── INSIGHTS.md
├── 05_readme/
│   ├── README.md
│   └── PORTFOLIO_NOTES.md
└── README.md
```

## How to Run
1. Create a PostgreSQL database for the project.
2. Open and run `03_sql/00_staging_schema.sql` to create staging tables.
3. Import the raw CSV files into the corresponding staging tables, following `03_sql/RUN_GUIDE.md`.
4. Run `03_sql/01_schema.sql` to create the structured tables.
5. Import the cleaned CSV files into `borrowers` and `loan_applications`, or follow the load steps in the run guide.
6. Execute the analysis queries in `03_sql/02_credit_risk_queries.sql`.
7. Connect Power BI Desktop to PostgreSQL or import the structured CSV files, then build visuals for portfolio KPIs, risk segmentation, delinquency, and origination trends.

**Important:** Confirm the exact table and column names in the SQL files and run guide match your database before running the queries. Do not publish database passwords or connection credentials.

## Suggested Power BI Dashboard
- KPI cards: total loans, originated amount, outstanding exposure, observed default rate, and loans over 30 DPD.
- Credit risk: observed default rate by credit-score band and DTI band.
- Portfolio segments: exposure and observed default rate by region and employment type.
- Delinquency: loan count and outstanding exposure by DPD bucket.
- Trends: monthly originations and month-over-month change.
- Slicers: origination date, region, employment type, credit-score band, and loan status.

## Limitations
- The dataset is synthetic and has no confirmed real-world representativeness.
- Currency is not specified; monetary values are therefore reported in dataset units.
- The default indicator and loan-status field are inconsistent and require a business-rule decision.
- The project does not estimate calibrated probability of default (PD), loss given default (LGD), or expected credit loss (ECL), because the required validated data and modelling assumptions are not provided.

## Skills Demonstrated
**SQL:** joins, aggregations, CTEs, window functions, ranking, date-based analysis, segmentation, data validation, and risk metrics.  
**Power BI:** KPI design, trend analysis, segmentation, interactive filtering, and dashboard storytelling.  
**Finance & Analytics:** credit-risk monitoring, portfolio exposure analysis, delinquency review, and data-driven recommendations.

---
*Created as a portfolio project to demonstrate SQL, Power BI, and finance analytics skills.*
