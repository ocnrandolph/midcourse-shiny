library(tidycensus)
library(tidyverse)
library(dplyr)
library(plotly)
library(stringr)

# Installing the most recent GitHub version of tidycensus
install.packages("remotes")
remotes::install_github("walkerke/tidycensus")

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
race_by_eth_acs3_2008 <- acs_08_3yr_vars %>% 
  filter(str_detect(name, 'B03002_\\d{3}')) %>% # select race variable of interest only
  separate(label, into = c('A', 'B', 'C', 'D', 'E'), sep = "!!") %>% # create columns A-E based on separators
  filter(!is.na(D)) %>% # Remove total columns
  filter(is.na(E)) # Remove "two or more races" detailed data

# STEP 2: grab specific B03002 rows of interest based on the ones kept in the code above
vars <- race_by_eth_acs3_2008 %>% 
  pull(name) # returns 'name' column as a vector

# STEP 3: pull 2008 ACS data
ex <- get_acs(
  geography = "county",
  year = 2008,
  survey = "acs3",
  state = c("ME", "MN", "OH", "WA"),
  variables = vars
)

# STEP 4: Create a data frame containing race variables of interest for counties within each state
# merge ex with race_by_eth dataframe
race_by_eth_acs3_2008 %>% 
  full_join(ex, by = c("name" = "variable")) %>% 
  select(C, D, NAME, estimate) %>%  # select columns of interest only, and in the order specified
  View()

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

#### Co-ethnic and immigrant community data ####
  # ACS3yr2008 Foreign-born Population Variable(s)
    # Somali population data
    # Variable of interest: People Reporting Ancestry (B04006)
      # Total population reporting ancestry (B04006_001)
      # Total population - for comparison ()
      # Self-reported Somali Ancestry (B04006_082)
      # Percent of total pop identifying as Somali = (B04006_082/B04006_001) * 100
      # Percent of foreign-born pop identifying as Somali = (B04006_082/B05006_001) * 100
  
  # ACS3yr2008 Alternate if above data are missing for a community
    # Place of Birth by Nativity and Citizenship Status: (NA)
      # Total foreign-born population (B05006_001)
      # Total foreign-born (citizen and non-citizen) and native-born population (B05002_001)
      # Total foreign-born population who identify as African (B05006_067)
      # Percent of total pop identifying as African = (B05006_067/B05002_001) * 100
      # Percent of foreign-born pop identifying as African = (B05006_067/B05006_001) * 100

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
  full_join(ME_rape,
            by = c("Year", "Location")
  ) %>% 
  rename(rape = Rate) %>%
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

################## Advice for renaming variables ##################
# See Michael's suggestion on programmatically generating variable vectors rather than manually creating them:
# Potentially, something like this could work. It does result in names that are a bit longer, and it's definitely debatable if it's worth the effort in this case to do it.:
# 
# edulevels_bygender <- acs_08_3yr_vars %>%
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