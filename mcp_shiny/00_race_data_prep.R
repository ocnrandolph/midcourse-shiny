# This code is to replicate the analyses and figures from my Jan 2021
# R shiny application. Code developed by Oluchi Nwosu Randolph

# 2009 and 2019 ACS 5-year data retrieval - race variables

# Load libraries
library(tidycensus)
library(tidyverse)
library(dplyr)
library(plotly)
library(stringr)

# Installing the most recent GitHub version of tidycensus (if needed)
#install.packages("remotes")
#remotes::install_github("walkerke/tidycensus")

#### Examine variables in 2009 5-year ACS data set ####
acs_09_vars <- load_variables(2009, "acs5", cache = TRUE)
View(acs_09_vars)

# ACS5yr2009 Race by Ethnicity variable of interest: B03002
  # B03002_003 = Not-Hispanic, White 
  # B03002_004 = Not-Hispanic, Black
  # B03002_005 = Not-Hispanic, Native American
  # B03002_006 = Not-Hispanic, Asian
  # B03002_007 = Not-Hispanic, Pacific Islander
  # B03002_008 = Not-Hispanic, Other Race
  # B03002_009 = Not-Hispanic, Multiracial
  # B03002_013 = Hispanic, White
  # B03002_014 = Hispanic, Black
  # B03002_015 = Hispanic, Native American
  # B03002_016 = Hispanic, Asian
  # B03002_017 = Hispanic, Pacific Islander
  # B03002_018 = Hispanic, Other Race
  # B03002_019 = Hispanic, Multiracial

# Isolate race variables of interest programmatically
# STEP 1: split label components into multiple columns 
race_by_eth_2009_vars <- acs_09_vars %>% 
  filter(str_detect(name, 'B03002_\\d{3}')) %>% # select race variable of interest only
  separate(label, into = c('A', 'B', 'C', 'D', 'E'), sep = '!!') %>% # create columns A-E based on '!!' separators
  filter(!is.na(D)) %>% # Remove total columns; exclusion criteria = NA in column D
  filter(is.na(E)) # Remove "two or more races" detailed data; inclusion criteria = NA in column E

# STEP 2: grab specific B03002 rows of interest based on the ones kept in the code above
race_2009_vector <- race_by_eth_2009_vars %>% 
  pull(name) # returns 'name' column as a vector

# STEP 3: pull 2009 ACS race data for variables specified in the vector above
race_2009_data <- get_acs(
  geography = 'county',
  year = 2009,
  survey = 'acs5',
  state = c('GA', 'ME', 'MN', 'OH', 'TX', 'WA'), # Added GA (DeKalb County), and TX (Dallas County) on 1/18/2021
  variables = race_2009_vector
)

# STEP 4: Create a data frame containing race variables of interest for counties within each state
# merge race_2009_data with race_vars_2009 
states_2009_race_data <- race_2009_data %>% 
  full_join(race_by_eth_2009_vars, by = c('variable' = 'name')) %>% 
  select(NAME, C, D, estimate) %>%  # select columns of interest only, and in the order specified
  rename(ethnicity = C, # rename columns so that they make more sense
         race = D) %>% 
  separate(NAME, into = c('county', 'state'), sep = ',') # separate 'NAME' column into two parts

subset_2009_race_data <- states_2009_race_data %>% 
  mutate(state = str_trim(state)) %>% # remove white spaces that will otherwise cause filtering issues
  filter(county == 'DeKalb County' | # Atlanta/Clarkston/Decatur, GA initial resettlement location
           county == 'Androscoggin County' | # Lewiston, ME secondary migration location
           county == 'Cumberland County' | # Portland, ME secondary migration location
           county == 'Hennepin County' | # Minneapolis, MN initial resettlement and secondary migration location
           county == 'Stearns County' | # St. Cloud, MN secondary migration location
           county == 'Dallas County' | # Dallas, TX initial resettlement location
           (county == 'King County' & state == 'Washington') | # Seattle, WA initial resettlement and secondary migration location
           (county == 'Franklin County' & state == 'Ohio')) # Columbus, OH initial resettlement location

#### Examine variables in 2019 5-year ACS data set ####
acs_19_vars <- load_variables(2019, "acs5", cache = TRUE)
View(acs_19_vars)

# ACS5yr2019 Race by Ethnicity variable of interest: B03002 (same as above)

# Isolate race variables of interest programmatically
# STEP 1: split label components into multiple columns 
race_by_eth_2019_vars <- acs_19_vars %>% 
  filter(str_detect(name, 'B03002_\\d{3}')) %>% # select race variable of interest only
  separate(label, into = c('A', 'B', 'C', 'D', 'E'), sep = '!!') %>% # create columns A-E based on '!!' separators
  filter(!is.na(D)) %>% # Remove total columns; exclusion criteria = NA in column D
  filter(is.na(E)) %>% # Remove "two or more races" detailed data; inclusion criteria = NA in column E
  mutate_at(vars(B:D), ~str_remove(., ':')) # Remove colons at the end of values for everything in columns B-D

# STEP 2: grab specific B03002 rows of interest based on the ones kept in the code above
race_2019_vector <- race_by_eth_2019_vars %>% 
  pull(name) # returns 'name' column as a vector

# STEP 3: pull 2019 ACS race data for variables specified in the vector above
race_2019_data <- get_acs(
  geography = 'county',
  year = 2019,
  survey = 'acs5',
  state = c('GA', 'ME', 'MN', 'OH', 'TX', 'WA'), # Added GA (DeKalb County), and TX (Dallas County) on 1/18/2021
  variables = race_2019_vector
)

# STEP 4: Create a data frame containing race variables of interest for counties within each state
# merge race_2019_data with race_vars_2019 
states_2019_race_data <- race_2019_data %>% 
  full_join(race_by_eth_2019_vars, by = c('variable' = 'name')) %>% 
  select(NAME, C, D, estimate) %>%  # select columns of interest only, and in the order specified
  rename(ethnicity = C, # rename columns so that they make more sense
         race = D) %>% 
  separate(NAME, into = c('county', 'state'), sep = ',') # separate 'NAME' column into two parts

subset_2019_race_data <- states_2019_race_data %>% 
  mutate(state = str_trim(state)) %>% # remove white spaces that will otherwise cause filtering issues
  filter(county == 'DeKalb County' | # Atlanta/Clarkston/Decatur, GA initial resettlement location
           county == 'Androscoggin County' | # Lewiston, ME secondary migration location
           county == 'Cumberland County' | # Portland, ME secondary migration location
           county == 'Hennepin County' | # Minneapolis, MN initial resettlement and secondary migration location
           county == 'Stearns County' | # St. Cloud, MN secondary migration location
           county == 'Dallas County' | # Dallas, TX initial resettlement location
           (county == 'King County' & state == 'Washington') | # Seattle, WA initial resettlement and secondary migration location
           (county == 'Franklin County' & state == 'Ohio')) # Columbus, OH initial resettlement location