#Note! the working directory must contain the UCI HAR Dataset folder.
#If this is not true the script does not work. 

#Reading the test & training data measured values 1 = test 2 = train
measuredValues1 <- read.table("./UCI HAR Dataset/test/X_test.txt")
measuredValues2 <- read.table("./UCI HAR Dataset/train/X_train.txt")

#Reading the column names for the measured values
namesForCols1_2 <-read.table("./UCI HAR Dataset/features.txt", stringsAsFactors =FALSE)[,2]

#Assigning the column names 
colnames(measuredValues1) <-namesForCols1_2
colnames(measuredValues2) <-namesForCols1_2

#Add the activity type indicators to the data.frame.  
activityCodes1 <- read.table("./UCI HAR Dataset/test/y_test.txt")
measuredValues1$activityCodes <- activityCodes1[,1]

activityCodes2 <- read.table("./UCI HAR Dataset/train/y_train.txt")
measuredValues2$activityCodes <- activityCodes2[,1]

#Add the test subject identification codes to the data.frame. 
testSubId1 <-read.table("./UCI HAR Dataset/test/subject_test.txt")
measuredValues1$subject <- testSubId1[,1]

testSubId2 <-read.table("./UCI HAR Dataset/train/subject_train.txt")
measuredValues2$subject <- testSubId2[,1]


#Creating a new data.frame to exact size required 
rows <- nrow(measuredValues2)+nrow(measuredValues1)
columns <- ncol(measuredValues2)
combined <- data.frame(matrix(NA, nrow = rows, ncol = columns))
colnames(combined) <- colnames(measuredValues2)

#Adding the test and training dataframes to the newly created combination dataframe. 
#Rbind is problematic as there are duplicate column names and I have no knoledge how to rename them. 
combined[1:nrow(measuredValues1), ] <- measuredValues1
combined[(nrow(measuredValues1)+1):rows, ] <- measuredValues2

#Selecting only the columns where the variable name contain std or mean idepedently of case
#The data seemed to contain variables for MeanFrequency, which were assumed to be different from mean
cleanCombined <- combined[,grep("mean\\(|std|activityCodes|subject", colnames(combined), ignore.case = TRUE)]

#Cleaning the column names to rules of tidy: no special characters and to camelCase.
#If you can give advice how to make this into one liner please do so in the comments. 
oldNames <- colnames(cleanCombined)
newNames <- gsub("-mean()-", "Mean", oldNames, fixed= TRUE)
newNames <- gsub("-mean()", "Mean", newNames, fixed= TRUE)
newNames <- gsub("-std()-", "Std", newNames, fixed = TRUE)
newNames <- gsub("-std()", "Std", newNames, fixed = TRUE)

colnames(cleanCombined) <- newNames 

#Transforming the activity names from numbers to  easily understandable
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
assignLabel <- function(x) activityLabels[x,2] 

library("dplyr")
cleanCombined <- mutate(cleanCombined, activity = assignLabel(activityCodes))
cleanCombined <- select(cleanCombined, -activityCodes)

#Creating the summary
summaryData <- cleanCombined %>% group_by(subject, activity) %>% summarise_each(funs(mean))
write.table(summaryData, "summary.txt", row.name=FALSE)
