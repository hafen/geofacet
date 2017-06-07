library(geofacet)
library(tidyverse)

### Get India Population by State/Union
# url <- "https://en.wikipedia.org/wiki/List_of_states_and_union_territories_of_India_by_population"

india_pop <- readr::read_csv("data-raw/India/wikipedia_data.csv")

india_pop <- india_pop %>%
  select(-decadal_growth_pct) %>%
  gather(pop_type, value, c(3:5)) %>%
  mutate(pop_type = as.character(forcats::fct_recode(pop_type,
    Total = "pop", Rural = "pop_rural", Urban = "pop_urban"))) %>%
  filter(pop_type != "Total")

use_data(india_pop, overwrite = TRUE)

ggplot(subset(india_pop, type == "state"),
  aes(pop_type, value / 1e6, fill = pop_type)) +
  geom_col() +
  facet_geo(~ name, grid = "india_grid1", label = "code") +
  labs(title = "Indian Population Breakdown",
       caption = "Data Source: Wikipedia",
       x = "",
       y = "Population [Millions]") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 40, hjust = 1))
