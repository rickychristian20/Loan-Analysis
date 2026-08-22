  ============================================================
   BANK LOAN ANALYSIS
   ============================================================  


  ============================================================
   BUSINESS QUESTION 1
   How is the overall loan portfolio performing?
   ============================================================  


  1. Total Loan Accounts  
SELECT
    COUNT(*) AS total_loan_account
FROM project.loan;


  2. Total Loan Amount  
SELECT
    SUM(loan_amnt) AS total_loan_amount
FROM project.loan;


  3. Total Approved Accounts  
SELECT
    COUNT(*) FILTER (WHERE loan_status = 1) AS total_approved
FROM project.loan;


  4. Approval Rate  
SELECT
    ROUND(
        COUNT(*) FILTER (WHERE loan_status = 1) * 100.0
        / COUNT(*),
        2
    ) AS approval_rate
FROM project.loan;


  5. Total Rejected Accounts  
SELECT
    COUNT(*) FILTER (WHERE loan_status = 0) AS total_rejected
FROM project.loan;


  6. Rejection Rate  
SELECT
    ROUND(
        COUNT(*) FILTER (WHERE loan_status = 0) * 100.0
        / COUNT(*),
        2
    ) AS rejection_rate
FROM project.loan;


  7. Average Loan Amount  
SELECT
    ROUND(AVG(loan_amnt), 2) AS avg_loan_amount
FROM project.loan;


  8. Average Customer Income  
SELECT
    ROUND(AVG(person_income), 2) AS avg_income
FROM project.loan;


  9. Average Interest Rate  
SELECT
    ROUND(AVG(loan_int_rate), 2) AS avg_interest_rate
FROM project.loan;



  ============================================================
   BUSINESS QUESTION 2
   What are the characteristics of customers who apply
   for loans the most?
   ============================================================  


  1. Loans by Age Group  
SELECT
    CASE
        WHEN person_age BETWEEN 20 AND 25 THEN '20 - 25'
        WHEN person_age BETWEEN 26 AND 30 THEN '26 - 30'
        WHEN person_age BETWEEN 31 AND 35 THEN '31 - 35'
        WHEN person_age BETWEEN 36 AND 40 THEN '36 - 40'
        WHEN person_age BETWEEN 41 AND 45 THEN '41 - 45'
        WHEN person_age BETWEEN 46 AND 50 THEN '46 - 50'
        ELSE '50+' 
    END AS age_group,
    COUNT(*) AS total_customer,
    COUNT(*) FILTER (WHERE loan_status = 1) AS approved_customer,
    ROUND(COUNT(*) FILTER (WHERE loan_status = 1) * 100.0 
        / COUNT(*),2) AS approved_percentage,
    COUNT(*) FILTER (WHERE loan_status = 0) AS rejected_customer,
    ROUND(COUNT(*) FILTER (WHERE loan_status = 0) * 100.0 
        / COUNT(*),2) AS rejected_percentage
FROM project.loan
GROUP BY 1
ORDER BY age_group ASC;

  2. Loans by Gender  
SELECT
    person_gender,
    COUNT(*) AS total_customer,
    SUM(loan_amnt) AS total_loan_amount
FROM project.loan
GROUP BY person_gender
ORDER BY total_customer DESC;


  3. Loans by Education Level  
SELECT
    person_education,
    COUNT(*) AS total_customer,
    SUM(loan_amnt) AS total_loan_amount
FROM project.loan
GROUP BY person_education
ORDER BY total_customer DESC;


  4. Average Income by Age Group  
SELECT
    CASE
        WHEN person_age BETWEEN 20 AND 25 THEN '20 - 25'
        WHEN person_age BETWEEN 26 AND 30 THEN '26 - 30'
        WHEN person_age BETWEEN 31 AND 35 THEN '31 - 35'
        WHEN person_age BETWEEN 36 AND 40 THEN '36 - 40'
        WHEN person_age BETWEEN 41 AND 45 THEN '41 - 45'
        WHEN person_age BETWEEN 46 AND 50 THEN '46 - 50'
        ELSE '50+'
    END AS age_group,
    COUNT(*) AS total_customer,
    ROUND(AVG(person_income), 2) AS avg_income
FROM project.loan
GROUP BY 1
ORDER BY total_customer DESC;


  5. Loans by Loan Purpose  
SELECT
    loan_intent,
    COUNT(*) AS total_customer,
    SUM(loan_amnt) AS total_loan_amount
FROM project.loan
GROUP BY loan_intent
ORDER BY total_customer DESC;



  ============================================================
   BUSINESS QUESTION 3
   What characteristics differentiate approved and
   rejected applicants?
   ============================================================  


  1. Approval by Credit Score  
SELECT
    CASE
        WHEN loan_status = 1 THEN 'Approved'
        WHEN loan_status = 0 THEN 'Rejected'
    END AS loan_status,
    COUNT(*) AS total_customer,
    ROUND(AVG(credit_score)) AS avg_credit_score,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM project.loan
GROUP BY loan_status
ORDER BY loan_status DESC;


  2. Approval by Income  
SELECT
    CASE
        WHEN loan_status = 1 THEN 'Approved'
        WHEN loan_status = 0 THEN 'Rejected'
    END AS loan_status,
    COUNT(*) AS total_customer,
    ROUND(AVG(person_income), 2) AS avg_income,
    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM project.loan
GROUP BY loan_status
ORDER BY loan_status DESC;


  3. Approval by Loan Amount  
SELECT
    CASE
        WHEN loan_status = 1 THEN 'Approved'
        WHEN loan_status = 0 THEN 'Rejected'
    END AS loan_status,
    COUNT(*) AS total_customer,
    ROUND(AVG(loan_amnt), 2) AS avg_loan_amount
