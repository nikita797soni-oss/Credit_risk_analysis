-- ============================================================
-- CREDIT RISK ANALYTICS PROJECT
-- 20 PostgreSQL Queries | SQL + Power BI Portfolio Project
-- ============================================================
-- Tables:
--   credit_risk.borrowers
--   credit_risk.loan_applications
--
-- Columns:
-- borrowers:
--   borrower_id, region, employment_type
--
-- loan_applications:
--   loan_id, borrower_id, application_date, loan_amount,
--   outstanding_balance, credit_score, debt_to_income_ratio,
--   interest_rate, loan_status, days_past_due, default_flag

-- ============================================================
-- SECTION 1: PORTFOLIO OVERVIEW AND DATA QUALITY
-- ============================================================

-- Query 01: Calculate key portfolio KPIs
SELECT
    COUNT(*) AS total_loans,
    COUNT(DISTINCT borrower_id) AS unique_borrowers,
    SUM(loan_amount) AS total_originated_amount,
    SUM(outstanding_balance) AS total_outstanding_exposure,
    ROUND(AVG(interest_rate), 2) AS average_interest_rate
FROM credit_risk.loan_applications;


-- Query 02: Identify duplicate loan IDs
SELECT
    loan_id,
    COUNT(*) AS record_count
FROM credit_risk.loan_applications
GROUP BY loan_id
HAVING COUNT(*) > 1
ORDER BY record_count DESC;


-- Query 03: Find records with missing or invalid values
SELECT *
FROM credit_risk.loan_applications
WHERE borrower_id IS NULL
   OR loan_amount IS NULL
   OR loan_amount <= 0
   OR outstanding_balance < 0
   OR (credit_score IS NOT NULL
       AND credit_score NOT BETWEEN 300 AND 850)
   OR days_past_due < 0;


-- ============================================================
-- SECTION 2: LOAN PORTFOLIO ANALYSIS
-- ============================================================

-- Query 04: Loan count and outstanding exposure by loan status
SELECT
    loan_status,
    COUNT(*) AS loan_count,
    SUM(outstanding_balance) AS outstanding_exposure
FROM credit_risk.loan_applications
GROUP BY loan_status
ORDER BY outstanding_exposure DESC NULLS LAST;


-- Query 05: Top 10 loans by outstanding balance
SELECT
    loan_id,
    borrower_id,
    loan_amount,
    outstanding_balance,
    loan_status
FROM credit_risk.loan_applications
ORDER BY outstanding_balance DESC NULLS LAST
LIMIT 10;


-- Query 06: Monthly loan originations
SELECT
    DATE_TRUNC('month', application_date)::DATE AS application_month,
    COUNT(*) AS loan_count,
    SUM(loan_amount) AS total_originated_amount
FROM credit_risk.loan_applications
WHERE application_date IS NOT NULL
GROUP BY 1
ORDER BY 1;


-- ============================================================
-- SECTION 3: CREDIT RISK AND DEFAULT ANALYSIS
-- ============================================================

-- Query 07: Observed default rate by credit score band
SELECT
    CASE
        WHEN credit_score < 580 THEN 'Below 580'
        WHEN credit_score < 670 THEN '580-669'
        WHEN credit_score < 740 THEN '670-739'
        WHEN credit_score <= 850 THEN '740-850'
        ELSE 'Unknown'
    END AS credit_score_band,
    COUNT(*) AS total_loans,
    COUNT(*) FILTER (WHERE default_flag = 1) AS defaulted_loans,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE default_flag = 1)
        / NULLIF(
            COUNT(*) FILTER (WHERE default_flag IN (0, 1)),
            0
        ),
        2
    ) AS observed_default_rate_pct
FROM credit_risk.loan_applications
WHERE credit_score BETWEEN 300 AND 850
GROUP BY 1
ORDER BY 1;


-- Query 08: Observed default rate by employment type
SELECT
    b.employment_type,
    COUNT(l.loan_id) AS total_loans,
    COUNT(*) FILTER (WHERE l.default_flag = 1) AS defaulted_loans,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE l.default_flag = 1)
        / NULLIF(
            COUNT(*) FILTER (WHERE l.default_flag IN (0, 1)),
            0
        ),
        2
    ) AS observed_default_rate_pct
