install.packages("tidyverse")
library(tidyverse)
install.packages("lubridate")
library(lubridate)
install.packages("scales")
library(scales)
install.packages("janitor")
library(janitor)
install.packages("here")
library(here)
install.packages("readr")
library(readr)

##Load Data
my_colnames <- c("member_casual", "day_of_week", "number_of_rides", "average_ride_length")
trip_summary<-read_csv("Cyclistic_Summary.csv",col_names=my_colnames)
trip_summary <- trip_summary %>%
  filter(!is.na(day_of_week)) %>%
  mutate(day_of_week = case_when(
    day_of_week == 1 ~ "Sun",
    day_of_week == 2 ~ "Mon",
    day_of_week == 3 ~ "Tue",
    day_of_week == 4 ~ "Wed",
    day_of_week == 5 ~ "Thu",
    day_of_week == 6 ~ "Fri",
    day_of_week == 7 ~ "Sat"
  )) %>%
  mutate(day_of_week = factor(day_of_week, 
                              levels = c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")))


##Volume By Ride Visualization
ggplot(data = trip_summary)+geom_col(mapping = aes(x=day_of_week,y=number_of_rides,fill = member_casual),position = 'dodge')+scale_y_continuous(labels = label_comma())+scale_fill_manual(values = c("member" = "#2c3e50","casual" = "#e74c3c"))+labs(title = "Average Ride Duration: Casual vs. Members",subtitle = "Casual members consistently ride longer than annual members",x="Day of the Week",y="Average Minutes Per Ride",fill="User Type")+theme_minimal()+theme(legend.position = "Top")

## Average Time Duration Visualization
ggplot(data = trip_summary)+geom_col(mapping = aes(x= day_of_week,y=average_ride_length,fill = member_casual), position = 'dodge')+scale_fill_manual(values = c("member"="#2c3e50","casual"="#e74c3c"))+labs(title = "Average Ride Duration By Day", subtitle = "Casual riders consistently ride for longer durations",x = "Day of the week",y="Average Minutes",fill="User Type")+theme_minimal()

##Preparing the station data
stations_columns<-c("start_station_name","number_of_rides")
top_stations<-readr::read_csv("top_stations_csv.csv",col_names=stations_columns)

##Hot Zones Visualization (Top 10 Stations)
ggplot(data = top_stations)+geom_col(mapping = aes(x= reorder(start_station_name,number_of_rides),y=number_of_rides), fill ="#e74c3c" )+coord_flip()+scale_y_continuous(labels = label_comma())+labs(title = "Top 10 Start Stations: Casual Riders",subtitle = "Where we should place our membership conversions ads?",x="Station Names",y= "Total number of rides")+theme_minimal()
