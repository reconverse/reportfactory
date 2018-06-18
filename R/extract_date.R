

## Extract the date from a character string (vectorised)

extract_date <- function(x) {
  date_pattern <- "[0-9]{4}[-_]?[0-9]{2}[-_]?[0-9]{2}"
  extract_string(x, date_pattern)
}
