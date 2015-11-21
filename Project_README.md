
ANALYSIS AND DESCRIPTION OF THE SCRIPT ON THE run_analysis.R FILE 
Getting & Cleaning Data - Course Project
Data Science Specialization - Coursera.

============================================================================
Author: C.A.Nallim
November, 2015
============================================================================

This file explains the reasons behind the operations, decisions taken and input/output data to the  accompanying "run_analysis.R" code script, with references where needed.
If you want to look at the final file produced by the code, as explained below, please download and read the attached FinalTidyDT.txt file as follows:
 
data <- read.table(file_path, header = TRUE)
View(data)

=============================================================================
GENERAL INFO

Packages needed to run the script:
data.table
dplyr

Note that these packages requiere R version 3.2.2

=============================================================================
1.- INITIAL STEPS, DATA INPUT AND DATA EXAMINATION

Download directory with files from this link to a local directory
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

Unzip the downloaded directory into your local directory

Using the R setwd() command, turn that directory into your working directory.

Provided .txt files are read using the "fread" command (data.table package). In the run_analysis.R script this is done in rows 10 - 24

Examine the files and subdirectories needed according to the instructions.

From that step, the useful files to produce the required tidy data set are as follows:

a) Descriptive files
README.txt
features.txt
features_info.txt
activity_labels.txt

b) Data files
b.1) From "test" directory
subject_test.txt
X_test.txt
y_test.txt

b.2) From "train" diredtory
subject_train.txt   
X_train.txt  (loaded in R it is a data table containing 7352 obs of 561 variables)
y_train.txt

The original README.txt contains general description of the experiment carried out, number of participantes, values measured and how they were processed, as well as information on files´ contents (description, units, ranges) and how they relate to one another (matching info).

features_info.txt includes  detailed info on signals obtained, transformation processes and a description of the variables estimated from those signals.


The "train" directory files contain data for 9 of the 30 volunteers that participated in the experiment, while the "test" directory files have the information for the remaining 21 subjects.

Loaded in R this is what you find in them:

.- subject_(test/train).txt  => they are data tables containing 2947 (test)/ 7352 (train) obs of 1 variables (it is a variable, with a total combined range of 1 to 30). It tells to whom (i.e.which of the 30 subjects) the variables values in the other corresponding files belong to, on a per row basis. 

.- X_(train/test).txt =>  these files contain the actual measurements and derived data. In R they are data tables containing 7352 (X_train / 2947 (X_test) observations of 561 variables. Variables have no descriptive column headers. These headers should be obtained from the features.txt file (1 column with the 561 variable names).

.- y_(train/test).txt => in R these files are read as data tables of 1 column (no descriptive header) of 7352 (y_train) / 2947 (y_test) values, that link same row data to a given activity. The list of activities that match the coded numbers (range: 1 to 6) is found in the activity_labels.txt file.



2.- PROCESSING PROCEDURE

2.1 STEP 1: "Merge the training and the test sets to create one data set."

The script code binds columns for the "train" - related data (code rows 26 - 30). Result is a combined data table named "utrain" (dimensions: 7352 obs of 563 variables)

The same procedure is applied to the "test"-related data (result: combined "wtest" data table, with 2947 obs of 563 variables).

Both data tables are combined in a single one by row binding. Result: complete dset1 data table (10299 obs of 563 variables). Scritp row performing this operation: 37

Renaming of the last two columns is performed to avoid repeated "V1" headers that may prove confusing. Code script rows 43 and 44 do this.


2.2 STEP 2: "Extract only the measurements on the mean and standard deviation for each measurement."

IMPORTANT: Variable Selection Criteria
Which of the 561 data variables to keep? There are several variables with the "mean" indication on their names. A decision has to be made (See "what columns are measurements on the mean and standard deviation" in https://thoughtfulbloke.wordpress.com/2015/09/09/getting-and-cleaning-the-assignment/)

Basically, using the info in "features_info.txt", I have chosen variables as close to the raw data as possible. That means that I decided to keep variables ending in -mean() (including those -mean()-X/Y/Z)  and -std() (including those -std()-X/Y/Z),  and disregarded  meanFreq() variables (these are weighted averages), as well as the angle variables ending in Mean ("...obtained by averaging the signals ...", as explained in "features_info.txt").

The remaining variables to continue the script analysis are in the "keep" vector (script row 47).
Based on this, next the complete data table is subsetted (script row 50). We get the "dtmeanstd" data table (dimensions: 10299 obs of 68 varables, i.e 66 data variables, plus one "subject" variable and one "activity code" one).

2.3 STEP 3: "Use descriptive activity names to name the activities in the data set"

The activities are coded (1,2,...,6), So we need to change those numbers for descriptive activities labels (i.e. words in plani English). The matching, and the descriptive names, are in the "activity_labels.txt" file.
With that information, I use the dplyr´s package transmute command to substitute activity codes for activity labels, while keeping all the other columns of the data table. This is performed in by script row 55.

2.4 STEP 4: "Appropriately label the data set with descriptive variable names."

To carry out this step, I refer to the features.txt file. Label number "n"  (i.e. nth row) in that file corresponds to variable "V(n)" in our current dataset (dtmeanstd).
Rename command carries out this operation (script row 58). Fully variable-renamed data table is "dtmeanstadrenamed" (still, obviously, with 10299 obs of 68 variables)

I have used the original variable names because they are descriptive enough. Why are these variables descriptive?
They were constructed  with four-level descriptors and axis-related suffixes when needed, as follows:

First descriptor: "t" or "f": prefix "t" denotes time, while prefix "f" denotes frequency domain signals.
Second descriptor: "BodyAcc", "GravityAcc", "BodyGyro", implying body acceleration, gravity acceleration, and body angular velocity
Third descriptor: "Jerk" (body linear acceleration and angular velocity derived in time, i.e. "the acceleration of the acceleration") 
Fourth descriptor: "Mag"(from "magnitude" of some of the three-dimensional signals, calculated using the Euclidean norm)
Axis related suffixes (when appropriate): -X, -Y, -Z


2.5 STEP 5: "From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject."

Again, I use commands from "dplyr" package. First I group by Subject and Activity criteria.
Finally, the summarise_each command is applied using the function "mean" to obtain the average for each variable, for each activity and each subject.

Resulting dataset is saved as FinalTidyDT data table. This is the final output required. 

Why is it tidy?

Because it complies with the basic criteria "each variable forms a column" and "each observation forms a row".
As further check, the FinalTidyDT dataset does not have any of the five most common problems with messy datasets, as described by Hadley Wickham (Section 3, "Tidying messy datasets", page 5) in http://www.jstatsoft.org/article/view/v059i10/v59i10.pdf














