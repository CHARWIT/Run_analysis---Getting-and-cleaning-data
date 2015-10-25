### Run_analysis---Getting-and-cleaning-data
#### This code is written as part of an assignment on the course Getting and cleaning data on Coursera.
The data for the project is found [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

#####This code does the following:
1. Labels the train and test data set with descriptive variable names (from features.txt)
2. Binds (and label) the subjects, activities and data in one table for the train and test set
3. Combines the training and the test sets into one data set
4. Extracts only the measurements on the mean and standard deviation for each measurement
5. Creates a tidy data set with the average of each variable for each activity and each subject
6. Uses descriptive activity names to name the activities in the data set

#####Start
Read x_train data table
```{r}
x_train_df <- read.table("UCI HAR Dataset/train/X_train.txt")
```

Read column names and name columns of x_train_df accordingly
```{r}
columnnames <- readLines("UCI HAR Dataset/features.txt")
names(x_train_df) <- columnnames
```

Read subject ID's and activity labels and add as first columns
```{r}
subject_train <- readLines("UCI HAR Dataset/train/subject_train.txt")
y_train <- readLines("UCI HAR Dataset/train/y_train.txt")
train_data <- cbind(subject_train, y_train, x_train_df)
```

Read x_test data and convert into data frame the same way as the x_train data
```{r}
x_test_df <- read.table("UCI HAR Dataset/test/X_test.txt")
```

Same column names for x_test as x_train
```{r}
names(x_test_df) <- columnnames
```

And also add ID's and activity names as first two columns
```{r}
subject_test <- readLines("UCI HAR Dataset/test/subject_test.txt")
y_test <- readLines("UCI HAR Dataset/test/y_test.txt")
test_data <- cbind(subject_test, y_test, x_test_df)
head(test_data[,1:5])
```

Check if subject IDs in test and train data are different, yes.
```{r}
table(subject_train)
table(subject_test)
```

test and train data together in one data frame, first synchronize (by renaming) first two column names
```{r}
names(train_data)[1:2] = c("subject", "activity")
#names(train_data)[1:3] #just testing
names(test_data)[1:2] = c("subject", "activity")
total_data <- rbind(train_data, test_data)
```

select first two columns and ALL columns with mean() and std() in name (in right order)
```{r}
columnlist <- c(1, 2, grep("mean()", names(total_data), fixed=T), grep("std()", names(total_data), fixed=T))
select_data <- total_data[,c(sort(columnlist))]
```

Create data set with the average of each variable for each activity and each subject.
```{r}
attach(select_data)
tidy_data <- aggregate(. ~ subject + activity, FUN=mean, data=select_data)
```

Replace activity label by activity name
```{r}
tidy_data$activity = lapply(tidy_data$activity, function(x) if (x==1) x="WALKING" else x=x)
tidy_data$activity = lapply(tidy_data$activity, function(x) if (x==2) x="WALKING_UPSTAIRS" else x=x)
tidy_data$activity = lapply(tidy_data$activity, function(x) if (x==3) x="WALKING_DOWNSTAIRS" else x=x)
tidy_data$activity = lapply(tidy_data$activity, function(x) if (x==4) x="SITTING" else x=x)
tidy_data$activity = lapply(tidy_data$activity, function(x) if (x==5) x="STANDING" else x=x)
tidy_data$activity = lapply(tidy_data$activity, function(x) if (x==6) x="LAYING" else x=x)
tidy_data$activity <- as.character(tidy_data$activity)
```

Some final checking
```{r}
table(tidy_data$subject)
table(tidy_data$activity) 
```

Write table to upload
```{r}
write.table(tidy_data, "UCI HAR Dataset/train/tidy_dataset.txt", row.names=F)
```
