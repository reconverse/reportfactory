
## Extract the base name of a report, i.e. keeping anything before the date.

extract_base <- function(x) {
  pattern <- ".[0-9]{4}-[0-9]{2}-[0-9]{2}.*$"
  out <- gsub(pattern, "", x)
  out <- gsub(".*/", "", out)
  out
}
