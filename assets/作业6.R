
setwd("E:/Î¢¹Û¼ÆÁ¿")
library(caret)
library(rpart)
library(randomForest)
library(gbm)
library(e1071)
library(nnet)
library(neuralnet)
library(NeuralNetTools)
library(gridExtra)

rm(list=ls())
transport <- read.csv("Transport.txt")
loginc <- transport$LogIncome
distance <- transport$DistanceToWork
y <- transport$ModeOfTransportation
N <- nrow(transport)



## logistic regression
logitfit <- multinom(y ~ loginc + distance) 
summary(logitfit)
## prediction
logit.yhat <- predict(logitfit)
table(logit.yhat,y)
sum(diag(table(logit.yhat,y)))/N


##machine learning 
names(transport)=c("loginc","distance","mode")
# process
transport[,1:2] = scale(transport[,1:2]) # scale the transport
transport$mode = as.factor(transport$mode)
nvar = ncol(transport) - 1

# create training and test sets
set.seed(123)
train=createDataPartition(transport$mode,p=0.5,list=F)
data_train = transport[train,]
data_test = transport[-train,]
ytrue = data_test$mode

## Classification Tree 
set.seed(100)
fit = rpart(mode ~.,data_train)
# test err
yhat = predict(fit,data_test,type="class") 
table(ytrue,yhat)
1-mean(yhat==ytrue) #misclassification error rate

## Random Forest 
set.seed(100)
fit = randomForest(mode~.,data=data_train,mtry=1)
# test err
yhat = predict(fit,data_test) 
table(ytrue,yhat)
1-mean(yhat==ytrue) #misclassification error rate

## Neural Net 
set.seed(100)
fit = nnet(mode~.,data=data_train,
           size=10,maxit=10000,MaxNWts=10000,decay=0.1)
# test err 
yhat = predict(fit,data_test,type="class") 
table(ytrue,yhat)
1-mean(yhat==ytrue) #misclassification error rate
