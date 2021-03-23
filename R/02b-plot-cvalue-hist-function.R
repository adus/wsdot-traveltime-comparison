# Plot cvalue histogram after selecting confidence score

cvalue_hist <- function(raw_data, tmcs, conf_score) {
  raw_data %>%
    filter(tmc_code %in% tmcs$tmc,
           confidence_score %in% conf_score) %>%
    ggplot(aes(x = cvalue)) +
    geom_histogram(aes(y = ..count../sum(..count..))) +
    facet_wrap(. ~ tmc_code)
}