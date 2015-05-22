library(dplyr)
make_tidy <- function(dir = 'UCI HAR Dataset/'){
  # combine the X training set and test
  x_train_file <- paste0(dir, 'train/','X_train.txt')
  x_test_file <- paste0(dir, 'test/','X_test.txt')
  x_train <- read.table(x_train_file)
  x_test <- read.table(x_test_file)
  x <- rbind(x_train, x_test)

  # combine the subject training and test
  subject_train_file <- paste0(dir, 'train/','subject_train.txt')
  subject_test_file <- paste0(dir, 'test/','subject_test.txt')
  s_train <- read.table(subject_train_file)
  s_test <- read.table(subject_test_file)
  s <- rbind(s_train, s_test)

  # combine the y training set and test
  y_train_file <- paste0(dir, 'train/', 'y_train.txt')
  y_test_file <- paste0(dir, 'test/', 'y_test.txt')
  y_train <- read.table(y_train_file)
  y_test <- read.table(y_test_file)
  y <- rbind(y_train, y_test)
  y <- y[[1]]

  # transform the y values to activity labels 
  labels_file <- paste0(dir, 'activity_labels.txt')
  labels <- read.table(labels_file, colClasses = "character")
  
  # read in features 
  features_file <- paste0(dir, 'features.txt')
  f <- read.table(features_file, colClasses="character")
  f <- f[,2]
  f <- c(f, c('subject', 'activity'))
  
  # combine x, s, y 
  x <- cbind(x, s)
  x <- cbind(x, y)
  
  # give the columns names
  colnames(x) <- f
  
  keepers <- c()
  # extract the columns that are relevant those containing mean/std
  for(colname in colnames(x)){
    if(grepl('mean', colname, ignore.case=T) ||  grepl('std', colname, ignore.case=T)){
      keepers <- c(keepers, colname)
    }
  }
  keepers <- c(keepers, c('subject', 'activity'))
  ans1 <- x[,keepers]
  ans2 <- aggregate(ans1, list(ans1$subject, ans1$activity), mean)
  ans2 <- ans2[, 3:length(colnames(ans2))]
  
  # modify names for 2nd data set 
  curr_names <- colnames(ans2)
  mod_names <- c()
  for(curr_name in curr_names){
    next_name <- curr_name
    if(!(grepl('subject', curr_name)) && !(grepl('activity', curr_name))){
      next_name <- paste0('MEAN_', curr_name)
    }
    mod_names <- c(mod_names, next_name)
  }
  colnames(ans2) <- mod_names
  
  # give datasets more descriptive labels 
  l <- labels 
  for(i in 1:nrow(l)){
    ans1$activity[ans1$activity == l[i,1]] = l[i,2]
    ans2$activity[ans2$activity == l[i,1]] = l[i,2]    
  }

  list(d1=ans1, d2=arrange(ans2, subject))
}