# Tanner Norton
# Case Study 3


library(reprex)  #Used to create a snippet that can be put on slack for easy analysis 
library(mosaic)
library(tidyverse)
library(mosaic)
library(nycflights13)
library(devtools)
library(usethis)
library(pander)
library(dplyr)


View(flights)
?flights

p75 <- function(x) quantile(x, probs = .75, na.rm=TRUE) 


flights %>% 
  filter(sched_dep_time < 1200)  %>% 
  mutate(carrier=fct_reorder(carrier, dep_delay, .fun=p75)) %>% 
  ggplot(aes(x=carrier, y=dep_delay)) + 
  geom_boxplot(outlier.color=NA) + 
  facet_wrap(~origin) + 
  scale_y_continuous(limits = c(-20, 20)) + 
  theme_bw()


# Which origin airport is best to minimize my chances of a late arrival when I am using Delta Airlines?

# Filter data set to only show Delta flights with arrival time values
delta_fl <- filter(flights, carrier == "DL", !is.na(arr_delay))

# Create data that shows the means for each origin airport
means <- aggregate(arr_delay ~  origin, delta_fl, mean)

# Create a boxplot to show the variation in the data
ggplot(data = delta_fl, aes(x = origin, y = arr_delay, fill = "firebrick")) +
  geom_boxplot() + 
  scale_y_continuous(limits = c(-20, 20), breaks = seq(-20, 20, by = 10)) +
  labs( x = "Airport of Origin", y = "Arrival delay (Min)", title = "Delta Airlines timeliness") +
  geom_text(data = means, aes(label = format(arr_delay, digits = 3)))

# Create a small table to show summary stats
delta_sum <- delta_fl %>%
  group_by(origin) %>%
  summarise('Avg Delay' = mean(arr_delay),
            SD = sd(arr_delay),
            Median = median(arr_delay))
pander()

# JFK is the best option to minimize chances of late arrival when flying Delta


# If I am leaving before noon, which two airlines do you recommend at each airport (JFK, LGA, EWR) 
# that will have the lowest delay time at the 75th percentile?

p75 <- function(x) quantile(x, probs = .75, na.rm=TRUE) 


# Create data that for flights with a departure time before noon
noon_fl <- filter(flights, dep_time < 1200) 

# Crete boxplot with facet wrapt to allow for easy comparison
ggplot(data = noon_fl, aes(x = reorder(carrier, dep_delay,median), y = dep_delay)) +
  geom_boxplot() + 
  scale_y_continuous(limits = c(-8, 2), breaks = seq(-8, 2, by = 2)) +
  facet_wrap(~ origin, nrow = 3) +
  labs( x = "Airline", y = "Departure Delay (Min)")


# EWR at US and 9E, JFK EV and AA, LGA US and MQ






