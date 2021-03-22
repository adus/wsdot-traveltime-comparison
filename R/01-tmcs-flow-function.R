# Use TMC file generated from Massive Data Downloader
# Get list of TMC segments from selected corridor for a specific flow arranged in order going upstream

selected_tmcs <- function(raw_tmc, flow_direction) {
  raw_tmc %>%
    filter(direction == flow_direction) %>%
    arrange(start_latitude, start_longitude) %>%
    mutate(segment_order = 1:n()) %>%
    select(tmc, segment_order)
}