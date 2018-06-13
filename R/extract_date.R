

## Extract the date from a character string (vectorised)

extract_date <- function(x) {
  date_pattern <- "[0-9]{4}-[0-9]{2}-[0-9]{2}"
  stringr::str_extract(x, date_pattern)
}
