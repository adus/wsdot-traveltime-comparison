# Calculate hourly travel time using selected INRIX data using selected_data function from 02-select-data-function
hourly_tt <- function(data_selected,
                      segment_length) {
  data_selected %>%
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