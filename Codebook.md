# Getting and Cleaning Data Code Book

## Steps

- Load Data
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement. 
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names. 
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### Loading Data

Download the data from the source URL and unzip the data.

### Merge the training and the test sets

Getting each file's directories, assign folderDir, activityLabelsFile, featuresFile, x_trainFile, y_trainFile, subject_trainFile, x_testFile, y_testFile, subject_testFile with its own file location.

Open each file with read.table and assign the data into the variables accordingly, namely activityLabel, features, x_train, y_train, subject_train, x_test, y_test, subject_test

### Merging Data

Merge the training data with x_train subject_train and y_train to training_data set.
Merge the testing data with x_test subject_test and y_test to testing_data set.

Merge the training and testing data set to data set.

Name the final data set with the name from features plus the subject name and Activity ID. There are 563 columns within data set.

### Extracting Data

Use grepl for matching the pattern with "mean", "std", "Subject", "ActivityId".

Get the extracted data set - data_mean_std - only contained the useful information

### Name with Descriptive activity names

Activity names are coming from activity_label file. 
Merging the data_mean_std with activity_label by ActivityId.
Then using the activity names instead of AcitivyId.

### Labelling data set with descriptive variable names

- Remove parentheses
- Make Valid names using make.name (in the format XX.XX.XX instad of XX.XX - XX)
- Replace abbv with plain English

### Getting Tidy Data 

Using ddply from plyr which splitting data frame, apply function, and return results in a data frame.
Save the final tidy data into "tidyData.txt"
