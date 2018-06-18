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

  new_dir <- function() {
    rnd  <- paste(runif(8), collapse = "")
    file.path(tempdir(), paste("factory_test", rnd, sep = "_"))
  }

  expect_error(validate_factory("asd"),
               "the directory 'asd' does not exist")

  ## empty factory
  dir.create(x <- new_dir(), FALSE, TRUE)

  exp_msg <- paste("file '.here' is missing",
                   "file '.gitignore' is missing",
                   "folder 'report_sources/' is missing",
                   sep = "\n")
  expect_error(validate_factory(x),
               exp_msg)


  ## .here missing
  dir.create(x <- new_dir(), FALSE, TRUE)
  file.create(file.path(x, ".gitignore"))
  dir.create(file.path(x, "report_sources"))

  exp_msg <- "file '.here' is missing"
  expect_error(validate_factory(x),
               exp_msg)


  ## .gitignore missing
  dir.create(x <- new_dir(), FALSE, TRUE)
  file.create(file.path(x, ".here"))
  dir.create(file.path(x, "report_sources"))

  exp_msg <- "file '.gitignore' is missing"
  expect_error(validate_factory(x),
               exp_msg)


  ## report_sources missing
  dir.create(x <- new_dir(), FALSE, TRUE)
  file.create(file.path(x, ".here"))
  file.create(file.path(x, ".gitignore"))

  exp_msg <- "folder 'report_sources/' is missing"
  expect_error(validate_factory(x),
               exp_msg)

  ## duplicated report names
  dir.create(x <- new_dir(), FALSE, TRUE)
  file.create(file.path(x, ".here"))
  file.create(file.path(x, ".gitignore"))
  dir.create(file.path(x, "report_sources"), FALSE, TRUE)
  file.create(file.path(x, "report_sources", "toto.Rmd"))
  dir.create(file.path(x, "report_sources", "toto"), FALSE, TRUE)
  file.create(file.path(x, "report_sources/toto", "toto.Rmd"))

  exp_msg <- paste("the following reports are duplicated:",
                   "toto.Rmd", sep = "\n")

  expect_error(validate_factory("broken_factories/duplicated_reports/"),
               exp_msg)


  ## non-rmd files in sources
  dir.create(x <- new_dir(), FALSE, TRUE)
  file.create(file.path(x, ".here"))
  file.create(file.path(x, ".gitignore"))
  dir.create(file.path(x, "report_sources"), FALSE, TRUE)
  file.create(file.path(x, "report_sources", "my_data.csv"))
  file.create(file.path(x, "report_sources", "toto.html"))

  exp_msg <- paste("the following files in 'report_sources/' are not .Rmd:",
                   "my_data.csv",
                   "toto.html", sep = "\n")
  expect_warning(validate_factory("broken_factories/messy_sources/"),
               exp_msg)

})
