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
coethnic_full <- read.csv("data_csv/coethnic_full.csv")

# specifying initial resettlement location options for casePage selectInput
firstCountyLoc <- c('DeKalb County', 'Hennepin County', 'Dallas County', 'King County', 'Franklin County')
secondCountyLoc <- c('Androscoggin County', 'Cumberland County', 'Hennepin County', 'Stearns County', 'King County', 'Franklin County')