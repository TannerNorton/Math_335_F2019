# Tanner Norton
# Case Study 2

library(manipulate)
library(mosaic)
library(usethis)
library(devtools)
library(tidyverse)
library(gapminder)
library(scales)

view(gapminder)
glimpse(gapminder)


# Filter out Kuwait
gapminder <- filter(gapminder, country != "Kuwait")  

# Create weighted dataset named weight_gap
weight_gap <- gapminder %>%
  group_by(year, continent) %>%
  mutate(weight_gdp = weighted.mean(gdpPercap, pop))

# Start with inital plot naming it GDP, using gapminder data. Make continents different colors and size the population
GDP <- ggplot(data = gapminder, aes(x = lifeExp, y = gdpPercap, group = continent)) +
  geom_point(aes(color = continent, size = pop))

# Add labels to the x & y axis as well as labels to the legend
GDP +  labs(x = "Life Expectancy", y = "GDP per capita", size = "Population (100k)", color = "Continent") 
  

# Split the plot up into 12 facets based off the 12 years of data
GDP + labs(x = "Life Expectancy", y = "GDP per capita", size = "Population (100k)", color = "Continent") +
  facet_wrap(~ year, ncol = 12) 
  

# Transform the y axis by squaring it and add commas to y axis numbers
GDP + labs(x = "Life Expectancy", y = "GDP per capita", size = "Population (100k)", color = "Continent") +
  facet_wrap(~ year, ncol = 12) +
  scale_y_continuous(trans = "sqrt", labels = comma) 
  

# Create a function called ks to allow for formatting of legend numbers. Turns 250,000,000 to 2,500
ks <- function (x) { number_format(accuracy = 1,
                                   scale = 1/100000,
                                   big.mark = ",")(x) }


# Use function ks that formats the legend data into hundreds of thousands
GDP + labs(x = "Life Expectancy", y = "GDP per capita", size = "Population (100k)", color = "Continent") +
  facet_wrap(~ year, ncol = 12) +
  scale_y_continuous(trans = "sqrt", labels = comma) +
  scale_size_continuous(labels = ks)


# Code to create entire graphic 
ggplot(data = gapminder, aes(x = lifeExp, y = gdpPercap, group = continent)) +
  geom_point(aes(color = continent, size = pop)) +
  labs(x = "Life Expectancy", y = "GDP per capita", size = "Population (100k)", color = "Continent") +
  facet_wrap(~ year, ncol = 12) +
  scale_y_continuous(trans = "sqrt", labels = comma) +
  scale_size_continuous(labels = ks)


# Code to create entire graphic 
  ggplot(data = gapminder, aes(x = lifeExp, y = gdpPercap, group = continent)) +
  geom_point(aes(color = continent, size = pop)) +
  labs(x = "Life Expectancy", y = "GDP per capita", size = "Population (100k)", color = "Continent") +
  facet_wrap(~ year, ncol = 12) +
  scale_y_continuous(trans = "sqrt", labels = comma) +
  scale_size_continuous(labels = ks) +
  theme_bw()
  
# Use ggsave() to save the first plot as a png
ggsave(file="Case2_plot1.png", plot = last_plot(), width=15)




# Create the weighted data facet plot
# Start creating the seconed graphic
ggplot(data = weight_gap, aes(x = year, y = weight_gdp, group = continent)) +
  geom_point(aes(size = pop)) +
  geom_line() +
  facet_wrap(~ continent, ncol= 5)




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


# Use ggsave() to save the seconed plot as a png
ggsave(file="Case2_plot2.png", plot = last_plot(), width=15)



