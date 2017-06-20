#' Arrange a sequence of geographical panels into a grid that preserves some geographical orientation
#'
#' @param facets passed to \code{\link[ggplot2]{facet_wrap}}
#' @param \ldots additional parameters passed to \code{\link[ggplot2]{facet_wrap}}
#' @param grid character vector of the grid layout to use (currently only "us_state_grid1" and "us_state_grid2" are available)
#' @param label an optional string denoting the name of a column in \code{grid} to use for facet labels. If NULL, the variable that best matches that in the data specified with \code{facets} will be used for the facet labels.
#' @param move_axes should axis labels and ticks be moved to the closest panel along the margins?
#' @example man-roxygen/ex-facet_geo.R
#' @export
facet_geo <- function(facets, ..., grid = "us_state_grid1", label = NULL, move_axes = TRUE) {
  ret <- c(list(facets = facets, grid = grid, label = label, move_axes = move_axes), list(...))
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
      message_nice("Multiple facet columns specified... only using '", facet_col[1], "'")
      facet_col <- facet_col[1]
    }

    move_axes <- e2$move_axes
    e2$move_axes <- NULL

    grd <- get_full_geo_grid(e2$grid)
    e2$grid <- NULL

    label_col <- NULL
    if (!is.null(e2$label)) {
      if (e2$label %in% names(grd)) {
        label_col <- e2$label
      } else {
        message_nice("Note: the specified label = '", e2$label,
          "' does not exist in the supplied grid and it will be ignored.")
      }
    }
    e2$label <- NULL

    if (!is.null(e2$ncol))
      message_nice("replacing user-specified 'ncol'")
    if (!is.null(e2$nrow))
      message_nice("replacing user-specified 'nrow'")
    if (!is.null(e2$drop))
      message_nice("replacing user-specified 'drop'")

    e2$nrow <- max(grd$row)
    e2$ncol <- max(grd$col)
    e2$drop <- FALSE
    e2$facets <- "facet_col" # we will create a new column "facet_col"
    # this is done below in get_full_geo_data()

    tmp <- get_full_geo_data(e1$data, grd, facet_col, label_col)
    e1$data <- tmp$dat
    grd <- tmp$grd

    e1 <- e1 %+% do.call(ggplot2::facet_wrap, e2)
    attr(e1, "geofacet") <- list(grid = grd, move_axes = move_axes, scales = e2$scales)

    class(e1) <- c("facet_geo", class(e1))
    return(e1)
  }

  e1 %+% e2
}

#' Print geofaceted ggplot2 object
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

  # TODO: look into using extra grid space to draw cartographic map
  # https://github.com/baptiste/gridextra/wiki/gtable
  # https://stackoverflow.com/questions/30532889/ggplot-overlay-two-plots

  graphics::plot(gtable::gtable_filter(g, rgx, trim = FALSE))
}

#' Plot a preview of a grid
#'
#' @param x a data frame containing a grid
#' @param label the column should be used for text labels
#' @export
#' @importFrom ggplot2 ggplot geom_rect geom_text aes xlim ylim
#' @examples
#' grid_preview(us_state_grid2)
#' grid_preview(eu_grid1, label = "name")
grid_preview <- function(x, label = NULL) {
  x <- get_grid(x)

  x <- check_grid(x)
  x$col <- factor(x$col, levels = seq_len(max(x$col)))
  x$row <- factor(x$row, levels = rev(seq_len(max(x$row))))
  if (is.null(label)) {
    nms <- names(x)
    nm <- nms[grepl("^code", nms)][1]
    x$txt <- x[[nm]]
  } else {
    x$txt <- x[[label]]
  }

  ggplot2::ggplot(x, ggplot2::aes_string("col", "row", label = "txt")) +
    ggplot2::geom_rect(
      xmin = as.numeric(x$col) - 0.5, xmax = as.numeric(x$col) + 0.5,
      ymin = as.numeric(x$row) - 0.5, ymax = as.numeric(x$row) + 0.5,
      fill = "gray", color = "#e1e1e1", alpha = 0.7) +
    ggplot2::ylim(levels(x$row)) +
    ggplot2::xlim(levels(x$col)) +
    ggplot2::geom_text()
}

#' Interactively design a grid
#'
#' @param data a data frame containing a grid to start from or NULL if starting from scratch
#' @param img optional URL pointing to a reference image containing a geographic map of the entities in the grid
#' @export
#' @examples
#' # edit aus_grid1
#' grid_design(data = aus_grid1, img = "http://www.john.chapman.name/Austral4.gif")
#' # start with a clean slate
#' grid_design()
#' # arrange the alphabet
#' grid_design(data.frame(code = letters))
grid_design <- function(data = NULL, img = NULL) {

  if (!is.null(data)) {
    rows <- c(paste(names(data), collapse = ","),
      apply(data, 1, function(x) paste(x, collapse = ",")))
    data <- paste(rows, collapse = "\n")
  } else {
    data <- ""
  }

  if (is.null(img))
    img <- ""

  url <- sprintf("https://hafen.github.io/grid-designer/#img=%s&data=%s", img, data)

  if (Sys.getenv("GEOFACET_PKG_TESTING") == "") browseURL(URLencode(url))
}

