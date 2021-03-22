library(dplyr)
library(lubridate)
library(ggplot2)
# INIRX data clean-up

# I-5 NB Jantzen-Main ----
## Read-in data ----
i5_jantzen_raw <- read.csv("data/inrix/i5-jantzen-main-inrix.csv", stringsAsFactors = F)
i5_jantzen_tmc <- read.csv("data/inrix/i5-jantzen-main-tmc-id.csv", stringsAsFactors = F)

## Use tmc file to filter NB and order by `road_order` ----
nb_i5_jantzen_tmc <- i5_jantzen_tmc %>%
  filter(direction == "NORTHBOUND") %>%
  arrange(start_latitude, start_longitude) %>%
  mutate(segment_order = 1:n())

## Create tmc and road segment df ----
nb_i5_jantzen_route <- nb_i5_jantzen_tmc %>%
  select(tmc, segment_order)

## Filter raw data by nb tmc code ----
nb_i5_jantzen_raw <- i5_jantzen_raw %>%
  filter(tmc_code %in% nb_i5_jantzen_tmc$tmc)

### Plot confidence score by cvalue, fill by tmc_code ----
conf_dist <- nb_i5_jantzen_raw %>%
  ggplot(aes(x = tmc_code, fill = as.character(confidence_score))) +
  geom_bar(stat = "count")
conf_dist

## Filter raw data by nb tmc codes and confidence score = 30 ----
nb_i5_jantzen <- i5_jantzen_raw %>%
  filter(tmc_code %in% nb_i5_jantzen_tmc$tmc,
         confidence_score == 30)

### Histogram of cvalues ----
c_value_hist <- nb_i5_jantzen %>%
  ggplot(aes(x = cvalue)) +
  geom_histogram(aes(y = ..count../sum(..count..))) +
  facet_wrap(. ~ tmc_code)
c_value_hist

## Filter out c_values < 75 and NA's ----
nb_i5_jantzen <- nb_i5_jantzen %>%
  filter(cvalue > 75)

## Calculate hourly average tt per segment ----
nb_i5_jantzen_tt <- nb_i5_jantzen %>%
  mutate(timestamp_hrly = floor_date(ymd_hms(measurement_tstamp), "hour")) %>%
  group_by(tmc_code, timestamp_hrly) %>%
  summarise(hourly_tt_sec = mean(travel_time_seconds)) %>%
  group_by(timestamp_hrly) %>%
  summarise(corridor_tt_min = sum(hourly_tt_sec)/60,
            num_segments = n()) %>%
  filter(num_segments == 13) %>%
  select(datetime = timestamp_hrly, traveltime = corridor_tt_min) %>%
  mutate(source = "INRIX")

## Save hourly corridor traveltime df ----
saveRDS(nb_i5_jantzen_tt, "data/nb_i5_jantzen_tt_inrix.rds")

# I-205 NB Airport-Padden ----
## Read-in data ----
i205_airport_raw <- read.csv("data/inrix/i205-airport-padden-inrix.csv", stringsAsFactors = F)
i205_airport_tmc <- read.csv("data/inrix/i205-airport-padden-tmc-id.csv", stringsAsFactors = F)

## NB I205 TMC road order ----
nb_i205_airport_tmc <- i205_airport_tmc %>%
  filter(direction == "NORTHBOUND") %>%
  arrange(start_latitude, start_longitude) %>%
  mutate(segment_order = 1:n())

## Create tmc and road segment df ----
nb_i205_airport_route <- nb_i205_airport_tmc %>%
  select(tmc, segment_order)

## Filter raw data by nb tmc codes ----
nb_i205_airport_raw <- i205_airport_raw %>%
  filter(tmc_code %in% nb_i205_airport_tmc$tmc)

### Plot confidence score by cvalue, fill by tmc_code ----
conf_dist <- nb_i205_airport_raw %>%
  ggplot(aes(x = tmc_code, fill = as.character(confidence_score))) +
  geom_bar(stat = "count")
conf_dist

