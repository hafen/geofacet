## source: http://lmip.gov.au/default.aspx?LMIP/Downloads/ABSLabourForceRegion
library(dplyr)

aus_pop <- readr::read_csv("https://gist.githubusercontent.com/jonocarroll/88b86cea90e798668dc25d43d0211180/raw/1c82f5c63371fe15a7b45697955207ea8ce918c8/SA4%2520Population%2520by%2520Age%2520Group%2520-%2520March%25202017.csv") %>%
  filter(`Region Name` != "Australia") %>%
  left_join(aus_grid1, by = c("Region Name" = "name")) %>%
  mutate(Population = as.integer(gsub(",", "", Population)))

use_data(aus_pop, overwrite = TRUE)
