# Plot confidence score of data filtered by flow

conf_dist <- function(raw_data, tmcs) {
  raw_data %>%
    filter(tmc_code %in% tmcs$tmc) %>%
    ggplot(aes(x = tmc_code, fill = as.character(confidence_score))) +
    geom_bar(stat = "count")
}