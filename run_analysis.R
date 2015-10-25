#Set working directory if neccesary
#setwd("directory")

#read x_train data table
x_train_df <- read.table("UCI HAR Dataset/train/X_train.txt")
head(x_train_df[,1:5])

#Read column names and name columns of x_train_df accordingly
columnnames <- readLines("UCI HAR Dataset/features.txt")
names(x_train_df) <- columnnames
head(x_train_df[,1:5])

#read subject ID's and activity labels and add as first columns
subject_train <- readLines("UCI HAR Dataset/train/subject_train.txt")
y_train <- readLines("UCI HAR Dataset/train/y_train.txt")
train_data <- cbind(subject_train, y_train, x_train_df)
head(train_data[,1:5])

#Read x_test data and convert into data frame the same way as the x_train data
x_test_df <- read.table("UCI HAR Dataset/test/X_test.txt")
head(x_test_df[,1:5])

#Same column names for x_test as x_train
names(x_test_df) <- columnnames
#And also add ID's and activity names as first two columns
subject_test <- readLines("UCI HAR Dataset/test/subject_test.txt")
y_test <- readLines("UCI HAR Dataset/test/y_test.txt")
test_data <- cbind(subject_test, y_test, x_test_df)
head(test_data[,1:5])

#Check if subject IDs in test and train data are different, yes.
table(subject_train)
table(subject_test)
#test and train data together in one data frame, first synchronize (by renaming) first two column names
names(train_data)[1:2] = c("subject", "activity")
#names(train_data)[1:3] #just testing
names(test_data)[1:2] = c("subject", "activity")
total_data <- rbind(train_data, test_data)

#Select first two columns and ALL columns with mean() and std() in name (in right order)
columnlist <- c(1, 2, grep("mean()", names(total_data), fixed=T), grep("std()", names(total_data), fixed=T))
select_data <- total_data[,c(sort(columnlist))]
head(select_data[,1:5])

#Create data set with the average of each variable for each activity and each subject.
attach(select_data)
tidy_data <- aggregate(. ~ subject + activity, FUN=mean, data=select_data)

#Replace activity label by activity name
tidy_data$activity = lapply(tidy_data$activity, function(x) if (x==1) x="WALKING" else x=x)
tidy_data$activity = lapply(tidy_data$activity, function(x) if (x==2) x="WALKING_UPSTAIRS" else x=x)
tidy_data$activity = lapply(tidy_data$activity, function(x) if (x==3) x="WALKING_DOWNSTAIRS" else x=x)
tidy_data$activity = lapply(tidy_data$activity, function(x) if (x==4) x="SITTING" else x=x)
tidy_data$activity = lapply(tidy_data$activity, function(x) if (x==5) x="STANDING" else x=x)
tidy_data$activity = lapply(tidy_data$activity, function(x) if (x==6) x="LAYING" else x=x)
tidy_data$activity <- as.character(tidy_data$activity)

#Some final checking
table(tidy_data$subject)
table(tidy_data$activity) 

#Write table to upload
write.table(tidy_data, "tidy_dataset.txt", row.names=F)

