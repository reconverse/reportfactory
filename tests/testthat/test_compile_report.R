context("Test report compilation")

test_that("Compilation can handle basic report", {
  skip_on_cran()
  
  x <- random_factory(tempdir(), move_in = FALSE)

  report_rmd <- list_reports(factory = x)[1]
  compile_report(report_rmd, factory = x, quiet = TRUE)
  output_files <- basename(list_outputs(factory = x))
  output_files <- sort(output_files)

  ref <- c("example_report_1.html")
  expect_identical(ref, output_files)

})





test_that("Compilation can take params and pass to markdown::render", {
  skip_on_cran()
 
  x <- random_factory(tempdir(), move_in = FALSE)

  report_rmd <- list_reports(factory = x)[1]
  foo_value <- "testzfoo"

  compile_report(report_rmd,
                 factory = x,
                 params =
                   list(foo = foo_value,
                        show_stuff = TRUE,
                        bar = letters))
  
  expect_match(
    list_outputs(factory = x),
    paste("foo", foo_value, "show_stuff_TRUE_bar_a_b_c_d", sep = "_"))

})





test_that("`clean_report_sources = TRUE` removes unprotected non Rmd files", {
  # tests the following criteria:
    # 1. IMPORTANT: A deeply nested .Rmd file AND its directories are not,
    #    removed, including in nested directories
    # 2. Files that are not .Rmd are removed
    # 3. Empty directories are removed
  skip_on_cran()
 
  x <- random_factory(tempdir(),
                      move_in = FALSE)

  ## create junk
  ## sutff/ will contain only junk and needs removing
  ## foo/ will contain some junk and Rmds and needs cleaning
  dir.create(
    file.path(
    x,
    "report_sources",
    "stuff"),
    FALSE, TRUE)
  dir.create(
    file.path(
      x,
      "report_sources",
      "foo"),
    FALSE, TRUE)
  file.create(
     file.path(x,
               "report_sources",
               "junk.csv"))
  file.create(
     file.path(x,
               "report_sources",
               "stuff",
               "some-crap.R"))
   file.create(
     file.path(x,
               "report_sources",
               "foo",
               "more_junk.xlsx"))
   file.create(
     file.path(x,
               "report_sources",
               "foo",
               "some_report_2020-01-01.Rmd"))
 

   ## round of cleaning
   exp_res <- c("report_sources/foo/more_junk.xlsx",
                "report_sources/stuff/some-crap.R", 
                "report_sources/junk.csv",
                "report_sources/stuff")
   
  expect_message(
    res <- clean_report_sources(x))
  expect_identical(res, exp_res)

  
  ## second cleaning should be empty
  res <- clean_report_sources(x)
  expect_identical(res, character())
  
})





## test_that("Compile logs activity in an rds file", {
##   skip_on_cran()

##   x <- random_factory(tempdir(),
##                       prefix = "foo",
##                       move_in = FALSE)

##   report_rmd <- list_reports(x)[1]
  
##   compile_report(
##     report_rmd,
##     factory = x,
##     quiet = TRUE,
##     params = list(other = "test"))
  
##   log_file <- readRDS(file.path(x, ".compile_log.rds"))
##   # TODO: fix this test, the factory name is currently not handled well
##   # correctly in the log
##   # expect_equal(attr(log_file, "factory_name"), basename(x))
##   init_time <- attr(log_file, "initialized_at")
##   expect_equal(as.Date(init_time), Sys.Date())
  
##   log_entry <- log_file[[1]]
##   other_param <- log_entry$compile_init_env$params$other
##   expect_equal(other_param, "test")
##   quiet_arg <- log_entry$compile_init_env$quiet
##   expect_equal(quiet_arg, TRUE)
  
##   ## compiling another report to be sure the log does not remove data 
##   ## or have merge issues
   
##   compile_report(
##     report_rmd,
##     factory = x,
##     quiet = TRUE,
##     params = list("other" = "two",
##                   "more" = list("thing" = "foo")))
  
##   log_file <- readRDS(file.path(x, ".compile_log.rds"))
  
##   log_entry <- log_file[[2]]
##   other_param <- log_entry$compile_init_env$params$other
##   expect_equal(other_param, "two")
##   log_output_dir <- log_entry$output_dir
##   ## Expect to have the two initalize values plus two log entries
##   expect_equal(length(log_file), 2)
  
## })
