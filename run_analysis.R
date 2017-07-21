# 1.Download and unzipping dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/Dataset.zip",method = "curl")
unzip(zipfile = "./data/Dataset.zip",exdir = "./data")

#2.Merges the training and the test data sets to create one data set
#Reading files
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./data/UCI HAR Dataset/features.txt")

activitylabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
#Assign column names
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityID"
colnames(subject_train) <- "subjectID"
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"

colnames(activitylabels) <- c("activityID","activityType")
#Merge data in a data set
m_train <- cbind(y_train,subject_train,x_train)
m_test <- cbind(y_test,subject_test,x_test)
alltogether <- rbind(m_train,m_test)

#3.Extracts only the measurements on the mean and standard deviation for each measurement.
#read all the column names
colNames <- colnames(alltogether)
#use the regular expressions to define mean and std,and make subset
mean_and_std <- (grepl("activityID",colNames)|grepl("subjectID",colNames)|grepl("mean..",colNames)|grepl("std..",colNames))
onlyforMeanAndStd <- alltogether[,mean_and_std==TRUE]

#4.Uses descriptive activity names to name the activities in the data set
changeactivitynames<- merge(onlyforMeanAndStd,activitylabels,by="activityID",all.x=TRUE)

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
secTidySet <- aggregate(.~subjectID + activityID,changeactivitynames,mean)
secTidySet <- secTidySet[order(secTidySet$subjectID,secTidySet$activityID),]

write.table(secTidySet,"secTidySet.txt",row.name = FALSE)
