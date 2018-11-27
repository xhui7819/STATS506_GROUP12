## STATS 506 Group project
##
## The IRIS data used in this script can be found at the link below : 
## https://www.kaggle.com/vvenanccio/irisflowers
##
## Author : Group 12
## Updated : Nov 27, 2018

## Load the data
data(iris) 

## Description of the data 
summary(iris)

## Seperate the data into training set and testing set
train_1 = iris[1:40,]; train_2 = iris[51:90,]; train_3 = iris[101:140,]
train = rbind(train_1,train_2); train = rbind(train, train_3)
test_1 = iris[41:50,]; test_2 = iris[91:100,]; test_3 = iris[141:150,]
test = rbind(test_1,test_2); test = rbind(test, test_3)

## Build the multinomial logistic regression model using the train set
library(nnet)
train$species2 = relevel(train$Species, ref = "virginica")
model = multinom(species2 ~ Sepal.Length + Sepal.Width + 
                    Petal.Length + Petal.Width , data = train)

summary(model)
## calculate p-values
z = summary(model)$coefficients/summary(model)$standard.errors
z
p = (1 - pnorm(abs(z), 0, 1)) * 2
p

## Test the accuracy of model using the test set
library(data.table)
a = predict(model, newdata =test, "probs")
a = data.table(a)
b = rep(1,30)                
b[which(a$versicolor == apply(a, 1, max))]=2              
b[which(a$virginica == apply(a, 1, max))]=3     
c = c(rep(1,10), rep(2,10), rep(3,10))
accuracy = sum(b==c)/30

