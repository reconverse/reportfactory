context("Test log filtering")
odir <- getwd()
on.exit(setwd(odir))

setwd(tempdir())
random_factory(include_examples = TRUE)
source_name <- "foo"
report_source_file_name <- list_reports(pattern = source_name)[1]
compile_report(
  report_source_file_name,
  quiet = TRUE,
  params = list(other = "test"))

dots_args <- list("lots" = data.frame(a = c(10,20)))
compile_report(
  report_source_file_name, 
  quiet = FALSE, 
  params = list("other" = "two",
                "more" = list("thing" = "foo")),
  extra = dots_args)


log_file <- readRDS(".compile_log.rds")

test_that("Filtering returns only exact matches on EXACT parameters", {
  skip_on_cran()
  
  ## entries missing some params arguments so should return an empty list
  missing_params_filtered <- filter_log(
    match_exact = c("params"),
    log_file = log_file,
    params = list("other" = "two")
  )
  
  expect_equal(length(missing_params_filtered), 0)
  
  ## conds missing some dots arguments so should return an empty list
  alt_dots_args <- list("lots" = data.frame(a = c(10)))
  missing_dots_filtered <- filter_log(
    match_exact = c("params", "dots"),
    log_file = log_file,
    params = list("other" = "two",
                  "more" = list("thing" = "foo")),
    dots = alt_dots_args)
  
  expect_equal(length(missing_dots_filtered), 0)
  
  ## dots args and params args match and should return exactly one log entry
  non_missing_filtered <- filter_log(
    match_exact = c("params", "dots"),
    log_file = log_file,
    params = list("other" = "two",
                  "more" = list("thing" = "foo")),
    dots = dots_args)
  
  expect_equal(non_missing_filtered, log_file[-c(1)])
})


test_that("Filtering a list with string values returns log entries", {
  skip_on_cran()
  
  filtered <- filter_log(log_file, 
                         file = report_source_file_name,
                         most_recent = FALSE)
  
  ## Expect the filtered list to be the same as the log entries of log_file
     ## (both entries match the filter)
  expect_equal(names(filtered), names(log_file))
  
  filtered <- filter_log(log_file, params = list("other" = "two"))
  
  expect_equal(filtered, log_file[-c(1)])
})


test_that("Filtering with non-string values returns the matching lists", {
  skip_on_cran()
  
  filtered <- filter_log(
    log_file = log_file,
    params = list("other" = "two"),
    dots = dots_args, 
    most_recent = FALSE)

  expect_equal(filtered, log_file[-c(1)])
})


test_that("Filtering for most recent returns only last match for each source", {
  source_name <- "contacts"
  report_source_file_name <- list_reports(pattern = source_name)[1]
  compile_report(
    report_source_file_name,
    quiet = TRUE,
    params = list(other = "test"))
  log_file <- readRDS(".compile_log.rds")
  
  most_recent_filtered <- filter_log(log_file, most_recent = TRUE)
  
  ## Without `most_recent = TRUE` this would be equal to log_file[c(1,2,3)]
  expect_equal(most_recent_filtered, log_file[c(2,3)])
})

test_that("Filtering can return outputs only", {
  outputs_only_filtered <- filter_log(log_file, 
                                     file = report_source_file_name,
                                     outputs_only = TRUE,
                                     most_recent = FALSE)
  
  expect_equal(names(outputs_only_filtered[[1]]), "output_files")
})

test_that("Filtering can return specific outputs only", {
  source_name <- "foo"
  report_source_file_name <- list_reports(pattern = source_name)[1]
  output_types <- c("png", "csv")
  outputs_only_filtered <- filter_log(log_file, 
                                      file = report_source_file_name,
                                      outputs_only = TRUE,
                                      output_file_types = output_types,
                                      most_recent = TRUE)
  
  
  remove <- c(".html", ".jpeg", ".pdf", ".rds", ".rmd", ".xls", ".xlsx")
  
  outputs_only_entry <- outputs_only_filtered[[1]]
  outputs_only_entry <- unlist(outputs_only_entry)
  removed <- lapply(remove, function(r) grep(r, outputs_only_entry))
  results <- outputs_only_entry[unlist(removed)]
  
  expect_equal(length(results), 0)
})

setwd(odir)
