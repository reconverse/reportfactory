context("Test filter_list")
odir <- getwd()
on.exit(setwd(odir))

setwd(tempdir())
random_factory(include_examples = TRUE)
factory_name <- "contacts"
compile_report(list_reports(
  pattern = factory_name)[1],
  quiet = TRUE,
  params = list(other = "test"))

dots_args <- list("lots" = data.frame(a = c(10,20)))
compile_report(list_reports(
  pattern = factory_name)[1], 
  quiet = FALSE, 
  params = list("other" = "two",
                "more" = list("thing" = "foo")),
  extra = dots_args)


log_file <- readRDS(".compile_log.rds")
length(log_file)

test_that("Filtering returns only exact matches on EXACT parameters", {
  skip_on_cran()
  
  # ids missing dots arguments so should return an empty list
  missing_params_filtered <- filter_log(
    match_exact = c("params"),
    log_file = log_file,
    params = list("other" = "two")
  )
  # missing_params_filtered
  expect_equal(length(missing_params_filtered), 0)
  
  missing_dots_filtered <- filter_log(
    match_exact = c("params", "dots"),
    log_file = log_file,
    params = list("other" = "two",
                  "more" = list("thing" = "foo")))
  # missing_dots_filtered
  expect_equal(length(missing_dots_filtered), 0)
  
  non_missing_filtered <- filter_log(
    match_exact = c("params"),
    log_file = log_file,
    params = list("other" = "two",
                  "more" = list("thing" = "foo")),
    dots = dots_args)
  # non_missing_filtered
  expect_equal(non_missing_filtered, log_file[-c(1,2,3)])
 
})


test_that("Filtering a list with string values returns the root list in which it is contained", {
  skip_on_cran()
  
  filtered <- filter_log(log_file, file = "contacts_2017-10-29.Rmd")
  
  ## Expect the filtered list to be the same as the log entries of log_file
     ## (both entries match the filter)
  expect_equal(filtered, log_file[-c(1,2)])
  
  filtered <- filter_log(log_file, params = list("other" = "two"))
  
  expect_equal(filtered, log_file[-c(1,2,3)])
  
})

test_that("Filtering with non-string values returns the matching lists", {
  skip_on_cran()

  filtered <- filter_log(
    log_file = log_file,
    params = list("other" = "two"),
    dots = dots_args)
  filtered
  expect_equal(filtered, log_file[-c(1,2,3)])
  
})

test_that("Filtering with non-string values returns the matching lists", {
  skip_on_cran()
  
  filtered <- filter_log(
    log_file = log_file,
    params = list("other" = "two"),
    dots = dots_args)
   # filtered
  expect_equal(filtered, log_file[-c(1,2,3)])
})


test_that("Filtering with for most recent returns only last match", {
  most_recent_filtered <- filter_log(log_file, 
                         file = "contacts_2017-10-29.Rmd",
                         most_recent = TRUE)
  
  ## Expect the filtered list to be the same as the log entries of log_file
  ## (both entries match the filter)
  expect_equal(most_recent_filtered, log_file[-c(1,2,3)])

})
