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

# Train-test split before missing data imputation
library(caTools)
set.seed(123)
sample = sample.split(df, SplitRatio = 0.7)
train.set = subset(df, sample == TRUE)
test.set = subset(df, sample == FALSE)
dim(train.set)
dim(test.set)

# Impute missing data in the train set
library(mice)
library(randomForest)
# Missing data imputation method:
  # 1. Generate 5 imputed datasets, m =5
  # 2. Impute numeric data column with random forest: 'rf'
  # 3. Impute binary data column with logistic regression: 'logreg'
imp.train = mice(train.set, m =5, method = c('', 'rf', '', '', 'logreg', 
                                     'rf', 'rf', '', 'rf','rf',
                                     '', 'logreg', '', 'logreg', 'logreg', 'logreg'),
                maxit = 5, seed = 100)
summary(imp.train)
head(imp.train$imp$io)

# Since m is set equal to 5, there are 5 imputed datasets.
df.train1 = complete(imp.train, 1)
df.train2 = complete(imp.train, 2)
df.train3 = complete(imp.train, 3)
df.train4 = complete(imp.train, 4)
df.train5 = complete(imp.train, 5)
dim(df.train1)

# To predict servere loan delinquent,
# fit logistic regression imputed datasets
# to see which dataset has the best fit. 
logit = function(df){
  set.seed(123)
  sample = sample.split(df, SplitRatio = 0.7)
  train = subset(df, sample == TRUE)
  test = subset(df, sample == FALSE)
  model = glm(sdq~., family = binomial(link = 'logit'), data = train)
  fitted.prob = predict(model, test, type = 'response')
  fitted.result = ifelse(fitted.prob > 0.5, 1, 0)
  missclasserror = mean(fitted.result != test$sdq)
  print(paste('Accuracy', 1- missclasserror))
  return(summary(model))
}

# Based on the model accuracy and AIC, 
# it seems that there are no significant differences among these five imputed datasets 
logit(df.train1) # Accuracy = 0.8708, AIC = 2561.6
logit(df.train2) # Accuracy = 0.8702, AIC = 2558.5
logit(df.train3) # Accuracy = 0.8696, AIC = 2562.6
logit(df.train4) # Accuracy = 0.8708, AIC = 2564.9
logit(df.train5) # Accuracy = 0.8702, AIC = 2563.9

# Plot the imputed data. Red ones are the 5 imputed data
stripplot(imp.train, pch = 20, cex =1.2)
densityplot(imp.train)


## Impute missing data in the test set
imp.test = mice(test.set, m =5, method = c('', 'rf', '', '', 'logreg', 
                                             'rf', 'rf', '', 'rf','rf',
                                             '', 'logreg', '', 'logreg', 'logreg', 'logreg'),
                 maxit = 5, seed = 100)
summary(imp.test)

# Since m is set equal to 5, there are 5 imputed datasets.
df.test1 = complete(imp.test, 1)
df.test2 = complete(imp.test, 2)
df.test3 = complete(imp.test, 3)
df.test4 = complete(imp.test, 4)
df.test5 = complete(imp.test, 5)
dim(df.test1)

# Fit logistic regression to imputed test set datasets to see which one has better performance
logit(df.test1) # Accuracy = 0.8591, AIC = 1254
logit(df.test2) # Accuracy = 0.8553, AIC = 1253
logit(df.test3) # Accuracy = 0.8553, AIC = 1254.9
logit(df.test4) # Accuracy = 0.8578, AIC = 1245.2
logit(df.test5) # Accuracy = 0.8591, AIC = 1250

# Combine the df.train2 and df.test4 into a complete dataset
clean_data = rbind(df.train2, df.test4)
dim(clean_data)
head(clean_data)
summary(clean_data)

# Export dataset to csv format
write.csv(clean_data, file = 'cleaned_data.csv')
