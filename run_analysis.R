# I download data to a local directory, and unzip it

# I turn that directory into the working directory. If you want to run this script, adjust the path to your own working directory
#As a reference, the following command set MY working directory
#setwd("C:/users/usuario/Documents/CN/Coursera/DataScienceSpecialization/GettingCleaningData/EspacioDeTrabajo/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

# Reading data
library(data.table)

# I read data from the "train" directory
# I read data values
dstraindata <- fread("train/x_train.txt")
#I read Subjects in "train" (21 subjects, randomly selected from the total of 30)
dstrainsubj<-fread("train/subject_train.txt")
# I read activity codes in "train" (represented by values from 1 to 6) 
dstraincode<-fread("train/y_train.txt")

#Now I do similarly, to read files from the "test" directory
# I read data values
dstestdata <- fread("test/x_test.txt")
#I read Subjects in "test" (reamining 9 subjects)
dstestsubj<-fread("test/subject_test.txt")
# I read activity codes in "test" (represented by values from 1 to 6)
dstestcode<-fread("test/y_test.txt")

# I work now merging the train data frames into a single one
#Now let큦 bind the column with subject information to the dstraindata frame
t<-cbind(dstraindata,dstrainsubj)
#And now let큦 add the activitity codes
utrain<-cbind(t, dstraincode)

# Let큦 do the same to get a single data frame for the Test data frames
v<-cbind(dstestdata,dstestsubj)
wtest<-cbind(v,dstestcode)

# Now I form a single dataset, with the content of both utrain and wtest
dset1<-rbind(utrain,wtest)

#dset1 is a data table of 10299 obs and 563 variables. Column 562 stores info
#about the subjects (values from 1 to 30) and column 563 stores activity codes (1::6)
# I check with sort(unique(dset1[[562]])) and with sort(unique(dset1[[563]]))
# I adjust column 562 and column 563 to avoid repeatede variable names ("V1")
names (dset1)[562]<-"Subject"
names (dset1)[563]<-"Activity_code"

# Let select the variable columns that I큞l keep:
keep<-c("V1", "V2", "V3", "V4", "V5","V6","V41", "V42", "V43", "V44", "V45","V46","V81", "V82", "V83", "V84", "V85","V86","V121", "V122", "V123", "V124", "V125","V126","V161", "V162", "V163", "V164", "V165","V166","V201","V202","V214","V215","V227","V228","V240","V241","V253","V254","V266","V267","V268","V269","V270","V271","V345","V346","V347","V348","V349","V350","V424","V425","V426","V427","V428","V429","V503","V504","V516","V517","V529","V530","V542","V543","Subject","Activity_code")

#Now I subset the original data table, and get a new one only with the "keep" columns:
dtmeanstd<-dset1[,keep,with=FALSE]

#It is time to rename variables
library(dplyr)
#First I substitute "Activity_code" for the Activities themselves (from "activity_labels.txt" file. transmute() works the same as mutate() except that it only returns the new columns.
dtmeanstd<-transmute(dtmeanstd,V1, V2, V3,V4, V5,V6,V41, V42, V43, V44, V45,V46,V81, V82, V83, V84, V85,V86,V121, V122,V123,V124,V125,V126,V161, V162, V163, V164, V165,V166,V201,V202,V214,V215,V227,V228,V240,V241,V253,V254,V266,V267,V268,V269,V270,V271,V345,V346,V347,V348,V349,V350,V424,V425,V426,V427,V428,V429,V503,V504,V516,V517,V529,V530,V542,V543,Subject, Activity = ifelse(Activity_code==1,"Walking",ifelse(Activity_code==2,"Walking_Upstairs",ifelse(Activity_code==3,"Walking_Downstairs",ifelse(Activity_code==4,"Sitting",ifelse(Activity_code==5,"Standing","Laying"))))))

#Now it큦 time to rename the data columns (variables):
dtmeanstadrenamed<-rename(dtmeanstd, "tBodyAcc-mean()-X" = V1, "tBodyAcc-mean()-Y" = V2, "tBodyAcc-mean()-Z" = V3, "tBodyAcc-std()-X" = V4, "tBodyAcc-std()-Y" = V5, "tBodyAcc-std()-Z" = V6, "tGravityAcc-mean()-X" = V41, "tGravityAcc-mean()-Y" = V42, "tGravityAcc-mean()-Z" = V43, "tGravityAcc-std()-X" = V44, "tGravityAcc-std()-Y" = V45, "tGravityAcc-std()-Z" = V46, "tBodyAccJerk-mean()-X" = V81, "tBodyAccJerk-mean()-Y" = V82, "tBodyAccJerk-mean()-Z" = V83, "tBodyAccJerk-std()-X" = V84, "tBodyAccJerk-std()-Y" = V85, "tBodyAccJerk-std()-Z" = V86, "tBodyGyro-mean()-X" = V121, "tBodyGyro-mean()-Y" = V122, "tBodyGyro-mean()-Z" = V123, "tBodyGyro-std()-X" = V124, "tBodyGyro-std()-Y" = V125, "tBodyGyro-std()-Z" = V126, "tBodyGyroJerk-mean()-X" = V161, "tBodyGyroJerk-mean()-Y" = V162, "tBodyGyroJerk-mean()-Z" = V163, "tBodyGyroJerk-std()-X" = V164, "tBodyGyroJerk-std()-Y" = V165, "tBodyGyroJerk-std()-Z" = V166, "tBodyAccMag-mean()" = V201, "tBodyAccMag-std()" = V202, "tGravityAccMag-mean()" = V214, "tGravityAccMag-std()" = V215, "tBodyAccJerkMag-mean()" = V227, "tBodyAccJerkMag-std()" = V228, "tBodyGyroMag-mean()" = V240, "tBodyGyroMag-std()" = V241, "tBodyGyroJerkMag-mean()" = V253, "tBodyGyroJerkMag-std()" = V254, "fBodyAcc-mean()-X" = V266, "fBodyAcc-mean()-Y" = V267, "fBodyAcc-mean()-Z" = V268, "fBodyAcc-std()-X" = V269, "fBodyAcc-std()-Y" = V270, "fBodyAcc-std()-Z" = V271, "fBodyAccJerk-mean()-X" = V345, "fBodyAccJerk-mean()-Y" = V346, "fBodyAccJerk-mean()-Z" = V347, "fBodyAccJerk-std()-X" = V348, "fBodyAccJerk-std()-Y" = V349, "fBodyAccJerk-std()-Z" = V350, "fBodyGyro-mean()-X" = V424, "fBodyGyro-mean()-Y" = V425, "fBodyGyro-mean()-Z" = V426, "fBodyGyro-std()-X" = V427, "fBodyGyro-std()-Y" = V428, "fBodyGyro-std()-Z" = V429, "fBodyAccMag-mean()" = V503,"fBodyAccMag-std()" = V504, "fBodyBodyAccJerkMag-mean()" = V516, "fBodyBodyAccJerkMag-std()" = V517, "fBodyBodyGyroMag-mean()" = V529, "fBodyBodyGyroMag-std()" = V530, "fBodyBodyGyroJerkMag-mean()" = V542, "fBodyBodyGyroJerkMag-std()" = V543)

#Finnally, I get a newly ordered data table from the last one
DTgrouped<-group_by(dtmeanstadrenamed,Subject, Activity)
FinalTidyDT<-summarise_each(DTgrouped, funs(mean))


