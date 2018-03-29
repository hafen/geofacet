context("auto")

test_that("auto examples work", {
  # auto grid using a name to identify the country
  grd <- grid_auto("brazil", seed = 1234)
  grid_preview(grd, label = "name")
  grd$name2 <- gsub(" ", "\n", grd$name)
  grid_preview(grd, label = "name2", label_raw = "name")
  # open the result up in the grid designer for further refinement
  grid_design(grd, label = "name")

  # using a custom file (can be GeoJSON or shapefile)
  ff <- system.file("extdata", "bay_counties.geojson", package = "geogrid")
  bay_shp <- geogrid::read_polygons(ff)
  grd <- grid_auto(bay_shp, seed = 1) # names are inferred
  grid_preview(grd, label = "name_county")
  grid_design(grd, label = "code_fipsstco")

  # explicitly specify the names and codes variables to use
  grd <- grid_auto(bay_shp, seed = 1, names = "county", codes = "fipsstco")
  grid_preview(grd, label = "name_county")
  grid_preview(grd, label = "code_fipsstco")
})
