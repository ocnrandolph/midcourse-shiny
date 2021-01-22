# This code is to replicate the analyses and figures from my Jan 2021
# R shiny application. Code developed by Oluchi Nwosu Randolph

# 2009 through 2019 FBI crime data retrieval

# Load libraries
library(tidyverse)
library(dplyr)
library(stringr)

#### Crime data for 2008-2018 by state ####

# Writing a function to merge and prepare all 6 data files for each state
crime_merge <- function(state){ # curly braces specifies chunk of r code
  
  # reading in csv files and naming resulting tibbles appropriately
  state_agg_assault <- read_csv(paste0("../../mcp_data/Crime/", state, "-aggravated-assault.csv"))
  state_homicide <- read_csv(paste0("../../mcp_data/Crime/", state, "-homicide.csv"))
  state_prop_crime <- read_csv(paste0("../../mcp_data/Crime/", state, "-property-crime.csv"))
  state_rape <- read_csv(paste0("../../mcp_data/Crime/", state, "-rape.csv"))
  state_robbery <- read_csv(paste0("../../mcp_data/Crime/", state, "-robbery.csv"))
  state_violent <- read_csv(paste0("../../mcp_data/Crime/", state, "-violent-crime.csv"))
  
  # Merge all 6 files into one data frame to report crime rates in the state per 100,000 people per year
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

for (state in c('georgia', 'maine', 'minnesota', 'ohio', 'texas', 'washington')) {
  
  if (state == 'georgia') {
    
    full_crime_data <- crime_merge(state)
  }
  
  else {
    
    full_crime_data <- bind_rows(full_crime_data, crime_merge(state) %>% filter(location != 'United States'))
    
  }
  
}

# Check out the resulting data frame
View(full_crime_data)

# Rename columns with pivot_longer and data visualization in mind
full_crime_data <- full_crime_data %>% 
  rename(`Rape Legacy` = Legacy,
         `Rape Revised` = Revised,
         `Aggravated Assault` = aggr_assault,
         `Homicide` = homicide,
         `Property Crime` = prop_crime,
         `Robbery` = robbery,
         `Violent Crime` = violent_crime) %>% 
  pivot_longer(
    cols = `Aggravated Assault`:`Violent Crime`,
    names_to = 'crime',
    values_to = 'rate_per_100K',
    values_drop_na = FALSE)

# link county and state names in this data set to facilitate data visualization
county_state <- race_full %>% 
  select(county, state)

full_crime_data %>% 
  left_join(county_state, by = c("location" = "state")) %>% 
  View()

crime_full <- full_crime_data %>% 
  write.csv(
    file = "C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/midcourse-shiny/mcp_shiny/refugee-resettlement-us/data_csv/crime_full.csv",
    row.names = FALSE
  )