# https://gist.github.com/eldenvo/f98d1adee22e9987b0cc97c117a619db#file-london_boroughs_geofacet_example-r

library(tibble)
library(dplyr)

affordable <- tibble::tribble(
  ~year,            ~code,                       ~la,            ~starts,                 ~compls,
  "2016-17",  "E09000002",    "Barking and Dagenham",               185L,                      0L,
  "2016-17",  "E09000003",                  "Barnet",                99L,                      1L,
  "2016-17",  "E09000004",                  "Bexley",                34L,                     53L,
  "2016-17",  "E09000005",                   "Brent",                38L,                      3L,
  "2016-17",  "E09000006",                 "Bromley",                21L,                     43L,
  "2016-17",  "E09000007",                  "Camden",                 0L,                      0L,
  "2016-17",  "E09000001",          "City of London",                17L,                      0L,
  "2016-17",  "E09000008",                 "Croydon",               180L,                      2L,
  "2016-17",  "E09000009",                  "Ealing",               176L,                      0L,
  "2016-17",  "E09000010",                 "Enfield",                32L,                     13L,
  "2016-17",  "E09000011",               "Greenwich",                25L,                     44L,
  "2016-17",  "E09000012",                 "Hackney",                35L,                      0L,
  "2016-17",  "E09000013",  "Hammersmith and Fulham",                56L,                      6L,
  "2016-17",  "E09000014",                "Haringey",                 0L,                      0L,
  "2016-17",  "E09000015",                  "Harrow",                55L,                      0L,
  "2016-17",  "E09000016",                "Havering",                15L,                     14L,
  "2016-17",  "E09000017",              "Hillingdon",                 6L,                      7L,
  "2016-17",  "E09000018",                "Hounslow",                71L,                     76L,
  "2016-17",  "E09000019",               "Islington",               166L,                     15L,
  "2016-17",  "E09000020",  "Kensington and Chelsea",                 3L,                      2L,
  "2016-17",  "E09000021",    "Kingston upon Thames",                 0L,                     20L,
  "2016-17",  "E09000022",                 "Lambeth",                 1L,                      1L,
  "2016-17",  "E09000023",                "Lewisham",               138L,                     58L,
  "2016-17",  "E09000024",                  "Merton",                28L,                      2L,
  "2016-17",  "E09000025",                  "Newham",                 0L,                     72L,
  "2016-17",  "E09000026",               "Redbridge",                32L,                      0L,
  "2016-17",  "E09000027",    "Richmond upon Thames",                45L,                      8L,
  "2016-17",  "E09000028",               "Southwark",                90L,                      0L,
  "2016-17",  "E09000029",                  "Sutton",                 0L,                     26L,
  "2016-17",  "E09000030",           "Tower Hamlets",               142L,                     98L,
  "2016-17",  "E09000031",          "Waltham Forest",               126L,                     30L,
  "2016-17",  "E09000032",              "Wandsworth",                12L,                     23L,
  "2016-17",  "E09000033",             "Westminster",                39L,                      0L,
  "2015-16",  "E09000002",    "Barking and Dagenham",               202L,                    318L,
  "2015-16",  "E09000003",                  "Barnet",               376L,                    113L,
  "2015-16",  "E09000004",                  "Bexley",               190L,                    197L,
  "2015-16",  "E09000005",                   "Brent",                96L,                    202L,
  "2015-16",  "E09000006",                 "Bromley",               110L,                     86L,
  "2015-16",  "E09000007",                  "Camden",               195L,                    106L,
  "2015-16",  "E09000001",          "City of London",                 0L,                      0L,
  "2015-16",  "E09000008",                 "Croydon",               397L,                    263L,
  "2015-16",  "E09000009",                  "Ealing",               171L,                     94L,
  "2015-16",  "E09000010",                 "Enfield",               324L,                     59L,
  "2015-16",  "E09000011",               "Greenwich",               277L,                    614L,
  "2015-16",  "E09000012",                 "Hackney",                67L,                     63L,
  "2015-16",  "E09000013",  "Hammersmith and Fulham",                20L,                     86L,
  "2015-16",  "E09000014",                "Haringey",                66L,                      5L,
  "2015-16",  "E09000015",                  "Harrow",                98L,                     59L,
  "2015-16",  "E09000016",                "Havering",                22L,                     67L,
  "2015-16",  "E09000017",              "Hillingdon",                25L,                     95L,
  "2015-16",  "E09000018",                "Hounslow",               476L,                     79L,
  "2015-16",  "E09000019",               "Islington",               318L,                    181L,
  "2015-16",  "E09000020",  "Kensington and Chelsea",                33L,                    108L,
  "2015-16",  "E09000021",    "Kingston upon Thames",                35L,                     65L,
  "2015-16",  "E09000022",                 "Lambeth",               640L,                    238L,
  "2015-16",  "E09000023",                "Lewisham",               358L,                    169L,
  "2015-16",  "E09000024",                  "Merton",                80L,                     92L,
  "2015-16",  "E09000025",                  "Newham",               320L,                     53L,
  "2015-16",  "E09000026",               "Redbridge",               279L,                     33L,
  "2015-16",  "E09000027",    "Richmond upon Thames",               123L,                     88L,
  "2015-16",  "E09000028",               "Southwark",               393L,                    267L,
  "2015-16",  "E09000029",                  "Sutton",               110L,                     85L,
  "2015-16",  "E09000030",           "Tower Hamlets",               750L,                    295L,
  "2015-16",  "E09000031",          "Waltham Forest",               217L,                    229L,
  "2015-16",  "E09000032",              "Wandsworth",               489L,                    410L,
  "2015-16",  "E09000033",             "Westminster",                 5L,                      8L
)

#merge
london_afford <- left_join(affordable, london_boroughs_grid, by = c("code" = "code_ons"))

london_afford <- select(london_afford, -row, -col, -name, -la)

devtools::use_data(london_afford, overwrite = TRUE)

#plot
library(ggplot2)
ggplot(london_afford, aes(x = year, y = starts, fill = year)) +
  geom_col(position = position_dodge()) +
  facet_geo(~ code, grid = "london_boroughs_grid", label = "name") +
  labs(title = "Affordable Housing Starts in London",
    subtitle = "Each Borough, 2015-16 to 2016-17",
    caption = "Source: London Datastore", x = "", y = "")
