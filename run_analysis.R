
###=============== run_analysis ==============###
#####Data preparation stage

#Loading required packages
library(dplyr)
#set the wd
setwd("C:/Users/retzer.matan")

#Load all data frames

features = read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities = read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test = read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test = read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train = read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train = read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

###Peer-graded Assignment stage:

#Merges the training and the test sets to create one data set
x = rbind(x_train, x_test)
y = rbind(y_train, y_test)
Subject = rbind(subject_train, subject_test)
Merged_Data = cbind(Subject, y, x)

#Extracts only the measurements on the mean and standard deviation for each measurement

TidyData = Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

#Uses descriptive activity names to name the activities in the data set

TidyData$code = activities[TidyData$code, 2]

#Appropriately labels the data set with descriptive variable names

colnames(TidyData)[2] = "activity"
colnames(TidyData)=gsub("Acc", "Accelerometer", colnames(TidyData))
colnames(TidyData)=gsub("Gyro", "Gyroscope", colnames(TidyData))
colnames(TidyData)=gsub("BodyBody", "Body", colnames(TidyData))
colnames(TidyData)=gsub("Mag", "Magnitude", colnames(TidyData))
colnames(TidyData)=gsub("^t", "Time", colnames(TidyData))
colnames(TidyData)=gsub("^f", "Frequency", colnames(TidyData))
colnames(TidyData)=gsub("tBody", "TimeBody", colnames(TidyData))
colnames(TidyData)=gsub("-mean()", "Mean", colnames(TidyData), ignore.case = T)
colnames(TidyData)=gsub("-std()", "STD", colnames(TidyData), ignore.case = T)
colnames(TidyData)=gsub("-freq()", "Frequency", colnames(TidyData), ignore.case = T)
colnames(TidyData)=gsub("angle", "Angle", colnames(TidyData))
colnames(TidyData)=gsub("gravity", "Gravity", colnames(TidyData))

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subjec

Final_Data = TidyData %>% group_by(subject, activity) %>% summarise_all(funs(mean))

###QA
glimpse(Final_Data)

#
write.table(Final_Data, "Final_Data.txt", row.name=F)

###====================== E N D ============================###

