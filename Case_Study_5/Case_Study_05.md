---
title: "Case Study 5"
author: "Tanner Norton"
date: "November 05, 2019"
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





## Read in xlsx data 

```r
# Read in the xlsx file
xlsx_url <- "https://byuistats.github.io/M335/data/heights/Height.xlsx"
xlsx = tempfile()
download(xlsx_url, destfile = xlsx,  mode = "wb")
height_xlsx <- read_xlsx(xlsx, skip = 2)

# Create matching dataset 
xlsx_done <- height_xlsx %>%
  pivot_longer(cols = "1800":"2011", names_to = "century_year", values_to = "height.cm" ) %>%
  filter(!is.na(height.cm)) %>%
  mutate(year_decade = century_year) %>%
  separate(century_year, into = c("century", "decade"), sep = 2) %>%
  separate(decade, into = c("decade", "year"), sep = 1) %>%
  mutate(height.in = conv_unit(height.cm, from = "cm", to = "inch")) 
```


## Plot xlsx data
Make a plot with decade on the x-axis and height in inches on the y-axis with the points from Germany highlighted based on the data from the .xlsx file.


```r
# Make a plot with decade on the x-axis and height in inches on the y-axis with the points from Germany highlighted based on the data from the .xlsx file.
ggplot(xlsx_done, aes(x = year_decade, y = height.in,color =`Continent, Region, Country`=="Germany")) +
  geom_boxplot() +
  labs(x = "Decade", y = "Height in inches", title = "Heights by decade") +
  scale_color_discrete(name = "Dose", labels = c("All Countries", "Germany"))
```

![](Case_Study_05_files/figure-html/xlsx_plot-1.png)<!-- -->

The plot shows that the heights of German individuals appears to be getting taller over time. 

## Read in and Tidy the 5 data sets into 1

```r
# Read in the BLS CSV file
# Let’s assume that these are mid 20th century births. Use 1950 as the birth year
BLS_wage <- read_csv("https://github.com/hadley/r4ds/raw/master/data/heights.csv") %>%
  select(c("height")) %>%
  mutate(birth_year = 1950, height.cm = conv_unit(height, from = "inch", to = "cm"), height.in = height, study = "BLS_wage") %>%
  select(birth_year, height.cm, height.in, study)

# Read in the german dta file
german <- read_dta("https://byuistats.github.io/M335/data/heights/germanconscr.dta") %>%
  select(c("bdec","height")) %>%
  mutate(birth_year = bdec, height.cm = height, height.in = conv_unit(height, from = "cm", to = "inch"), study = "german") %>%
  select(birth_year, height.cm, height.in, study)

# Read in the bavarian dta file
bavarian <- read_dta("https://byuistats.github.io/M335/data/heights/germanprison.dta") %>%
  select(c("bdec","height")) %>%
  mutate(birth_year = bdec, height.cm = height, height.in = conv_unit(height, from = "cm", to = "inch"), study = "bavarian19") %>%
  select(birth_year, height.cm, height.in, study)

# Read in the soldiers zip dbf file
soldier_heights_url <- "https://byuistats.github.io/M335/data/heights/Heights_south-east.zip"
zip_file <- tempfile()
zip_unzip <- tempfile()

downloader::download(soldier_heights_url, zip_file, mode = "wb")
unzip(zipfile = zip_file, exdir = zip_unzip)
file_name <- list.files(zip_unzip, pattern = "DBF")

german_soldiers <- read.dbf(file.path(zip_unzip, file_name)) %>%
  select(c("SJ","CMETER")) %>%
  mutate(birth_year = SJ, height.cm = CMETER, height.in = conv_unit(CMETER, from = "cm", to = "inch"),  study = "german_soldiers") %>%
  select(birth_year, height.cm, height.in, study)

# Read in the wisconsin sav file
Wisconsin <- read_sav("http://www.ssc.wisc.edu/nsfh/wave3/NSFH3%20Apr%202005%20release/main05022005.sav") %>%
  select(DOBY,RT216F,RT216I) %>%
  filter(RT216F >= 0 | RT216I >=  0) %>%
  filter(RT216I < 12) %>%         # Need to get rid of negative feet and also inches over 12.
  mutate(birth_year = (1800 + DOBY), height.in = ((12*RT216F) + RT216I), height.cm = (height.in * 2.54), study = "Wisconsin") %>%
  select(birth_year, height.cm, height.in, study)


# This dataset should have the following columns - birth_year, height.cm, height.in, and study_id
# Combine all data sets into one
alldata <- bind_rows(BLS_wage, bavarian, german, german_soldiers, Wisconsin)
```



## Background
The Scientific American argues that humans have been getting taller over the years. As the data scientists that we are becoming, we would like to find data that validates this concept. Our challenge is to show different male heights across the centuries.


## Data Visualizations


```r
# Create a facet wrap plot
ggplot(alldata, aes(x = birth_year, y = height.cm)) +
  geom_point(color = "azure4", position = "jitter")+
  facet_grid(~study, scales = "free_x") +
  coord_cartesian(ylim = c(150, 200)) +
  labs(x = "Birth Year", y = "Height in cm",title = "Reported heights by Study")
```

![](Case_Study_05_files/figure-html/plot_facet-1.png)<!-- -->

Above is a plot that shows reported heights from five different studies conducted accross the world dating back to the 1700's. There are 28,551 different individuals who make up the complete data and each dot represents a person. As can be seen there really is no clear pattern between any of these studies indicating that heights have been increasing. Instead it appears that where the study was conducted is a better indicator of heights. For example, the tallest individuals come from the Wisoncon study which was done in the United states as compared to the study studies done in Germany.


```r
# Median heights over time
alldata %>%
  group_by(birth_year) %>%
  summarise(med.height.cm = median(height.cm)) %>%
ggplot(mapping = aes(x = birth_year, y = med.height.cm)) +
  geom_jitter(alldata, mapping =  aes(x = birth_year, y = height.cm)) +
  labs(x = "Birth Year", y = "Height in cm", title = "Median heights by Birth Year") +
  coord_cartesian(ylim = c(150, 190))
```

![](Case_Study_05_files/figure-html/plot_medians-1.png)<!-- -->

The line graph above shows the median heights of all individuals in data set over time. While spikes and dips do occur this is a result of people in some countries being smaller or taller than others. The data from all these studies do not overlap in time very well as the only observations from the 1700's came from the `german_soldiers` study and not the other 4 studies. While it may seem reasonable that humans have been getting taller over time through evolution the data speaks otherwise. 