FROM project.loan
GROUP BY loan_status
ORDER BY loan_status DESC;


  4. Approval by Loan-to-Income Ratio  
SELECT
    CASE
        WHEN loan_status = 1 THEN 'Approved'
        WHEN loan_status = 0 THEN 'Rejected'
    END AS loan_status,
    COUNT(*) AS total_customer,
    ROUND(
        AVG(loan_percent_income) * 100,
        2
    ) AS avg_loan_percent_income
FROM project.loan
GROUP BY loan_status
ORDER BY loan_status DESC;


  5. Approval by Previous Loan Default  
SELECT
    CASE
        WHEN loan_status = 1 THEN 'Approved'
        WHEN loan_status = 0 THEN 'Rejected'
    END AS loan_status,
    previous_loan_defaults_on_file,
    COUNT(*) AS total_customer,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (PARTITION BY loan_status),
        2
    ) AS percentage
FROM project.loan
GROUP BY
    loan_status,
    previous_loan_defaults_on_file
ORDER BY
    loan_status DESC,
    percentage DESC;


  6. Approval by Loan Purpose  
SELECT
    CASE
        WHEN loan_status = 1 THEN 'Approved'
        WHEN loan_status = 0 THEN 'Rejected'
    END AS loan_status,
    loan_intent,
    COUNT(*) AS total_customer,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (PARTITION BY loan_status),
        2
    ) AS percentage
FROM project.loan
GROUP BY
    loan_status,
    loan_intent
ORDER BY
    loan_status DESC,
    percentage DESC;



  ============================================================
   BUSINESS QUESTION 4
   What type of customer has the highest credit risk?
   ============================================================  


  1. Previous Loan Default  
SELECT
    previous_loan_defaults_on_file,
    COUNT(*) AS total_customer,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM project.loan
GROUP BY previous_loan_defaults_on_file
ORDER BY total_customer DESC;


  2. Loan-to-Income Group  
SELECT
    CASE
        WHEN loan_percent_income < 0.10 THEN '< 10%'
        WHEN loan_percent_income < 0.20 THEN '10% - 20%'
        WHEN loan_percent_income < 0.30 THEN '20% - 30%'
        ELSE '30%+'
    END AS loan_income_group,
    COUNT(*) AS total_customer,
    ROUND(
        AVG(loan_percent_income) * 100,
        2
    ) AS avg_loan_percent_income
FROM project.loan
GROUP BY 1
ORDER BY
    MIN(loan_percent_income);


  3. Credit History Length  
SELECT
    CASE
        WHEN cb_person_cred_hist_length < 3 THEN '< 3 years'
        WHEN cb_person_cred_hist_length BETWEEN 3 AND 5 THEN '3 - 5 years'
        WHEN cb_person_cred_hist_length BETWEEN 6 AND 10 THEN '6 - 10 years'
        ELSE '> 10 years'
    END AS credit_history_group,
    COUNT(*) AS total_customer
FROM project.loan
GROUP BY 1
ORDER BY
    MIN(cb_person_cred_hist_length);


  4. Credit Score Group  
SELECT
    CASE
        WHEN credit_score < 580 THEN '< 580'
        WHEN credit_score BETWEEN 580 AND 669 THEN '580 - 669'
        WHEN credit_score BETWEEN 670 AND 739 THEN '670 - 739'
        ELSE '740+'
    END AS credit_score_group,
    COUNT(*) AS total_customer,
    ROUND(
        AVG(loan_percent_income) * 100,
        2
    ) AS avg_loan_percent_income
FROM project.loan
GROUP BY 1
ORDER BY
    MIN(credit_score);


  5. Credit Score vs Previous Loan Default  
SELECT
    previous_loan_defaults_on_file,
    COUNT(*) AS total_customer,
    ROUND(AVG(credit_score)) AS avg_credit_score,
    ROUND(
        AVG(loan_percent_income) * 100,
        2
    ) AS avg_loan_percent_income
FROM project.loan
GROUP BY previous_loan_defaults_on_file
ORDER BY total_customer DESC;


  6. High-Risk Customers  
    SELECT
        COUNT(*) AS high_risk_customer,
        ROUND(
            COUNT(*) * 100.0 /
            (SELECT COUNT(*) FROM project.loan),
            2
        ) AS high_risk_percentage,
        ROUND(AVG(person_income), 2) AS avg_income,
        ROUND(AVG(loan_amnt), 2) AS avg_loan_amount,
        ROUND(AVG(credit_score)) AS avg_credit_score,
        ROUND(
            AVG(loan_percent_income) * 100,
            2
        ) AS avg_loan_percent_income
    FROM project.loan
    WHERE credit_score < 580
    AND previous_loan_defaults_on_file = 'Yes'
    AND loan_percent_income >= 0.30;



  ============================================================
   BUSINESS QUESTION 5
   How can the company improve loan approval decisions
   and reduce credit risk?
   ============================================================  


  1. Risk Segmentation  
SELECT
    CASE
        WHEN credit_score < 580
             AND previous_loan_defaults_on_file = 'Yes'
             AND loan_percent_income >= 0.30
            THEN 'High Risk'
        WHEN credit_score < 670
             OR previous_loan_defaults_on_file = 'Yes'
             OR loan_percent_income >= 0.20
            THEN 'Medium Risk'
        ELSE 'Low Risk'
    END AS risk_level,
    COUNT(*) AS total_customer,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage,
    ROUND(AVG(credit_score)) AS avg_credit_score,
    ROUND(AVG(person_income), 2) AS avg_income,
    ROUND(
        AVG(loan_percent_income) * 100,2) AS avg_loan_percent_income
FROM project.loan
GROUP BY 1;