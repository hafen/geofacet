#' Generate a grid automatically from a country/continent name or a SpatialPolygonsDataFrame or `sf` polygons
#'
#' @param x A country/continent name, a SpatialPolygonsDataFrame or `sf` polygons to build a grid for.
#' @param names An optional vector of variable names in \code{x} to use as "name_" columns in the resulting grid.
#' @param codes An optional vector of variable names in \code{x} to use as "code_" columns in the resulting grid.
#' @param seed An optional random seed sent to \code{\link[geogrid]{calculate_grid}}.
#' @details If a country or continent name is specified for \code{x}, it can be any of the strings found in \code{\link{auto_countries}} or \code{\link{auto_states}}. In this case, the rnaturalearth package will be searched for the corresponding shapefiles. You can use \code{\link{get_ne_data}} to see what these shapefiles look like.
#'
#' The columns of the \code{} component of resulting shapefile (either user-specified or fetched from rnaturalearth) are those that will be available to \code{names} and \code{codes}.
#' @importFrom utils tail
#' @importFrom methods as
#' @importFrom geogrid calculate_grid assign_polygons
#' @importFrom sf st_as_sf st_coordinates
#' @export
#' @examples
#' \dontrun{
#' # auto grid using a name to identify the country
#' grd <- grid_auto("brazil", seed = 1234)
#' grid_preview(grd, label = "name")
#' # open the result up in the grid designer for further refinement
#' grid_design(grd, label = "name")
#'
#' # using a custom file (can be GeoJSON or shapefile)
#' ff <- system.file("extdata", "bay_counties.geojson", package = "geogrid")
#' bay_shp <- sf::st_read(ff)
#' grd <- grid_auto(bay_shp, seed = 1) # names are inferred
#' grid_preview(grd, label = "name_county")
#' grid_design(grd, label = "code_fipsstco")
#'
#' # explicitly specify the names and codes variables to use
#' grd <- grid_auto(bay_shp, seed = 1, names = "county", codes = "fipsstco")
#' grid_preview(grd, label = "name_county")
#' grid_preview(grd, label = "code_fipsstco")
#' }
grid_auto <- function(x, names = NULL, codes = NULL, seed = NULL) {
  # if(!requireNamespace("geogrid", quietly = TRUE)) {
  #   stop("Package 'geogrid' is needed for this function to work. Please install it.\n",
  #     "remotes::install_github(\"sassalley/geogrid\")",
  #   call. = FALSE)
  # }

  is_ne_data <- FALSE

  # if x is "sf" object, just use it
  if (is.character(x)) {
    if (length(x) > 1) {
      message("Just using first value: ", x[1])
      x <- x[1]
    }
    x <- get_ne_data(x)
    is_ne_data <- TRUE
  }
  if (inherits(x, "SpatialPolygonsDataFrame")) {
    x <- sf::st_as_sf(x)
  }
  if (!inherits(x, "sf")) {
    stop("x must be a country/continent name, an sf object, or a SpatialPolygonsDataFrame.")
  }
  # x@data$ID__gfct <- seq_len(nrow(x@data))

  new_cells <- geogrid::calculate_grid(shape = x, grid_type = "regular", seed = seed)

  # plot(new_cells[[2]])

  res <- suppressWarnings(geogrid::assign_polygons(x, new_cells))
  if (inherits(res, "SpatialPolygonsDataFrame")) {
    res <- sf::st_as_sf(res)
  }

  grd <- do.call(rbind, lapply(res$geometry, function(x) {
    tmp <- sf::st_coordinates(x)
    data.frame(x = min(tmp[, "X"]), y = min(tmp[, "Y"]))
  }))

  dx <- min(diff(sort(unique(grd$x))))
  dy <- min(diff(sort(unique(grd$y))))

  grd$xo <- as.integer( (grd$x - min(grd$x)) / dx + 1)
  grd$yo <- as.integer( (grd$y - min(grd$y)) / dy + 1)
  grd$yo <- max(grd$yo) - grd$yo + 1

  grd2 <- data.frame(
    row = grd$yo,
    col = grd$xo
  )

  if (any(duplicated(grd2)))
    stop("Automatic grid creation resulted in a grid with duplicate cell entries.\n",
      "Please try re-running grid_auto() with a different seed value.", call. = FALSE)

  if (is_ne_data) {
    grd2$name <- res$name
    grd2$code <- res$gns_adm1
  } else {
    idx <- which(sapply(res, function(a) length(unique(a)) == length(a)))
    if (length(idx) > 0) {
      prop_char <- sapply(idx, function(a) {
        tmp <- as.character(res[[a]])
        mean(1 - nchar(gsub("[A-Za-z]", "", tmp)) / nchar(tmp))
      })
      char_len <- sapply(idx, function(a) {
        mean(nchar(as.character(res[[a]])))
      })
      # for names, look at top 3 prop_char having at least 50% char
      # and of those, choose the one with longest char_len
      if (is.null(names)) {
        top3n <- utils::tail(sort(prop_char[prop_char > 0.5]), 3)
        if (length(top3n) > 0) {
          names <- names(top3n[which.max(char_len[names(top3n)])])
          message("Inferred that 'name' is in the column '", names, "'")
        }
      }
      # for codes, anything else unique is a code
      # unless it's numeric or has too many characters
      if (is.null(codes)) {
        codes <- setdiff(names(char_len[char_len <= 15]), c(names, "row", "col"))
        is_numeric <- which(sapply(idx, function(a) is.numeric(res[[a]])))
        has_decimal <- which(sapply(idx[is_numeric], function(a) any(res[[a]] %% 1 != 0)))
        codes <- setdiff(codes, names(has_decimal))
      }
    }
    if (is.null(names)) {
      stop("Could not infer the columns to use as 'name' entities.\n",
        "  Please re-run grid_auto supplying 'names = ...', with '...'\n",
        "  being a string or vector of strings of name variables found in\n",
        "  your input 'sf' object or the @data portion of your input\n",
        "  SpatialPolygonsDataFrame.")
    }
    if (is.null(codes)) {
      stop("Could not infer the columns to use as 'code' entities.\n",
        "  Please re-run grid_auto supplying 'names = ...', with '...'\n",
        "  being a string or vector of strings of code variables found in\n",
        "  your input 'sf' object or the @data portion of your input\n",
        "  SpatialPolygonsDataFrame.")
    }
    for (nm in names) {
      grd2[[paste0("name_", nm)]] <- res[[nm]]
      x[[paste0("name_", nm)]] <- x[[nm]]
    }
    for (cd in codes) {
      grd2[[paste0("code_", cd)]] <- res[[cd]]
      x[[paste0("code_", cd)]] <- x[[cd]]
    }
  }

  attr(grd2, "spdf") <- x
  class(grd2) <- c("geofacet_grid", "data.frame")

  grd2
}

