library(tidycensus)
library(tidyverse)
library(dplyr)
library(plotly)
library(stringr)

# Installing the most recent GitHub version of tidycensus (if needed)
#install.packages("remotes")
#remotes::install_github("walkerke/tidycensus")

# Notes on retrieving variables of interest (VOI) from both ACS data sets

################## 2008 ACS 3-YR VOIs ##################

# Examine variables in 2008 3-year ACS data set
acs_08_3yr_vars <- load_variables(2008, "acs3", cache = TRUE)
View(acs_08_3yr_vars)

#### Racial composition data ####
  # ACS3yr2008 Race by Ethnicity variables of interest: B03002
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
race_by_eth_acs3_2008_vars <- acs_08_3yr_vars %>% 
  filter(str_detect(name, 'B03002_\\d{3}')) %>% # select race variable of interest only
  separate(label, into = c('A', 'B', 'C', 'D', 'E'), sep = '!!') %>% # create columns A-E based on '!!' separators
  filter(!is.na(D)) %>% # Remove total columns; exclusion criteria = NA in column D
  filter(is.na(E)) # Remove "two or more races" detailed data by; inclusion criteria = NA in column E

# STEP 2: grab specific B03002 rows of interest based on the ones kept in the code above
race_vars_2008 <- race_by_eth_acs3_2008_vars %>% 
  pull(name) # returns 'name' column as a vector

# STEP 3: pull 2008 ACS race data for variables specified in the vector above
race_acs3_2008_data <- get_acs(
  geography = 'county',
  year = 2008,
  survey = 'acs3',
  state = c('ME', 'MN', 'OH', 'WA'),
  variables = race_vars_2008
)

# STEP 4: Create a data frame containing race variables of interest for counties within each state
# merge race_acs3_2008_data with race_by_eth_acs3_2008_vars 
ME_MN_OH_WA_2008_race <- race_by_eth_acs3_2008_vars %>% 
  full_join(race_acs3_2008_data, by = c("name" = "variable")) %>% 
  select(NAME, C, D, estimate) %>%  # select columns of interest only, and in the order specified
  rename(ethnicity = C, # rename columns so that they make more sense
         race = D) %>% 
  separate(NAME, into = c('county', 'state'), sep = ',') # separate 'NAME' column into two parts

# STEP 5: (Optional) Filter so that only 6 counties within 4 states are included in the final product
# Hennepin County, MN (Minneapolis); Stearns County, MN (St. Cloud)
# Franklin County, OH (Columbus)
# King County, WA (Seattle)
# Cumberland County, ME (Portland); Androscoggin County, ME (Lewiston)

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

#### Co-ethnic and immigrant community data ####
  # ACS3yr2008 Foreign-born Population Variable(s)
    # Somali population data
    # Variable of interest: People Reporting Ancestry (B04006)
      # Total population reporting ancestry (B04006_001)
      # Total population - for comparison ()
      # Self-reported Somali Ancestry (B04006_082)
      # Percent of total pop identifying as Somali = (B04006_082/B04006_001) * 100
      # Percent of foreign-born pop identifying as Somali = (B04006_082/B05006_001) * 100

# Isolate foreign-born pop variables of interest programmatically
# STEP 1: split label components into multiple columns 
somali_acs3_2008_vars <- acs_08_3yr_vars %>% 
  filter(str_detect(name, 'B04006')) %>% # select foreign-born variable of interest only
  separate(label, into = c('A', 'B', 'C', 'D'), sep = '!!') %>% # create columns A-D based on '!!' separators
  filter(name == 'B04006_001' | name == 'B04006_082')  # keep total foreign-born and Somali variables only

# STEP 2: grab specific B03002 rows of interest based on the ones kept in the code above
somali_vars_2008 <- somali_acs3_2008_vars %>% 
  pull(name) # returns 'name' column as a vector

# STEP 3: pull 2008 ACS data
somali_acs3_2008_data <- get_acs(
  geography = 'county',
  year = 2008,
  survey = 'acs3',
  state = c('ME', 'MN', 'OH', 'WA'),
  variables = somali_vars_2008
)

