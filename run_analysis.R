## loading dplyr
library(dplyr)

## Files loading

## Activities loading
Activities <- read.table(file="./UCI HAR Dataset/activity_labels.txt", sep ="")

## Features names loading
Features <- read.table(file="./UCI HAR Dataset/features.txt", sep ="")

## Training features loading
XTrain <- read.table(file="./UCI HAR Dataset/train/X_train.txt", sep ="")

## Training activities loading
YTrain <- read.table(file="./UCI HAR Dataset/train/Y_train.txt", sep ="")

## Training subject loading
SubjectTrain <- read.table(file="./UCI HAR Dataset/train/subject_train.txt", sep ="")

## Testing features loading
XTest <- read.table(file="./UCI HAR Dataset/test/X_test.txt", sep ="")

## Testing activities loading
YTest <- read.table(file="./UCI HAR Dataset/test/Y_test.txt", sep ="")

## Testing subject loading
SubjectTest <- read.table(file="./UCI HAR Dataset/test/subject_test.txt", sep ="")


## Merge data frames (Step 1)
SubjectFull <- rbind(SubjectTrain, SubjectTest)
YFull <- rbind(YTrain, YTest)
XFull <- rbind(XTrain, XTest)

## Add the column Activity to FullResults (Step 3)
ActivitiesFull <- vector(length=nrow(YFull))
for(i in 1:nrow(YFull))
{
  ActivitiesFull[i] <- as.character(Activities[YFull[i, 1], 2])
}

## Merge activities and subject info with the main data frame (Step 1 end)
XFull <- cbind(SubjectFull, ActivitiesFull, XFull)

## Appropriately labels the data set XTrain with descriptive variable names (Step 4)
colnames(XFull) <- c("Subject", "Activity", as.vector(Features[,2]))

## remove duplicated columns
XFull <- XFull[, !duplicated(names(XFull))]

## Keep mean and standard diversion (Step 2)
XFull <- select(XFull, Subject, Activity, contains("mean()"), contains("std()"))

## Creates independent tidy data set with the average of each variable for
## each activity and each subject (Step 5)
grouped_data <- group_by(XFull, Subject, Activity)
TidyData <- summarize_each(grouped_data, funs(mean))

## Write tidy data in file
write.table(TidyData, file = "TidyData.txt", row.names = FALSE)

print("TidyData.txt file written.")


