---
title: "Case Study 8"
author: "Tanner Norton"
date: "November 12, 2019"
output:
  html_document:  
    keep_md: true
    toc: true
    toc_float: true
    code_folding: hide
    fig_height: 6
    fig_width: 12
    fig_align: 'center'
---






```r
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

# Create total revenue data
total <- sales %>% 
  group_by(Name) %>% 
  summarise(total_rev = sum(Amount))
```

## Background

We have transaction data for a few businesses that have been in operation for three months. Each of these companies has come to your investment company for a loan to expand their business. Your boss has asked you to go through the transactions for each business and provide daily, weekly, and monthly gross revenue summaries and comparisons. Your boss would like a short write up with tables and visualizations that help with the decision of which company did the best over the three month period. You will also need to provide a short paragraph with your recommendation after building your analysis.

In our course we are only looking at understanding and visualizing recorded time series data. If you would like to learn more about forecasting I would recommend Forecasting: Principles and Practice and for a quick introduction see here


## Daily Revenue


```r
# Daily Revenue
ggplot(daily, aes(x = wday, y = wday_rev, col = Name)) +
  geom_point() +
  facet_wrap(~ Name) +
  scale_y_continuous(labels = scales::dollar) +
  labs(title = "Daily Revenue",  x = "Day", y = "Revenue in $")
```

![](Case_Study_8_files/figure-html/daily-1.png)<!-- -->
One interesting thing about this graph is that almost every business did best on Fridays throughout the three month period. 

## Weekly Revenue


```r
# Weekly Revenue
ggplot(weekly, aes(x = week, y = weekly_rev, col = Name)) +
  geom_point() +
  facet_wrap(~ Name) +
  scale_y_continuous(labels = scales::dollar) +
  labs(title = "Weekly Revenue", x = "Revenue in $", y = "Week of year")
```

![](Case_Study_8_files/figure-html/weekly-1.png)<!-- -->

## Monthly Revenue 


```r
# Monthly Revenue
ggplot(monthly, aes(x = month, y = monthly_rev)) +
  geom_bar(stat = "identity") +
  facet_grid(~ Name) +
  scale_y_continuous(labels = scales::dollar) +
  labs(title = "Monthly Revenue", x = "Month", y = "Revenue in $")
```

![](Case_Study_8_files/figure-html/monthly-1.png)<!-- -->


## Total Revenue


```r
# Total Revenue
ggplot(total, aes(x = Name, y = total_rev)) +
  geom_bar(stat = "identity") +
  scale_y_continuous(labels = scales::dollar) +
  labs(title = "Total Revenue", x = "Month", y = "Revenue in $")
```

![](Case_Study_8_files/figure-html/total-1.png)<!-- -->

Looking at total revenue throughout the semester we can see that `HotDiggity` was able to bring in the greatest amount at over $22,000. `Frozone` was the least successful as far as revenue is concerned with a mere $6,000. Therefore, based off the data that was given I would suggest investing in `HotDiggity`. It is important to remember that while their revenue was greatest it does not mean that they were the most succesful in capturing profit as costs were not taken into consideration for this case study. 