#' Get rnaturalearth data
#'
#' @param code A country/continent name to get rnaturalearth data from (see \code{\link{auto_countries}} or \code{\link{auto_states}}).
#' @importFrom rnaturalearth ne_countries
#' @importFrom rnaturalearth ne_states
#' @export
#' @examples
#' \dontrun{
#' dat <- get_ne_data("brazil")
#' }
get_ne_data <- function(code) {
  code <- tolower(code)
  if (code %in% geofacet::auto_countries) {
    res <- rnaturalearth::ne_countries(continent = code)
  } else {
    pars <- list()
    if (code %in% geofacet::auto_states$country) {
      pars$country <- code
    } else if (code %in% geofacet::auto_states$geounit) {
      pars$geounit <- code
    } else if (code %in% geofacet::auto_states$iso_a2) {
      pars$iso_a2 <- code
    } else {
      message("code: ", code, " not recognized in Natural Earth data. ",
        "See auto_countries or auto_states for a list of acceptable codes.")
    }
    res <- do.call(rnaturalearth::ne_states, pars)
  }
  res
}

#' Attach an "sf" object to a grid
#'
#' @param x object to attach "sf" object to
#' @param spdf an "sf" object to attach
#' @export
attach_spdf <- function(x, spdf) {
  if (inherits(x, "SpatialPolygonsDataFrame")) {
    x <- sf::st_as_sf(x)
  }
  if (!inherits(spdf, "sf"))
    stop("spdf must be an sf object.")
  # TODO: try to link the data of x and spdf
  attr(x, "spdf") <- spdf
  x
}

#' @importFrom ggrepel geom_text_repel
#' @importFrom ggplot2 geom_sf coord_sf guides theme_void
plot_geo_raw <- function(x, label = "name") {
  if (is.character(x)) {
    if (length(x) > 1) {
      message("Just using first value: ", x[1])
      x <- x[1]
    }
    x <- get_ne_data(x)
  }

  tmp <- sf::st_centroid(x$geometry)
  x$xcentroid <- sapply(tmp, "[[", 1)
  x$ycentroid <- sapply(tmp, "[[", 2)

  x$label_col <- x[[label]]

  ggplot2::ggplot(x) +
    ggplot2::geom_sf(aes(geometry = geometry),
      fill = "lightgray", color = "white", linewidth = 0.3) +
    ggrepel::geom_text_repel(aes(xcentroid, ycentroid, label = label_col),
      data = x, min.segment.length = 0) +
    ggplot2::coord_sf() +
    ggplot2::guides(fill = "none") +
    ggplot2::theme_void()
}

# a <- geogrid::calculate_grid(shape = bay_shp, grid_type = "regular", seed = 12)
# plot(a)
# plot_geo_raw("afghanistan")
