#' Arrange a sequence of geographical panels into a grid that preserves some geographical orientation
#'
#' @param facets passed to \code{\link[ggplot2]{facet_wrap}}
#' @param \ldots additional parameters passed to \code{\link[ggplot2]{facet_wrap}}
#' @param grid either a character vector of the grid layout to use (see `?grids` for the list and use `get_grid()` to inspect or `grid_preview()` to plot a specific grid),
#' or a data.frame object containing a grid (e.g. an output from `grid_design()` or `grid_auto()`)
#' @param label an optional string denoting the name of a column in \code{grid} to use for facet labels. If NULL, the variable that best matches that in the data specified with \code{facets} will be used for the facet labels.
#' @param move_axes should axis labels and ticks be moved to the closest panel along the margins?
#' @example man-roxygen/ex-facet_geo.R
#' @export
facet_geo <- function(facets, ..., grid = "us_state_grid1", label = NULL, move_axes = TRUE) {
  ret <- c(list(facets = facets, grid = grid, label = label, move_axes = move_axes), list(...))
  class(ret) <- "facet_geo_spec"
  ret
}

#' @importFrom ggplot2 ggplot_add
#' @importFrom ggplot2 %+%
#' @export
ggplot_add.facet_geo_spec <- function(object, plot, object_name, ...) {
  facet_col <- setdiff(unlist(lapply(object$facets, as.character)), c("~", "+"))
  if (length(facet_col) > 1) {
    message_nice("Multiple facet columns specified... only using '", facet_col[1], "'")
    facet_col <- facet_col[1]
  }

  move_axes <- object$move_axes
  object$move_axes <- NULL

  grd <- get_full_geo_grid(object$grid)
  object$grid <- NULL

  label_col <- NULL
  if (!is.null(object$label)) {
    if (object$label %in% names(grd)) {
      label_col <- object$label
    } else {
      message_nice("Note: the specified label = '", object$label,
        "' does not exist in the supplied grid and it will be ignored.")
    }
  }
  object$label <- NULL

  if (!is.null(object$ncol))
    message_nice("replacing user-specified 'ncol'")
  if (!is.null(object$nrow))
    message_nice("replacing user-specified 'nrow'")
  if (!is.null(object$drop))
    message_nice("replacing user-specified 'drop'")

  object$nrow <- max(grd$row)
  object$ncol <- max(grd$col)
  object$drop <- FALSE
  object$facets <- "facet_col" # we will create a new column "facet_col"
  # this is done below in get_full_geo_data()

  # update the data to layers if specified independent of global data
  other_data <- lapply(plot$layers, function(x) x$data)

  tmp <- get_full_geo_data(plot$data, grd, facet_col, label_col, other_data)
  plot$data <- tmp$dat
  for (ii in seq_along(plot$layers))
    plot$layers[[ii]]$data <- tmp$other_data[[ii]]
  grd <- tmp$grd

  plot <- plot %+% do.call(ggplot2::facet_wrap, object)
  attr(plot, "geofacet") <- list(
    grid = grd,
    move_axes = move_axes,
    scales = object$scales
  )

  class(plot) <- c("facet_geo", class(plot))
  return(plot)
}

#' Perform post-processing on a facet_geo ggplot object
#'
#' @param x object of class 'facet_geo'
#' @export
get_geofacet_grob <- function(x) {
  if (!inherits(x, "facet_geo"))
    stop("'x' must be an object of class 'facet_geo'.",
      call. = FALSE)

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
        b1 <- paste0("axis-b-", ii, "-", nr)
        t1 <- paste0("axis-t-", ii, "-1")
        if (length(idx) > 0) {
          last <- max(idx)
          b2 <- paste0("axis-b-", ii, "-", last)
          g$layout[g$layout$name == b1, c("t", "b")] <-
            g$layout[g$layout$name == b2, c("t", "b")]
          first <- min(idx)
          t2 <- paste0("axis-t-", ii, "-", first)
          g$layout[g$layout$name == t1, c("t", "b")] <-
          g$layout[g$layout$name == t2, c("t", "b")]
        } else {
          extra_rgx <- c(extra_rgx, b1)
        }
      }
    }
    if (!scls %in% c("free", "free_y")) {
      # do y-axis stuff
      for (ii in seq_len(max(grd$row))) {
        idx <- which(!is.na(grd$label[grd$row == ii]))
        l1 <- paste0("axis-l-", ii, "-1")
        r1 <- paste0("axis-r-", ii, "-", max(grd$col))
        if (length(idx) > 0) {
          first <- min(idx)
          l2 <- paste0("axis-l-", ii, "-", first)
          g$layout[g$layout$name == l1, c("l", "r")] <-
            g$layout[g$layout$name == l2, c("l", "r")]
          last <- max(idx)
          r2 <- paste0("axis-r-", ii, "-", last)
          g$layout[g$layout$name == r1, c("l", "r")] <-
            g$layout[g$layout$name == r2, c("l", "r")]
        } else {
          extra_rgx <- c(extra_rgx, r1, l1)
        }
      }
    }
  }

  idx <- which(is.na(grd$label))
  tmp <- setdiff(g$layout$name, c(grd$strip[idx], grd$panel[idx], extra_rgx))
  # rgx <- paste0("(^", paste(tmp, collapse = "$|^"), "$)")

  # TODO: look into using extra grid space to draw cartographic map
  # https://github.com/baptiste/gridextra/wiki/gtable
  # https://stackoverflow.com/questions/30532889/ggplot-overlay-two-plots

  g <- gf_gtable_filter(g, tmp, trim = FALSE)
  # g <- gtable::gtable_filter(g, rgx, trim = FALSE)
  g
}

