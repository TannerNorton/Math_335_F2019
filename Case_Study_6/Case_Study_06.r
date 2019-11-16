# Tanner Norton
# Case Study 6

library(tidyverse)
devtools::install_github("hathawayj/buildings")
library(buildings)
library(stringr)

View(buildings0809)
?buildings0809

# Convert all subgroup strings into lower case so they are in a standardized form
not_restaurants <- c("development","Food preperation center", "Food Services center","bakery","Grocery","conceession","Cafeteria", "lunchroom","school","facility"," hall ") %>%
  str_to_lower %>%
  str_flatten(collapse = "|")

standalone_retail <- c("Wine","Spirits","Liquor","Convenience","drugstore","Flying J", "Rite Aid ","walgreens ","Love's Travel ") %>%
  str_to_lower %>%
  str_flatten(collapse = "|")

full_service_type <- c("Ristorante","mexican","pizza ","steakhouse"," grill ","buffet","tavern"," bar ","waffle","italian","steak house") %>%
  str_to_lower %>%
  str_flatten(collapse = "|")

quick_service_type <- c("coffee"," java "," Donut ","Doughnut"," burger ","Ice Cream ","custard ","sandwich ","fast food "," bagel ") %>%
  str_to_lower %>%
  str_flatten(collapse = "|")

quick_service_names <- restaurants$Restaurant[restaurants$Type %in% c("coffee","Ice Cream","Fast Food")] %>%
  str_to_lower %>%
  str_flatten(collapse = "|")

full_service_names <- restaurants$Restaurant[restaurants$Type %in% c("Pizza","Casual Dining","Fast Casual")] %>%
  str_to_lower %>%
  str_flatten(collapse = "|")


# Construction value is related to population in the area. Join the climate_zone_fips data to the buildings0809 data using the two FIPS columns for state and county.
buildings0809 %>%
  left_join(climate_zone_fips, by = c("FIPS.state","FIPS.county")) 


# After filtering to Food_Beverage_Service group of buildings in the Type variable, use the ProjectTitle column to create new subgroups from the groupings in the code section below and the restaurant names in restaurants
# Restaurants that are not assigned using the names and keywords that are over 4000 square feet should be grouped into Full Service Restaurants and be in Quick Service Restaurants if they are under 4000 square feet and new construction.
dat <- buildings0809 %>%
  left_join(climate_zone_fips, by = c("FIPS.state","FIPS.county")) %>%
  filter(Type == "Food_Beverage_Service") %>%
  mutate(ProjectTitle = str_to_lower(str_trim(ProjectTitle))) %>%
  mutate(Subgroups = case_when(str_detect(ProjectTitle, not_restaurants) ~ "Not_restaurants",
                               str_detect(ProjectTitle, standalone_retail) ~ "Standalone_retail",
                               str_detect(ProjectTitle, full_service_type) ~ "Full_service_type",
                               str_detect(ProjectTitle, quick_service_type) ~ "Quick_service_type",
                               str_detect(ProjectTitle, quick_service_names) ~ "Quick_service_names",
                               str_detect(ProjectTitle, full_service_names) ~ "Full_service_names",
                               SqFt >= 4000 ~ "Full_service_type",
                               SqFt < 4000 ~ "Quick_service_type"))




# Create Plots to answer the questions
# 1.How did full-service restaurant construction compare to quick service restaurant construction across county and years?

restaurants_only <- filter(dat, Subgroups %in% c("Full_service_type","Quick_service_type")) 

ggplot(restaurants_only, aes(x = County.y)) +
  geom_bar(aes(fill = Subgroups)) +
  facet_grid(Subgroups ~ Year) +
  scale_fill_discrete(name = "Service type", labels = c("Full Service", "Quick Service")) +
  labs(x = "County", y = "Number of new Restaurants", title = "New Restaurant Construction: 2008-2009")
  

  
  
# 2.How did restaurant construction fare compare to the other commercial construction in Idaho?
idaho <- buildings0809 %>%
  mutate(building_type = case_when(Type != "Food_Beverage_Service" ~ "All_Other_Commercial", 
                                   Type == "Food_Beverage_Service" ~ "Restaurant"))



ggplot(idaho, aes(x = building_type )) +
  geom_bar() +
  facet_grid(~ Year) +
  labs(x = "Construction Type", title = "Restaurant vs all other Commercial Construction", subtitle = "Idaho: 2008-2009")
  
  
# 3.Which county in Idaho spent the most on fast food construction each year?

fast_food <- dat %>%
  group_by(County.y, Year) %>%
  summarise(Total_spent = sum(Value1000)) 

ggplot(fast_food, aes(x = County.y, y = Total_spent)) +
  geom_point() +
  facet_grid(Year ~ .) +
  labs(x = "County", y = "Dollars spent", title = "Total Spending on fast food Construction: Idaho") +
  scale_y_continuous(labels = scales::dollar)


# Jittered dot plot
ggplot(dat, aes(x = County.y, y = Value1000)) +
  geom_jitter() +
  facet_grid(Year ~ .) +
  labs(x = "County", y = "Total $ spent on Fast food")


# 4.In that county how did other commercial construction compare?

ada <- filter(idaho, County == "ADA, ID")
  

ggplot(ada, aes(x = building_type)) +
  geom_bar(aes(fill = building_type)) +
  facet_grid(~ Year) +
  scale_fill_discrete(name = element_blank(), labels = c("All other Commercial", "Restaurant")) +
  theme(axis.text.x = element_blank(),
        axis.ticks = element_blank()) +
  labs(x = "Construction Type", title = "Restaurant vs all other Commercial Construction", subtitle = "Ada County: 2008-2009")







