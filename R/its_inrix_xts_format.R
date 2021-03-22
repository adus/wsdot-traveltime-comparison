library(dplyr)
library(lubridate)
library(tibble)
library(tidyr)
library(xts)

# NB I5 Jantzen-Main segment ----
## Read-in INRIX and ITS data ----
nb_i5_jantzen_tt_inrix <- readRDS("data/nb_i5_jantzen_tt_inrix.rds")
nb_i5_jantzen_tt_its <- read.csv("data/portal/i5-jantzen-main-portal.csv", stringsAsFactors = F)

## Format ITS data ----
nb_i5_jantzen_tt_its$time <- ymd_hms(nb_i5_jantzen_tt_its$time)
nb_i5_jantzen_tt_its <- nb_i5_jantzen_tt_its %>%
  select(datetime = time, traveltime = travel.time) %>%
  mutate(source = "ITS")

## Create xts df for dygraph ----
nb_i5_jantzen_tt <- data.frame(
  datetime = seq(
    from = as.POSIXct("2019-02-03 00:00:00", tz = "America/Los_Angeles"),
    to = as.POSIXct("2019-03-03 00:00:00", tz = "America/Los_Angeles"),
    by = "hour"
  )
) %>%
  left_join(nb_i5_jantzen_tt_its, by = "datetime") %>%
  select(datetime, ITS = traveltime) %>%
  left_join(nb_i5_jantzen_tt_inrix, by = "datetime") %>%
  select(datetime, ITS, INRIX = traveltime)

nb_i5_jantzen_tt <- column_to_rownames(nb_i5_jantzen_tt, var = "datetime")

nb_i5_jantzen_tt_xts <- as.xts(nb_i5_jantzen_tt)

## Save xts tibble ----
saveRDS(nb_i5_jantzen_tt_xts, "data/nb_i5_jantzen_tt_xts.rds")

# NB I-205 Airport-Padden segment ----
## Read-in INRIX and ITS data ----
nb_i205_airport_tt_inrix <- readRDS("data/nb_i205_airport_tt_inrix.rds")
nb_i205_airport_tt_its <- read.csv("data/portal/i205-airport-padden-portal.csv", stringsAsFactors = F)

## Format ITS data ----
nb_i205_airport_tt_its$time <- ymd_hms(nb_i205_airport_tt_its$time)
nb_i205_airport_tt_its <- nb_i205_airport_tt_its %>%
  select(datetime = time, traveltime = travel.time) %>%
  mutate(source = "ITS")

## Create xts df for dygraph ----
nb_i205_airport_tt <- data.frame(
  datetime = seq(
    from = as.POSIXct("2019-02-03 00:00:00", tz = "America/Los_Angeles"),
    to = as.POSIXct("2019-03-03 00:00:00", tz = "America/Los_Angeles"),
    by = "hour"
  )
) %>%
  left_join(nb_i205_airport_tt_its, by = "datetime") %>%
  select(datetime, ITS = traveltime) %>%
  left_join(nb_i205_airport_tt_inrix, by = "datetime") %>%
  select(datetime, ITS, INRIX = traveltime)

nb_i205_airport_tt <- column_to_rownames(nb_i205_airport_tt, var = "datetime")

nb_i205_airport_tt_xts <- as.xts(nb_i205_airport_tt)

## Save xts tibble ----
saveRDS(nb_i205_airport_tt_xts, "data/nb_i205_airport_tt_xts.rds")

# SB I-205 Padden-Airport segment ----
## Read-in INRIX and ITS data ----
sb_i205_padden_tt_inrix <- readRDS("data/sb_i205_padden_tt_inrix.rds")
sb_i205_padden_tt_its <- read.csv("data/portal/i205-padden-airport-portal.csv", stringsAsFactors = F)

## Format ITS data ----
sb_i205_padden_tt_its$time <- ymd_hms(sb_i205_padden_tt_its$time)
sb_i205_padden_tt_its <- sb_i205_padden_tt_its %>%
  select(datetime = time, traveltime = travel.time) %>%
  mutate(source = "ITS")

## Create xts df for dygraph ----
sb_i205_padden_tt <- data.frame(
  datetime = seq(
    from = as.POSIXct("2019-02-03 00:00:00", tz = "America/Los_Angeles"),
    to = as.POSIXct("2019-03-03 00:00:00", tz = "America/Los_Angeles"),
    by = "hour"
  )
) %>%
  left_join(sb_i205_padden_tt_its, by = "datetime") %>%
  select(datetime, ITS = traveltime) %>%
  left_join(sb_i205_padden_tt_inrix, by = "datetime") %>%
  select(datetime, ITS, INRIX = traveltime)

sb_i205_padden_tt <- column_to_rownames(sb_i205_padden_tt, var = "datetime")

sb_i205_padden_tt_xts <- as.xts(sb_i205_padden_tt)

## Save xts tibble ----
saveRDS(sb_i205_padden_tt_xts, "data/sb_i205_padden_tt_xts.rds")
