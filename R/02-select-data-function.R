# Filter raw data to use from INRIX data based on selected tmcs, confidence score, and cvalue
selected_data <- function(raw_data,
                          tmcs,
                          conf_score,
                          c_value) {
  selected_data <-raw_data %>%
    filter(tmc_code %in% tmcs$tmc) %>%
    filter(confidence_score %in% conf_score) %>%
    filter(cvalue >= c_value)
}