# STEP 4: Create a data frame containing race variables of interest for counties within each state
# merge race_acs3_2008_data with race_by_eth_acs3_2008_vars 
ME_MN_OH_WA_2008_somali <- somali_acs3_2008_vars %>% 
  full_join(somali_acs3_2008_data, by = c("name" = "variable")) %>% 
  select(NAME, D, estimate) %>%  # select columns of interest only, and in the order specified
  rename(fb_nationality = D) %>% # rename columns
  separate(NAME, into = c('county', 'state'), sep = ',') %>% # separate 'NAME' column into two parts
  mutate(fb_nationality = replace_na(fb_nationality, 'Non-Somali Foreign-Born')) # replace 'NA' in nationality col with new value

# STEP 5: (Optional) Filter so that only 6 counties within 4 states are included in the final product
# Hennepin County, MN (Minneapolis); Stearns County, MN (St. Cloud)
# Franklin County, OH (Columbus)
# King County, WA (Seattle)
# Cumberland County, ME (Portland); Androscoggin County, ME (Lewiston)

  # ACS3yr2008 Alternate if above data are missing for a community
    # Place of Birth by Nativity and Citizenship Status: (NA)
    # Total foreign-born population (B05006_001)
    # Total foreign-born (citizen and non-citizen) and native-born population (B05002_001)
    # Total foreign-born population who identify as African (B05006_067)
    # Percent of total pop identifying as African = (B05006_067/B05002_001) * 100
    # Percent of foreign-born pop identifying as African = (B05006_067/B05006_001) * 100

# STEP 1: split label components into multiple columns 
african_acs3_2008_vars <- acs_08_3yr_vars %>% 
  filter(str_detect(name, 'B05006')) %>% # select foreign-born variables of interest only
  separate(label, into = c('A', 'B', 'C', 'D'), sep = '!!') %>% # create columns A-D based on '!!' separators
  filter(name == 'B04006_001' | name == 'B04006_082')  # keep total foreign-born and Somali variables only

# STEP 2: grab specific B03002 rows of interest based on the ones kept in the code above
somali_vars_2008 <- somali_acs3_2008_vars %>% 
  pull(name) # returns 'name' column as a vector

# STEP 3: pull 2008 ACS data
somali_acs3_2008_data <- get_acs(
  geography = 'county',
  year = 2008,
  survey = 'acs3',
  state = c('ME', 'MN', 'OH', 'WA'),
  variables = somali_vars_2008
)

# STEP 4: Create a data frame containing race variables of interest for counties within each state
# merge race_acs3_2008_data with race_by_eth_acs3_2008_vars 
ME_MN_OH_WA_2008_somali <- somali_acs3_2008_vars %>% 
  full_join(somali_acs3_2008_data, by = c("name" = "variable")) %>% 
  select(NAME, D, estimate) %>%  # select columns of interest only, and in the order specified
  rename(fb_nationality = D) %>% # rename columns
  separate(NAME, into = c('county', 'state'), sep = ',') %>% # separate 'NAME' column into two parts
  mutate(fb_nationality = replace_na(fb_nationality, 'Non-Somali Foreign-Born')) # replace 'NA' in nationality col with new value

################## 2018 ACS 5-YR VOIs ##################
# Examine variables in 2018 5-year ACS data set
acs_18_5yr_vars <- load_variables(2018, "acs5", cache = TRUE)
View(acs_18_5yr_vars)
# Retrieve same VOIs as above if/where appropriate; double-check that variables names
# are still equivalent

#### Racial composition data ####
  # ACS5yr2018 Race by Ethnicity variables of interest: B03002
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

