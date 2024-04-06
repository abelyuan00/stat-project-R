# Download required packages for data processing
# options(repos = c(CRAN = "https://mirror.rcg.sfu.ca/mirror/CRAN/"))
# install.packages("fastDummies")
# install.packages('tidyverse', dependencies=TRUE, type="source")
# install.packages("ggplot2")
# install.packages("lubridate")
# install.packages("dplyr")
library(dplyr)
library(tidyr)
library(lubridate)
library(stringr)
library(fastDummies)
# Read the data
print(class(read.csv("car_data.csv")$Annual_Income))
cars_data <- read.csv("car_data.csv") %>%
    mutate(
        Date = mdy(Date), # Convert Date to Date format assuming m/d/y format
        Engine = gsub("Â", "", Engine), # Clean Engine column
        `Price` = as.numeric(`Price`), # Ensure numeric
        Gender = ifelse(Gender == "Male", 1, 0)
    ) # Convert Gender to binary


# Na dealing with categorical columns
# Numeric columns: Replace NA with mean
numeric_columns <- sapply(cars_data, is.numeric)
cars_data[numeric_columns] <- lapply(cars_data[numeric_columns], function(x) ifelse(is.na(x), mean(x, na.rm = TRUE), x))

cars_data_encoded <- dummy_cols(cars_data, select_columns = c("Transmission", "Color", "Body_Style", "Engine", "Dealer_Region"))
# Drop the original columns to avoid multicollinearity
cars_data_encoded <- select(cars_data_encoded, -c(Transmission, Color, `Body_Style`, Engine, Dealer_Region))

cars_data_encoded <- mutate(cars_data_encoded, Car_Age = year(Sys.Date()) - year(Date))

# Write the cars_data_encoded dataframe to a CSV file
# Specify the full path if you want to save it somewhere specific
write.csv(cars_data_encoded, "cars_data_encoded.csv", row.names = FALSE)
