#setwd("E:/DATA/Thomas/Coursera/GitHub/get_clean_data")
# loading packages
library(reshape2)
library(plyr)

## load activity labels
file <- "./UCI HAR Dataset/activity_labels.txt"
activity <- read.table(file, col.names=c("Code","Activity"))

## load features labels
file <- "./UCI HAR Dataset/features.txt"
features <- read.table(file)

## load test data
file <- "./UCI HAR Dataset/test/subject_test.txt"
subject_test <- read.table(file, col.names="SubjectNumber")
file <- "./UCI HAR Dataset/test/X_test.txt"
x_test <- read.table(file)
names(x_test) <- as.character(features[,2])
file <- "./UCI HAR Dataset/test/Y_test.txt"
y_test <- read.table(file, col.names="Code")
y_test_activity <- merge(activity, y_test, 
        by=intersect(names(y_test), names(activity))) ## Merge with activity

## load train data
file <- "./UCI HAR Dataset/train/subject_train.txt"
subject_train <- read.table(file, col.names="SubjectNumber")
file <- "./UCI HAR Dataset/train/X_train.txt"
x_train <- read.table(file)
names(x_train) <- as.character(features[,2])
file <- "./UCI HAR Dataset/train/Y_train.txt"
y_train <- read.table(file, col.names="Code")
y_train_activity <- merge(activity, y_train, 
            by=intersect(names(y_train), names(activity))) ## Merge with activity

## merge x_xx with subject and activity
x_test$SubjectNumber <- subject_test$SubjectNumber
x_train$SubjectNumber <- subject_train$SubjectNumber
x_test$Activity <- y_test_activity$Activity
x_train$Activity <- y_train_activity$Activity

## merge x_test with x_train
x_measurement <- rbind(x_test, x_train)
write.csv(x_measurement, file = "x.csv")

## exctract measurement of mean and std from x_measurement

colName_features <- as.character(features[c(grep("std", as.character(features[,2])),
           grep("mean\\(", as.character(features[,2]))),2])
colName_id <- c("SubjectNumber", "Activity")
colNames <- c(colName_id, colName_features)
x_mean_std <- x_measurement[,colNames]

## mean of each features per subject and activity
# transpose the data set
x <- melt(x_mean_std, id=colName_id, measure.vars=colName_features)
# calculate the mean
x_mean <- ddply(x, .(SubjectNumber, Activity, variable), summarize, mean=mean(value)) 
names(x_mean) <- c(names(x_mean[1:2]), "Features", "Average")

