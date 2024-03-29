# INRIX and WSDOT PORTAL data clean-up and xts formatting 

# Required packages ----
library(dplyr)
library(ggplot2)
library(lubridate)
library(tibble)
library(tidyr)
library(xts)

# Read-in functions ----
source("R/inrix-its-cleanup-functions.R")

# Read-in INRIX data ----
sr14_inrix_raw <- read.csv("data/inrix/sr14-ellsworth-inrix.csv", stringsAsFactors = F)
sr14_inrix_tmc <- read.csv("data/inrix/sr14-ellsworth-tmc-id.csv", stringsAsFactors = F)

# Read-in WSDOT/PORTAL data ----
sr14_ellsworth_portal <- read.csv("data/portal/sr14-ellsworth-mp2-portal.csv", stringsAsFactors = F)
sr14_mp193_portal <- read.csv("data/portal/sr14-mp2-ellsworth-portal.csv", stringsAsFactors = F)

# SR14 EB MP 1.93 to Ellsworth ------------------------------------------------------------------
## Filter and format EB INRIX data
sr14_eb_tmc <- select_tmcs(sr14_inrix_tmc, "EASTBOUND")

# Check confidence interval distribution
sr14_eb_conf_dist <- conf_dist(sr14_inrix_raw, sr14_eb_tmc)
sr14_eb_conf_dist # four of the six segments have almost half confidence interval scores of less than 30.

# Check hist of c-values when confidence interval = 30
sr14_eb_cvalue <- cvalue_hist(sr14_inrix_raw, sr14_eb_tmc, 30)
sr14_eb_cvalue

# Calculate average hourly travel time for INRIX data
sr14_eb_data <- select_data(sr14_inrix_raw, sr14_eb_tmc, 30, 75)
sr14_eb_inrix_tt <- hourly_inrix_tt(sr14_eb_data, 6)

# Format WSDOT/PORTAL data
sr14_eb_portal_tt <- its_tt(sr14_mp193_portal)

# create xts tibble for dygraph
sr14_eb_tt <- its_inrix_xts("2019-02-03 00:00:00", "2019-03-03 00:00:00",
                            sr14_eb_portal_tt, sr14_eb_inrix_tt)

saveRDS(sr14_eb_tt, "data/eb_sr14_mp193_tt_xts.rds")

# SR14 WB Ellsworth to MP 1.93 ----------------------------------------------------
# Filter and format WB INRIX data
sr14_wb_tmc <- select_tmcs(sr14_inrix_tmc, "WESTBOUND")

# confidence interval distribution
conf_dist(sr14_inrix_raw, sr14_wb_tmc)
# half the segments have either half or almost half confidence scores of less than 30.

#cvalue histo for when confidence = 30
cvalue_hist(sr14_inrix_raw, sr14_wb_tmc, 30)

# Calculate average hourly travel time for INRIX data
sr14_wb_data <- select_data(sr14_inrix_raw, sr14_wb_tmc, 30, 75)
sr14_wb_inrix_tt <- hourly_inrix_tt(sr14_wb_data, 6)

# Format WSDOT/PORTAL data
sr14_wb_portal_tt <- its_tt(sr14_mp193_portal)

# Create xts tibble for dygraph
sr14_wb_tt <- its_inrix_xts("2019-02-03 00:00:00", "2019-03-03 00:00:00",
                            sr14_wb_portal_tt, sr14_wb_inrix_tt)
saveRDS(sr14_wb_tt, "data/wb_sr14_ellsworth_xts.rds")

# I-84 WB 53rd to Holiday Ramp {Lloyd} -----------------------------------------------
i84_inrix_tmc <- read.csv("data/inrix/i84-holiday-53rd-tmc-id.csv", stringsAsFactors = F)
i84_inrix_raw <- read.csv("data/inrix/i84-holiday-53rd-inrix.csv", stringsAsFactors = F)

# Filter and format WB INRIX data
i84_wb_tmc <- select_tmcs(i84_inrix_tmc, "WESTBOUND")

# confidence interval distribution
conf_dist(i84_inrix_raw, i84_wb_tmc)
# not bad

# cvalue histo for when confidence = 30
cvalue_hist(i84_inrix_raw, i84_wb_tmc, 30)

# Calculate average hourly travel time for INRIX data
i84_wb_data <- select_data(i84_inrix_raw, i84_wb_tmc, 30, 75)
i84_wb_inrix_tt <- hourly_inrix_tt(i84_wb_data, 11)

# Read-in and format ODOT/PORTAL data
i84_wb_portal_data <- read.csv("data/portal/i84-53rd-holiday-portal.csv", stringsAsFactors = F)
i84_wb_portal_tt <- its_tt(i84_wb_portal_data)

# Create xts tibble for dygraph
i84_wb_tt <- its_inrix_xts("2019-02-03 00:00:00", "2019-03-03 00:00:00",
                           i84_wb_portal_tt, i84_wb_inrix_tt)
saveRDS(i84_wb_tt, "data/wb_i84_53rd_holiday_xts.rds")

# I-84 EB Holiday Ramp {Lloyd} to 53rd --------------------------------------------
# Filter and format EB INRIX data
i84_eb_tmc <- select_tmcs(i84_inrix_tmc, "EASTBOUND")

# Confidence interval dist
conf_dist(i84_inrix_raw, i84_eb_tmc)

# cvalue histo for when confidence = 30
cvalue_hist(i84_inrix_raw, i84_eb_tmc, 30)

# Calculate average hourly travel time for INRIX data
i84_eb_data <- select_data(i84_inrix_raw, i84_eb_tmc, 30, 75)
i84_eb_inrix_tt <- hourly_inrix_tt(i84_eb_data, 11)

# Read-in and format ODOT/PORTAL data
i84_eb_portal_data <- read.csv("data/portal/i84-holiday-53rd-poral.csv", stringsAsFactors = F)
i84_eb_portal_tt <- its_tt(i84_eb_portal_data)     

# Create xts tibble for dygraph
i84_eb_tt <- its_inrix_xts("2019-02-03 00:00:00", "2019-03-03 00:00:00",
                           i84_eb_portal_tt, i84_eb_inrix_tt)
saveRDS(i84_eb_tt, "data/eb_i84_holiday_53rd_xts.rds")