#' Print geofaceted ggplot2 object
#'
#' @param x plot object
#' @param newpage draw new (empty) page first?
#' @param vp viewport to draw plot in
#' @param ... other arguments not used by this method
#' @importFrom gtable gtable_filter
#' @importFrom graphics plot
#' @export
print.facet_geo <- function(x, newpage = is.null(vp), vp = NULL, ...) {
  if (newpage) grid::grid.newpage()

  g <- get_geofacet_grob(x)

  grid::grid.draw(g)
}

#' Plot geofaceted ggplot2 object
#'
#' @param x plot object
#' @param ... ignored
#' @importFrom gtable gtable_filter
#' @importFrom graphics plot
#' @export
plot.facet_geo <- function(x, ...) {
  print.facet_geo(x, ...)
}

#' Plot a preview of a grid
#'
#' @param x a data frame containing a grid
#' @param label the column name in \code{x} that should be used for text labels in the grid plot
#' @param label_raw the column name in the optional SpatialPolygonsDataFrame attached to \code{x} that should be used for text labels in the raw geography plot
#' @param do_plot should the grid preview be plotted?
#' @export
#' @importFrom ggplot2 ggplot geom_rect geom_text aes xlim ylim
#' @importFrom gridExtra grid.arrange
#' @importFrom rlang .data
#' @examples
#' grid_preview(us_state_grid2)
#' grid_preview(eu_grid1, label = "name")
grid_preview <- function(x, label = NULL, label_raw = NULL, do_plot = TRUE) {

  if (!inherits(x, "geofacet_grid"))
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

  p <- ggplot2::ggplot(x, ggplot2::aes(.data$col, .data$row, label = .data$txt)) +
    ggplot2::geom_rect(
      xmin = as.numeric(x$col) - 0.5, xmax = as.numeric(x$col) + 0.5,
      ymin = as.numeric(x$row) - 0.5, ymax = as.numeric(x$row) + 0.5,
      fill = "gray", color = "#e1e1e1", alpha = 0.7) +
    ggplot2::ylim(levels(x$row)) +
    ggplot2::xlim(levels(x$col)) +
    ggplot2::geom_text()

  spdf <- attr(x, "spdf")
  if (!is.null(spdf) && inherits(spdf, "SpatialPolygonsDataFrame")) {
    if (is.null(label_raw)) {
      if (label %in% names(spdf@data)) {
        label_raw <- label
      } else {
        stop("Couldn't find a variable with name '", label, "' ",
          "in the SpatialPolygonsDataFrame attached to the grid object. ",
          "Please explicity provide a variable name to use for plotting ",
          "This data using the argument label_raw.")
      }
    }

    p2 <- plot_geo_raw(spdf, label = label_raw)
    p <- gridExtra::grid.arrange(p2, p, nrow = 1)
  } else {
    if (do_plot)
      plot(p)
  }
  invisible(p)
}

