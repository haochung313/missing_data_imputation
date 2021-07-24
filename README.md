# missing_data_imputation
Impute missing data by Multiple Imputation by Chained Equations ( MICE )

# Overview:

This is a mortgate loan dataset that has 8000 observations and 16 columns. 
There are some missing data exists in the features of the dastaset, and the goal of this project is to the missing data. 
The features of the dataset contains both numerical and dummy variables; therefore, simply replacing the mean to the missing values may not be a ideal solution. 
MICE package in R provides various types of algorithms to impute the missing data. 
It allows user to choose which algorithms to use for each column.
Since the dummy columns are binary variables, I decided to impute the dummy columns with logistic regression.
On the other hand, for the numerical columns, I applied random forest to impute the missing values. 


- Strengths:
  - Using model based approach to impute missing data. Unlike replacing missing values with mean or mode of a single column, MICE utilizes other features in the dataset to predict the missing values. 
- Weaknesses:
  - Adding a layer of complexity to build model to prepare for dataset, so it can be used for further analysis. 
- Assumptions:
  - Data are missing at random.
  - The missing values can be predicted by other features within the dataset. 




| Column names | Description | 
| ------------ | ----------- |
sdq| Severe Delinquency
ltv| Loan to Value Ratio
intrt| Interest Rate on the Mortgage
bal| Balance of the Loan
lien| Whether it is a first or second lien on the home
cltv| Combined LTV Ratio
dti| Debt to Income Ratio
Margin| Margin on an Adjustable Rate Mortgage (0 if it is a fixed rate mortgage)
fico| FICO Score
term| Term of the Mortgage Loan
arm| Dummy for if it is an Adjustable Rate Mortgage
prepaype| Dummy for if there is a pre-payment penalty
balloon| Dummy for if there is a balloon payment
io| Dummy for if it is an Interest Only Mortgage
pmi| Dummy for if the borrower had to take Private Mortgage Insurance
negam| Dummy for if it is a Negative Amortizing Loan
