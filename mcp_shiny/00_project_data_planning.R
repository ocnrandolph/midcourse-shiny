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

# Racial composition data
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

# Economic/employment opportunity data
  # ACS3yr2008 Unemployment variables of interest: C23002A
    # Total civilian male pop in labor force aged 16-64 yrs (C23002A_006)
    # Unemployed civilian male pop in labor force aged 16-64 yrs (C23002A_008)
    # Total male pop in labor force aged 65+ yrs (C23002A_011)
    # Unemployed male pop in labor force aged 65+ yrs (C23002A_013)
  
    # Total civilian female pop in labor force aged 16-64 yrs (C23002A_019)
    # Unemployed civilian female pop in labor force aged 16-64 yrs (C23002A_021)
    # Total female pop in labor force aged 65+ yrs (C23002A_024)
    # Unemployed female pop in labor force aged 65+ yrs (C23002A_026)
  
  # Calculating ACS3yr2008 unemployment rate column for areas of interest; confirmed by info available at
  # https://www.edd.ca.gov/pdf_pub_ctr/de8714aa.pdf
    # Combine estimates of unemployed civilian males and females in labor force aged 16-64 yrs (C23002A_008 + C23002A_021)
    # Divide this number by total estimates of civilian males and females in labor force aged 16-64 yrs (C23002A_006 + C23002A_019)
    # Final formula: (C23002A_008 + C23002A_021)/(C23002A_006 + C23002A_019) * 100
    # Do these same calculations for people aged 65+ yrs in labor force (C23002A_013 + C23002A_026)/(C23002A_011 + C23002A_024) * 100

# Co-ethnic and immigrant community data
  # ACS3yr2008 Foreign-born Population Variable(s)
    # Somali population data
    # Variable of interest: People Reporting Ancestry (B04006)
      # Total population reporting ancestry (B04006_001)
      # Total population - for comparison ()
      # Self-reported Somali Ancestry (B04006_082)
      # Final formula: Percent of pop identifying as Somali = (B04006_082/Total) * 100
  
  # ACS3yr2008 Alternate if above data are missing for a community
    # Place of Birth by Nativity and Citizenship Status: B05002
      # Total population reporting place of birth and citizenship status (B05002_001)
      # Total population - for comparison ()
      # Total Foreign-born population born in Eastern Africa, excluding Ethiopia and Kenya (B05006_071)
      # Final formula: Percent of pop identifying as East African = (B05006_071/Total) * 100
      # Foreign-born population - Naturalized Citizens born in Africa (NA)
      # Foreign-born population - Non-U.S. Citizens born in Africa (NA)

################## 2018 ACS 5-YR VOIs ##################
# Examine variables in 2018 5-year ACS data set
acs_18_5yr_vars <- load_variables(2018, "acs5", cache = TRUE)
View(acs_18_5yr_vars)
# Retrieve same VOIs as above if/where appropriate; double-check that variables names
# are still equivalent

# Racial composition data
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

# Economic/employment opportunity data
  # ACS5yr2018 Unemployment variables of interest: C23002A
    # Total civilian male pop in labor force aged 16-64 yrs (C23002A_006)
    # Unemployed civilian male pop in labor force aged 16-64 yrs (C23002A_008)
    # Total male pop in labor force aged 65+ yrs (C23002A_011)
    # Unemployed male pop in labor force aged 65+ yrs (C23002A_013)
  
    # Total civilian female pop in labor force aged 16-64 yrs (C23002A_019)
    # Unemployed civilian female pop in labor force aged 16-64 yrs (C23002A_021)
    # Total female pop in labor force aged 65+ yrs (C23002A_024)
    # Unemployed female pop in labor force aged 65+ yrs (C23002A_026)
  
  # Calculating ACS5yr2018 unemployment rate column for areas of interest; confirmed by info available at
  # https://www.edd.ca.gov/pdf_pub_ctr/de8714aa.pdf
    # Combine estimates of unemployed civilian males and females in labor force aged 16-64 yrs (C23002A_008 + C23002A_021)
    # Divide this number by total estimates of civilian males and females in labor force aged 16-64 yrs (C23002A_006 + C23002A_019)
    # Final formula: (C23002A_008 + C23002A_021)/(C23002A_006 + C23002A_019) * 100
    # Do these same calculations for people aged 65+ yrs in labor force (C23002A_013 + C23002A_026)/(C23002A_011 + C23002A_024) * 100


# ACS5yr2018 Foreign-born Population Variable(s)
# Variable of interest: People Reporting Ancestry (B04006)
# Total population reporting ancestry (B04006_001)
# Total population - for comparison ()
# Self-reported Somali Ancestry (B04006_082)
# Percent of pop identifying as Somali = (B04006_082/Total) * 100

# ACS5yr2018 Alternate if above data are missing for a community
# Place of Birth by Nativity and Citizenship Status: B05002
# Total population reporting place of birth and citizenship status (B05002_001)
# Total population - for comparison ()
# Total Foreign-born population born in Eastern Africa, excluding Ethiopia and Kenya (B05006_071)
# Foreign-born population - Naturalized Citizens born in Africa (NA)
# Foreign-born population - Non-U.S. Citizens born in Africa (NA)

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