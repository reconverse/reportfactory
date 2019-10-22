context("Test filter_list")

# sample_log <- list(
#   `2019_10_22_090403` = list(
#     compile_init_env = list(factory = "contacts", quiet = TRUE, params = list(light = TRUE))
#   ),
#   timestamp = "2019_10_22_090403",
#   dots = list(extra = "things"),
#   `2019_10_22_090403` = list(
#     compile_init_env = list(factory = "contacts", params = list(sc = "beni"))
#   ),
#   timestamp = "2019_10_22_090403",
#   dots = list(more = "args_string")
# )
# attr(sample_log, "factory") = "contacts"


filter_log <- function(log_file, ...) {
  conds <- unlist(...)
  
  ul <- unlist(log_file)
  n <- names(ul)
  matches_key <- ul[grep("file", n)]
  matches_value <- unname("contacts_2017-10-29.Rmd" == matches_key)
  full_match <- matches_key[matches_value]
  full_match_names <- names(full_match)
  list_keys <- lapply(full_match_names, function(x) gsub("\\..*","",x))
  keys <- unlist(list_keys)
  
  results <- log_file[keys]
  return(results)
}




test_that("Filtering a list returns the root list in which it is contained", {
  skip_on_cran()
  
  odir <- getwd()
  on.exit(setwd(odir))
  
  setwd(tempdir())
  random_factory(include_examples = TRUE)
  
  factory_name <- "contacts"
  compile_report(list_reports(
    pattern = factory_name)[1],
    quiet = TRUE,
    params = list(other = "test"))
  compile_report(list_reports(
    pattern = factory_name)[1], 
    quiet = FALSE, 
    params = list("other" = "two",
                   "more" = list("thing" = "foo")),
    extra = dots_args)
  
  
  log_file <- readRDS(".compile_log.rds")
  
  filtered <- filter_log(log_file, file = "contacts_2017-10-29.Rmd")
  
  ## Expect the filtered list to be the same as the log entries of log_file
     ## (both entries match the filter)
  expect_equal(filtered, log_file[-c(1,2)])
})