#### Economic/employment opportunity data ####
  # [NON-HISPANIC WHITE]
  # ACS5yr2018 Unemployment variables of interest: C23002H [NON-HISPANIC WHITE]
    # Total civilian NON-HISPANIC WHITE male pop in labor force aged 16-64 yrs (C23002H_006)
    # Unemployed NON-HISPANIC WHITE civilian male pop in labor force aged 16-64 yrs (C23002H_008)
    # Total NON-HISPANIC WHITE male pop in labor force aged 65+ yrs (C23002H_011)
    # Unemployed NON-HISPANIC WHITE male pop in labor force aged 65+ yrs (C23002H_013)
    
    # Total civilian NON-HISPANIC WHITE female pop in labor force aged 16-64 yrs (C23002H_019)
    # Unemployed civilian NON-HISPANIC WHITE female pop in labor force aged 16-64 yrs (C23002H_021)
    # Total NON-HISPANIC WHITE female pop in labor force aged 65+ yrs (C23002H_024)
    # Unemployed NON-HISPANIC WHITE female pop in labor force aged 65+ yrs (C23002H_026)
  
  # Calculating ACS5yr2018 unemployment rate column for areas of interest; confirmed by info available at https://www.edd.ca.gov/pdf_pub_ctr/de8714aa.pdf
    # Unemployment rate for NON-HISPANIC WHITE men aged 16-64 yrs: (C23002H_008/C23002H_006) * 100
    # Unemployment rate for NON-HISPANIC WHITE women aged 16-64 yrs: (C23002H_021/C23002H_019) * 100
    # Overall unemployment rate for NON-HISPANIC WHITE labor force aged 16-64 yrs: (C23002H_008 + C23002H_021)/(C23002H_006 + C23002H_019) * 100
    # Unemployment rate for NON-HISPANIC WHITE men aged 65+ yrs: (C23002H_013/C23002H_011) * 100
    # Unemployment rate for NON-HISPANIC WHITE women aged 65+ yrs: (C23002H_026/C23002H_024) * 100
    # Overall unemployment rate for NON-HISPANIC WHITE labor force aged 65+ yrs: (C23002H_013 + C23002H_026)/(C23002H_011 + C23002H_024) * 100
  
  # [BLACK]
  # ACS5yr2018 Unemployment variables of interest: C23002B [BLACK]
    # Total civilian BLACK male pop in labor force aged 16-64 yrs (C23002B_006)
    # Unemployed BLACK civilian male pop in labor force aged 16-64 yrs (C23002B_008)
    # Total BLACK male pop in labor force aged 65+ yrs (C23002B_011)
    # Unemployed BLACK male pop in labor force aged 65+ yrs (C23002B_013)
    
    # Total civilian BLACK female pop in labor force aged 16-64 yrs (C23002B_019)
    # Unemployed civilian BLACK female pop in labor force aged 16-64 yrs (C23002B_021)
    # Total BLACK female pop in labor force aged 65+ yrs (C23002B_024)
    # Unemployed BLACK female pop in labor force aged 65+ yrs (C23002B_026)
    
  # Calculating ACS5yr2018 unemployment rate column for areas of interest; confirmed by info available at https://www.edd.ca.gov/pdf_pub_ctr/de8714aa.pdf
    # Unemployment rate for BLACK men aged 16-64 yrs: (C23002B_008/C23002B_006) * 100
    # Unemployment rate for BLACK women aged 16-64 yrs: (C23002B_021/C23002B_019) * 100
    # Overall unemployment rate for BLACK labor force aged 16-64 yrs: (C23002B_008 + C23002B_021)/(C23002B_006 + C23002B_019) * 100
    # Unemployment rate for BLACK men aged 65+ yrs: (C23002B_013/C23002B_011) * 100
    # Unemployment rate for BLACK women aged 65+ yrs: (C23002B_026/C23002B_024) * 100
    # Overall unemployment rate for BLACK labor force aged 65+ yrs: (C23002B_013 + C23002B_026)/(C23002B_011 + C23002B_024) * 100
  
  # [NATIVE AMERICAN]
  # ACS5yr2018 Unemployment variables of interest: C23002C [NATIVE AMERICAN]
    # Total civilian NATIVE AMERICAN male pop in labor force aged 16-64 yrs (C23002C_006)
    # Unemployed NATIVE AMERICAN civilian male pop in labor force aged 16-64 yrs (C23002C_008)
    # Total NATIVE AMERICAN male pop in labor force aged 65+ yrs (C23002C_011)
    # Unemployed NATIVE AMERICAN male pop in labor force aged 65+ yrs (C23002C_013)
    
    # Total civilian NATIVE AMERICAN female pop in labor force aged 16-64 yrs (C23002C_019)
    # Unemployed civilian NATIVE AMERICAN female pop in labor force aged 16-64 yrs (C23002C_021)
    # Total NATIVE AMERICAN female pop in labor force aged 65+ yrs (C23002C_024)
    # Unemployed NATIVE AMERICAN female pop in labor force aged 65+ yrs (C23002C_026)
  
  # Calculating ACS5yr2018 unemployment rate column for areas of interest; confirmed by info available at https://www.edd.ca.gov/pdf_pub_ctr/de8714aa.pdf
    # Unemployment rate for NATIVE AMERICAN men aged 16-64 yrs: (C23002C_008/C23002C_006) * 100
    # Unemployment rate for NATIVE AMERICAN women aged 16-64 yrs: (C23002C_021/C23002C_019) * 100
    # Overall unemployment rate for NATIVE AMERICAN labor force aged 16-64 yrs: (C23002C_008 + C23002C_021)/(C23002C_006 + C23002C_019) * 100
    # Unemployment rate for NATIVE AMERICAN men aged 65+ yrs: (C23002C_013/C23002C_011) * 100
    # Unemployment rate for NATIVE AMERICAN women aged 65+ yrs: (C23002C_026/C23002C_024) * 100
    # Overall unemployment rate for NATIVE AMERICAN labor force aged 65+ yrs: (C23002C_013 + C23002C_026)/(C23002C_011 + C23002C_024) * 100
  
  # [ASIAN]
  # ACS5yr2018 Unemployment variables of interest: C23002D [ASIAN]
    # Total civilian ASIAN male pop in labor force aged 16-64 yrs (C23002D_006)
    # Unemployed ASIAN civilian male pop in labor force aged 16-64 yrs (C23002D_008)
    # Total ASIAN male pop in labor force aged 65+ yrs (C23002D_011)
    # Unemployed ASIAN male pop in labor force aged 65+ yrs (C23002D_013)
    
    # Total civilian ASIAN female pop in labor force aged 16-64 yrs (C23002D_019)
    # Unemployed civilian ASIAN female pop in labor force aged 16-64 yrs (C23002D_021)
    # Total ASIAN female pop in labor force aged 65+ yrs (C23002D_024)
    # Unemployed ASIAN female pop in labor force aged 65+ yrs (C23002D_026)
  
  # Calculating ACS5yr2018 unemployment rate column for areas of interest; confirmed by info available at https://www.edd.ca.gov/pdf_pub_ctr/de8714aa.pdf
    # Unemployment rate for ASIAN men aged 16-64 yrs: (C23002D_008/C23002D_006) * 100
    # Unemployment rate for ASIAN women aged 16-64 yrs: (C23002D_021/C23002D_019) * 100
    # Overall unemployment rate for ASIAN labor force aged 16-64 yrs: (C23002D_008 + C23002D_021)/(C23002D_006 + C23002D_019) * 100
    # Unemployment rate for ASIAN men aged 65+ yrs: (C23002D_013/C23002D_011) * 100
    # Unemployment rate for ASIAN women aged 65+ yrs: (C23002D_026/C23002D_024) * 100
    # Overall unemployment rate for ASIAN labor force aged 65+ yrs: (C23002D_013 + C23002D_026)/(C23002D_011 + C23002D_024) * 100
  
  # [HISPANIC OR LATINO (ANY RACE)]
  # ACS5yr2018 Unemployment variables of interest: C23002I [HISPANIC]
    # Total civilian HISPANIC male pop in labor force aged 16-64 yrs (C23002I_006)
    # Unemployed HISPANIC civilian male pop in labor force aged 16-64 yrs (C23002I_008)
    # Total HISPANIC male pop in labor force aged 65+ yrs (C23002I_011)
    # Unemployed HISPANIC male pop in labor force aged 65+ yrs (C23002I_013)
    
    # Total civilian HISPANIC female pop in labor force aged 16-64 yrs (C23002I_019)
    # Unemployed civilian HISPANIC female pop in labor force aged 16-64 yrs (C23002I_021)
    # Total HISPANIC female pop in labor force aged 65+ yrs (C23002I_024)
    # Unemployed HISPANIC female pop in labor force aged 65+ yrs (C23002I_026)
  
  # Calculating ACS5yr2018 unemployment rate column for areas of interest; confirmed by info available at https://www.edd.ca.gov/pdf_pub_ctr/de8714aa.pdf
    # Unemployment rate for HISPANIC men aged 16-64 yrs: (C23002I_008/C23002I_006) * 100
    # Unemployment rate for HISPANIC women aged 16-64 yrs: (C23002I_021/C23002I_019) * 100
    # Overall unemployment rate for HISPANIC labor force aged 16-64 yrs: (C23002I_008 + C23002I_021)/(C23002I_006 + C23002I_019) * 100
    # Unemployment rate for HISPANIC men aged 65+ yrs: (C23002I_013/C23002I_011) * 100
    # Unemployment rate for HISPANIC women aged 65+ yrs: (C23002I_026/C23002I_024) * 100
    # Overall unemployment rate for HISPANIC labor force aged 65+ yrs: (C23002I_013 + C23002I_026)/(C23002I_011 + C23002I_024) * 100

