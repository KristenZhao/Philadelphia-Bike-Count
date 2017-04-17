# Downloaded from http://dvrpc.dvrpcgis.opendata.arcgis.com/datasets/f8cf3245754c4b79a89a04a5d278a450_0.csv
# 2017-04-19 
# File downloaded as bikecount.csv

library(dplyr)
library(lubridate)
library(readr)
library(magrittr)
library(stringr)
library(purrr)
setwd("~/2016_UPennMUSA/04_Courses/08 MUSA 620/HW4-Shiny")
bike <- read_csv("DVRPC_Bicycle_Counts.csv")
head(bike)

### clean up columns and rows by removing unused ones and ones with missing data
str(bike)
bike_philly <- bike%>%
  select(-RECORDNUM,-COMMENTS,-MCD,-ROUTE,-FROMLMT,-OUTDIR,-INDIR,-TYPE,-FACTOR,-AXLE,-X,-Y)%>%
  filter(CO_NAME %in% 'Philadelphia') %>%
  filter(!is.na(AADB)) 

bike_philly$UPDATED <- as.POSIXlt(bike_philly$UPDATED, format = "%Y%m%d %H:%M:%S", tz = "UTC") %>%
  trunc('days')
head(bike_philly$UPDATED)
# bike_philly$update_date <- gsub(pattern = "(\\d{4}-\\d{2}-\\d{2}).*", replacement = "\\1",x=bike_philly$UPDATED) %>%
#   as.Date.factor(format = "%Y-%m-%d")
# head(bike_philly$update_date)
# class(bike_philly$update_date)
# bike_philly$update_time <- gsub(pattern = ".*\\s(\\d{2}:\\d{2}:\\d{2}).*", replacement = "\\1",x=bike_philly$UPDATED)
# head(bike_philly$update_time)
# test <- trunc(bike_philly$UPDATED,'days')
# test2 <- subset(test,test<as.POSIXlt('2017-03-01') & test>as.POSIXlt('2017-01-01'))
# test2
# test3 <- test$wday

# 
# crime %<>%
#   select(-Post, -Location_1, -`Total Incidents`) %>%
#   filter(!is.na(lat)) %>%
#   filter(!is.na(lng))
# 
# crime %<>%
#   filter(!is.na(CrimeDate)) %>%
#   mutate(popdate = paste("Date:", CrimeDate)) %>%
#   mutate(content = paste(popdate, Location, Description, sep = "<br/>"))
# as.factor(bike_philly$UPDATED$wday)
# wday_conversion = function(wday){
#   if (wday == 0){
#     wday = 'Sunday'
#   } else if (wday == 1){
#     wday = 'Monday'
#   } else if (wday == 2){
#     wday = 'Tuesday'
#   } else if (wday == 3){
#     wday = 'Wednesday'
#   } else if (wday == 4){
#     wday = 'Thursday'
#   } else if (wday == 5){
#     wday = 'Friday'
#   } else{
#     wday = 'Saturday'
#   }
# }
bike_philly%<>%
  mutate(popinfo = paste('Bicycle Count:',AADB))
head(bike_philly$popinfo)
# %>%
#   wday_conversion() 

saveRDS(bike_philly, "bike_philly.rds")
