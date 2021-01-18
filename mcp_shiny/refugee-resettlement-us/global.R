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

# specifying initial resettlement location options for casePage selectInput
firstCountyLoc <- c("County 1", "County 2")
secondCountyLoc <- c("County 3", "County 4")