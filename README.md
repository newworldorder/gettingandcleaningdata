# Getting and Cleaning Data Course Project 
## Requirements 

- Unzipped [UCI dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ), (a full description is available at the [main Website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)  )
- R (has only been tested with R 3.1.2)
- [dplyr](http://cran.r-project.org/web/packages/dplyr/index.html) package 

## Overview 
1. Put `run_analysis.R` and the unzipped UCI dataset folder in the same working directory
2. In R, enter the following commands 
```
> source('run_analysis.R')
> result <- make_tidy()
```
3. To observe the dataset of interest enter the following command
```
> result$d2 
```

## Function Description 
- `make_tidy(dir = "UCI HAR Dataset/")` assumes the directory name (`dir`) is unchanged.  If an absolute path is provided, the function can be run from anywhere on the filesystem. 
- `make_tidy` combines the data and test set X values (measurements), y values (activity labels), subject identifiers into a single table keeping only those X values that correspond to a _mean_ or _standard deviation_.  The y values are replaced with the character representations in `activity_labels.txt`  This data frame is stored `result$d1`.
- `make_tidy` for each (activity label, subject id) pair computes the mean for each measurement still in `result$d1`.  The names of these columns have been modified to be prepended with `MEAN_` to indicate they correspond to means.  The result of this computation is stored in `result$d2`.

## Fields in New Dataset (result$d2)
- `activity` corresponds to the verbal description of the activity label
- `subject` corresponds to the subject responsible for producing the data in a given row
- `MEAN_*` corresponds to the mean of measurements from the original UCI that corresponded to means or standard deviations. (see `features.txt` for the features containing case insensitive `mean` and `std` strings in the name)
