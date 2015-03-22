library(dplyr)

## load the subject data to a data frame given a file path and name in 'file'
load_subject <- function (file) {
  
  subject <- read.table(file, header=FALSE)
  
  names(subject) <- "subj.id"
  
  return (subject)
  
}

## load the activity data given a file path and name (in the 'file' argument)
load_activity <- function(file) {
  
  activity <- read.table(file, header=FALSE)
  
  names(activity) <- "act.id"
  
  activity$act.name[activity$act.id=="1"] <- "WALKING"
  activity$act.name[activity$act.id=="2"] <- "WALKING_UPSTAIRS"
  activity$act.name[activity$act.id=="3"] <- "WALKING_DOWNSTAIRS"
  activity$act.name[activity$act.id=="4"] <- "SITTING"
  activity$act.name[activity$act.id=="5"] <- "STANDING"
  activity$act.name[activity$act.id=="6"] <- "LAYING"
  
  ## return the descriptive activity names, as required by step 3
  return (activity["act.name"])
  
}

## load the measurement data set given a file path and name (in the 'file' argument)
load_data <- function(file){
  
  ##  pick the following columns from the file which have the mean and sd values
  ## as required by step 2 of the project
  ##  1,2,3,4,5,6,41,42,43,44,45,46,81,82,83,84,85,86,121,122,123,124,125,126,
  ##  161,162,163,164,165,166,201,202,214,215,227,228,240,241,253,254,266,267,
  ##  268,269,270,271,345,346,347,348,349,350,424,425,426,427,428,429,503,504,
  ##  529,530,542,543
  
  columns <- c(1,2,3,4,5,6,41,42,43,44,45,46,81,82,83,84,85,86,121,122,123,124,125,126,
              161,162,163,164,165,166,201,202,214,215,227,228,240,241,253,254,266,267,
              268,269,270,271,345,346,347,348,349,350,424,425,426,427,428,429,503,504,
              529,530,542,543)
  
  ## set up the columns to read as "numeric" and the columns to be discarded as "NULL"
  ## set this in colClasses in read.table, to read only the columns we are 
  ## interested in
  colSelect <- c(rep("numeric",6),rep("NULL",34),rep("numeric",6),rep("NULL",34),
                 rep("numeric",6),rep("NULL",34),rep("numeric",6),rep("NULL",34),
                 rep("numeric",6),rep("NULL",34),rep("numeric",2),rep("NULL",11),
                 rep("numeric",2),rep("NULL",11),rep("numeric",2),rep("NULL",11),
                 rep("numeric",2),rep("NULL",11),rep("numeric",2),rep("NULL",11),
                 rep("numeric",6),rep("NULL",73),rep("numeric",6),rep("NULL",73),
                 rep("numeric",6),rep("NULL",73),rep("numeric",2),rep("NULL",24),
                 rep("numeric",2),rep("NULL",11),rep("numeric",2),rep("NULL",18))
   
  data <- read.table(file, colClasses=colSelect, header=FALSE)
  
  ## load the features txt file to give descriptive column names to the 'data' data.frame
  features <- read.table("./features.txt", colClasses=c("integer", "character"), 
                         header=FALSE)

  ## generate column names from the features data for the measurement variables 
  ## selected (indicated by 'columns')
  
  j <- 1
  colNames <- NULL
  for (i in columns) {
    ## remove all '-' and '()'
    colNames[j] <- gsub("[()-]", "", features[i,"V2"])
    j <- j + 1
  }
  
  ## set the descriptive column names, as required by step 4
  names(data) <- colNames 
  
  return (data)
}

## load and merge subject, activity and the measurements into a data frame
load_and_merge <- function(subject_file, activity_file, data_file) {
  
  subject <- load_subject(subject_file)
  activity <- load_activity(activity_file)
  data <- load_data(data_file)
  
  merged_data <- cbind(subject, activity, data)
  
  return (merged_data)
  
}

## the main function to clean up and merge data in 'test' and 'train'
## returns the tidy dataset
run_Analysis <- function() {
  
  subject_file <- "./test/subject_test.txt"
  activity_file <- "./test/y_test.txt"
  data_file <- "./test/X_test.txt"
  
  test_data <- load_and_merge(subject_file, activity_file, data_file)
  
  subject_file <- "./train/subject_train.txt"
  activity_file <- "./train/y_train.txt"
  data_file <- "./train/X_train.txt"
  
  train_data <- load_and_merge(subject_file, activity_file, data_file)
  
  ## combine the two data sets, as required by step 1
  dataset <- rbind(test_data, train_data)
  
  tidy_dataset <- tidy_data(dataset)
  
  return (tidy_dataset)
  
}

## creates the tidy data as required by step 5
tidy_data <- function(dataset) {
  
  ## group by subject and then by activity
  grp_dataset <- group_by(dataset, subj.id, act.name)
  
  ## summarise to get average value of all columns
  tidy_dataset <- summarise_each(grp_dataset, funs(mean))
  
  write.table(tidy_dataset, file="./tidy_data.txt", row.name=FALSE)
  
  return (tidy_dataset)
}