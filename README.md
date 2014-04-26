# run_Analysis.R - ReadMe

## Overview
This script merges two data sets obtained from the experiment detailed below to:  
1. Create a tidy data set with appropriate labels and descriptive data elements. Extract only means and std deviation measures from this dataset.  
2. Summarize the average of measures in the first dataset as a separate dataset.  
3. Create two output files with data from Step 1 and from Step 2


## Experiment
The experiments were carried out with a group of 30 volunteers within an age bracket of 19-48 years.   Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II)
on the waist. Using its embedded accelerometer and gyroscope,  3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured.The obtained dataset was randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

## Dataset information


### The dataset includes the following files:

* README.txt
* features_info.txt: Shows information about the variables used on the feature vector.
* features.txt: List of all features.
* activity_labels.txt: Links the class labels with their activity name.
* train/X_train.txt: Training set.
* train/y_train.txt: Training labels.
* test/X_test.txt: Test set.
* test/y_test.txt: Test labels.
* test/subject_train.txt: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

`Equivalent data available for train and test`

### CodeBook.md:

* CodeBook.md details the data attributes and processing logic

### run_Analysis.R:

* R script that creates two output files:
	1. Dataset combining std and mean measures from test and train data.
	2. Dataset with average of std and mean measures grouped by Subject Id and Activity.

### Assumptions:
* For this analysis, precalculated std and mean values from 'X_test.txt' and 'X_train.txt' were considered. Raw data from 'Inertial Signals' folder was not used
* Dataset should be unzipped into working directory from
  <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>



