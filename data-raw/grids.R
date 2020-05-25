url <- "https://raw.githubusercontent.com/hafen/grid-designer/master/grid_list.json"
grid_list <- jsonlite::fromJSON(url)

## read in any that haven't been stored in package yet
##---------------------------------------------------------

# get list of new ones to read in
nms <- setdiff(grid_list$name, gsub("\\.rda", "", list.files("data")))
# setdiff(gsub("\\.rda", "", list.files("data")), grid_list$name)

# nms <- grid_list$name # to re-read all grids

# make sure all have a ref image
sort(nchar(grid_list$ref_img))

lapply(nms, function(x) {
  message(x)
  url <- sprintf("https://raw.githubusercontent.com/hafen/grid-designer/master/grids/%s.csv", x)
  # tmp <- utils::read.csv(url, stringsAsFactors = FALSE, nrows = 1)
  # # all columns other than "row" and "col" will be strings (names and codes)
  # cls <- ifelse(names(tmp) %in% c("row", "col"), "integer", "character")
  # # use read.csv simply because it means one less dependency...
  # res <- utils::read.csv(url, colClasses = cls, stringsAsFactors = FALSE, na.strings = NULL)
  res <- data.frame(readr::read_csv(url, na = ""))
  assign(x, res)
  eval(parse(text = sprintf("usethis::use_data(%s, overwrite = TRUE)", x)))
})

## make sure grids are good
##---------------------------------------------------------

# load_all()
nms <- grid_list$name # to re-read all grids
for (nm in nms)
  check_grid(get(nm, "package:geofacet"))

## update documentation - generate R/grid_docs.R
##---------------------------------------------------------

doc_string <- paste0("#' Geo Grids
#'
#' @name grids
#' @docType data
#' @keywords data
#' @description ",
  "There are now ", nrow(grid_list), " grids available in this package and more online. ",
  "To view a full list of available grids, see ",
  "[here](https://raw.githubusercontent.com/hafen/grid-designer/master/grid_list.json). ",
  "To create and submit your own grid, see ",
  "[here](https://hafen.github.io/grid-designer/). ",
  "To see several examples of grids being used to visualize data, see \\code{\\link{facet_geo}}.
#' @rdname grids
#' @md
NULL
")

for (ii in seq_len(nrow(grid_list))) {
  x <- grid_list[ii, ]
  doc_string <- paste0(doc_string, "
#' @name ", x$name, "
#' @description
#' * **", x$name, ":** ", x$desc, " Image reference [here](", x$ref_img, ").",
  ifelse(is.na(x$contrib), "",
    paste0(" Thanks to [", basename(x$contrib), "](", x$contrib, ").")), "
#' @usage ", x$name, "
#' @rdname grids
#' @md
NULL
"
)
}

cat(doc_string, file = "R/grid_docs.R")

document()

## generate R/valid_grids.R
##---------------------------------------------------------

nms <- paste0("\"", paste0(grid_list$name, collapse = "\", \""), "\"")
txt <- paste0(strwrap(paste0(".valid_grids <- c(", nms, ")"), 80, exdent = 2), collapse = "\n")
cat(paste0(txt, "\n"), file = "R/valid_grids.R")
