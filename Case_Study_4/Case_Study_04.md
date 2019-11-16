---
title: "Case Study 4"
author: "Tanner Norton"
date: "October 22, 2019"
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
deaths <- read_csv("C:/Users/User/Documents/Fall 2019/Math 335/M335_FA19_Norton_Tann/full_data.csv")

deaths <- deaths %>%
  mutate(intent = fct_relevel(intent,c("Suicide","Homicide","Accidental","Undetermined")))

death_season <- deaths %>%
  group_by(intent, year) %>%
  mutate(season = case_when(month %in% c("12","01","02") ~ "Winter",
         month %in% c("03","04","05") ~ "Spring",
         month %in% c("06","07","08") ~ "Summer",
         month %in% c("09","10","11") ~ "Fall"),
         death = 1)

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
```





## Background

The world is a dangerous place. During 2015 and 2016 there was a lot of discussion in the news about police shootings. [FiveThirtyEight]("https://fivethirtyeight.com/features/gun-deaths/") reported on gun deaths in 2016. As leaders in data journalism, they have posted a clean version of this data in their GitHub repo called [full_data.csv]("https://github.com/fivethirtyeight/guns-data") for us to use.

While their visualizations focused on yearly averages, our client wants to create commercials that help reduce the gun deaths in the US. They would like to target the commercials in different seasons of the year (think month variable) to audiences that could have the most impact in reducing gun deaths. Our challenge is to summarize and visualize seasonal trends accros the other variables in these data.


## Deaths by Category

The purpopse of this graph was to show that Suicide is the reason for 2/3s of US gun deaths every year. This graph also demonstrates that the vast majority of gun deaths are a combination of suicides and homicides with accidents and undetermined making up very little. 

```r
# Graph similar to fivethirtyeight, 2/3 of deaths from suicides
ggplot(deaths, aes(x = intent)) +
  geom_bar(fill = grey.colors(5)) +
  labs(x = "Category of death", y = "Number of deaths", title = "US Gun related deaths: 2012-2014")
```

![](Case_Study_04_files/figure-html/Part_1-1.png)<!-- -->

## Deaths by Seasons
Overall the summer season shows the most deaths with winter having the least amount of gun related deaths. This could be because warmer months are associated with higher crime rates. The colder months may to a degree deter some crimes for happening especially if the weather is severe. 


```r
ggplot(death_season, aes(x = season)) +
  geom_bar() +
  labs(x = "Season", y = "Number of Deaths", "Number of gun deaths 2012-2014")
```

![](Case_Study_04_files/figure-html/Part_2-1.png)<!-- -->


## Deaths by Season and Education

This graph shows that those who only have a High School diploma or GED are the education group with the most gun related deaths. Even attending some college is associated with nearly half the number of gun related deaths. Here the same trend of warmer months being associated with more gun deaths continues. Therefore, I would suggest that the clients focus should be on HS/GED graduates during the Spring and Summer months. 

```r
# The client should focus on HS/GED grads during the Spring and Summer months
ggplot(death_4, aes(x = season, y = count , color = education)) +
  geom_point() +
  labs(x = "Education level", y = "Number of Deaths", title = "US Gun related deaths: 2012-2014")
```

![](Case_Study_04_files/figure-html/deaths_education_season-1.png)<!-- -->


# Deaths by Age & Season

Suicide is most prevalent between those aged 50-60 while Homicide is most common on those between 20-30 years old.

```r
ggplot(death_season) + 
  geom_histogram(aes(x = age), binwidth = 5, fill = "firebrick", alpha = .6) +
  labs(x = "Age", y = "Number of Deaths", title = "Gun related deaths by Age & Season")  +
  facet_grid(season~intent) + 
  scale_x_continuous(breaks = seq(0, 100, by = 10)) +
  theme_bw() 
```

![](Case_Study_04_files/figure-html/deaths_age_season-1.png)<!-- -->

