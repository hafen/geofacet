# make messages wrap nicely
message_nice <- function(...) {
  message(paste(strwrap(paste(...), exdent = 2), collapse = "\n"))
}
