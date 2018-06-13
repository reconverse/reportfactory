
list_reports <- function() {
  out <- dir(here::here("report_sources"),
             recursive = TRUE, pattern = ".Rmd$",
             full.names = TRUE)
  out <- gsub(".*/", "", out)
  out
}
