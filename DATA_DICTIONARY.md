# Data Dictionary

## borrowers.csv
| Column | Type | Meaning |
|---|---|---|
| borrower_id | text (PK) | Unique synthetic borrower identifier |
| borrower_name | text | Synthetic borrower label |
| region | text | Broad region |
| annual_income | numeric INR/year | Annual income |
| employment_type | text | Employment category |
| home_ownership | text | Housing status category |
| city | text | Synthetic location field |

## loan_applications.csv
| Column | Type | Meaning |
|---|---|---|
| loan_id | text (PK) | Unique synthetic loan identifier |
| borrower_id | text (FK) | Links to borrowers.borrower_id |
| application_date | date | Application date |
| loan_amount | numeric INR | Original loan amount |
| applicant_annual_income | numeric INR/year | Income recorded on loan application |
| credit_score | integer | Synthetic score between 300 and 850 |
| debt_to_income_ratio | decimal | Ratio from 0 to 1; 0.35 means 35% |
| interest_rate | decimal percent | Annual interest rate in percentage points |
| outstanding_balance | numeric INR | Current synthetic outstanding balance |
| days_past_due | integer | Synthetic days past due |
| loan_status | category | Current, Delinquent, Default, Closed |
| default_flag | 0/1 | Synthetic generated default indicator |

All data are synthetic. Values and relationships are designed for learning and should not be used for real credit decisions.
