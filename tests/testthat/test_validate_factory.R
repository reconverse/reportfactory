context("Validation of report factory")


test_that("A new_factory is valid", {

  skip_on_cran()

  time <- format(Sys.time(), "%Y-%m-%d_%H-%M-%S")
  new_fac_path <- file.path(tempdir(), paste("new_factory", time, sep = "_"))
  new_factory(new_fac_path, move_in = FALSE)

  no_probs <- function(test) {
    length(test$errors) == 0L && length(test$warnings) == 0L
  }
  expect_true(no_probs(validate_factory(new_fac_path)))
  update_reports(quiet = TRUE, factory = new_fac_path)
  expect_true(no_probs(validate_factory(new_fac_path)))

})





test_that("Broken factories are identified", {

  skip_on_cran()

  expect_error(validate_factory("asd"),
               "the directory 'asd' does not exist")

  ## empty factory
  exp_msg <- paste("file '.here' is missing",
                   "file '.gitignore' is missing",
                   "folder 'report_sources/' is missing",
                   sep = "\n")
  expect_error(validate_factory("broken_factories/empty/"),
               exp_msg)

  ## .here missing
  exp_msg <- "file '.here' is missing"
  expect_error(validate_factory("broken_factories/no_here/"),
               exp_msg)

  ## .gitignore missing
  exp_msg <- "file '.gitignore' is missing"
  expect_error(validate_factory("broken_factories/no_gitignore/"),
               exp_msg)

  ## report_sources missing
  exp_msg <- "folder 'report_sources/' is missing"
  expect_error(validate_factory("broken_factories/no_sources/"),
               exp_msg)

  ## duplicated report names
  exp_msg <- paste("the following reports are duplicated:",
                   "toto.Rmd", sep = "\n")

  expect_error(validate_factory("broken_factories/duplicated_reports/"),
               exp_msg)

  ## non-rmd files in sources
  exp_msg <- paste("the following files in 'report_sources/' are not .Rmd:",
                   "my_data.csv",
                   "toto.html", sep = "\n")
  expect_warning(validate_factory("broken_factories/messy_sources/"),
               exp_msg)

})
