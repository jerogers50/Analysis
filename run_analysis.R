## You should create one R script called run_analysis.R that does the following. 
## Merges the training and the test sets to create one data set.
## Extracts only the measurements on the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

  setwd("./UCI HAR Dataset/")
  
## Collect test data by reading .txt files and assigning column names to tables X_test and Y_test tables.
  X_test<-read.table("test/X_test.txt", header=FALSE)
  Y_test<-read.table("test/Y_test.txt", header=FALSE)
  subject_test<-read.table("test/subject_test.txt", header=FALSE)
  
  features<-read.table("features.txt")[,2]
  names(X_test)<-features
  extract_features<-grepl("mean|std", features)
  
  
  X_test<-X_test[,extract_features]
  
  Activity_Label<-read.table("activity_labels.txt", header=FALSE)[,2]
  
  Y_test[,2]<-Activity_Label[Y_test[,1]]
  names(Y_test)<-c("Activity_ID", "Activity_Label")
  names(subject_test)<-"subject"

## Create test_data table contain both X_test and Y_test data  
  test_data <- cbind(data.table(subject_test), Y_test, X_test)
  
## ## Collect train data by reading .txt files and assigning column names to tables X_train and Y_train tables.
  X_train<-read.table("train/X_train.txt", header=FALSE)
  Y_train<-read.table("train/Y_train.txt", header=FALSE)
  subject_train<-read.table("train/subject_train.txt", header=FALSE)
  
  names(X_train)<-features
  
  X_train<-X_train[,extract_features]
  
  Y_train[,2]<-Activity_Label[Y_train[,1]]
  names(Y_train)<-c("Activity_ID", "Activity_Label")
  names(subject_train)<-"subject"

## Create train_data table contain both X_test and Y_test data  
  train_data<-cbind(data.table(subject_train), Y_train, X_train)
  
## Merge train and test data
  data<-rbind(test_data, train_data)
  
  id_variables<-c("subject", "Activity_ID", "Activity_Label")
  measure_variables<-setdiff(colnames(data), id_variables)
  melt_data<-melt(data, id = id_variables, measure.vars = measure_variables)
  
  tidy_data<-dcast(melt_data, subject + Activity_Label ~ variable, mean)

## Write table containing merged train and test data  
  write.table(tidy_data, file = "./Analysis/tidy_data.txt")
  
## write codebook to disk
  write.table(paste("* ", names(tidy_data), sep=""), file="./Analysis/CodeBook.md", quote=FALSE,
              row.names=FALSE, col.names=FALSE, sep="\t")
  
