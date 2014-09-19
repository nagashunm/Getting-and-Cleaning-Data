
library(dplyr)

###### Step1 - Read and Merge data set and step 4 - label the data set with descriptive variable names is done below ######
  #Read Activity_label and store for later use
activity_labels <- read.table( "./UCI HAR Dataset/activity_labels.txt",header = FALSE, sep = "")
colnames(activity_labels) <- c("activity_code","activity")
activity_labels$activity = as.character(activity_labels$activity)

  # Read features file and store variable names for assiging later
features <- read.table( "./UCI HAR Dataset/features.txt",header = FALSE, sep = "")

  # Read test & training subject (Person performing the task) data and assign column heading as "subject" 
subject_test <- read.table( "./UCI HAR Dataset/test/subject_test.txt",header = FALSE, sep = "")
colnames(subject_test) <- c("subject")
subject_train <- read.table( "./UCI HAR Dataset/train/subject_train.txt",header = FALSE, sep = "")
colnames(subject_train) <- c("subject")

  # Read the type of activity done like walking, sitting etc for test and training data
y_test <- read.table( "./UCI HAR Dataset/test/y_test.txt",header = FALSE, sep = "")
colnames(y_test) <- c("activity_code")
y_train <- read.table( "./UCI HAR Dataset/train/y_train.txt",header = FALSE, sep = "")
colnames(y_train) <- c("activity_code")

  # Read accelerometer, gyroscope data and assign column heading for test and training data
X_test <- read.table( "./UCI HAR Dataset/test/X_test.txt",header = FALSE, sep = "")
colnames(X_test) <- as.character(features$V2)
X_train <- read.table( "./UCI HAR Dataset/train/X_train.txt",header = FALSE, sep = "")
colnames(X_train) <- as.character(features$V2)
  
  # combine the subject column , acitivity column and accelerometer & gyroscope reading columns for test & Training data
test <- cbind(subject_test,y_test,X_test)
train <- cbind(subject_train,y_train,X_train)
  # comnine both test and trainig data set
comb <- rbind(test,train)

###### Step 2 - Extract mean and standard deviation for each measurement  ######
  # indetify the fiedls that has mean and standard deviation and store it in meanstdcol
meanstdcol <- features$V2[grepl(".*[Mm]ean*.|.*std*.",features$V2)]
  # Add column name "subject" to meanstdcol
meanstdcol <- factor(append(as.character(meanstdcol),"subject"))
  # Add column name "activity_code" to meanstdcol
meanstdcol <- factor(append(as.character(meanstdcol),"activity_code"))
combmeanstd <- comb[ , which(names(comb) %in% meanstdcol[])]
###### Completed - Step 2 - Extract mean and standard deviation for each measurement  ######

###### Step 3 - Uses descriptive activity names to name the activities ######
  # map activity code 1 to 6 to Walking, standing etc 
combmeanstd_lab = merge(activity_labels,combmeanstd,by.x="activity_code",by.y="activity_code", all = TRUE)
  # removed the activity code column as we now have the corresponding activity names in the data set
combmeanstd_lab <- combmeanstd_lab[,-1]

###### Step 5 : creates a second, independent tidy data set with the average of each variable for each activity and each subject ###### 

tidydata <-combmeanstd_lab %>% group_by(activity,subject, add=FALSE) %>% summarise_each(funs(mean))

###### Finaly write the data from step 5 in to a text file
write.table(tidydata, "tidydata.txt", sep = "\t", row.name=FALSE)
