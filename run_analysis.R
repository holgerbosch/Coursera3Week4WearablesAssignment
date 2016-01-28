## This Coursera script merges all test and training data files together, 
## filters on relevant variables and creates a tidy summary data frame

## below setwd statement brings you to your working directory
## setwd("C:/3_BigData/01. Coursera/C3/W4/UCI HAR Dataset") 

## read all required input files
testdata=read.table("test//X_test.txt")
traindata=read.table("train//X_train.txt")

testActivities=read.table("test//y_test.txt")
trainActivities=read.table("train//y_train.txt")

testSubjects=read.table("test//subject_test.txt")
trainSubjects=read.table("train//subject_train.txt")

featureNames=read.table("features.txt")
activity_labels=read.table("activity_labels.txt")

## rename variables and merge all test data files
testActivities=merge(testActivities,activity_labels)
names(testActivities)=c("ActIndex", "Activity")
names(testSubjects)=c("Subject")

names(testdata)=featureNames$V2
testdata=cbind(testdata,testActivities,testSubjects)
testdata$Origin="test"

## rename variables and merge all train data files
trainActivities=merge(trainActivities,activity_labels)
names(trainActivities)=c("ActIndex", "Activity")
names(trainSubjects)=c("Subject")

names(traindata)=featureNames$V2
traindata=cbind(traindata,trainActivities,trainSubjects)
traindata$Origin="train"

## merge train and test data together, filter on relevant variables and finally create tidy summary data frame
maindata=rbind(traindata, testdata)
selectedVariables=grep("((mean|std)\\()|Activity|Origin|Subject",names(maindata),value=TRUE)
maindata=maindata[,selectedVariables]
tidydata=aggregate(x = maindata[,grep("((mean|std)\\()",names(maindata))], by = maindata[,c("Activity","Origin","Subject")], FUN = "mean")
write.table(tidydata,"tidydata.txt",row.names=FALSE)
