# This code is to replicate the analyses and figures from my Jan 2021
# R shiny application. Code developed by Oluchi Nwosu Randolph

# Refugee admissions and arrivals data retrieval

# Load libraries
library(tidyverse)
library(dplyr)
library(stringr)
library(readxl)

# pull cumulative summary of refugee admissions data from DOS Bureau of Population, Refugees, and Migration
prm_hist_admit_data <- read_excel("../../mcp_data/Refugees/PRM Refugee Admissions Report as of November 30, 2020.xlsx",
                                sheet = 1,
                                range = 'A11:K59',
                                col_names = T)
