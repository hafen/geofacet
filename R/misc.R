# make messages wrap nicely
message_nice <- function(...) {
  message(paste(strwrap(paste0(...), exdent = 2), collapse = "\n"))
}

gf_gtable_filter <- function (x, keep, trim = FALSE) {
  matches <- x$layout$name %in% keep
  x$layout <- x$layout[matches, , drop = FALSE] # nolint
  x$grobs <- x$grobs[matches]
  if (trim)
    x <- gtable::gtable_trim(x)
  x
}
