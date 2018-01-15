## for admin 1 (states within a country)

spdf <- rnaturalearthhires::states10

auto_states <- data.frame(
  country = tolower(spdf$admin),
  geounit = tolower(spdf$geonunit),
  iso_a2 = tolower(spdf$iso_a2),
  stringsAsFactors = FALSE
)

length(unique(auto_states$country))
length(unique(auto_states$geounit))
length(unique(auto_states$iso_a2))

auto_states <- auto_states[!duplicated(auto_states$country),]
rownames(auto_states) <- NULL

auto_states$iso_a2[auto_states$iso_a2 == "-1"] <- NA

devtools::use_data(auto_states, overwrite = TRUE)

## for admin 0 (countries within a continent)

spdf <- rnaturalearth:::get_data(scale = 110, type = "countries")
names(spdf) <- tolower(names(spdf))

auto_countries <- sort(unique(tolower(spdf$continent)))

devtools::use_data(auto_countries, overwrite = TRUE)

# make sure there are no intersections
idx <- which(auto_states$country != auto_states$geounit)
intersect(auto_states$country[idx], auto_states$geounit[idx])
intersect(auto_states$country, auto_states$iso_a2)
intersect(auto_states$geounit, auto_states$iso_a2)
intersect(auto_states$country, auto_countries)

ne_states("antarctica")@data
ne_countries(continent = "antarctica")@data

# auto_countries <- data.frame(
#   continent = tolower(spdf$continent),
#   country = tolower(spdf$admin),
#   geounit = tolower(spdf$geounit),
#   sovereignty = tolower(spdf$sovereignt),
#   stringsAsFactors = FALSE
# )

# length(unique(auto_countries$continent))
# length(unique(auto_countries$country))
# length(unique(auto_countries$geounit))
# length(unique(auto_countries$sovereignty))

