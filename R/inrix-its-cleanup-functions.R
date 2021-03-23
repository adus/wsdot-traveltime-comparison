# Functions for cleaning and formatting INRIX data from RITIS, and ITS data from PORTAL

# Use TMC file generated from Massive Data Downloader
# Get list of TMC segments from selected corridor for a specific flow arranged in order going upstream
# flow_direction can be "NORTHBOUND", "SOUTHBOUND", "EASTBOUND", or "WESTBOUND"
select_tmcs <- function(inrix_tmc, flow_direction) {
  its_tmc %>%
    filter(direction == flow_direction) %>%
    arrange(start_latitude, start_longitude) %>%
    mutate(segment_order = 1:n()) %>%
    select(tmc, segment_order)
}

# Filter raw data to use from INRIX data based on selected tmcs, confidence score, and cvalue
select_data <- function(inrix_data,
                        tmcs,
                        conf_score,
                        c_value) {
  selected_data <-raw_data %>%
    filter(tmc_code %in% tmcs$tmc) %>%
    filter(confidence_score %in% conf_score) %>%
    filter(cvalue >= c_value)
}

# Plot confidence score of data filtered by flow
conf_dist <- function(inrix_data, tmcs) {
  raw_data %>%
    filter(tmc_code %in% tmcs$tmc) %>%
    ggplot(aes(x = tmc_code, fill = as.character(confidence_score))) +
    geom_bar(stat = "count")
}

# Plot cvalue histogram after selecting confidence score
cvalue_hist <- function(inrix_data, tmcs, conf_score) {
  raw_data %>%
    filter(tmc_code %in% tmcs$tmc,
           confidence_score %in% conf_score) %>%
    ggplot(aes(x = cvalue)) +
    geom_histogram(aes(y = ..count../sum(..count..))) +
    facet_wrap(. ~ tmc_code)
}

# Calculate hourly travel time using selected INRIX data using selected_data function from 02-select-data-function
hourly_inrix_tt <- function(select_inrix_data,
                            segment_length) {
  select_its_data %>%
    mutate(timestamp_hrly = floor_date(ymd_hms(measurement_tstamp), "hour")) %>%
    group_by(tmc_code, timestamp_hrly) %>%
    summarise(hourly_tt_sec = mean(travel_time_seconds)) %>%
    group_by(timestamp_hrly) %>%
    summarise(corridor_tt_min = sum(hourly_tt_sec)/60,
              num_segments = n()) %>%
    filter(num_segments == segment_length) %>%
    select(datetime = timestamp_hrly, traveltime = corridor_tt_min) %>%
    mutate(source = "INRIX")
}

# Format ITS data from PORTAL
its_tt <- function(raw_its_data) {
  raw_its_data %>%
    mutate(datetime = ymd_hms(time)) %>%
    select(datetime, traveltime = travel.time) %>%
    mutate(source = "ITS")
}

# Combine and convert ITS and INRIX data into xts format
its_inrix_xts <- function(from_date,
                          to_date,
                          its_tt,
                          inrix_tt) {
  data.frame(
    datetime = seq(
      from = as.POSIXct(from_date, tz = "America/Los_Angeles"),
      to = as.POSIXct(to_date, tz = "America/Los_Angeles"),
      by = "hour"
    )
  ) %>%
    left_join(its_tt, by = "datetime") %>%
    select(datetime, ITS = traveltime) %>%
    left_join(inrix_tt, by = "datetime") %>%
    select(datetime, ITS, INRIX = traveltime) %>%
    column_to_rownames(var = "datetime") %>%
    as.xts()
}