#' Interactively design a grid
#'
#' @param data A data frame containing a grid to start from or NULL if starting from scratch.
#' @param img An optional URL pointing to a reference image containing a geographic map of the entities in the grid.
#' @param label An optional column name to use as the label for plotting the original geography, if attached to \code{data}.
#' @param auto_img If the original geography is attached to \code{data}, should a plot of that be created and uploaded to the viewer?
#' @export
#' @importFrom grDevices png dev.off
#' @examples
#' # edit aus_grid1
#' grid_design(data = aus_grid1, img = "http://www.john.chapman.name/Austral4.gif")
#' # start with a clean slate
#' grid_design()
#' # arrange the alphabet
#' grid_design(data.frame(code = letters))
grid_design <- function(data = NULL, img = NULL, label = "code", auto_img = TRUE) {
  if (!is.null(data)) {
    # clean out data
    for (vr in names(data)) {
      if (is.factor(data[[vr]]))
        data[[vr]] <- as.character(data[[vr]])
      if (is.character(data[[vr]])) {
        data[[vr]] <- gsub("\\\n", " ", data[[vr]])
        # other things to get rid of?
      }
    }

    rows <- c(paste(names(data), collapse = ","),
      apply(data, 1, function(x) paste(x, collapse = ",")))
    data_csv <- paste(rows, collapse = "\n")
    data_csv <- gsub("&", "%26", data_csv)
  } else {
    data_csv <- ""
  }

  spdf <- attr(data, "spdf")
  if (auto_img && is.null(img) && !is.null(spdf) &&
    inherits(spdf, "SpatialPolygonsDataFrame")) {

    message("Attempting to create and upload image of original geography...")

    p <- plot_geo_raw(spdf, label = label)
    grDevices::png(tmpfile <- tempfile(), res = 150, width = 1000, height = 1000)
    print(p)
    grDevices::dev.off()
    # system2("open", tmpfile)
    res <- upload_image(tmpfile)
    img <- res$link
  }

  if (is.null(img))
    img <- ""

  url <- sprintf("https://hafen.github.io/grid-designer/#img=%s&data=%s", img, data_csv)

  if (Sys.getenv("GEOFACET_PKG_TESTING") == "") browseURL(URLencode(url))
}

#' @importFrom httr2 request req_headers req_body_file req_perform resp_status
#'   resp_body_json
upload_image <- function(path) {
  req <- httr2::request("https://api.imgur.com/3/image") |>
    httr2::req_headers(Authorization = "Client-ID 1bb8a830d134946") |>
    httr2::req_body_file(path, type = "image/png")

  tryres <- try(resp <- httr2::req_perform(req))
  if (inherits(tryres, "try-error") || httr2::resp_status(resp) != 200) {
    warning("Failed to upload image to imgur. ", call. = FALSE)
    return("")
  }

  httr2::resp_body_json(resp)$data$link
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

  idx <- which(sapply(d, is.factor))
  for (ii in idx)
    d[[ii]] <- as.character(d[[ii]])

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
get_grid_names <- function() {
  message("Note: More grids are available by name as listed here: ",
    "https://raw.githubusercontent.com/hafen/grid-designer/master/grid_list.json")
  .valid_grids
}

get_grid <- function(grid) {
  if (is.character(grid)) {
    if (grid %in% .valid_grids) {
      grd <- get(grid)
    } else {
      message("grid '", grid, "' not found in package, checking online...")
      url <- sprintf("https://raw.githubusercontent.com/hafen/grid-designer/master/grids/%s.csv",
        grid)

      tmp <- suppressWarnings(try(
        utils::read.csv(url, stringsAsFactors = FALSE, nrows = 1),
        silent = TRUE))
      if (inherits(tmp, "try-error"))
        stop("grid '", grid, "' not recognized...")
      # all columns other than "row" and "col" will be strings (names and codes)
      cls <- ifelse(names(tmp) %in% c("row", "col"), "integer", "character")
      # use read.csv simply because it means one less dependency...
      grd <- utils::read.csv(url, colClasses = cls,
          stringsAsFactors = FALSE,
          na.strings = NULL) # grid cannot have NAs
    }
  } else if (inherits(grid, "data.frame")) {
    grd <- check_grid(grid)
    if (!inherits(grid, "geofacet_grid"))
      message_nice("Note: You provided a user-specified grid. ",
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

get_full_geo_data <- function(d, grd, facet_col, label_col = NULL, other_data) {
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

  for (ii in seq_along(other_data)) {
    if (!inherits(other_data[[ii]], "waiver") && facet_col %in% names(other_data[[ii]])) {
      conv_idx <- match(other_data[[ii]][[facet_col]], grd$label)
      other_data[[ii]]$facet_col <- grd[[label_col]][conv_idx]
      other_data[[ii]]$facet_col <- factor(other_data[[ii]]$facet_col, levels = tmp)
    }
  }

  d$facet_col <- factor(d$facet_col, levels = tmp)

  # need to update grd to have the right column
  list(dat = d, grd = grd, other_data = other_data)
}
