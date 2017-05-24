# make messages wrap nicely
message_nice <- function(...) {
  message(paste(strwrap(paste0(...), exdent = 2), collapse = "\n"))
}
