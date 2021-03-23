# INRIX and WSDOT PORTAL data clean-up and xts formatting

# Required packages ----
library(dplyr)
library(ggplot2)
library(tidyr)
library(lubridate)
library(xts)

# Read-in functions ----
source("R/inrix-its-cleanup-functions.R")

# Read-in INRIX data ----
sr14_inrix_raw <- read.csv("data/inrix/sr14-ellsworth-inrix.csv", stringsAsFactors = F)
sr14_inrix_tmc <- read.csv("data/inrix/sr14-ellsworth-tmc-id.csv", stringsAsFactors = F)

# Read-in WSDOT/PORTAL data ----
sr14_ellsworth_portal <- read.csv("data/portal/sr14-ellsworth-mp2-portal.csv", stringsAsFactors = F)
sr14_mp193_portal <- read.csv("data/portal/sr14-mp2-ellsworth-portal.csv", stringsAsFactors = F)

# SR14 EB MP 1.93 to Ellsworth ----
## Filter and format INRIX data ----
sr14_eb_tmc <- select_tmcs(sr14_inrix_tmc, "EASTBOUND")

# Check confidence interval distribution
sr14_eb_conf_dist <- conf_dist(sr14_inrix_raw, sr14_eb_tmc)
sr14_eb_conf_dist # four of the six segments have almost half confidence interval scores of less than 30.

# Check hist of c-values when confidence interval = 30
sr14_eb_cvalue <- cvalue_hist(sr14_inrix_raw, sr14_eb_tmc, 30)
sr14_eb_cvalue

sr14_eb_data <- select_data(sr14_inrix_raw, sr14_eb_tmc, 30, 75)
sr14_eb_tt <- hourly_inrix_tt(sr14_eb_data, 6)
