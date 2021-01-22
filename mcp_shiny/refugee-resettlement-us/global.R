# This file is run only once at the start of the app

# Import all needed libraries
library(dplyr)
library(tidyverse)
library(tidycensus)
library(stringr)
library(readxl)
library(janitor)
library(ggplot2)
library(plotly)
library(shiny)
library(shinydashboard)
library(scales)
library(viridis)

# Import all needed data files
prm_hist_admit <- read.csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/midcourse-shiny/mcp_shiny/refugee-resettlement-us/data_csv/prm_hist_admit.csv")
admit_vs_ceiling <- read.csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/midcourse-shiny/mcp_shiny/refugee-resettlement-us/data_csv/admit_vs_ceiling.csv")
admissions_2009 <- read.csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/midcourse-shiny/mcp_shiny/refugee-resettlement-us/data_csv/admissions_2009.csv")
admissions_2019 <- read.csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/midcourse-shiny/mcp_shiny/refugee-resettlement-us/data_csv/admissions_2019.csv")
race_full <- read.csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/midcourse-shiny/mcp_shiny/refugee-resettlement-us/data_csv/race_full.csv")
coethnic_full <- read.csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/midcourse-shiny/mcp_shiny/refugee-resettlement-us/data_csv/coethnic_full.csv")
employment_full_wide <- read.csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/midcourse-shiny/mcp_shiny/refugee-resettlement-us/data_csv/employment_full_wide.csv")
crime_full <- read.csv("C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/midcourse-shiny/mcp_shiny/refugee-resettlement-us/data_csv/crime_full.csv")

# specifying initial resettlement location options for casePage selectInput
firstCountyLoc <- c('DeKalb County', 'Hennepin County', 'Dallas County', 'King County', 'Franklin County')
secondCountyLoc <- c('Androscoggin County', 'Cumberland County', 'Hennepin County', 'Stearns County', 'King County', 'Franklin County')

# colorblind-friendly palette
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")