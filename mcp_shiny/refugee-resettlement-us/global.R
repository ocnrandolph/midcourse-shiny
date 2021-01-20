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

# Import all needed data files
prm_hist_admit <- read.csv("data_csv/prm_hist_admit.csv")
race_full <- read.csv("data_csv/race_full.csv")
coethnic_full <- read.csv("data_csv/coethnic_full.csv")
employment_full <- read.csv("data_csv/employment_full.csv")
employment_full_wide <- read.csv("data_csv/employment_full_wide.csv")

# specifying initial resettlement location options for casePage selectInput
firstCountyLoc <- c('DeKalb County', 'Hennepin County', 'Dallas County', 'King County', 'Franklin County')
secondCountyLoc <- c('Androscoggin County', 'Cumberland County', 'Hennepin County', 'Stearns County', 'King County', 'Franklin County')