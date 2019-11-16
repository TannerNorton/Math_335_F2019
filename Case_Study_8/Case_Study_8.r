# Tanner Norton
# Case Study 8

# Load libraries
pacman::p_load(tidyverse, readxl, stringr, blscrapeR, forcats, skimr, rio, lubridate, riem, viridis, RColorBrewer, epitools)

# Read in the data from https://byuistats.github.io/M335/data/sales.csv and format it for visualization and analysis
# The data are for businesses in the mountain time zone make sure you read in times correctly
sales <- read_csv("https://byuistats.github.io/M335/data/sales.csv") %>%
  filter(Amount > 0,
         Name != "Missing") %>% 
  mutate(MT = with_tz(Time, tz = "US/Mountain"),
         hour_ceiling =  ceiling_date(MT, unit = "hours"))




# This is point of sale (pos) data, so you will need to use library(lubridate) to create the correct time aggregations
# Check the data for any inaccuracies
# Aggregate the point of sale data into hour sales totals

# Create Daily data
daily <- sales %>%
  filter(Amount > 0) %>% 
  group_by(Name) %>% 
  mutate(MT = with_tz(Time, tz = "US/Mountain"),
         hour_ceiling =  ceiling_date(MT, unit = "hours"),
         day = day(MT),
         wday =  ymd_hms(MT) %>%
           wday(label = TRUE)) %>% 
  group_by(Name, wday) %>%
  summarise(wday_rev = sum(Amount)) %>%
  select(Name, wday, wday_rev)

# Turn days into factors
daily$wday <- factor(daily$wday)
  

# Create Weekly data
weekly <- sales %>%
  filter(Amount > 0) %>%
  mutate(MT = with_tz(Time, tz = "US/Mountain"),
         week = week(MT)) %>% 
  group_by(Name, week) %>%
  summarise(weekly_rev = sum(Amount)) %>%
  select(Name, week, weekly_rev)

# Turn weeks into factors
weekly$week <- factor(weekly$week)


# Create Monthly data
monthly <- sales %>% 
  filter(Amount >0) %>% 
  mutate(MT = with_tz(Time, tz = "US/Mountain"),
         month_num = month(MT),
         month = case_when(month_num == 5 ~ "May",
                            month_num == 6 ~ "June",
                            month_num == 7 ~ "July")) %>% 
  group_by(Name, month) %>%
  summarise(monthly_rev = sum(Amount)) %>%
  select(Name, month, monthly_rev)

# Turn months into factors
monthly$month <- factor(monthly$month)
is.factor(monthly$month)

# Create total revenue data

total <- sales %>% 
  group_by(Name) %>% 
  summarise(total_rev = sum(Amount))



# Help your boss understand which business is the best investment through visualizations
# Provide an understanding and recommendation for hours of operation

# Daily Revenue
ggplot(daily, aes(x = wday, y = wday_rev, col = Name)) +
  geom_point() +
  facet_wrap(~ Name) +
  scale_y_continuous(labels = scales::dollar) +
  labs(title = "Daily Revenue",  x = "Day", y = "Revenue in $")


# Weekly Revenue
ggplot(weekly, aes(x = week, y = weekly_rev, col = Name)) +
  geom_point() +
  facet_wrap(~ Name) +
  scale_y_continuous(labels = scales::dollar) +
  labs(title = "Weekly Revenue", x = "Revenue in $", y = "Week of year")


# Monthly Revenue
ggplot(monthly, aes(x = month, y = monthly_rev)) +
  geom_bar(stat = "identity") +
  facet_grid(~ Name) +
  scale_y_continuous(labels = scales::dollar) +
  labs(title = "Monthly Revenue", x = "Month", y = "Revenue in $")



# Total Revenue
ggplot(total, aes(x = Name, y = total_rev)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::dollar) +
  labs(title = "Total Revenue", x = "Month", y = "Revenue in $")


# Provide a final comparison of the six companies and a final recommendation

