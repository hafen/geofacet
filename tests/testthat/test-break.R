context("breaking")

library(ggplot2)

test_that("things break in an expected way", {

  testthat::skip_if_not_installed("rnaturalearthhires")

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

  expect_message({
    p <- ggplot(sa_pop_dens, aes(factor(year), density, fill = factor(year))) +
      geom_col() +
      facet_geo(~ code, grid = "sa_prov_grid1", label = "name_asdf") +
      labs(title = "South Africa population density by province",
        caption = "Data Source: Statistics SA Census",
        y = "Population density per square km") +
      theme_bw()
  },
  "will be ignored")

  my_grid <- us_state_grid1

  # make it overlap another state
  my_grid$col[my_grid$code == "WA"] <- 2
  expect_error({
    check_grid(my_grid)
  },
  "must have unique")

  my_grid$col[my_grid$code == "WA"] <- 0
  expect_error({
    check_grid(my_grid)
  },
  "must have positive")

  my_grid$col[my_grid$code == "WA"] <- 1
  my_grid$row[my_grid$code == "WA"] <- 0
  expect_error({
    check_grid(my_grid)
  },
  "must have positive")

  names(my_grid)[1] <- "asdf"
  expect_error({
    check_grid(my_grid)
  },
  "must contain variables 'row' and 'col'")

  names(my_grid)[1] <- "row"
  names(my_grid)[3] <- "cooode"
  expect_error({
    check_grid(my_grid)
  },
  "must begin with 'code' or 'name'")

  names(my_grid)[3] <- "code"
  expect_error({
    check_grid(my_grid[, 1:3])
  },
  "must have at least one column beginning with 'name'")

  expect_error({
    check_grid(my_grid[, c(1:2, 4)])
  },
  "must have at least one column beginning with 'code'")

  my_grid <- us_state_grid1
  my_grid[4, 2] <- NA
  expect_error({
    check_grid(my_grid)
  },
  "cannot have any missing values")

  expect_error({
    get_grid(list(1))
  },
  "grid not recognized...")
})
