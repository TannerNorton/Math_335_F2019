# Tanner Norton
# Case Study 4

library(reprex) 
library(mosaic)
library(tidyverse)
library(mosaic)
library(devtools)
library(usethis)
library(pander)
library(dplyr)
library(RColorBrewer)

#download.file("https://raw.githubusercontent.com/fivethirtyeight/guns-data/master/full_data.csv", "full_data.csv")


deaths <- read_csv("https://raw.githubusercontent.com/fivethirtyeight/guns-data/master/full_data.csv")
deaths <- read_csv("C:/Users/User/Documents/Fall 2019/Math 335/M335_FA19_Norton_Tann/full_data.csv")

glimpse(deaths)

deaths <- deaths %>%
  mutate(intent = fct_relevel(intent,c("Suicide","Homicide","Accidental","Undetermined")))

is.factor(deaths$intent)

deaths$intent <- as.factor(deaths$intent)



# Part 1
# Graph similar to fivethirtyeight, 2/3 of deaths from suicides
ggplot(deaths, aes(x = intent)) +
  geom_bar(fill = grey.colors(5)) +
  labs(x = "Category of death", y = "Number of deaths", title = "US Gun related deaths: 2012-2014")





# Part 2

# Address the clients needs for the information about how to reduce deaths based off of the different seasons (months)?

# Tidy data
death_season <- deaths %>%
  group_by(intent, year) %>%
  mutate(season = case_when(month %in% c("12","01","02") ~ "Winter",
         month %in% c("03","04","05") ~ "Spring",
         month %in% c("06","07","08") ~ "Summer",
         month %in% c("09","10","11") ~ "Fall"),
         death = 1 )

# Tidy data 2
death_group <- death_season %>%
  group_by(intent, season, education) %>%
  summarise(count = n())


# Total deaths by season of the year from 2012-2014
ggplot(death_group, aes(x = season, y = count , color = intent)) +
  geom_point() 

# Variation in the data
ggplot(death_group, aes(x = season, y  = count)) +
  geom_boxplot() 



# Tidy data 3
death_3 <- deaths %>%
  mutate(season = case_when(month %in% c("12","01","02") ~ "Winter",
                            month %in% c("03","04","05") ~ "Spring",
                            month %in% c("06","07","08") ~ "Summer",
                            month %in% c("09","10","11") ~ "Fall"),
         death = 1,
         count = n())

death_4 <- death_3 %>%
  group_by(season, education) %>%
  summarise(count = n())

# The client should focus on HS/GED grads during the Spring and Summer months
ggplot(death_4, aes(x = season, y = count , color = education)) +
  geom_point() +
  labs(x = "Education level", y = "Number of Deaths", title = "US Gun related deaths: 2012-2014")



ggplot(death_season) + 
  geom_histogram(aes(x = age), binwidth = 5, fill = "firebrick", alpha = .6) +
  labs(x = "Age", y = "Number of Deaths", title = "Gun related deaths by Age & Season")  +
  facet_grid(season~intent) + 
  scale_x_continuous(breaks = seq(0, 100, by = 10)) +
  theme_bw() 


# death season barplot


ggplot(death_season, aes(x = season)) +
  geom_bar() +
  labs(x = "Season", y = "Number of Deaths", "Number of gun deaths 2012-2014")








