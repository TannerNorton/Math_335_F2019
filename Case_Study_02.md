---
title: "CASE STUDY 2"
author: "Tanner Norton"
date: "October 01, 2019"
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
view(gapminder)
```

## Background
The purpose of this task is to recreate the same two graphs using the gapminder dataset. 


## Data Wrangling


```r
# Use this R-Chunk to clean & wrangle your data!
# Filter out Kuwait
gapminder <- filter(gapminder, country != "Kuwait") 


# Create weighted dataset named weight_gap
weight_gap <- gapminder %>%
  group_by(year, continent) %>%
  mutate(weight_gdp = weighted.mean(gdpPercap, pop))

# Create a function called ks to allow for formatting of legend numbers. Turns 250,000,000 to 2,500
ks <- function (x) { number_format(accuracy = 1,
                                   scale = 1/100000,
                                   big.mark = ",")(x) }
```

## Plot 1

I learned that creating variables can be very useful in order to customize plots. I built the variable ks which helped me format the numbers in the legend. I also learned about ggsave() and how I can save my plots in different formats as well as sizes. I understand that ncol = n in the face_wrap function tells how many individual facets to place in a single row. 


```r
# Code to create entire graphic 
  ggplot(data = gapminder, aes(x = lifeExp, y = gdpPercap, group = continent)) +
  geom_point(aes(color = continent, size = pop)) +
  labs(x = "Life Expectancy", y = "GDP per capita", size = "Population (100k)", color = "Continent") +
  facet_wrap(~ year, ncol = 12) +
  scale_y_continuous(trans = "sqrt", labels = comma) +
  scale_size_continuous(labels = ks) +
  theme_bw()
```

![](Case_Study_02_files/figure-html/plot_data-1.png)<!-- -->

```r
# Use ggsave() to save the first plot as a png
ggsave(file="Case2_plot1.png", plot = last_plot(), width=15)
```

## Plot 2

In creating this second plot I learned that creating two plots and then combining them can help simplify things. 


```r
# Start creating the seconed graphic
ggplot(data = weight_gap, aes(x = year, y = weight_gdp, group = continent)) +
  geom_point(aes(size = pop)) +
  geom_line() +
  facet_wrap(~ continent, ncol= 5)
```

![](Case_Study_02_files/figure-html/Plot_data2-1.png)<!-- -->

```r
# Add individual country data to plot above
ggplot(data = weight_gap, aes(x = year, y = gdpPercap, group = country)) +
  geom_point(aes(color = continent, size = pop)) +                           # plots all the countries
  geom_line(aes(color = continent)) +
  geom_point(aes(x = year, y = weight_gdp, size = pop)) +                    # plots the weighted data
  geom_line(aes(x = year, y = weight_gdp)) +
  labs(x = "Year", y = "GDP per capita", size = "Population (100k)", color = "Continent") +
  facet_wrap(~ continent, ncol= 5) +
  scale_y_continuous(labels = comma) +
  scale_size_continuous(labels = ks) +
  theme_bw()
```

![](Case_Study_02_files/figure-html/Plot_data2-2.png)<!-- -->

```r
# Use ggsave() to save the seconed plot as a png
ggsave(file="Case2_plot2.png", plot = last_plot(), width=15)
```