FROM credit_risk.borrowers AS b
JOIN credit_risk.loan_applications AS l
    ON b.borrower_id = l.borrower_id
GROUP BY b.employment_type
ORDER BY observed_default_rate_pct DESC NULLS LAST;


-- Query 09: Observed default rate by region
SELECT
    b.region,
    COUNT(l.loan_id) AS total_loans,
    COUNT(*) FILTER (WHERE l.default_flag = 1) AS defaulted_loans,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE l.default_flag = 1)
        / NULLIF(
            COUNT(*) FILTER (WHERE l.default_flag IN (0, 1)),
            0
        ),
        2
    ) AS observed_default_rate_pct
FROM credit_risk.borrowers AS b
JOIN credit_risk.loan_applications AS l
    ON b.borrower_id = l.borrower_id
GROUP BY b.region
ORDER BY observed_default_rate_pct DESC NULLS LAST;


-- Query 10: Classify loans by days past due (DPD)
WITH delinquency AS (
    SELECT
        CASE
            WHEN days_past_due = 0 THEN 'Current'
            WHEN days_past_due BETWEEN 1 AND 30 THEN '1-30 DPD'
            WHEN days_past_due BETWEEN 31 AND 60 THEN '31-60 DPD'
            WHEN days_past_due BETWEEN 61 AND 90 THEN '61-90 DPD'
            WHEN days_past_due > 90 THEN '90+ DPD'
            ELSE 'Unknown'
        END AS delinquency_bucket,
        outstanding_balance,
        days_past_due
    FROM credit_risk.loan_applications
)
SELECT
    delinquency_bucket,
    COUNT(*) AS loan_count,
    SUM(outstanding_balance) AS outstanding_exposure
FROM delinquency
GROUP BY delinquency_bucket
ORDER BY
    CASE delinquency_bucket
        WHEN 'Current' THEN 1
        WHEN '1-30 DPD' THEN 2
        WHEN '31-60 DPD' THEN 3
        WHEN '61-90 DPD' THEN 4
        WHEN '90+ DPD' THEN 5
        ELSE 6
    END;


-- Query 11: List loans overdue by more than 30 days
SELECT
    loan_id,
    borrower_id,
    outstanding_balance,
    days_past_due,
    loan_status
FROM credit_risk.loan_applications
WHERE days_past_due > 30
ORDER BY days_past_due DESC,
         outstanding_balance DESC NULLS LAST;


-- ============================================================
-- SECTION 4: BORROWER AND FINANCIAL RISK ANALYSIS
-- ============================================================

-- Query 12: Average interest rate and loan amount by credit score band
SELECT
    CASE
        WHEN credit_score < 580 THEN 'Below 580'
        WHEN credit_score < 670 THEN '580-669'
        WHEN credit_score < 740 THEN '670-739'
        WHEN credit_score <= 850 THEN '740-850'
        ELSE 'Unknown'
    END AS credit_score_band,
    COUNT(*) AS loan_count,
    ROUND(AVG(interest_rate), 2) AS average_interest_rate,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM credit_risk.loan_applications
WHERE credit_score BETWEEN 300 AND 850
GROUP BY 1
ORDER BY 1;


-- Query 13: Exposure by region and employment type
SELECT
    b.region,
    b.employment_type,
    COUNT(l.loan_id) AS total_loans,
    SUM(l.loan_amount) AS total_loan_amount,
    SUM(l.outstanding_balance) AS outstanding_exposure
FROM credit_risk.borrowers AS b
LEFT JOIN credit_risk.loan_applications AS l
    ON b.borrower_id = l.borrower_id
GROUP BY b.region, b.employment_type
ORDER BY outstanding_exposure DESC NULLS LAST;


-- Query 14: Borrowers with multiple loans
SELECT
    borrower_id,
    COUNT(*) AS total_loans,
    SUM(loan_amount) AS total_borrowed_amount,
    SUM(outstanding_balance) AS total_outstanding_exposure
FROM credit_risk.loan_applications
GROUP BY borrower_id
HAVING COUNT(*) > 1
ORDER BY total_outstanding_exposure DESC NULLS LAST;


