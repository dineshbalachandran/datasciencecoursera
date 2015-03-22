### Getting and Cleaning Data project

Run the run_Analysis() function to generate the final tidy data set required by step 5 of the project.

Three functions load_subject, load_activity and load_data loads the data in subject_test.txt, y_test.txt, X_test.txt respectively based on the file path sent as arguments to the functions. The files should be present in the "test" and "train" folders. 

Also the "features.txt" should be present in the working directory. This provides the values for the descriptive names of the columns for the measurements data.

The functions are called twice, the first to load the “test” and then to load the “train” data. cbind is used to merge subject, activity and the data measurements together. rbind is used to merge test and train data sets.

Finally, the tidy_data function, groups the data by subject and activity using the group_by dplyr package function and then using summarise_each to calculate the mean of the measurements to generate the tidy data set required by the project.