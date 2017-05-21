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

  # custom grid (move Wisconsin above Michigan)
  my_grid <- us_state_grid1
  my_grid$col[my_grid$label == "WI"] <- 7

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
})
