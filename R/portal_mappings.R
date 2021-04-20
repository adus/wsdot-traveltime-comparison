library(dplyr)

station_metadata <- read.csv("data/portal/station_metadata.csv", stringsAsFactors = F)

select_highways <- station_metadata %>%
  filter(highwayid %in% c(1, 2, 3, 4, 7, 8, 50, 51, 54, 55, 501, 502))

select_stations <- select_highways %>%
  filter(highwayid == 1 & milepost >= 307.90 |
           highwayid == 2 & milepost >= 307.90 |
           highwayid == 3 & milepost >= 24.92 |
           highwayid == 4 & milepost >= 24.77 |
           highwayid == 7 & milepost >= 1.21 & milepost <= 3.36 |
           highwayid == 8 & milepost >= 1.21 & milepost <= 3.36 |
           highwayid == 50 & milepost >= 1.93 & milepost <= 5.59 |
           highwayid == 51 & milepost >= 1.93 & milepost <= 5.59 |
           highwayid == 54 & milepost >= 28.36 & milepost <= 32.90 |
           highwayid == 55 & milepost >= 27.26 & milepost <= 32.90 |
           highwayid == 501 & milepost >= 0.45 & milepost <= 3.10 |
           highwayid == 502 & milepost >= 0.45 & milepost <= 3.10
  )

select_stations %>%
  leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addCircleMarkers(
    lat = ~y_coord,
    lng = ~x_coord,
    # color = ~pal(on_time_rating),
    stroke = F,
    fillOpacity = 0.5,
    radius = 5,
    popup = paste("Location:", select_stations$locationtext, "<br>",
                  "Station ID:", select_stations$stationid, "<br>",
                  "Mile Post:", select_stations$milepost)
  )

saveRDS(select_stations, "data/select_stations.rds")
