
## If the data zip file not exist, download the file and unzip the file

if(!file.exists("UCI.zip")){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip";
  download.file(fileURL, destfile= "UCI.zip", method = "curl");
  unzip("UCI.zip");
  
}

## Getting each file's directories
folderDir <- "UCI HAR Dataset";
activityLabelsFile <- paste(folderDir, "/activity_labels.txt", sep ="");
featuresFile <- paste(folderDir, "/features.txt", sep ="");

x_trainFile<- paste(folderDir, "/train/X_train.txt", sep ="");
y_trainFile <- paste(folderDir, "/train/y_train.txt", sep ="");
subject_trainFile <- paste(folderDir, "/train/subject_train.txt", sep="");

x_testFile<- paste(folderDir, "/test/X_test.txt", sep ="");
y_testFile <- paste(folderDir, "/test/y_test.txt", sep ="");
subject_testFile <- paste(folderDir, "/test/subject_test.txt", sep="");


## load the raw data into working environment
activityLabel <- read.table(activityLabelsFile, col.names = c("ActivityId", "activityName"));
features <- read.table(featuresFile, colClasses = c("character"));
x_train <- read.table(x_trainFile);
y_train <- read.table(y_trainFile);
subject_train <- read.table(subject_trainFile);
x_test <-read.table(x_testFile);
y_test <- read.table(y_testFile);
subject_test <- read.table(subject_testFile);

##################################################################
## Merges the training and the test sets to create one data set.##
##################################################################
training_data <- cbind(cbind(x_train, subject_train), y_train);
testing_data <- cbind(cbind(x_test, subject_test), y_test);

data<- rbind(training_data, testing_data);

## Column Name of the final data, the first 561 columns are features, 
## 562th col is subject and 563th col is activity id 
names(data) <- rbind(rbind(features, c(562, "Subject")), 
                     c(563, "ActivityId"))[,2];



##################################################################
## Extract the mean and standard deviation for each measurement.##
##################################################################

##use grepl for matching the pattern
data_mean_std <- data[,grepl("mean|std|Subject|ActivityId", names(data))];

#########################################################################
### Uses descriptive activity names to name the activities in dataset.###
#########################################################################
data_mean_std <- merge(data_mean_std, activityLabel, by = "ActivityId", match = "first");
data_mean_std <- data_mean_std[,-1];

#########################################################################
### Appropriately labels the data set with descriptive variable names.###
#########################################################################

##Remove parentheses
names(data_mean_std) <- gsub('\\(|\\)',"",names(data_mean_std), perl = TRUE);
## Make valid names
names(data_mean_std) <- make.names(names(data_mean_std));
## Make name with Plain English
names(data_mean_std) <- gsub('Acc',"Acceleration",names(data_mean_std));
names(data_mean_std) <- gsub('GyroJerk',"AngularAcceleration",names(data_mean_std));
names(data_mean_std) <- gsub('Gyro',"AngularSpeed",names(data_mean_std));
names(data_mean_std) <- gsub('Mag',"Magnitude",names(data_mean_std));
names(data_mean_std) <- gsub('^t',"TimeDomain.",names(data_mean_std));
names(data_mean_std) <- gsub('^f',"FrequencyDomain.",names(data_mean_std));
names(data_mean_std) <- gsub('\\.mean',".Mean",names(data_mean_std));
names(data_mean_std) <- gsub('\\.std',".StandardDeviation",names(data_mean_std));
names(data_mean_std) <- gsub('Freq\\.',"Frequency.",names(data_mean_std));
names(data_mean_std) <- gsub('Freq$',"Frequency",names(data_mean_std));


########################################################################
### creates a second, independent tidy data set with the average of ####
###### each variable for each activity and each subject#################
#########################################################################
library(plyr)
tidyData <- ddply(data_mean_std, c("Subject","activityName"), numcolwise(mean))
write.table(tidyData, "tidyData.txt", sep="\t")
