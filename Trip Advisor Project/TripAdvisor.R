library(rvest)
library(dplyr)
library(tidyverse)
library(stringr)
library(tibble)
library(RSQLite)
library(rvest)


setwd("C:/Users/Hemanth Lakshman/Documents/Trip Advisor Project")
restaurant<-read.csv("Restaurants.csv",header=T, na.strings=c("","NA"))
hotel<-read.csv("Hotels.csv")
flights<-read.csv("Flights.csv")
Points_of_interest<-read.csv("Points_of_interest.csv")

str(restaurant)

restaurant$Review_1 <- as.character(restaurant$Review_1)
restaurant$Review_2 <- as.character(restaurant$Review_2)
restaurant$Review_Count<-gsub("[A-z]","",restaurant$Review_Count)
hotel$Hotel_Web_Link <- as.character(hotel$Hotel_Web_Link)
class(hotel$Hotel_Web_Link)
names(restaurant) <- c("Restaurant_Name","Restaurant_Web_Link","Review_Count","Price.Range","Cuisines_offered_1","Cuisines_offered_2","Review_1","Review_1_date","Review_2","Review_2_date","Category","Cuisines_offered_3","Cuisines_offered_4","Cuisines_offered_5") 
restaurant <- unite(restaurant,"Cuisine",c(Cuisines_offered_1,Cuisines_offered_2,Cuisines_offered_3,Cuisines_offered_4,Cuisines_offered_5),sep=",",remove=TRUE)
restaurant$Cuisine <- gsub("(?:NA\\,)|NA","",restaurant$Cuisine)
restaurant$Cuisine <- gsub("\\,$","",restaurant$Cuisine)

hotel$address <- rep(NA,nrow(hotel))
for(i in 1:nrow(hotel)){
  print(hotel$Hotel_Web_Link[[i]])
  htm <- read_html(hotel$Hotel_Web_Link[[i]])
  add1 <- htm %>% html_node(css="span.street-address") %>% html_text()
  add2 <- htm %>% html_node(css="span.extended-address") %>% html_text()
  add3 <- htm %>% html_node(css="span.locality") %>% html_text()
  add4 <- htm %>% html_node(css="span.country-name") %>% html_text()
  hotel$address[[i]] <- paste(add1,add2,add3,add4,collapse=',')
}
rm(restaurant
  )

db<- dbConnect(SQLite(), dbname = 'TripAdvisor')

