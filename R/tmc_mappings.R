library(leaflet)
library(dplyr)
library(sf)

oregon_tmc <- st_read("/home/leetam/Share/GIS/Oregon-TMC/OREGON/OREGON.shp")
wash_tmc <- st_read("/home/leetam/Share/GIS/Washington-TMC/Washington.shp")

region1 <- oregon_tmc %>%
  select(Tmc, FirstName, State, Direction,
         StartLat, StartLong, EndLat, EndLong,
         Miles, geometry)

sw_wash <- wash_tmc %>%
  select(Tmc, FirstName, State, Direction,
         StartLat, StartLong, EndLat, EndLong,
         Miles, geometry)

sw_wash$Direction <- case_when(sw_wash$Direction == "N" ~ "Northbound",
                               sw_wash$Direction == "S" ~ "Southbound",
                               sw_wash$Direction == "W" ~ "Westbound",
                               sw_wash$Direction == "E" ~ "Eastbound")

#### i84 ####
tmc_84 <- readLines("data/tmc/TMC-I84-Holiday-53rd")
tmc_84 <- as.data.frame(unlist(stringr::str_split(tmc_84, pattern = ",")))
colnames(tmc_84) <- c("Tmc")

# tmc1 <- purrr::map(tmc1, function(x) {
#   tibble(text = unlist(stringr::str_split(x, pattern = ",")))
# })

i84 <- region1 %>%
  filter(Tmc %in% tmc_84$Tmc) %>%
  mutate(segment = "i84")

line_pal <- colorFactor(c("#B983FF", "#00BCD8", "#A3A500", "#F8766D"),
                        domain = c("Eastbound", "Westbound", "Northbound", "Southbound"))

i84 %>%
  leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolylines(color = ~line_pal(as.factor(Direction)),
               opacity = 1,
               popup = paste("Segment Name:", i84$FirstName, "<br>",
                             "TMC ID:", i84$Tmc, "<br>",
                             "Direction:", i84$Direction))


#### i5 cross ####
tmc_i5 <- readLines("data/tmc/TMC-I5-Main-Jantzen")
tmc_i5 <- as.data.frame(unlist(stringr::str_split(tmc_i5, pattern = ",")))
colnames(tmc_i5) <- c("Tmc")

or_i5 <- region1 %>%
  filter(Tmc %in% tmc_i5$Tmc)
wa_i5 <- sw_wash %>%
  filter(Tmc %in% tmc_i5$Tmc)

i5_bridge <- bind_rows(or_i5, wa_i5) %>%
  mutate(segment = "i5_bridge")

i5_bridge %>%
  leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolylines(color = ~line_pal(as.factor(Direction)),
               opacity = 1,
               popup = paste("Segment Name:", i5_bridge$FirstName, "<br>",
                             "TMC ID:", i5_bridge$Tmc, "<br>",
                             "Direction:", i5_bridge$Direction))
str(i5_bridge)
saveRDS(i5_bridge, "data/i5_bridge.rds")

#### i205 cross ####
tmc_i205 <- readLines("data/tmc/TMC-I205-Airport-Padden")
tmc_i205 <- as.data.frame(unlist(stringr::str_split(tmc_i205, pattern = ",")))
colnames(tmc_i205) <- c("Tmc")
tmc_i205 <- tmc_i205 %>%
  mutate(segment = "i205_bridge")

or_i205 <- region1%>%
  filter(Tmc %in% tmc_i205$Tmc)
wa_i205 <- sw_wash %>%
  filter(Tmc %in% tmc_i205$Tmc)

i205_bridge <- bind_rows(or_i205, wa_i205) %>%
  mutate(segment = "i205_bridge")

#### sr14 ####
tmc_sr14 <- readLines("data/tmc/TMC-SR14-MP1.93-Ellsworth")
tmc_sr14 <- as.data.frame(unlist(stringr::str_split(tmc_sr14, pattern = ",")))
colnames(tmc_sr14) <- c("Tmc")
tmc_sr14 <- tmc_sr14 %>%
  mutate(segment = "sr14")

sr14 <- sw_wash %>%
  filter(Tmc %in% tmc_sr14$Tmc) %>%
  mutate(segment = "sr14")


#### all segments ####
tt_segments <- bind_rows(sr14, i205_bridge, i5_bridge, i84)
saveRDS(tt_segments, "data/tt_segments.rds")


tt_test %>%
  filter(segment == "sr14") %>%
  leaflet() %>%
  addProviderTiles(providers$CartoDB.Positron) %>%
  addPolylines(color = ~line_pal(as.factor(Direction)),
               opacity = 1,
               popup = paste("Segment Name:", tt_segments$FirstName, "<br>",
                             "TMC ID:", tt_segments$Tmc, "<br>",
                             "Direction:", tt_segments$Direction))
