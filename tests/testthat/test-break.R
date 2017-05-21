context("breaking")

library(ggplot2)

test_that("things break in an expected way", {

  expect_error({
    ggplot(iris, aes(Sepal.Length, Petal.Length)) +
        geom_point() +
        facet_geo(~ Species)
  },
  "do not match")

  # works with only a subset of states
  tmp <- subset(state_ranks, state %in% c("WA", "OR", "CA"))
  p <- ggplot(tmp, aes(variable, rank, fill = variable)) +
    geom_col() +
    coord_flip() +
    facet_geo(~ state) +
    theme_bw()
  print(p)

  tmp <- state_ranks
  tmp$state[tmp$state == "WA"] <- "AW"
  expect_message({
    ggplot(tmp, aes(variable, rank, fill = variable)) +
      geom_col() +
      coord_flip() +
      facet_geo(~ state) +
      theme_bw()
  },
  "will be removed")

  # bad grid...
  expect_error({
    ggplot(tmp, aes(variable, rank, fill = variable)) +
      geom_col() +
      coord_flip() +
      facet_geo(~ state, grid = "asdf") +
      theme_bw()
  },
  "not recognized")

  expect_message({
    ggplot(tmp, aes(variable, rank, fill = variable)) +
      geom_col() +
      coord_flip() +
      facet_geo(~ state + stuff) +
      theme_bw()
  },
  "Multiple facet columns")

  my_grid <- us_state_grid1

  # make it overlap another state
  my_grid$col[my_grid$label == "WA"] <- 2
  expect_error({
    ggplot(state_ranks, aes(variable, rank, fill = variable)) +
      geom_col() +
      coord_flip() +
      facet_geo(~ state, grid = my_grid)
  },
  "must have unique")

  my_grid$col[my_grid$label == "WA"] <- 0
  expect_error({
    ggplot(state_ranks, aes(variable, rank, fill = variable)) +
      geom_col() +
      coord_flip() +
      facet_geo(~ state, grid = my_grid)
  },
  "must have positive")

  my_grid$col[my_grid$label == "WA"] <- 1
  my_grid$row[my_grid$label == "WA"] <- 0
  expect_error({
    ggplot(state_ranks, aes(variable, rank, fill = variable)) +
      geom_col() +
      coord_flip() +
      facet_geo(~ state, grid = my_grid)
  },
  "must have positive")

  names(my_grid)[1] <- "asdf"
  expect_error({
    ggplot(state_ranks, aes(variable, rank, fill = variable)) +
      geom_col() +
      coord_flip() +
      facet_geo(~ state, grid = my_grid)
  },
  "must contain variable")
})
