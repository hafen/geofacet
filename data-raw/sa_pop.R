library(tibble)
library(tidyr)
library(ggplot2)
library(dplyr)

# https://en.wikipedia.org/wiki/List_of_South_African_provinces_by_population_density
sa_census_data <- tribble(~province,  ~"1996", ~"2001", ~"2011",
  "Gauteng",  432.0,  519.5,  675.1,
  "KwaZulu-Natal",  91.4, 102.3,  108.8,
  "Mpumalanga", 35.2, 39.3, 52.8,
  "Western Cape", 30.6, 35.0, 45.0,
  "Limpopo",  39.8, 42.6, 43.0,
  "Eastern Cape", 37.2, 38.0, 38.8,
  "North West", 28.8, 31.5, 33.5,
  "Free State", 20.3, 20.9, 21.1,
  "Northern Cape",  2.3,  2.3,  3.1)

sa_prov_grid1  <- readr::read_csv("code,row,col,name
WC,4,1,Western Cape
EC,4,2,Eastern Cape
NC,3,1,Northern Cape
GT,2,2,Gauteng
NL,3,3,KwaZulu-Natal
MP,2,3,Mpumalanga
LP,1,3,Limpopo
NW,2,1,North West
FS,3,2,Free State
")

sa_pop_dens <- sa_census_data %>%
  gather(year, density, 2:4) %>%
  mutate(year = as.integer(year)) %>%
  left_join(sa_prov_grid1, by = c("province" = "name")) %>%
  select(-row, -col) %>%
  data.frame()

devtools::use_data(sa_pop_dens, overwrite = TRUE)
