library(tidycensus)
library(tidyverse)
library(dplyr)
library(plotly)
library(stringr)

# Installing the most recent GitHub version of tidycensus (if needed)
#install.packages("remotes")
#remotes::install_github("walkerke/tidycensus")

# Notes on retrieving variables of interest (VOI) from both ACS data sets
################## 2009 ACS 5-YR VOIs ##################

# Examine variables in 2009 5-year ACS data set
acs_09_vars <- load_variables(2009, "acs5", cache = TRUE)
View(acs_09_vars)

#### Racial composition data ####
# ACS5yr2009 Race by Ethnicity variables of interest: B03002
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
race_vars_2009 <- race_by_eth_2009_vars %>% 
  pull(name) # returns 'name' column as a vector

# STEP 3: pull 2008 ACS race data for variables specified in the vector above
race_2009_data <- get_acs(
  geography = 'county',
  year = 2009,
  survey = 'acs5',
  state = c('GA', 'ME', 'MN', 'OH', 'TX', 'WA'), # Added GA (DeKalb County), and TX (Dallas County) on 1/18/2021
  variables = race_vars_2009
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

#### Economic/employment opportunity data ####
  # [NON-HISPANIC WHITE]
  # ACS3yr2008 Unemployment variables of interest: C23002H [NON-HISPANIC WHITE]
    # Total civilian NON-HISPANIC WHITE male pop in labor force aged 16-64 yrs (C23002H_006)
    # Unemployed NON-HISPANIC WHITE civilian male pop in labor force aged 16-64 yrs (C23002H_008)
    # Total NON-HISPANIC WHITE male pop in labor force aged 65+ yrs (C23002H_011)
    # Unemployed NON-HISPANIC WHITE male pop in labor force aged 65+ yrs (C23002H_013)
    
    # Total civilian NON-HISPANIC WHITE female pop in labor force aged 16-64 yrs (C23002H_019)
    # Unemployed civilian NON-HISPANIC WHITE female pop in labor force aged 16-64 yrs (C23002H_021)
    # Total NON-HISPANIC WHITE female pop in labor force aged 65+ yrs (C23002H_024)
    # Unemployed NON-HISPANIC WHITE female pop in labor force aged 65+ yrs (C23002H_026)
  
  # Calculating ACS3yr2008 unemployment rate column for areas of interest; confirmed by info available at https://www.edd.ca.gov/pdf_pub_ctr/de8714aa.pdf
    # Unemployment rate for NON-HISPANIC WHITE men aged 16-64 yrs: (C23002H_008/C23002H_006) * 100
    # Unemployment rate for NON-HISPANIC WHITE women aged 16-64 yrs: (C23002H_021/C23002H_019) * 100
    # Overall unemployment rate for NON-HISPANIC WHITE labor force aged 16-64 yrs: (C23002H_008 + C23002H_021)/(C23002H_006 + C23002H_019) * 100
    # Unemployment rate for NON-HISPANIC WHITE men aged 65+ yrs: (C23002H_013/C23002H_011) * 100
    # Unemployment rate for NON-HISPANIC WHITE women aged 65+ yrs: (C23002H_026/C23002H_024) * 100
    # Overall unemployment rate for NON-HISPANIC WHITE labor force aged 65+ yrs: (C23002H_013 + C23002H_026)/(C23002H_011 + C23002H_024) * 100
  
  # [BLACK]
  # ACS3yr2008 Unemployment variables of interest: C23002B [BLACK]
  # Total civilian BLACK male pop in labor force aged 16-64 yrs (C23002B_006)
  # Unemployed BLACK civilian male pop in labor force aged 16-64 yrs (C23002B_008)
  # Total BLACK male pop in labor force aged 65+ yrs (C23002B_011)
  # Unemployed BLACK male pop in labor force aged 65+ yrs (C23002B_013)
  
  # Total civilian BLACK female pop in labor force aged 16-64 yrs (C23002B_019)
  # Unemployed civilian BLACK female pop in labor force aged 16-64 yrs (C23002B_021)
  # Total BLACK female pop in labor force aged 65+ yrs (C23002B_024)
  # Unemployed BLACK female pop in labor force aged 65+ yrs (C23002B_026)
  
  # Calculating ACS3yr2008 unemployment rate column for areas of interest; confirmed by info available at https://www.edd.ca.gov/pdf_pub_ctr/de8714aa.pdf
  # Unemployment rate for BLACK men aged 16-64 yrs: (C23002B_008/C23002B_006) * 100
  # Unemployment rate for BLACK women aged 16-64 yrs: (C23002B_021/C23002B_019) * 100
  # Overall unemployment rate for BLACK labor force aged 16-64 yrs: (C23002B_008 + C23002B_021)/(C23002B_006 + C23002B_019) * 100
  # Unemployment rate for BLACK men aged 65+ yrs: (C23002B_013/C23002B_011) * 100
  # Unemployment rate for BLACK women aged 65+ yrs: (C23002B_026/C23002B_024) * 100
  # Overall unemployment rate for BLACK labor force aged 65+ yrs: (C23002B_013 + C23002B_026)/(C23002B_011 + C23002B_024) * 100
  
  # [NATIVE AMERICAN]
  # ACS3yr2008 Unemployment variables of interest: C23002C [NATIVE AMERICAN]
  # Total civilian NATIVE AMERICAN male pop in labor force aged 16-64 yrs (C23002C_006)
  # Unemployed NATIVE AMERICAN civilian male pop in labor force aged 16-64 yrs (C23002C_008)
  # Total NATIVE AMERICAN male pop in labor force aged 65+ yrs (C23002C_011)
  # Unemployed NATIVE AMERICAN male pop in labor force aged 65+ yrs (C23002C_013)
  
  # Total civilian NATIVE AMERICAN female pop in labor force aged 16-64 yrs (C23002C_019)
  # Unemployed civilian NATIVE AMERICAN female pop in labor force aged 16-64 yrs (C23002C_021)
  # Total NATIVE AMERICAN female pop in labor force aged 65+ yrs (C23002C_024)
  # Unemployed NATIVE AMERICAN female pop in labor force aged 65+ yrs (C23002C_026)
  
  # Calculating ACS3yr2008 unemployment rate column for areas of interest; confirmed by info available at https://www.edd.ca.gov/pdf_pub_ctr/de8714aa.pdf
  # Unemployment rate for NATIVE AMERICAN men aged 16-64 yrs: (C23002C_008/C23002C_006) * 100
  # Unemployment rate for NATIVE AMERICAN women aged 16-64 yrs: (C23002C_021/C23002C_019) * 100
  # Overall unemployment rate for NATIVE AMERICAN labor force aged 16-64 yrs: (C23002C_008 + C23002C_021)/(C23002C_006 + C23002C_019) * 100
  # Unemployment rate for NATIVE AMERICAN men aged 65+ yrs: (C23002C_013/C23002C_011) * 100
  # Unemployment rate for NATIVE AMERICAN women aged 65+ yrs: (C23002C_026/C23002C_024) * 100
  # Overall unemployment rate for NATIVE AMERICAN labor force aged 65+ yrs: (C23002C_013 + C23002C_026)/(C23002C_011 + C23002C_024) * 100
  
  # [ASIAN]
  # ACS3yr2008 Unemployment variables of interest: C23002D [ASIAN]
  # Total civilian ASIAN male pop in labor force aged 16-64 yrs (C23002D_006)
  # Unemployed ASIAN civilian male pop in labor force aged 16-64 yrs (C23002D_008)
  # Total ASIAN male pop in labor force aged 65+ yrs (C23002D_011)
  # Unemployed ASIAN male pop in labor force aged 65+ yrs (C23002D_013)
  
  # Total civilian ASIAN female pop in labor force aged 16-64 yrs (C23002D_019)
  # Unemployed civilian ASIAN female pop in labor force aged 16-64 yrs (C23002D_021)
  # Total ASIAN female pop in labor force aged 65+ yrs (C23002D_024)
  # Unemployed ASIAN female pop in labor force aged 65+ yrs (C23002D_026)
  
  # Calculating ACS3yr2008 unemployment rate column for areas of interest; confirmed by info available at https://www.edd.ca.gov/pdf_pub_ctr/de8714aa.pdf
  # Unemployment rate for ASIAN men aged 16-64 yrs: (C23002D_008/C23002D_006) * 100
  # Unemployment rate for ASIAN women aged 16-64 yrs: (C23002D_021/C23002D_019) * 100
  # Overall unemployment rate for ASIAN labor force aged 16-64 yrs: (C23002D_008 + C23002D_021)/(C23002D_006 + C23002D_019) * 100
  # Unemployment rate for ASIAN men aged 65+ yrs: (C23002D_013/C23002D_011) * 100
  # Unemployment rate for ASIAN women aged 65+ yrs: (C23002D_026/C23002D_024) * 100
  # Overall unemployment rate for ASIAN labor force aged 65+ yrs: (C23002D_013 + C23002D_026)/(C23002D_011 + C23002D_024) * 100
  
  # [HISPANIC OR LATINO (ANY RACE)]
  # ACS3yr2008 Unemployment variables of interest: C23002I [HISPANIC]
  # Total civilian HISPANIC male pop in labor force aged 16-64 yrs (C23002I_006)
  # Unemployed HISPANIC civilian male pop in labor force aged 16-64 yrs (C23002I_008)
  # Total HISPANIC male pop in labor force aged 65+ yrs (C23002I_011)
  # Unemployed HISPANIC male pop in labor force aged 65+ yrs (C23002I_013)
  
  # Total civilian HISPANIC female pop in labor force aged 16-64 yrs (C23002I_019)
  # Unemployed civilian HISPANIC female pop in labor force aged 16-64 yrs (C23002I_021)
  # Total HISPANIC female pop in labor force aged 65+ yrs (C23002I_024)
  # Unemployed HISPANIC female pop in labor force aged 65+ yrs (C23002I_026)
  
  # Calculating ACS3yr2008 unemployment rate column for areas of interest; confirmed by info available at https://www.edd.ca.gov/pdf_pub_ctr/de8714aa.pdf
  # Unemployment rate for HISPANIC men aged 16-64 yrs: (C23002I_008/C23002I_006) * 100
  # Unemployment rate for HISPANIC women aged 16-64 yrs: (C23002I_021/C23002I_019) * 100
  # Overall unemployment rate for HISPANIC labor force aged 16-64 yrs: (C23002I_008 + C23002I_021)/(C23002I_006 + C23002I_019) * 100
  # Unemployment rate for HISPANIC men aged 65+ yrs: (C23002I_013/C23002I_011) * 100
  # Unemployment rate for HISPANIC women aged 65+ yrs: (C23002I_026/C23002I_024) * 100
  # Overall unemployment rate for HISPANIC labor force aged 65+ yrs: (C23002I_013 + C23002I_026)/(C23002I_011 + C23002I_024) * 100

# Isolate employment variables of interest (C23002 B-D,H-I) programmatically
# STEP 1: split label components into multiple columns 
empl_by_race_acs3_2008_vars <- acs_08_3yr_vars %>% 
  filter(str_detect(name, 'C23002[B-D, H-I]')) %>% # select employment variable of interest only
  mutate(race = str_match(name, 'C23002(\\D{1})')[,2]) %>% # put letters at the end of each variable in a separate column; translate into racial groups later
  separate(label, into = c('A', 'B', 'C', 'D', 'E', 'G', 'H'), sep = '!!') %>% # create columns A-H based on '!!' separators; skip 'F' since it typically means 'False'
  filter(!is.na(D)) %>% # Remove total columns; exclusion criteria = NA in column D
  filter(E == 'In labor force') %>% # focus on people in labor force
  filter(G == 'Civilian' | G == 'Employed' | G == 'Unemployed' | is.na(G)) %>% # remove estimates of people employed in the armed forces
  filter(str_detect(name, 'C23002\\w_004', negate = TRUE)) %>% # drop all rows ending in 004 (total male labor force including armed forces) from each group  
  filter(str_detect(name, 'C23002\\w_017', negate = TRUE)) # drop all rows ending in 017 (total female labor force including armed forces) from each group

str_match('This is a test C23002B_003', 'C23002(\\D{1})')[,2]

# STEP 2: grab specific B03002 rows of interest based on the ones kept in the code above
empl_vars_2008 <- empl_by_race_acs3_2008_vars %>% 
  pull(name) # returns 'name' column as a vector

# STEP 3: pull 2008 ACS data
empl_acs3_2008_data <- get_acs(
  geography = 'county',
  year = 2008,
  survey = 'acs3',
  state = c('ME', 'MN', 'OH', 'WA'),
  variables = empl_vars_2008
)

# STEP 4: Create a data frame containing race variables of interest for counties within each state
# merge empl_acs3_2008_data with empl_by_race_acs3_2008_vars
ME_MN_OH_WA_2008_empl <- empl_acs3_2008_data %>% 
  full_join(empl_by_race_acs3_2008_vars, by = c('variable' = 'name')) %>% 
  select(NAME, race, C, D, H, G, estimate) %>%  # select columns of interest only, and in the order specified
  rename(sex = C, # rename columns so that they make more sense
         age_group = D,
         empl_status_16_64 = H,
         empl_status_65_up = G) %>% 
  separate(NAME, into = c('county', 'state'), sep = ',')  # separate 'NAME' column into two parts

# STEP 5: Consolidate employment status columns; source data in empl_status_65_up to replace NA columns in empl_status_16_64
ME_MN_OH_WA_2008_empl <- within(ME_MN_OH_WA_2008_empl, {
  empl_status_16_64 = as.character(empl_status_16_64) # column I want to keep with gaps in it
  empl_status_65_up = as.character(empl_status_65_up) # reference column I'll use to complete the desired column
  empl_status_16_64 = ifelse(is.na(empl_status_16_64), empl_status_65_up, empl_status_16_64) # fills gaps in desired column with specific values from reference column
})

# Next, rename empl_status so that it's by itself; and then drop the extra empl_status column

# STEP 5: (Optional) Filter so that only 6 counties within 4 states are included in the final product
# Hennepin County, MN (Minneapolis); Stearns County, MN (St. Cloud)
# Franklin County, OH (Columbus)
# King County, WA (Seattle)
# Cumberland County, ME (Portland); Androscoggin County, ME (Lewiston)

################## 2019 ACS 5-YR VOIs ##################
# Examine variables in 2019 5-year ACS data set
acs_19_vars <- load_variables(2019, "acs5", cache = TRUE)
View(acs_19_vars)

#### Racial composition data ####
# Repeat procedure above (where appropriate) for 2019 ACS data
# STEP 1: split label components into multiple columns 
race_by_eth_2019_vars <- acs_19_vars %>% 
  filter(str_detect(name, 'B03002_\\d{3}')) %>% # select race variable of interest only
  separate(label, into = c('A', 'B', 'C', 'D', 'E'), sep = '!!') %>% # create columns A-E based on '!!' separators
  filter(!is.na(D)) %>% # Remove total columns; exclusion criteria = NA in column D
  filter(is.na(E)) %>%  # Remove "two or more races" detailed data; inclusion criteria = NA in column E
  mutate_at(vars(B:D), ~str_remove(., ':')) # Remove colons at the end of values for everything in columns B-D

# STEP 2: grab specific B03002 rows of interest based on the ones kept in the code above
race_vars_2019 <- race_by_eth_2019_vars %>% 
  pull(name) # returns 'name' column as a vector

# STEP 3: pull 2019 ACS race data for variables specified in the vector above
race_2019_data <- get_acs(
  geography = 'county',
  year = 2019,
  survey = 'acs5',
  state = c('GA', 'ME', 'MN', 'OH', 'TX', 'WA'), # Added GA (DeKalb County), and TX (Dallas County) on 1/18/2021
  variables = race_vars_2019
)

# STEP 4: Create a data frame containing race variables of interest for counties within each state
# merge race_2009_data with race_vars_2009 
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

