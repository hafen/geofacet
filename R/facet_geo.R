
#' Arrange a sequence of geographical panels into a grid that preserves some geographical orientation
#'
#' @param facets passed to \code{\link[ggplot2]{facet_wrap}}
#' @param \ldots additional parameters passed to \code{\link[ggplot2]{facet_wrap}}
#' @param grid character vector of the grid layout to use (currently only "us_state_grid1" and "us_state_grid2" are available)
#' @param move_axes should axis labels and ticks be moved to the closest panel along the margins?
#' @example man-roxygen/ex-facet_geo.R
#' @export
facet_geo <- function(facets, ..., grid = "us_state_grid1", move_axes = TRUE) {
  ret <- c(list(facets = facets, grid = grid, move_axes = move_axes), list(...))
  class(ret) <- "facet_geo_spec"
  ret
}

#' Add method for gg / facet_geo
#'
#' @param e1 a object with class gg
#' @param e2 if object is of class 'facet_geo', then 'facet_geo' will be appended to the class of e1
#' @export
#' @importFrom ggplot2 %+% facet_wrap
`+.gg` <- function (e1, e2) {
  if (inherits(e2, "facet_geo_spec")) {
    facet_col <- setdiff(unlist(lapply(e2$facets, as.character)), c("~", "+"))
    if (length(facet_col) > 1) {
      message("Multiple facet columns specified... only using '", facet_col[1], "'")
      facet_col <- facet_col[1]
    }

    move_axes <- e2$move_axes
    e2$move_axes <- NULL

    grd <- get_full_geo_grid(e2$grid)
    e2$grid <- NULL

    if (!is.null(e2$ncol))
      message("replacing user-specified 'ncol'")
    if (!is.null(e2$nrow))
      message("replacing user-specified 'nrow'")
    if (!is.null(e2$drop))
      message("replacing user-specified 'drop'")

    e2$nrow <- max(grd$row)
    e2$ncol <- max(grd$col)
    e2$drop <- FALSE
    e2$facets <- facet_col

    e1$data <- get_full_geo_data(e1$data, grd, facet_col)

    e1 <- e1 %+% do.call(ggplot2::facet_wrap, e2)
    attr(e1, "geofacet") <- list(grid = grd, move_axes = move_axes, scales = e2$scales)

    class(e1) <- c("facet_geo", class(e1))
    return(e1)
  }

  e1 %+% e2
}

#' Print geofaceted ggplot
#'
#' @param x plot object
#' @param ... ignored
#' @importFrom gtable gtable_filter
#' @importFrom graphics plot
#' @export
print.facet_geo <- function(x, ...) {
  attrs <- attr(x, "geofacet")
  grd <- attrs$grid

  g <- ggplot2::ggplotGrob(x)

  idx <- which(is.na(grd$label))
  tmp <- setdiff(g$layout$name, c(grd$strip[idx], grd$panel[idx]))
  rgx <- paste0("(^", paste(tmp, collapse = "$|^"), "$)")

  if (attrs$move_axes) {
    scls <- attrs$scales
    if (is.null(scls))
      scls <- "same"
    if (!scls %in% c("free", "free_x")) {
      # do x-axis stuff
      nc <- max(grd$col)
      nr <- max(grd$row)
      for (ii in seq_len(nc)) {
        last <- max(which(!is.na(grd$label[grd$col == ii])))
        l1 <- paste0("axis-b-", ii, "-", nr)
        l2 <- paste0("axis-b-", ii, "-", last)
        g$layout[g$layout$name == l1, c("t", "b")] <-
          g$layout[g$layout$name == l2, c("t", "b")]
      }
    }
    if (!scls %in% c("free", "free_y")) {
      # do y-axis stuff
      for (ii in seq_len(max(grd$row))) {
        first <- min(which(!is.na(grd$label[grd$row == ii])))
        l1 <- paste0("axis-l-", ii, "-1")
        l2 <- paste0("axis-l-", ii, "-", first)
        g$layout[g$layout$name == l1, c("l", "r")] <-
          g$layout[g$layout$name == l2, c("l", "r")]
      }
    }
  }

  graphics::plot(gtable::gtable_filter(g, rgx, trim = FALSE))
}

check_grid <- function(d) {
  if (! all(c("label", "row", "col") %in% names(d)))
    stop("A custom grid must contain variables 'label', 'row', and 'col'", call. = FALSE)

  d$row <- as.integer(d$row)
  d$col <- as.integer(d$col)

  if (min(d$row) < 1)
    stop("A custom grid must have positive integer-valued 'row' values", call. = FALSE)

  if (min(d$col) < 1)
    stop("A custom grid must have positive integer-valued 'col' values", call. = FALSE)

  if (any(duplicated(d[, c("row", "col")])))
    stop("A custom grid must have unique row/column locations for each entry", call. = FALSE)

  d
}

get_full_geo_grid <- function(grid) {

  if (is.character(grid) && grid == "us_state_grid1") {
    grd <- geofacet::us_state_grid1
  } else if (is.character(grid) && grid == "us_state_grid2") {
    grd <- geofacet::us_state_grid2
  } else if (inherits(grid, "data.frame")) {
    grd <- check_grid(grid)
  } else {
    stop("grid '", grid, "' not recognized...")
  }
  ## TODO: allow support of 'grid' being a data frame and add other defaults

  nr <- max(grd$row)
  nc <- max(grd$col)
  gd <- expand.grid(col = seq_len(nc), row = seq_len(nr))

  grd <- merge(grd, gd, all.y = TRUE)
  grd <- grd[order(grd$row, grd$col), ]

  grd$col2 <- as.vector(t(matrix(grd$col, nrow = nr)))
  grd$row2 <- as.vector(t(matrix(grd$row, nrow = nr)))
  grd$panel <- paste0("panel-", grd$col2, "-", grd$row2)
  grd$strip <- paste0("strip-t-", grd$col, "-", grd$row)

  grd
}

get_full_geo_data <- function(d, grd, facet_col) {
  # check to make sure facet_col data matches that of grd
  ul <- unique(d[[facet_col]])
  uldif <- setdiff(ul, grd$label)
  if (length(uldif) == length(ul)) {
    stop("The values of the specified facet_geo column '", facet_col,
      "' do not match the label column of the specified grid.", call. = FALSE)
  } else if (length(uldif) > 0) {
    message("Some values in the specified facet_geo column '", facet_col,
      "' do not match the label column of the specified grid and will be removed: ",
      paste(uldif, collapse = ", "))
    d <- d[!d[[facet_col]] %in% uldif, ]
  }

  # create unique dummy levels (incrementing whitespace) for empty panels
  tmp <- grd$label
  idx <- which(is.na(tmp))
  tmp[idx] <- sapply(seq_along(idx), function(a) paste0(rep(" ", a), collapse = ""))

  d[[facet_col]] <- factor(d[[facet_col]], levels = tmp)
  d
}