#### Co-ethnic and immigrant community data ####
  # ACS5yr2018 Foreign-born Population Variable(s)
    # Variable of interest: People Reporting Ancestry (B04006)
    # Total population reporting ancestry (B04006_001)
    # Total population - for comparison ()
    # Self-reported Somali Ancestry (B04006_082)
    # Percent of total pop identifying as Somali = (B04006_082/B04006_001) * 100
    # Percent of foreign-born pop identifying as Somali = (B04006_082/B05002_013) * 100
  
  # ACS5yr2018 Alternate if above data are missing for a community
    # Place of Birth by Region of Nativity and Citizenship Status: B05002
    # Total population reporting place of birth and citizenship status (B05002_001)
    # Total population - for comparison ()
    # Foreign-born population - Naturalized Citizens born in Africa (B05002_017)
    # Foreign-born population - Non-U.S. Citizens born in Africa (B05002_024)
    # Percent of total pop identifying as African = ((B05002_017 + B05002_024)/B05002_001) * 100
    
#### Crime data for 2008-2018 by state ####
# Read-in csv files retrieved from FBI's Crime Data Explorer (https://crime-data-explorer.fr.cloud.gov/)
ME_agg_assault <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/maine-aggravated-assault.csv")
ME_homicide <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/maine-homicide.csv")
ME_prop_crime <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/maine-property-crime.csv")
ME_rape <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/maine-rape.csv")
ME_robbery <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/maine-robbery.csv")
ME_violent <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/maine-violent-crime.csv")

