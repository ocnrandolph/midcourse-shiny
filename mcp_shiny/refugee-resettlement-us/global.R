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
library(colorspace)

# Import all needed data files
#C:/Users/ocnra/Documents/NSS_Projects/r-midcourse-project/midcourse-shiny/mcp_shiny/refugee-resettlement-us/
prm_hist_admit <- read.csv("data_csv/prm_hist_admit.csv")
admit_vs_ceiling <- read.csv("data_csv/admit_vs_ceiling.csv")
admissions_2009 <- read.csv("data_csv/admissions_2009.csv")
admissions_2019 <- read.csv("data_csv/admissions_2019.csv")
race_full <- read.csv("data_csv/race_full.csv")
coethnic_full <- read.csv("data_csv/coethnic_full.csv")
employment_full_wide <- read.csv("data_csv/employment_full_wide.csv")
crime_full <- read.csv("data_csv/crime_full.csv")

# specifying initial resettlement location options for casePage selectInput
firstCountyLoc <- c('DeKalb County', 'Hennepin County', 'Dallas County', 'King County', 'Franklin County')
secondCountyLoc <- c('Androscoggin County', 'Cumberland County', 'Hennepin County', 'Stearns County', 'King County', 'Franklin County')

# colorblind-friendly palette
cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
vPalette <- c("#440154FF", "#453781FF", "#33638DFF", "#238A8DFF", "#20A387FF", "#55C667FF", "#B8DE29FF", "#FDE725FF")
alladmit_Palette <- c("#A7226E", "#453781FF", "#33638DFF", "#238A8DFF", "#839B97", "#55C667FF", "#B8DE29FF", "#433D3C")
top09_Palette <- c("#453781FF", "#482677FF", "#29AF7FFF", "#39568CFF", "#20A387FF", "#238A8DFF", "#404788FF", "#440154FF", "#FDE725FF",
               "#DCE319FF", "#95D840FF", "#2D708EFF", "#3CBB75FF", "#73D055FF", "#1F968BFF")
top19_Palette <- c("#39568CFF", "#453781FF", "#B8DE29FF", "#3CBB75FF", "#440154FF", "#29AF7FFF", "#404788FF", "#95D840FF", 
                   "#FDE725FF", "#1F968BFF", "#73D055FF", "#DCE319FF", "#20A387FF", "#2D708EFF", "#482677FF")
eggplant <- '#440154FF'
teal <- '#287D8EFF'
lemon <- '#FDE725FF'
cocoa <- '#8F5728'