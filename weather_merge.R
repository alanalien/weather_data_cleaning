# import data -------------------------------------------------------------

temperature <- read.csv("Google Drive/2019 Spring/INFO 658 Information Visualization/week 06 Tableau Lab/Lab2_Tableau_historical_weather/historical-hourly-weather-data/transposed/temperature_cleaned.csv")
humidity <- read.csv("Google Drive/2019 Spring/INFO 658 Information Visualization/week 06 Tableau Lab/Lab2_Tableau_historical_weather/historical-hourly-weather-data/transposed/humidity_cleaned.csv")
pressure <- read.csv("Google Drive/2019 Spring/INFO 658 Information Visualization/week 06 Tableau Lab/Lab2_Tableau_historical_weather/historical-hourly-weather-data/transposed/pressure_cleaned.csv")
weather_description <- read.csv("Google Drive/2019 Spring/INFO 658 Information Visualization/week 06 Tableau Lab/Lab2_Tableau_historical_weather/historical-hourly-weather-data/transposed/weather_description_cleaned.csv")
wind_direction <- read.csv("Google Drive/2019 Spring/INFO 658 Information Visualization/week 06 Tableau Lab/Lab2_Tableau_historical_weather/historical-hourly-weather-data/transposed/wind_direction_cleaned.csv")
wind_speed <- read.csv("Google Drive/2019 Spring/INFO 658 Information Visualization/week 06 Tableau Lab/Lab2_Tableau_historical_weather/historical-hourly-weather-data/transposed/wind_speed.csv")

summary(temperature)
summary(humidity)
summary(pressure)
summary(weather_description)
summary(wind_direction)
summary(wind_speed)

dim(temperature)
dim(humidity)
dim(pressure)
dim(weather_description)
dim(wind_direction)
dim(wind_speed)


# merge weather data to one frame -----------------------------------------

weather <- merge(temperature, humidity)
weather <- merge(weather, pressure)
weather <- merge(weather, wind_direction)
weather <- merge(weather, wind_speed)
weather <- merge(weather, weather_description)

summary(weather)
dim(weather)

# repalce empty values in column weather_description
unique(weather$weather_description)
weather$weather_description[weather$weather_description == ""] <- NA

summary(weather)
dim(weather)
head(weather)


# merge geo-data ----------------------------------------------------------

geoinfo <- read.csv("Google Drive/2019 Spring/INFO 658 Information Visualization/week 06 Tableau Lab/Lab2_Tableau_historical_weather/historical-hourly-weather-data/city_attributes.csv")
# turn headers to lowercase
names(geoinfo) <- tolower(names(geoinfo))
print(geoinfo)

weather_geo <- merge(weather, geoinfo)

dim(weather_geo)
summary(weather_geo)
head(weather_geo)


# convert temperature unit Kalvin to Celsius ------------------------------

weather_geo$temperature <- weather_geo$temperature - 273.15
head(weather_geo)
dim(weather_geo)


# sorting data by city and datetime columns -------------------------------

weather_geo <- weather_geo[order(weather_geo$city, weather_geo$datetime ),]


# remove first column (row number) ----------------------------------------

weather_geo_cleaned <- weather_geo[,(1:11)]
head(weather_geo_cleaned)


# replace NA to mean value of previous and following rows for tableau -----

weather_geo$temperature[weather_geo$temperature == "NA"] <- ""
weather_geo$pressure[weather_geo$pressure == "NA"] <- ""
weather_geo$humidity[weather_geo$humidity == "NA"] <- ""
weather_geo$wind_direction[weather_geo$wind_direction == "NA"] <- ""
weather_geo$wind_speed[weather_geo$wind_speed == "NA"] <- ""
head(weather_geo)

# install.packages("zoo")


# # option_1_fail
# # https://stackoverflow.com/questions/24341178/replace-na-with-mean-of-values-in-previous-and-following-row-in-r
# library(plyr)
# library(zoo)
# library(tidyverse)
# 
# my.na.approx <- function(x) {
#   if (sum(is.finite(x)) == 0L) return(x)
#   if (sum(is.finite(x)) == 1L) return(na.approx(x, rule=2, method="constant"))
#   na.approx(x, rule=2)
# }

# head(my.na.approx(weather_geo$temperature))
# glimpse(my.na.approx(weather_geo$temperature))
# glimpse(my.na.approx(weather_geo$temperature[weather_geo$temperature == NA]))


# option_2_fail
# https://stackoverflow.com/questions/22916525/replace-na-with-previous-and-next-rows-mean-in-r

# approximate <- which(is.na(weather_geo$temperature))
# test <- sapply(approximate, function(i) with(weather_geo, mean(c(temperature[i-1], temperature[i+1]))))
# print(test)


# write to a new csv ------------------------------------------------------

head(weather_geo)
summary(weather_geo)
write.csv(weather_geo, "Desktop/weather_cleaned_geo.csv")



# select 2013-2017 --------------------------------------------------------





# split by year -----------------------------------------------------------

# weather_geo_2012 <-
#   split(weather_geo, weather_geo$datetime == "^2012", drop = FALSE)
# summary(weather_geo_2012)
# write.csv(weather_geo_2012, "Desktop/weather_cleaned_geo_2012.csv")

# weather_geo_2013 <- split(weather_geo, weather_geo$datetime == "^2013", drop = FALSE)
# summary(weather_geo_2013)
# write.csv(weather_geo_2013, "Desktop/weather_cleaned_geo_2013.csv")
# 
# weather_geo_2014 <- split(weather_geo, weather_geo$datetime == "^2014", drop = FALSE)
# summary(weather_geo_2014)
# write.csv(weather_geo_2014, "Desktop/weather_cleaned_geo_2014.csv")
# 
# weather_geo_2015 <- split(weather_geo, weather_geo$datetime == "^2015", drop = FALSE)
# summary(weather_geo_2015)
# write.csv(weather_geo_2015, "Desktop/weather_cleaned_geo_2015.csv")
# 
# weather_geo_2016 <- split(weather_geo, weather_geo$datetime == "^2016", drop = FALSE)
# summary(weather_geo_2016)
# write.csv(weather_geo_2016, "Desktop/weather_cleaned_geo_2016.csv")
# 
# weather_geo_2017 <- split(weather_geo, weather_geo$datetime == "^2017", drop = FALSE)
# summary(weather_geo_2017)
# write.csv(weather_geo_2017, "Desktop/weather_cleaned_geo_2017.csv")
