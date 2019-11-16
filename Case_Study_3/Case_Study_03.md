---
title: "CASE STUDY 3"
author: "Tanner Norton"
date: "October 08, 2019"
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
# Use this R-Chunk to import all your datasets!
```

## Background

You just started your internship at a big firm in New York, and your manager gave you an extensive file of flights that departed JFK, LGA, or EWR in 2013. From this data (nycflights13::flights), which you can obtain in R (install.packages("nycflights13"); library(nycflights13)), your manager wants you to answer the following questions;

If I am leaving before noon, which two airlines do you recommend at each airport (JFK, LGA, EWR) that will have the lowest delay time at the 75th percentile?
Which origin airport is best to minimize my chances of a late arrival when I am using Delta Airlines?
Which destination airport is the worst (you decide on the metric for worst) airport for arrival time?


## Data Wrangling


```r
# Filter data set to only show Delta flights with arrival time values
delta_fl <- filter(flights, carrier == "DL", !is.na(arr_delay))

# Create data that shows the means for each origin airport
means <- aggregate(arr_delay ~  origin, delta_fl, mean)

noon_fl <- filter(flights, dep_time < 1200) 
```

## Question 1
If I am leaving before noon, which two airlines do you recommend at each airport (JFK, LGA, EWR) that will have the lowest delay time at the 75th percentile?


```r
# Crete boxplot with facet wrapt to allow for easy comparison
ggplot(data = noon_fl, aes(x = reorder(carrier, dep_delay,median), y = dep_delay)) +
  geom_boxplot() + 
  scale_y_continuous(limits = c(-8, 2), breaks = seq(-8, 2, by = 2)) +
  facet_wrap(~ origin, nrow = 3) +
  labs( x = "Airline", y = "Departure Delay (Min)")
```

![](Case_Study_03_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

If you were departing from EWR I would suggest US Airways and 9E Endeavor Air. Departing from JFK I would suggest EV ExpressJet Airlines and AA American Airlines. And departing from LGA I would suggest US Airways and Envoy Air. 



## Question 2
Which origin airport is best to minimize my chances of a late arrival when I am using Delta Airlines?


```r
# Create a boxplot to show the variation in the data
ggplot(data = delta_fl, aes(x = origin, y = arr_delay, fill = "firebrick")) +
  geom_boxplot() + 
  scale_y_continuous(limits = c(-20, 20), breaks = seq(-20, 20, by = 10)) +
  labs( x = "Airport of Origin", y = "Arrival delay (Min)", title = "Delta Airlines timeliness") +
  geom_text(data = means, aes(label = format(arr_delay, digits = 3)))
```

![](Case_Study_03_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

When flying with Delta it is best to fly out of JFK to minimize the chance of a late arrival. The summary stats below also confirm that JFK would be best as it has the lowest mean, sd, and median values. 


```r
pander(delta_sum <- delta_fl %>%
  group_by(origin) %>%
  summarise('Avg Delay' = mean(arr_delay),
            SD = sd(arr_delay),
            Median = median(arr_delay)))
```


-------------------------------------
 origin   Avg Delay    SD     Median 
-------- ----------- ------- --------
  EWR       8.78      52.19     -4   

  JFK      -2.379     41.31    -11   

  LGA       3.928     45.16     -7   
-------------------------------------

