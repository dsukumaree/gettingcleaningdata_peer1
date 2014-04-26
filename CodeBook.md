# run_Analysis.R - CodeBook

## Overview
This script merges two data sets obtained from the experiment detailed below to:  
1. Create a tidy data set with appropriate labels and descriptive data elements. Extract only means and std deviation measures from this dataset.  
2. Summarize the average of measures in the first dataset as a separate dataset grouped by Subject and Activity.   
3. Create two output files with data from Step 1 and from Step 2


## Data Attributes

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables.  
* An identifier of the subject who carried out the experiment.
* Activity codes & names.

`Equivalent data available for train and test`

### Subject Id:
* Id to identify subjects who participated in the experiment
* Range from 1 to 30

### Activity Codes & Names
* 1 WALKING
* 2 WALKING_UPSTAIRS
* 3 WALKING_DOWNSTAIRS
* 4 SITTIN
* 5 STANDING
* 6 LAYING

### Measures from experiment

* Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
* Triaxial Angular velocity from the gyroscope. 
* A 561-feature vector with time and frequency domain variables.  

### Calculated measures  


#### Std and Mean measures

* The first dataset created by the script contains mean and std measures from test and train datasets.
* To identify mean and std measures 'grep(std())' and 'grep(mean())' functions were used. The results include 'meanFreq()' variables.

#### Average by Subject & Activity

* The second dataset created by the script contains average of mean and std measures from the first dataset grouped by Subject and Activity

## run_Analysis.R

### Libraries used
* plyr
* reshape2

### Processing steps
* Unzip provided dataset into your working directory. Script assumes that data files are present in 'UCI HAR Dataset' directory in your working directory.
* Load 'subject_test.txt' and 'X_test.txt' into 'Subject_test' and 'X_test' dataframes.
* Add 'Subject Id' from 'Subject_test' into 'X_test' to combine measures with subjects
* Assign feature names from 'features.txt' as column names for the measures in 'X_test'
* Join the data in 'Y_test.txt' (containing activity id) with the data loaded from 'activity_labels.txt' to get activity names. 
* Add 'Activity Name' obtained from above step to the 'X_test' data frame
* Identify columns that have 'std()' or 'mean()' in the column names. This includes 'meanFreq' columns as well.
* Create a dataset for 'Test' subjects, with subject id, activity name and the columns identified in the above step. This is 'XTestData'
* The steps above are repeated for the 'Train' dataset to create 'XTrainData'
* Append the 'XTrainData' dataset to the 'XTestData' dataset to create a combined dataset with 'Subject Id', 'Activity Name', and std and mean  measures. This is the 'TestTrainCombined'
* Create a second dataset 'avgBySubjActy'. This dataset contains the average of the std and mean measures obtained above and is grouped by 'Subject Id' and 'Activity Name'.
* Create output file 'CombinedTidyData.txt' from the combined data set, 'TestTrainCombined' in working directory
* Create output file 'AvgBySubjectActivity.txt' from the second data set, 'avgBySubjActy' in working directory


### Assumptions
* For this analysis, precalculated std and mean values from 'X_test.txt' and 'X_train.txt' were considered. Raw data from 'Inertial Signals' folder was not used
* To identify mean and std measures 'grep(std())' and 'grep(mean())' functions were used. The results include 'meanFreq()' variables.
