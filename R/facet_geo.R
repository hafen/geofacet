
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

    tmp <- get_full_geo_data(e1$data, grd, facet_col)
    e1$data <- tmp$dat
    grd <- tmp$grd

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

  extra_rgx <- NULL

  if (attrs$move_axes) {
    scls <- attrs$scales
    if (is.null(scls))
      scls <- "same"
    if (!scls %in% c("free", "free_x")) {
      # do x-axis stuff
      nc <- max(grd$col)
      nr <- max(grd$row)
      for (ii in seq_len(nc)) {
        idx <- which(!is.na(grd$label[grd$col == ii]))
        l1 <- paste0("axis-b-", ii, "-", nr)
        if (length(idx) > 0) {
          last <- max(idx)
          l2 <- paste0("axis-b-", ii, "-", last)
          g$layout[g$layout$name == l1, c("t", "b")] <-
            g$layout[g$layout$name == l2, c("t", "b")]
        } else {
          extra_rgx <- c(extra_rgx, l1)
        }
      }
    }
    if (!scls %in% c("free", "free_y")) {
      # do y-axis stuff
      for (ii in seq_len(max(grd$row))) {
        idx <- which(!is.na(grd$label[grd$row == ii]))
        l1 <- paste0("axis-l-", ii, "-1")
        if (length(idx) > 0) {
          first <- min(idx)
          l2 <- paste0("axis-l-", ii, "-", first)
          g$layout[g$layout$name == l1, c("l", "r")] <-
            g$layout[g$layout$name == l2, c("l", "r")]
        } else {
          extra_rgx <- c(extra_rgx, l1)
        }
      }
    }
  }

  idx <- which(is.na(grd$label))
  tmp <- setdiff(g$layout$name, c(grd$strip[idx], grd$panel[idx], extra_rgx))
  rgx <- paste0("(^", paste(tmp, collapse = "$|^"), "$)")

  graphics::plot(gtable::gtable_filter(g, rgx, trim = FALSE))
}

#' Print geofaceted ggplot
#'
#' @param x a data frame containing a grid
#' @param name proposed name of the grid (if not supplied, will be asked for interactively)
#' @param desc a description of the grid (if not supplied, will be asked for interactively)
#' @details This opens up a github issue for this package in the web browser with pre-populated content for adding a grid to the package.
#' @importFrom utils write.csv browseURL URLencode
#' @examples
#' \dontrun{
#' my_grid <- us_state_grid1
#' my_grid$col[my_grid$label == "WI"] <- 7
#' submit_grid(my_grid, name = "us_grid_tweak_wi",
#'   desc = "Modified us_state_grid1 to move WI over")
#' }
#'
#'
#' @export
submit_grid <- function(x, name = NULL, desc = NULL) {
  x <- check_grid(x)
  message("The data for your proposed grid will be added ",
    "as an issue in this package's github reposotory.")
  message("After you answer a few questions below, the issue will open in your web browser ",
    "and after you make any desired edits, you need to click 'Submit new issue'.")
  message("If you do not have a github account, you will first be prompted to create one.")
  message("Your github username will be credited with the submission in the grid's docs.")

  if (is.null(name)) name <- readline("Proposed name of grid: ")
  if (is.null(desc)) desc <- readline("Description of grid: ")

  tc <- textConnection("foo", "w")
  utils::write.csv(x, tc, row.names = FALSE)
  dat_txt <- paste(textConnectionValue(tc), collapse = "\n")
  close(tc)

  body <- paste0(desc, "\n\n```\n", dat_txt, "\n```\n")

  url <- sprintf(
    "https://github.com/hafen/geofacet/issues/new?title=new grid: '%s'&body=%s",
    name,
    body
  )

  if (Sys.getenv("GEOFACET_PKG_TESTING") == "") browseURL(URLencode(url))
}

check_grid <- function(d) {
  if (! all(c("code", "row", "col", "name") %in% names(d)))
    stop("A custom grid must contain variables 'code', 'name', 'row', and 'col'", call. = FALSE)

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
  } else if (is.character(grid) && grid == "eu_grid1") {
    grd <- geofacet::eu_grid1
  } else if (is.character(grid) && grid == "aus_grid1") {
    grd <- geofacet::aus_grid1
  } else if (inherits(grid, "data.frame")) {
    grd <- check_grid(grid)
    message("You provided a user-specified grid. ",
      "If this is a generally-useful grid, please consider submitting it ",
      "to become a part of the geofacet package. You can do this easily by ",
      "calling:\nsubmit_grid(__grid_df_name__)")
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
  uldif1 <- setdiff(ul, grd$code)
  uldif2 <- setdiff(ul, grd$name)
  if (length(uldif1) < length(uldif2)) {
    uldif <- uldif1
    names(grd)[names(grd) == "code"] <- "label"
    grd$name <- NULL
  } else {
    uldif <- uldif2
    names(grd)[names(grd) == "name"] <- "label"
    grd$code <- NULL
  }

  if (length(uldif) == length(ul)) {
    stop("The values of the specified facet_geo column '", facet_col,
      "' do not match the 'code' column of the specified grid.", call. = FALSE)
  } else if (length(uldif) > 0) {
    message("Some values in the specified facet_geo column '", facet_col,
      "' do not match the 'code' column of the specified grid and will be removed: ",
      paste(uldif, collapse = ", "))
    d <- d[!d[[facet_col]] %in% uldif, ]
  }

  # create unique dummy levels (incrementing whitespace) for empty panels
  tmp <- grd$label
  idx <- which(is.na(tmp))
  tmp[idx] <- sapply(seq_along(idx), function(a) paste0(rep(" ", a), collapse = ""))

  d[[facet_col]] <- factor(d[[facet_col]], levels = tmp)

  # need to update grd to have the right column
  list(dat = d, grd = grd)
}
