context("examples")

library(ggplot2)

test_that("examples work", {

  # barchart of state rankings in various categories
  p <- ggplot(state_ranks, aes(variable, rank, fill = variable)) +
    geom_col() +
    coord_flip() +
    facet_geo(~ state) +
    theme_bw()
  print(p)

  # use an alternative US state grid and place
  p <- ggplot(state_ranks, aes(variable, rank, fill = variable)) +
    geom_col() +
    coord_flip() +
    facet_geo(~ state, grid = "us_state_grid2") +
    theme(panel.spacing = unit(0.1, "lines"))
  print(p)

  grid_preview(us_state_grid2)
  grid_preview(eu_grid1, use_code = FALSE)

  # custom grid (move Hawaii over more)
  my_grid <- us_state_grid2
  my_grid$col <- my_grid$col + 2
  my_grid$col[my_grid$code == "HI"] <- 1
  grid_preview(my_grid)

  # test to make sure we can have empty columns (since Hawaii is moved over)
  ggplot(state_ranks, aes(variable, rank, fill = variable)) +
    geom_col() +
    coord_flip() +
    facet_geo(~ state, grid = my_grid)

  # use a free x-axis (not a good idea but just to show it works)
  p <- ggplot(state_ranks, aes(variable, rank, fill = variable)) +
    geom_col() +
    coord_flip() +
    facet_geo(~ state, scales = "free_x") +
    theme_bw()
  print(p)

  # plot unemployment rate time series for each state
  p <- ggplot(state_unemp, aes(year, rate)) +
    geom_line() +
    facet_geo(~ state) +
    scale_x_continuous(labels = function(x) paste0("'", substr(x, 3, 4))) +
    ylab("Unemployment Rate (%)")
  print(p)

  # plot the 2016 unemployment rate
  p <- ggplot(subset(state_unemp, year == 2016), aes(factor(year), rate)) +
    geom_col(fill = "steelblue") +
    facet_geo(~ state) +
    theme(
      axis.title.x = element_blank(),
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank()) +
    ylab("Unemployment Rate (%)")
  print(p)

  # plot European Union GDP
  p <- ggplot(eu_gdp, aes(year, gdp_pc)) +
    geom_line(color = "steelblue") +
    geom_hline(yintercept = 100, linetype = 2) +
    facet_geo(~ name, grid = "eu_grid1") +
    scale_x_continuous(labels = function(x) paste0("'", substr(x, 3, 4))) +
    ylab("GDP Per Capita") +
    theme_bw()
  print(p)

  # use a free x-axis to look at just change
  p <- ggplot(eu_gdp, aes(year, gdp_pc)) +
    geom_line(color = "steelblue") +
    facet_geo(~ name, grid = "eu_grid1", scales = "free_y") +
    scale_x_continuous(labels = function(x) paste0("'", substr(x, 3, 4))) +
    ylab("GDP Per Capita In Relation to EU Index (100)") +
    theme_bw()
  print(p)

  # plot European Union annual # of resettled persons
  p <- ggplot(eu_imm, aes(year, persons)) +
    geom_line() +
    facet_geo(~ name, grid = "eu_grid1") +
    scale_x_continuous(labels = function(x) paste0("'", substr(x, 3, 4))) +
    scale_y_sqrt(minor_breaks = NULL) +
    ylab("# Resettled Persons") +
    theme_bw()
  print(p)

  # plot just for 2016
  p <- ggplot(subset(eu_imm, year == 2016), aes(factor(year), persons)) +
    geom_col(fill = "steelblue") +
    geom_text(aes(factor(year), 3000, label = persons), color = "gray") +
    facet_geo(~ name, grid = "eu_grid1") +
    theme(
      axis.title.x = element_blank(),
      axis.text.x = element_blank(),
      axis.ticks.x = element_blank()) +
    ylab("# Resettled Persons in 2016") +
    xlab("Year") +
    theme_bw()
  print(p)

  # plot Australian population
  p <- ggplot(aus_pop, aes(`Age Group`, Population / 1e6, fill = `Age Group`)) +
    geom_col() +
    facet_geo(~ code, grid = "aus_grid1") +
    coord_flip() +
    labs(
      title = "Australian Population Breakdown",
      caption = "Data Source: ABS Labour Force Survey, 12 month average",
      y = "Population [Millions]") +
    theme_bw()
  print(p)

  Sys.setenv(GEOFACET_PKG_TESTING = "TRUE")
  my_grid <- us_state_grid1
  my_grid$col[my_grid$code == "WI"] <- 7
  submit_grid(my_grid, name = "us_grid_tweak_wi",
    desc = "Modified us_state_grid1 to move WI over")
  Sys.setenv(GEOFACET_PKG_TESTING = "")
})
