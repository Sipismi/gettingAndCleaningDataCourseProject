#Readme for run_analysis.R scrip

##Introduction
This script makes a tidy datashet out of the data obtained part and produces of summary of this project:  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones.
The content of the summary is explained in a file called CodeBook.txt

This file is part of an peer-reviewed exercise in Coursera. 

##Principle of the script function
###Tidy data set 
The script requires that the data is in unzipped to a folder called "UCI HAR Dataset" (which hapens automaticly when unzipping with standard settings) in the R working directory. 

The script first reads the measured data to R. Then additional id variables are read (subjects, acitivities and columnames).  These are added to the data before mergin to make it easier to notice if operations that reorganise the data would be accidentally done. 

The test and training datasets are combined by creating a new data.frame that is exactly the right size for the read datasets. This is done to prevent any issues with rbind.

Grep is used to find the columns  that match the specified regular experssions (are calculated means or standar deviations) and  the columns containing the activity and subject information. The columns are extracted to a new data.frame.

The data shet is made tidy: 
*The variable names are cleaned from any special characters and made sure that they are in     camel case. To make the data set tidy. 

*Dplyr package is used to tansform the numeric activity codes to easily understandable strings. 

###Summary generation

Dplyr package is again used summarise the data according to activity and test subject. Mean for each variable selected to the tidy data set is calculated for each test subject for each activity. 


The summary is saved with write table function. 

