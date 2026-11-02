-- Credit Risk Analytics | PostgreSQL 15+
-- Run in pgAdmin Query Tool. Creates a dedicated schema and clean relational tables.
CREATE SCHEMA IF NOT EXISTS credit_risk;

DROP TABLE IF EXISTS credit_risk.loan_applications CASCADE;
DROP TABLE IF EXISTS credit_risk.borrowers CASCADE;

CREATE TABLE credit_risk.borrowers (
    borrower_id VARCHAR(30) PRIMARY KEY,
    borrower_name VARCHAR(100) NOT NULL,
    region VARCHAR(30),
    annual_income NUMERIC(14,2) CHECK (annual_income IS NULL OR annual_income >= 0),
    employment_type VARCHAR(40),
    home_ownership VARCHAR(30),
    city VARCHAR(60)
);

CREATE TABLE credit_risk.loan_applications (
    loan_id VARCHAR(30) PRIMARY KEY,
    borrower_id VARCHAR(30) NOT NULL,
    application_date DATE,
    loan_amount NUMERIC(14,2) CHECK (loan_amount IS NULL OR loan_amount >= 0),
    applicant_annual_income NUMERIC(14,2) CHECK (applicant_annual_income IS NULL OR applicant_annual_income >= 0),
    credit_score SMALLINT CHECK (credit_score IS NULL OR credit_score BETWEEN 300 AND 850),
    debt_to_income_ratio NUMERIC(6,4) CHECK (debt_to_income_ratio IS NULL OR debt_to_income_ratio BETWEEN 0 AND 1),
    interest_rate NUMERIC(6,3) CHECK (interest_rate IS NULL OR interest_rate BETWEEN 0 AND 100),
    outstanding_balance NUMERIC(14,2) CHECK (outstanding_balance IS NULL OR outstanding_balance >= 0),
    days_past_due SMALLINT CHECK (days_past_due IS NULL OR days_past_due >= 0),
    loan_status VARCHAR(30) NOT NULL CHECK (loan_status IN ('Current','Delinquent','Default','Closed')),
    default_flag SMALLINT CHECK (default_flag IN (0,1)),
    CONSTRAINT fk_loan_borrower
        FOREIGN KEY (borrower_id) REFERENCES credit_risk.borrowers(borrower_id)
);

CREATE INDEX idx_loan_borrower ON credit_risk.loan_applications(borrower_id);
CREATE INDEX idx_loan_date ON credit_risk.loan_applications(application_date);
CREATE INDEX idx_loan_status ON credit_risk.loan_applications(loan_status);

-- After creating the tables, import the two structured CSV files:
-- borrowers.csv -> credit_risk.borrowers
-- loan_applications.csv -> credit_risk.loan_applications
-- In pgAdmin: right-click table > Import/Export Data > Import > CSV > Header = Yes.