-- Query 15: Outstanding balance as a percentage of original loan amount
SELECT
    loan_id,
    borrower_id,
    loan_amount,
    outstanding_balance,
    ROUND(
        100.0 * outstanding_balance / NULLIF(loan_amount, 0),
        2
    ) AS outstanding_pct_of_original_loan
FROM credit_risk.loan_applications
WHERE loan_amount > 0
ORDER BY outstanding_pct_of_original_loan DESC NULLS LAST;


-- ============================================================
-- SECTION 5: WINDOW FUNCTIONS, CTES AND TREND ANALYSIS
-- ============================================================

-- Query 16: Rank loans by outstanding exposure
SELECT
    loan_id,
    borrower_id,
    outstanding_balance,
    RANK() OVER (
        ORDER BY outstanding_balance DESC NULLS LAST
    ) AS exposure_rank
FROM credit_risk.loan_applications
ORDER BY exposure_rank, loan_id;


-- Query 17: Cumulative monthly loan originations
WITH monthly_originations AS (
    SELECT
        DATE_TRUNC('month', application_date)::DATE AS month,
        SUM(loan_amount) AS monthly_amount
    FROM credit_risk.loan_applications
    WHERE application_date IS NOT NULL
    GROUP BY 1
)
SELECT
    month,
    monthly_amount,
    SUM(monthly_amount) OVER (
        ORDER BY month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_originations
FROM monthly_originations
ORDER BY month;


-- Query 18: Month-over-month change in loan originations
WITH monthly_originations AS (
    SELECT
        DATE_TRUNC('month', application_date)::DATE AS month,
        SUM(loan_amount) AS monthly_amount
    FROM credit_risk.loan_applications
    WHERE application_date IS NOT NULL
    GROUP BY 1
),
monthly_comparison AS (
    SELECT
        month,
        monthly_amount,
        LAG(monthly_amount) OVER (ORDER BY month) AS previous_month_amount
    FROM monthly_originations
)
SELECT
    month,
    monthly_amount,
    previous_month_amount,
    ROUND(
        100.0 * (monthly_amount - previous_month_amount)
        / NULLIF(previous_month_amount, 0),
        2
    ) AS mom_change_pct
FROM monthly_comparison
ORDER BY month;


-- Query 19: Flag loans for additional risk review
-- These are illustrative screening rules, not a validated lending policy.
SELECT
    loan_id,
    borrower_id,
    credit_score,
    debt_to_income_ratio,
    days_past_due,
    outstanding_balance,
    default_flag,
    CASE
        WHEN days_past_due > 30 THEN 'Delinquency review'
        WHEN credit_score < 580
             AND debt_to_income_ratio > 0.40 THEN 'Multiple risk indicators'
        WHEN credit_score < 580 THEN 'Low credit score review'
        WHEN debt_to_income_ratio > 0.40 THEN 'High DTI review'
        ELSE 'Other review'
    END AS review_reason
FROM credit_risk.loan_applications
WHERE days_past_due > 30
   OR credit_score < 580
   OR debt_to_income_ratio > 0.40
ORDER BY days_past_due DESC NULLS LAST,
         outstanding_balance DESC NULLS LAST;


-- Query 20: Observed default rate and exposure by DTI band
SELECT
    CASE
        WHEN debt_to_income_ratio < 0.20 THEN 'Below 20%'
        WHEN debt_to_income_ratio < 0.40 THEN '20%-39.99%'
        WHEN debt_to_income_ratio <= 0.60 THEN '40%-60%'
        ELSE 'Above 60%'
    END AS dti_band,
    COUNT(*) AS total_loans,
    COUNT(*) FILTER (WHERE default_flag = 1) AS defaulted_loans,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE default_flag = 1)
        / NULLIF(
            COUNT(*) FILTER (WHERE default_flag IN (0, 1)),
            0
        ),
        2
    ) AS observed_default_rate_pct,
    SUM(outstanding_balance) AS outstanding_exposure
FROM credit_risk.loan_applications
WHERE debt_to_income_ratio >= 0
GROUP BY 1
ORDER BY
    CASE
        WHEN MIN(debt_to_income_ratio) < 0.20 THEN 1
        WHEN MIN(debt_to_income_ratio) < 0.40 THEN 2
        WHEN MIN(debt_to_income_ratio) <= 0.60 THEN 3
        ELSE 4
    END;