# Merge all files into one data frame to report crime rates in the state per 100,000 people per year
ME_crime_data <- ME_agg_assault %>% 
  full_join(ME_homicide, 
            by = c("Year", "Location"), 
            suffix = c("_a", "_h")
  ) %>% 
  rename(aggr_assault = Rate_a,
         homicide = Rate_h
  ) %>% 
  full_join(ME_prop_crime,
            by = c("Year", "Location")
  ) %>% 
  rename(prop_crime = Rate) %>% 
  full_join(ME_rape %>% 
              mutate(type = str_match(Location, 'Rape\\s(\\w+)')[,2]) %>% 
              mutate(Location = str_match(Location, '(.+)\\sRape')[,2]) %>% 
              pivot_wider(names_from = type,
                          values_from = Rate),
            by = c("Year", "Location")
  ) %>% 
  #rename(rape = Rate) %>% # No longer needed
  full_join(ME_robbery,
            by = c("Year", "Location")
  ) %>% 
  rename(robbery = Rate) %>%
  full_join(ME_violent,
            by = c("Year", "Location")
  ) %>% 
  rename(violent_crime = Rate,
         year = Year,
         location = Location) %>% 
  relocate(location, .before = aggr_assault) 

# 
# ME_rape %>% 
#   mutate(type = str_match(Location, 'Rape\\s(\\w+)')[,2]) %>% 
#   mutate(Location = str_match(Location, '(.+)\\sRape')[,2]) %>% 
#   pivot_wider(names_from = type,
#               values_from = Rate) %>% 
#   View()

