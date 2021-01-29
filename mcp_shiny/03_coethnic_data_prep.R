# This code is to replicate the analyses and figures from my Jan 2021
# R shiny application. Code developed by Oluchi Nwosu Randolph

# 2009 and 2019 ACS 5-year data retrieval - coethnics variables

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

# ACS5yr2009 Foreign-born Population Variable(s)
  # Somali population data
    # Variable of interest: People Reporting Ancestry (B04006)
    # Total population reporting ancestry (B04006_001)
    # Self-reported Somali Ancestry (B04006_082)
    # Percent of total pop identifying as Somali = (B04006_082/B04006_001) * 100
    # Percent of foreign-born pop identifying as Somali = (B04006_082/B05006_001) * 100

# ACS5yr2009 Alternate if above data are missing for a community
  # Place of Birth by Nativity and Citizenship Status: (NA)
    # Total foreign-born population (B05006_001)
    # Total foreign-born (citizen and non-citizen) and native-born population (B05002_001)
    # Total foreign-born population who identify as African (B05006_091)
    # Percent of total pop identifying as African = (B05006_091/B05002_001) * 100
    # Percent of foreign-born pop identifying as African = (B05006_091/B05006_001) * 100

# STEP 1: gather all foreign-born population variables into one data set
coeth_09_vars <- acs_09_vars %>% 
  mutate(name = str_trim(name)) %>%
  filter(str_detect(name, 'B04006|B05002|B05006')) %>% # select 3 foreign-born variables of interest only
  filter(str_detect(name, '_001|_013|_014|_015|_082|_091')) %>%  # select potential rows of interest based on notes above
  separate(label, into = c('A', 'B', 'C', 'D', 'E'), sep = '!!') %>% # create columns A-E based on '!!' separators
  filter(is.na(C) | C == 'Subsaharan African'| C == 'Africa' | C == 'Foreign born') %>% # keep total foreign-born, Somali, and African pop variables only
  select(name, C, D, concept) %>%   # drop unhelpful columns
  slice(-7) # drop Total Foreign Born Population data duplicate (B05006_001)

# recode values - clarify Somali, African, and foreign-born population data
coeth_09_vars <- coeth_09_vars %>% 
  mutate(D = case_when(
    name == 'B04006_001' ~ 'Ancestry Total', 
    name == 'B04006_082' ~ 'Somali Ancestry', 
    name == 'B05002_001' ~ 'Total Population', 
    name == 'B05002_013' ~ 'Total Foreign Born Population',
    name == 'B05002_014' ~ 'Foreign Born - Naturalized Citizen',
    name == 'B05002_015' ~ 'Foreign Born - Not a U.S. Citizen',
    #name == 'B05006_001' ~ 'Total Foreign Born Population',
    name == 'B05006_091' ~ 'Foreign Born Population - African')
  ) %>% 
  select(name, D, concept)

# STEP 2: obtain name vector
coeth_2009_vector <- coeth_09_vars %>% 
  pull(name)

# STEP 3: pull 2009 ACS data
coeth_2009_data <- get_acs(
  geography = 'county',
  year = 2009,
  survey = 'acs5',
  state = c('GA', 'ME', 'MN', 'OH', 'TX', 'WA'),
  variables = coeth_2009_vector
)

# STEP 4: merge acs data with vars
states_2009_coeth_data <- coeth_2009_data %>% 
  full_join(coeth_09_vars, by = c('variable' = 'name')) %>% 
  select(NAME, D, estimate) %>% 
  rename(coethnic = D) %>% 
  separate(NAME, into = c('county', 'state'), sep = ',')  # separate 'NAME' column into two parts

# STEP 5: Create a subset of data only containing counties and states of interest 
subset_2009_coeth_data <- states_2009_coeth_data %>% 
  mutate(state = str_trim(state)) %>% # remove white spaces that will otherwise cause filtering issues
  filter(county == 'DeKalb County' | # Atlanta/Clarkston/Decatur, GA initial resettlement location
           county == 'Androscoggin County' | # Lewiston, ME secondary migration location
           county == 'Cumberland County' | # Portland, ME secondary migration location
           county == 'Hennepin County' | # Minneapolis, MN initial resettlement and secondary migration location
           county == 'Stearns County' | # St. Cloud, MN secondary migration location
           county == 'Dallas County' | # Dallas, TX initial resettlement location
           (county == 'King County' & state == 'Washington') | # Seattle, WA initial resettlement and secondary migration location
           (county == 'Franklin County' & state == 'Ohio')) # Columbus, OH initial resettlement location

coethnic_2009 <- subset_2009_coeth_data %>% 
  # create a new column that retains information on the ACS year
  mutate(year = 2009)

#### Examine variables in 2019 5-year ACS data set ####
acs_19_vars <- load_variables(2019, "acs5", cache = TRUE)
View(acs_19_vars)