#' Submit a grid to be included in the package
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
#' grid_submit(my_grid, name = "us_grid_tweak_wi",
#'   desc = "Modified us_state_grid1 to move WI over")
#' }
#' @export
grid_submit <- function(x, name = NULL, desc = NULL) {
  x <- check_grid(x)

  prompt_txt <- "The"
  if (is.null(name) || is.null(desc)) prompt_txt <- "After you answer a few questions below, the"

  message_nice(
    "The data for your proposed grid will be added ",
    "as an issue in this package's github reposotory. ",
    prompt_txt, " issue will open in your web browser ",
    "and after you make any desired edits, you need to click 'Submit new issue'.")
  message_nice(
    "If you do not have a github account, you will first be prompted to create one. ",
    "Your github username will be credited with the submission in the grid's docs.")

  if (is.null(name)) name <- readline("Proposed name of grid: ")
  if (is.null(desc)) desc <- readline("Description of grid: ")

  tc <- textConnection("foo", "w")
  utils::write.csv(x, tc, row.names = FALSE)
  dat_txt <- paste(textConnectionValue(tc), collapse = "\n")
  close(tc)

  body <- paste0(desc, "\n\n",
    "[[Note: To help streamline the process of adding this grid, ",
    "please replace this text with an image of a map for the region for reference. ",
    "Also, please check the ISO_3166-2 (https://en.wikipedia.org/wiki/ISO_3166-2) ",
    "codes if your grid uses countries or states/provinces. Finally, if you can ",
    "provide an example of your grid in action with a data set and sample code, ",
    "that would be great but is not required.]]",
    "\n\nGrid data:\n\n```\n", dat_txt, "\n```\n\n")

  url <- sprintf(
    "https://github.com/hafen/geofacet/issues/new?title=new grid: '%s'&body=%s",
    name,
    body
  )

  if (Sys.getenv("GEOFACET_PKG_TESTING") == "") browseURL(URLencode(url))
}

check_grid <- function(d) {
  nms <- names(d)
  if (! all(c("row", "col") %in% nms))
    stop("A custom grid must contain variables 'row' and 'col'", call. = FALSE)

  nms2 <- setdiff(nms, c("row", "col"))
  if (any(!grepl("^code|^name", nms2)))
    stop("Other than 'row' and 'col', variable names of a custom grid ",
      "must begin with 'code' or 'name'", call. = FALSE)

  if (length(which(grepl("^code", nms2))) == 0)
    stop("A custom grid must have at least one column beginning with 'code'", call. = FALSE)
  if (length(which(grepl("^name", nms2))) == 0)
    stop("A custom grid must have at least one column beginning with 'name'", call. = FALSE)

  d$row <- as.integer(d$row)
  d$col <- as.integer(d$col)

  if (anyNA(d, recursive = TRUE))
    stop("A custom grid cannot have any missing values", call. = FALSE)

  if (min(d$row) < 1)
    stop("A custom grid must have positive integer-valued 'row' values", call. = FALSE)

  if (min(d$col) < 1)
    stop("A custom grid must have positive integer-valued 'col' values", call. = FALSE)

  if (any(duplicated(d[, c("row", "col")])))
    stop("A custom grid must have unique row/column locations for each entry", call. = FALSE)

  d
}

#' Get a list of valid grid names
#' @export
get_grid_names <- function()
  .valid_grids

get_grid <- function(grid) {
  if (is.character(grid)) {
    if (grid %in% .valid_grids) {
      grd <- get(grid)
    } else {
      message("grid '", grid, "' not found in package, checking online...")
      url <- sprintf("https://raw.githubusercontent.com/hafen/grid-designer/master/grids/%s.csv",
        grid)
      grd <- suppressWarnings(try(utils::read.csv(url, stringsAsFactors = FALSE), silent = TRUE))
      if (inherits(grd, "try-error")) {
        stop("grid '", grid, "' not recognized...")
      }
    }
  } else if (inherits(grid, "data.frame")) {
    grd <- check_grid(grid)
    message_nice("You provided a user-specified grid. ",
      "If this is a generally-useful grid, please consider submitting it ",
      "to become a part of the geofacet package. You can do this easily by ",
      "calling:\ngrid_submit(__grid_df_name__)")
  } else {
    stop("grid not recognized...")
  }
  grd
}

#' @importFrom utils read.csv
get_full_geo_grid <- function(grid) {

  grd <- get_grid(grid)

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

get_full_geo_data <- function(d, grd, facet_col, label_col = NULL) {
  # check to make sure facet_col data matches that of grd
  ul <- unique(d[[facet_col]])
  set_nms <- c("row", "col", "row2", "col2", "panel", "strip")
  nms <- setdiff(names(grd), set_nms)
  uldifs <- lapply(nms, function(x) setdiff(ul, grd[[x]]))
  nn <- unlist(lapply(uldifs, length))
  match_idx <- which.min(nn)
  uldif <- uldifs[[match_idx]]
  grd$label <- grd[[nms[match_idx]]]
  if (is.null(label_col))
    label_col <- nms[match_idx]

  if (length(uldif) == length(ul)) {
    stop("The values of the specified facet_geo column '", facet_col,
      "' do not match any column of the specified grid.", call. = FALSE)
  } else if (length(uldif) > 0) {
    message_nice("Some values in the specified facet_geo column '", facet_col,
      "' do not match the '", nms[match_idx],
      "' column of the specified grid and will be removed: ",
      paste(uldif, collapse = ", "))
    d <- d[!d[[facet_col]] %in% uldif, ]
  }

  conv_idx <- match(d[[facet_col]], grd$label)
  d$facet_col <- grd[[label_col]][conv_idx]

  # create unique dummy levels (incrementing whitespace) for empty panels
  tmp <- grd[[label_col]]
  na_idx <- which(is.na(tmp))
  tmp[na_idx] <- sapply(seq_along(na_idx), function(a) paste0(rep(" ", a), collapse = ""))

  d$facet_col <- factor(d$facet_col, levels = tmp)

  # need to update grd to have the right column
  list(dat = d, grd = grd)
}
