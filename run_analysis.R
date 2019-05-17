setwd("/Users/esraa1/datasciencecoursera/GettingCleaningDataCourse/Week4/GettingCleaningDataProject")
MainDataDir <- "/Users/esraa1/datasciencecoursera/GettingCleaningDataCourse/Week4/data/UCI HAR Dataset"
TestDataDir <- "/Users/esraa1/datasciencecoursera/GettingCleaningDataCourse/Week4/data/UCI HAR Dataset/test"
TrainDataDir <- "/Users/esraa1/datasciencecoursera/GettingCleaningDataCourse/Week4/data/UCI HAR Dataset/train"

features <- read.table(paste0(MainDataDir,"/features.txt"), header = F)
activity_label <- read.table(paste0(MainDataDir,"/activity_labels.txt"), header = F)

x_test <- read.table(paste0(TestDataDir,"/X_test.txt"), header = F)
y_test <- read.table(paste0(TestDataDir,"/y_test.txt"), header = F)
subject_test <- read.table(paste0(TestDataDir,"/subject_test.txt"), header = F)


x_train <- read.table(paste0(TrainDataDir,"/X_train.txt"), header = F)
y_train <- read.table(paste0(TrainDataDir,"/y_train.txt"), header = F)
subject_train <- read.table(paste0(TrainDataDir,"/subject_train.txt"), header = F)

colnames(activity_label) <- c("ActivityID", "ActivityType")

colnames(x_test) <- features[,2]
colnames(y_test) <- c("ActivityID")
colnames(subject_test) <- c("subID")

colnames(x_train) <- features[,2]
colnames(y_train) <- c("ActivityID")
colnames(subject_train) <- c("subID")

trainData <- cbind(y_train, subject_train, x_train)
testData <- cbind(y_test, subject_test, x_test)
finalData <- rbind(trainData, testData)

colNames <- colnames(finalData)
Mean_STD <- finalData[,grep("mean|std|subID|ActivityID", colnames(finalData))]
Mean_STD <- merge(Mean_STD, activity_label, by = intersect(names(Mean_STD), names(activity_label)))

names(Mean_STD) <- gsub("\\(|\\)", "", names(Mean_STD))
names(Mean_STD) <- gsub("\\-", "", names(Mean_STD))

names(Mean_STD) <- gsub("Acc", "Acceleration", names(Mean_STD))
names(Mean_STD) <- gsub("Gyro", "Gyroscope", names(Mean_STD))
names(Mean_STD) <- gsub("Mag", "Magnitude", names(Mean_STD))
names(Mean_STD) <- gsub("Freq", "Frequency", names(Mean_STD))
names(Mean_STD) <- gsub("BodyBody", "Body", names(Mean_STD))
names(Mean_STD) <- gsub("mean", "Mean", names(Mean_STD))
names(Mean_STD) <- sub("^f|^t", "", names(Mean_STD))
names(Mean_STD) <- gsub("Jerk", "", names(Mean_STD))
names(Mean_STD) <- gsub("sd", "Std", names(Mean_STD))

library(dplyr)
TidyDataAverage <- ddply(Mean_STD, c("ActivityType", "subID"), numcolwise(mean))
write.table(TidyDataAverage, "TidyDataAverage.txt")