# ACS5yr2019 Foreign-born Population Variable(s)
  # Somali population data
    # Variable of interest: People Reporting Ancestry (B04006)
    # Total population reporting ancestry (B04006_001)
    # Self-reported Somali Ancestry (B04006_082)
    # Total foreign-born (citizen and non-citizen) and native-born population (B05002_001)
    # Place of birth for the foreign-born population (B05006)
    # Total foreign-born population who identify as African (B05006_091)
  
  # ACS5yr2019 additions not present in ACS5yr2009 survey
    # Estimate!!Total:!!Foreign born:!!Naturalized U.S. citizen!!Africa (B05002_017)
    # Estimate!!Total:!!Foreign born:!!Not a U.S. citizen!!Africa (B05002_024)
    # Estimate!!Total:!!Africa:!!Eastern Africa:!!Somalia (B05006_096)

# STEP 1: gather all foreign-born population variables into one data set
coeth_19_vars <- acs_19_vars %>% 
  mutate(name = str_trim(name)) %>%
  filter(str_detect(name, 'B04006_|B05002_|B05006_')) %>% # select 3 foreign-born variables of interest only
  filter(str_detect(name, '_001|_013|_014|_017|_021|_024|_082|_091|_096')) %>%  # select potential rows of interest based on notes above
  separate(label, into = c('A', 'B', 'C', 'D', 'E'), sep = '!!') %>% # create columns A-E based on '!!' separators
  mutate_at(vars(B:D), ~str_remove(., ':')) %>% # Remove colons at the end of values for everything in columns B-D
  filter(is.na(C) | C == 'Subsaharan African'| C == 'Africa' | C == 'Foreign born') %>% # keep total foreign-born, Somali, and African pop variables only
  select(name, C, D, E, concept) %>%   # drop unhelpful columns
  slice(-9) # drop Total Foreign Born Population data duplicate (B05006_001)

# recode values - clarify Somali, African, and foreign-born population data
coeth_19_vars <- coeth_19_vars %>% 
  mutate(D = case_when(
    name == 'B04006_001' ~ 'Ancestry Total', 
    name == 'B04006_082' ~ 'Somali Ancestry', 
    name == 'B05002_001' ~ 'Total Population', 
    name == 'B05002_013' ~ 'Total Foreign Born Population',
    name == 'B05002_014' ~ 'Foreign Born - Naturalized Citizen',
    name == 'B05002_017' ~ 'Foreign Born African Origins - Naturalized Citizen',
    name == 'B05002_021' ~ 'Foreign Born - Not a U.S. Citizen',
    name == 'B05002_024' ~ 'Foreign Born African Origins - Not a U.S. Citizen',
    name == 'B05006_091' ~ 'Foreign Born Population - African',
    name == 'B05006_096' ~ 'Foreign Born Population - Somali')
  ) %>% 
  select(name, D, concept)

# STEP 2: obtain name vector
coeth_2019_vector <- coeth_19_vars %>% 
  pull(name)

# STEP 3: pull 2009 ACS data
coeth_2019_data <- get_acs(
  geography = 'county',
  year = 2019,
  survey = 'acs5',
  state = c('GA', 'ME', 'MN', 'OH', 'TX', 'WA'),
  variables = coeth_2019_vector
)

# STEP 4: merge acs data with vars
states_2019_coeth_data <- coeth_2019_data %>% 
  full_join(coeth_19_vars, by = c('variable' = 'name')) %>% 
  select(NAME, D, estimate) %>% 
  rename(coethnic = D) %>% 
  separate(NAME, into = c('county', 'state'), sep = ',')  # separate 'NAME' column into two parts

# STEP 5: Create a subset of data only containing counties and states of interest 
subset_2019_coeth_data <- states_2019_coeth_data %>% 
  mutate(state = str_trim(state)) %>% # remove white spaces that will otherwise cause filtering issues
  filter(county == 'DeKalb County' | # Atlanta/Clarkston/Decatur, GA initial resettlement location
           county == 'Androscoggin County' | # Lewiston, ME secondary migration location
           county == 'Cumberland County' | # Portland, ME secondary migration location
           county == 'Hennepin County' | # Minneapolis, MN initial resettlement and secondary migration location
           county == 'Stearns County' | # St. Cloud, MN secondary migration location
           county == 'Dallas County' | # Dallas, TX initial resettlement location
           (county == 'King County' & state == 'Washington') | # Seattle, WA initial resettlement and secondary migration location
           (county == 'Franklin County' & state == 'Ohio')) # Columbus, OH initial resettlement location

coethnic_2019 <- subset_2019_coeth_data %>% 
  # create a new column that retains information on the ACS year
  mutate(year = 2019)

#### Coethnic 2009 and 2019 data merge ####
# Combine data sets on all columns
coethnic_full <- coethnic_2009 %>% 
  full_join(coethnic_2019)

# export to a csv file for easy shiny app access
coethnic_full %>% 
  write.csv(
    file = "C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/midcourse-shiny/mcp_shiny/refugee-resettlement-us/data_csv/coethnic_full.csv",
    row.names = FALSE
  )
