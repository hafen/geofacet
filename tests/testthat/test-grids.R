context("grids")

library(ggplot2)

test_that("grids all load and work correctly", {
  for (grd in .valid_grids)
    expect_no_error(grid_preview(grd))
})
