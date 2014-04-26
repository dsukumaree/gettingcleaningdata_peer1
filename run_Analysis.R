## This script merges two data sets obtained from the experiment detailed below to:  
## 1. Create a tidy data set with appropriate labels and descriptive data elements. Extract only means and std deviation measures from this dataset.  
## 2. Summarize the average of measures in the first dataset as a separate dataset grouped by Subject and Activity.   
## 3. Create two output files with data from Step 1 and from Step 2


## Load required libraries
library(plyr)
library(reshape2)

## Load SubjectId into dataframe
testSubjectId <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep = " ", header = FALSE)
# Set column name
colnames(testSubjectId) <- c("SubjectId")

# Load X_test.txt
XTest <- read.table("./UCI HAR Dataset/test/X_test.txt", sep = "", header=FALSE)
# Add Subject Id to X_test
XTest <- cbind(testSubjectId$SubjectId, XTest)
# Load column names to another dataframe
featureNames <- read.table("./UCI HAR Dataset/features.txt", sep = "", header=FALSE, stringsAsFactors=FALSE)
colnames(XTest) <- c("SubjectId", featureNames[,2])

##Add activity labels to the X test set
## Load Y_test.txt
YTest <- read.table("./UCI HAR Dataset/test/Y_test.txt", sep = "", header=FALSE)

## LOad activity_labels.txt
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", sep = "", header=FALSE, stringsAsFactors=FALSE)

## Join YTest and activityLabels
YTestLabels <- join(YTest,activityLabels, by="V1")

##Add activity label to the XTest dataframe

XTest <- cbind(YTestLabels$V2, XTest)

## Rename column to ActivityName
names(XTest)[1] <- "ActivityName"

## Get column names with std or mean in them
z <- colnames(XTest)
colStdMean <- c(z[grep("std()", z)],z[grep("mean()", z)])

## Include SubjectId, ActivityName and std and mean columns
colList <- c("SubjectId", "ActivityName", colStdMean)

## Extract the dataset with SubjectId, ActivityName and colList created above

XTestData <- XTest[,colList]

## Train Data Set

## Load SubjectId into dataframe
trainSubjectId <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep = " ", header = FALSE)
# Set column name
colnames(trainSubjectId) <- c("SubjectId")

# Load X_train.txt
XTrain <- read.table("./UCI HAR Dataset/train/X_train.txt", sep = "", header=FALSE)
# Add Subject Id to X_train
XTrain <- cbind(trainSubjectId$SubjectId, XTrain)
# Load column names to another dataframe
##featureNames <- read.table("./UCI HAR Dataset/features.txt", sep = "", header=FALSE, stringsAsFactors=FALSE)
colnames(XTrain) <- c("SubjectId", featureNames[,2])

##Add activity labels to the X train set
## Load Y_train.txt
YTrain <- read.table("./UCI HAR Dataset/train/Y_train.txt", sep = "", header=FALSE)

## Load activity_labels.txt
##activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", sep = "", header=FALSE, stringsAsFactors=FALSE)

## Join Ytrain and activityLabels
YTrainLabels <- join(YTrain,activityLabels, by="V1")

##Add activity label to the Xtrain dataframe

XTrain <- cbind(YTrainLabels$V2, XTrain)

## Rename column to ActivityName
names(XTrain)[1] <- "ActivityName"

## Get column names with std or mean in them
z <- colnames(XTrain)
colStdMean <- c(z[grep("std()", z)],z[grep("mean()", z)])

## Include SubjectId, ActivityName and std and mean columns
colList <- c("SubjectId", "ActivityName", colStdMean)

## Extract the dataset with SubjectId, ActivityName and colList created above

XTrainData <- XTrain[,colList]

## Combine the two datasets to combine test and train data together

TestTrainCombined <- rbind(XTestData, XTrainData)

## Create a dataset comprising of average measures grouped by SubjectId and ActivityName
molten = melt(TestTrainCombined, id = c("SubjectId", "ActivityName"), na.rm = TRUE)

avgBySubjActy <- dcast(molten, SubjectId + ActivityName ~ variable, mean)

## Write Combined Test,Train dataset to file
write.table(TestTrainCombined, file = "CombinedTidyData.txt")

## Write average by Subject & Activity to file
write.table(avgBySubjActy, file = "AvgBySubjectActivity.txt")
