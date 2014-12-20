##Assuming that the Samsung data are in the working directory,
##unzip them.

unzip ("getdata-projectfiles-UCI HAR Dataset.zip")

##Read the data. Merge each data (test and train) with its labels.

test <- read.table("UCI HAR Dataset/test/X_test.txt")
testlabels <- read.table("UCI HAR Dataset/test/y_test.txt")
test <- cbind (testlabels, test)

train <- read.table("UCI HAR Dataset/train/X_train.txt")
trainlabels <- read.table("UCI HAR Dataset/train/y_train.txt")
train <- cbind (trainlabels, train)

## Merge the training and the test sets to create one data set called "union".

union <- rbind(train, test)

##Appropriately label the data set with descriptive variable names.
        ##The first variable is the one taken above from "y_test.txt"
        ##and "y_train.txt", so it is called "Activity".
        ##The rest of the variable names are taken from "features.txt".

headers <- as.character(read.table("UCI HAR Dataset/features.txt")[,2])
headers <- c("Activity", headers)
headers <- make.names(headers, unique = TRUE)
colnames(union) <- headers

##Install and load needed package.

if("dplyr" %in% rownames(installed.packages()) == FALSE) {install.packages("dplyr")}
library(dplyr)

##Extract only the activity and the measurements on the mean and
##standard deviation for each measurement. 

union <- select(union, Activity, contains("mean"), contains ("std"))

##Rename the Activity names using descriptive activity names instead of numbers.

union[,1] <- sub("1", "WALKING", union$Activity)
union[,1] <- sub("2", "WALKING_UPSTAIRS", union$Activity)
union[,1] <- sub("3", "WALKING_DOWNSTAIRS", union$Activity)
union[,1] <- sub("4", "SITTING", union$Activity)
union[,1] <- sub("5", "STANDING", union$Activity)
union[,1] <- sub("6", "LAYING", union$Activity)


##Read subjects data and merge it with "union", as a new variable called "Subject".

trainsubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
testsubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
subjects <- rbind(trainsubjects, testsubjects)
colnames(subjects) <- "Subject"
union2 <- cbind(subjects, union)

##Install and load needed package.

if("reshape2" %in% rownames(installed.packages()) == FALSE) {install.packages("reshape2")}
library(reshape2)

##Create a new data set called "union2" with the average of
##each measurement for each activity and each subject.

union2 <- melt(union2, id.vars=c(1,2), measure.vars=c(3:88), variable.name = "Measurement")
union2 <- summarise(group_by(union2, Activity, Subject, Measurement), mean(value))
colnames(union2)[4] <- "Mean"
print(union2)