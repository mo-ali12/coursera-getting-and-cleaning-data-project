---
title: "getting and cleaning data Project"
output: pdf_document
---


# prerequisite

```{r}
library(dplyr)
```


# 1. Loading Data and Merge the training and the test sets to create one data set.

Columns names

```{r}
activity_data <- read.table("C:/Users/Mohsin Ali/Documents/R/UCI HAR Dataset/activity_labels.txt", stringsAsFactors = FALSE, col.names = c("code", "activity_name"))
str(activity_data)

head(activity_data)

```


```{r}

data_columns_names <- read.table("C:/Users/Mohsin Ali/Documents/R/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE, col.names = c("Id", "name"))
str(data_columns_names)

head(data_columns_names)

```

Reading train and test data for y (target variable)

```{r}
train_data_y <- read.table("C:/Users/Mohsin Ali/Documents/R/UCI HAR Dataset/train/y_train.txt", stringsAsFactors =FALSE, col.names = "code")

str(train_data_y)

head(train_data_y)

```

```{r}
test_data_y <-  read.table("C:/Users/Mohsin Ali/Documents/R/UCI HAR Dataset/test/y_test.txt", stringsAsFactors =FALSE, col.names = "code")

str(test_data_y)

head(test_data_y)

```

Reading train and test data for x (features)

```{r}
train_data_x <- read.table("C:/Users/Mohsin Ali/Documents/R/UCI HAR Dataset/train/x_train.txt", stringsAsFactors =FALSE, col.names = data_columns_names$name )

str(train_data_x, list.len = 10)

head(train_data_x)

```

```{r}
test_data_x <- read.table("C:/Users/Mohsin Ali/Documents/R/UCI HAR Dataset/test/x_test.txt", stringsAsFactors =FALSE, col.names = data_columns_names$name)

str(test_data_x, list.len = 10)
head(train_data_x)
```

Reading train and test data for subjects

```{r}
test_subject <- read.table("C:/Users/Mohsin Ali/Documents/R/UCI HAR Dataset/test/subject_test.txt", stringsAsFactors =FALSE, col.names = "subject")

str(test_subject)
head(test_subject)

```

```{r}
train_subject <- read.table("C:/Users/Mohsin Ali/Documents/R/UCI HAR Dataset/train/subject_train.txt", stringsAsFactors =FALSE, col.names = "subject")

str(train_subject)
head(train_subject)
```

## Binding  X train and test

```{r}

merged_x <- bind_rows(train_data_x,test_data_x)
str(merged_x, list.len = 10)
head(merged_x)

```

## Binding Y train and test

```{r}
merged_y <- bind_rows(train_data_y, test_data_y)

str(merged_y, list.len = 10)

head(merged_y)

```

## Binding subject data for X and Y

```{r}
merged_data_subject <- bind_rows(train_subject, test_subject)

str(merged_data_subject, list.len = 10)

head(merged_data_subject)
```

## All merged data(train, test, subject) into one final dataframe and Using descriptive activity names to name the activities in the data set :

```{r}
merged_data <- bind_cols(merged_data_subject,merged_x,merged_y)

str(merged_data, list.len = 10)

head(merged_data)

merged_data$code <- activity_data[merged_data$code, 2]

merged_data %>%
  select(subject, code)%>%
  filter(code == "WALKING_DOWNSTAIRS")

```


# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

```{r}
tidy_data <- merged_data %>%
  select(subject, code, contains("mean"), contains("std"))
head(tidy_data)

tidy_data %>%
  filter(code == "STANDING")

```

# 3. Appropriately labels the data set with descriptive variable names.

```{r}
library(stringr)

tidy_data <- tidy_data %>%
  rename_all(funs(str_replace(., "Acc", "Accelerometer")))%>%
  rename_all(funs(str_replace(., "Gyro", "Gyroscope")))%>%
  rename_all(funs(str_replace(., "BodyBody", "Body")))%>%
  rename_all(funs(str_replace(., "Mag", "Magnitude")))%>%
  rename_all(funs(str_replace(., "^t", "Time")))%>%
  rename_all(funs(str_replace(., "^f", "Frequency")))%>%
  rename_all(funs(str_replace(., "tBody", "TimeBody")))%>%
  rename_all(funs(str_replace(., "-std()", "STD")))%>%
  rename_all(funs(str_replace(., "-mean()", "Mean")))%>%
  rename_all(funs(str_replace(., "-freq()", "Frequency")))%>%
  rename_all(funs(str_replace(., "angle", "Angle")))%>%
  rename_all(funs(str_replace(., "gravity", "Gravity")))

tidy_data

```

# 4. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```{r}
final_data <- tidy_data %>%
  summarise_all(funs(mean))

final_data

write.table(final_data, "FinalData.txt", row.names = FALSE)

```

