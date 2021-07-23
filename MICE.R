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
df1 = complete(imp_data, 1)
df2 = complete(imp_data, 2)
df3 = complete(imp_data, 3)
df4 = complete(imp_data, 4)
df5 = complete(imp_data, 5)

# Since the goal is to predict servere loan delinquent,
# I decided to fit logistic regression to these 5 imputed datasets
# to see which dataset has the best fit. 
library(caTools)
library(ROCR)

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
logit(df1) # Accuracy = 0.8524, AIC = 3683.9
logit(df2) # Accuracy = 0.852, AIC = 3675.3
logit(df3) # Accuracy = 0.8516, AIC = 3686.7
logit(df4) # Accuracy = 0.8548, AIC = 3691.4
logit(df5) # Accuracy = 0.8528, AIC = 3690.9

## plot the imputed data. Red ones are the 5 imputed data
stripplot(imp_data, pch = 20, cex =1.2)
densityplot(imp_data)

# Export data to csv format
clean_data = df2
write.csv(clean_data, file = 'cleaned_data.csv')
