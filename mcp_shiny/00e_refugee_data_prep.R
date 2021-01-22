# This code is to replicate the analyses and figures from my Jan 2021
# R shiny application. Code developed by Oluchi Nwosu Randolph

# Refugee admissions and arrivals data retrieval

# Load libraries
library(tidyverse)
library(dplyr)
library(stringr)
library(readxl)

# DOS PRM data on all refugee admissions by year and region from FY1975 to 2021 
# incomplete 2021 data should be dropped
prm_hist_admit_data <- read_excel("../../mcp_data/Refugees/PRM Refugee Admissions Report as of November 30, 2020.xlsx",
                                sheet = 1,
                                range = 'A11:K59',
                                col_names = T)

prm_hist_admit_data <- prm_hist_admit_data %>% 
  slice(-47) %>% # dropping FY 2021 incomplete data
  select(! ...4) %>% # losing the unnecessary `...4` column
  rename(`Former Soviet Union` = Union,
         `Latin America/Caribbean` = Caribbean,
         `Near East/South Asia` = `South Asia`,
         `Private Sector Initiative` = PSI) %>% 
  pivot_longer(cols = !Year, 
               names_to = "Region",
               values_to = "Population")

# export to a csv file for easy shiny app access
prm_hist_admit <- prm_hist_admit_data %>% 
  write.csv(
    file = "C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/midcourse-shiny/mcp_shiny/refugee-resettlement-us/data_csv/prm_hist_admit.csv",
    row.names = FALSE
  )

# MPI data comparing presidential refugee ceilings and actual refugee admissions FY1980 to 2020
admit_vs_ceiling <- read_excel("../../mcp_data/Refugees/MPI-Data-Hub_Refugee-Admissions_FY1980-2020.xlsx",
                               range = 'A8:C49',
                               col_names = T)

admit_vs_ceiling <- admit_vs_ceiling %>% 
  rename(Ceiling = `Annual Ceiling`,
         Admissions = `Number of Admitted Refugees`)

admit_vs_ceiling %>% 
  write.csv(
    file = "C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/midcourse-shiny/mcp_shiny/refugee-resettlement-us/data_csv/admit_vs_ceiling.csv",
    row.names = FALSE
  )

# provides info on top countries of origin for 2009
admissions_2009 <- read_excel("../../mcp_data/Refugees/PRM Refugee Admissions Report as of November 30, 2020.xlsx",
                              sheet = '2009',
                              range = 'A7:D89',
                              col_names = T)

admissions_2009 <- admissions_2009 %>% 
  slice(-1) %>% # remove first row
  slice(-1) %>% # remove second row which is now the first row
  rename(Region = ...1,
         Country = ...2,
         Ceiling = Admissions)

# change admitted and ceiling columns to numeric 
admissions_2009$Admitted <- as.numeric(admissions_2009$Admitted)
admissions_2009$Ceiling <- as.numeric(admissions_2009$Ceiling)

admissions_2009 %>% 
  write.csv(
    file = "C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/midcourse-shiny/mcp_shiny/refugee-resettlement-us/data_csv/admissions_2009.csv",
    row.names = FALSE
  )

# provides info on top countries of origin for 2019
admissions_2019 <- read_excel("../../mcp_data/Refugees/PRM Refugee Admissions Report as of November 30, 2020.xlsx",
                              sheet = '2019',
                              range = 'A7:D86',
                              col_names = T)

admissions_2019 <- admissions_2019 %>% 
  slice(-1) %>% # remove first row
  slice(-1) %>% # remove second row which is now the first row
  rename(Region = ...1,
         Country = ...2,
         Ceiling = Admissions)

# change admitted and ceiling columns to numeric 
admissions_2019$Admitted <- as.numeric(admissions_2019$Admitted)
admissions_2019$Ceiling <- as.numeric(admissions_2019$Ceiling)

admissions_2019 %>% 
  write.csv(
    file = "C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/midcourse-shiny/mcp_shiny/refugee-resettlement-us/data_csv/admissions_2019.csv",
    row.names = FALSE
  )