# Writing a function to merge and prepare all 6 data files for each state
crime_merge <- function(state){ # curly braces specifies chunk of r code
  
  # reading in csv files and naming resulting tibbles appropriately
  state_agg_assault <- read_csv(paste0("../../mcp_data/Crime/", state, "-aggravated-assault.csv"))
  state_homicide <- read_csv(paste0("../../mcp_data/Crime/", state, "-homicide.csv"))
  state_prop_crime <- read_csv(paste0("../../mcp_data/Crime/", state, "-property-crime.csv"))
  state_rape <- read_csv(paste0("../../mcp_data/Crime/", state, "-rape.csv"))
  state_robbery <- read_csv(paste0("../../mcp_data/Crime/", state, "-robbery.csv"))
  state_violent <- read_csv(paste0("../../mcp_data/Crime/", state, "-violent-crime.csv"))
  
  # Merge all files into one data frame to report crime rates in the state per 100,000 people per year
  state_crime_data <- state_agg_assault %>% 
    full_join(state_homicide, 
              by = c("Year", "Location"), 
              suffix = c("_a", "_h")
    ) %>% 
    rename(aggr_assault = Rate_a,
           homicide = Rate_h
    ) %>% 
    full_join(state_prop_crime,
              by = c("Year", "Location")
    ) %>% 
    rename(prop_crime = Rate) %>% 
    full_join(state_rape %>% 
                mutate(type = str_match(Location, 'Rape\\s(\\w+)')[,2]) %>% 
                mutate(Location = str_match(Location, '(.+)\\sRape')[,2]) %>% 
                pivot_wider(names_from = type,
                            values_from = Rate),
              by = c("Year", "Location")
    ) %>% 
    full_join(state_robbery,
              by = c("Year", "Location")
    ) %>% 
    rename(robbery = Rate) %>%
    full_join(state_violent,
              by = c("Year", "Location")
    ) %>% 
    rename(violent_crime = Rate,
           year = Year,
           location = Location) %>% 
    relocate(location, .before = aggr_assault)
  
  # Return state crime data
  return(state_crime_data)
  
  }

# Creating a for loop to create and combine all crime data for states of interest

for (state in c('maine', 'minnesota', 'ohio', 'washington')) {
  
  if (state == 'maine') {
    
    full_crime_data <- crime_merge(state)
  }
  
  else {
    
    full_crime_data <- bind_rows(full_crime_data, crime_merge(state) %>% filter(location != 'United States'))
    
  }
  
}

MN_agg_assault <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/minnesota-aggravated-assault.csv")
MN_homicide <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/minnesota-homicide.csv")
MN_prop_crime <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/minnesota-property-crime.csv")
MN_rape <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/minnesota-rape.csv")
MN_robbery <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/minnesota-robbery.csv")
MN_violent <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/minnesota-violent-crime.csv")

OH_agg_assault <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/ohio-aggravated-assault.csv")
OH_homicide <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/ohio-homicide.csv")
OH_prop_crime <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/ohio-property-crime.csv")
OH_rape <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/ohio-rape.csv")
OH_robbery <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/ohio-robbery.csv")
OH_violent <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/ohio-violent-crime.csv")

WA_agg_assault <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/washington-aggravated-assault.csv")
WA_homicide <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/washington-homicide.csv")
WA_prop_crime <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/washington-property-crime.csv")
WA_rape <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/washington-rape.csv")
WA_robbery <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/washington-robbery.csv")
WA_violent <- read_csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/mcp_data/Crime/washington-violent-crime.csv")

## Refugee Data
library(readxl)

refugee_hist_data <- read_excel("../../mcp_data/Refugees/PRM Refugee Admissions Report as of November 30, 2020.xlsx",
                                sheet = 1,
                                range = 'A11:K59',
                                col_names = T)

################## Advice for renaming variables ##################
# See Michael's suggestion on programmatically generating variable vectors rather than manually creating them:
# Potentially, something like this could work. It does result in names that are a bit longer, and it's definitely debatable if it's worth the effort in this case to do it.:
# 
# edulevels_bygender <- v19 %>%
#   filter(str_detect(name, 'B15002_\\d{3}')) %>%    # Narrow it down to the education variables
#   filter(!str_detect(label, 'grade')) %>%     # Remove the unwanted ones
#   separate(label, into = c('A', 'B', 'C', 'D'), sep = "!!") %>%   # Split into multiple columns
#   mutate(C = str_remove(C, ':')) %>%      # Do some formatting
#   mutate(D = str_replace_all(D, ' ', '_')) %>%
#   mutate_at(c('C', 'D'), ~str_to_lower(.)) %>%
#   mutate(C = replace_na(C, 'all')) %>%
#   mutate(D = replace_na(D, 'total')) %>%
#   unite(label, C, D, na.rm = TRUE) %>%     # Glue the labels back together
#   select(label, name) %>%      # Pull out the pieces we need
#   deframe()               # Covert to a named vector