# missing_data_imputation
Impute missing data by Multiple Imputation by Chained Equations ( MICE )

This is a mortgate loan dataset contains 8000 observations and 16 columns. 

| Column names | Description | 
| ------------ | ----------- |
sdq| Severe Delinquency
ltv: Loan to Value Ratio
- intrt: Interest Rate on the Mortgage
- bal: Balance of the Loan
- lien: Whether it is a first or second lien on the home
- cltv: Combined LTV Ratio
- dti: Debt to Income Ratio
- Margin: Margin on an Adjustable Rate Mortgage (0 if it is a fixed rate mortgage)
- fico: FICO Score
- term: Term of the Mortgage Loan
- arm: Dummy for if it is an Adjustable Rate Mortgage
- prepaype: Dummy for if there is a pre-payment penalty
- balloon: Dummy for if there is a balloon payment
- io: Dummy for if it is an Interest Only Mortgage
- pmi: Dummy for if the borrower had to take Private Mortgage Insurance
- negam: Dummy for if it is a Negative Amortizing Loan