## Filter raw data by nb tmc codes, and Confidence score = 30 ----
nb_i205_airport <- i205_airport_raw %>%
  filter(tmc_code %in% nb_i205_airport_tmc$tmc,
         confidence_score == 30)

### Histogram of cvalues ----
c_value_hist <- nb_i205_airport %>%
  ggplot(aes(x = cvalue)) +
  geom_histogram(aes(y = ..count../sum(..count..))) +
  facet_wrap(. ~ tmc_code)
c_value_hist

## Filter out c_values < 75 and NA's ----
nb_i205_airport <- nb_i205_airport %>%
  filter(cvalue > 75)

## Calculate hourly average tt per segment ----
nb_i205_airport_tt <- nb_i205_airport %>%
  mutate(timestamp_hrly = floor_date(ymd_hms(measurement_tstamp), "hour")) %>%
  group_by(tmc_code, timestamp_hrly) %>%
  summarise(hourly_tt_sec = mean(travel_time_seconds)) %>%
  group_by(timestamp_hrly) %>%
  summarise(corridor_tt_min = sum(hourly_tt_sec)/60,
            num_segments = n()) %>%
  filter(num_segments == 11) %>%
  select(datetime = timestamp_hrly, traveltime = corridor_tt_min) %>%
  mutate(source = "INRIX")

## Save hourly corridor tt df ----
saveRDS(nb_i205_airport_tt, "data/nb_i205_airport_tt_inrix.rds")

# I-205 SB Padden-Airport ----
## Read-in data, if not already done in previously ----
# i205_airport_raw <- read.csv("data/inrix/i205-airport-padden-inrix.csv", stringsAsFactors = F)
# i205_airport_tmc <- read.csv("data/inrix/i205-airport-padden-tmc-id.csv", stringsAsFactors = F)

## NB I205 TMC road order ----
sb_i205_padden_tmc <- i205_airport_tmc %>%
  filter(direction == "SOUTHBOUND") %>%
  arrange(start_latitude, start_longitude) %>%
  mutate(segment_order = 1:n())

## Create tmc and road segment df ----
sb_i205_padden_route <- sb_i205_padden_tmc %>%
  select(tmc, segment_order)

## Filter raw data by sb tmc codes ----
sb_i205_padden_raw <- i205_airport_raw %>%
  filter(tmc_code %in% sb_i205_padden_tmc$tmc)

### Plot confidence score by cvalue, fill by tmc_code ----
conf_dist <- sb_i205_padden_raw %>%
  ggplot(aes(x = tmc_code, fill = as.character(confidence_score))) +
  geom_bar(stat = "count")
conf_dist

## Filter raw data by sb tmc codes, and Confidence score = 30 ----
sb_i205_padden <- i205_airport_raw %>%
  filter(tmc_code %in% sb_i205_padden_tmc$tmc,
         confidence_score == 30)

### Histogram of cvalues ----
c_value_hist <- sb_i205_padden %>%
  ggplot(aes(x = cvalue)) +
  geom_histogram(aes(y = ..count../sum(..count..))) +
  facet_wrap(. ~ tmc_code)
c_value_hist

## Filter out c_values < 75 and NA's ----
sb_i205_padden <- sb_i205_padden %>%
  filter(cvalue > 75)

## Calculate hourly average tt per segment ----
sb_i205_padden_tt <- sb_i205_padden %>%
  mutate(timestamp_hrly = floor_date(ymd_hms(measurement_tstamp), "hour")) %>%
  group_by(tmc_code, timestamp_hrly) %>%
  summarise(hourly_tt_sec = mean(travel_time_seconds)) %>%
  group_by(timestamp_hrly) %>%
  summarise(corridor_tt_min = sum(hourly_tt_sec)/60,
            num_segments = n()) %>%
  filter(num_segments == 11) %>%
  select(datetime = timestamp_hrly, traveltime = corridor_tt_min) %>%
  mutate(source = "INRIX")

## Save hourly corridor tt df ----
saveRDS(sb_i205_padden_tt, "data/sb_i205_padden_tt_inrix.rds")
