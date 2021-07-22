data = read.csv('mortloan_samp19.csv')
head(data) 
summary(data)

# Create a vector for binary data column
col = c("lien", "arm", "prepaype", "balloon", "io", "pmi", "negam")
df = data.frame(data)
# Set binary data column from numeric to factor 
df[col] =lapply(df[col], as.factor)
# Set missing data in 'Margin' column equal to 0. 
df$Margin[is.na(df$Margin)] = 0 
head(df)
# To oberve how many NA's in each column
summary(df) 

# install.packages('mice')
library(mice)
library(randomForest)
# Missing data imputation method:
  # 1. Generate 5 imputed datasets, m =5
  # 2. Impute numeric data column with random forest: 'rf'
  # 3. Impute binary data column with logistic regression: 'logreg'
imp_data = mice(df, m =5, method = c('', 'rf', '', '', 'logreg', 
                                     'rf', 'rf', '', 'rf','rf',
                                     '', 'logreg', '', 'logreg', 'logreg', 'logreg'),
                maxit = 5, seed = 100)
summary(imp_data)
head(imp_data$imp$io)

# Since m is set equal to 5, there are 5 imputed datasets.
# Randomly choose the second dataset
clean_data = complete(imp_data, 2)
summary(clean_data)

## plot the imputed data. Red ones are the 5 imputed data
stripplot(imp_data, pch = 20, cex =1.2)
densityplot(imp_data)

# Export data to csv format
write.csv(clean_data, file = 'cleaned_data.csv')
