context("Validation of report factory")


test_that("A new_factory is valid, and stays valid after update", {

  skip_on_cran()

  x <- random_factory(tempdir())

  no_probs <- function(test) {
    length(test$errors) == 0L && length(test$warnings) == 0L
  }
  expect_true(no_probs(validate_factory(x)))
  update_reports(x, quiet = TRUE)
  expect_true(no_probs(validate_factory(x)))

})





test_that("Broken factories are identified", {

  skip_on_cran()

  random_dir <- function() {
    file.path(tempdir(), random_alphanum(6))
  }

  expect_error(validate_factory("asd"),
               "the directory 'asd' does not exist")

  ## empty factory
  x <- random_dir()
  dir.create(x, FALSE, TRUE)

  exp_msg <- paste("file '.here' is missing",
                   "file '.gitignore' is missing",
                   "folder 'report_sources/' is missing",
                   sep = "\n")
  expect_error(validate_factory(x), exp_msg)


  ## .here missing
  x <- random_dir()
  dir.create(x, FALSE, TRUE)
 
  file.create(file.path(x, ".gitignore"))
  dir.create(file.path(x, "report_sources"))
  
  exp_msg <- "file '.here' is missing"
  expect_error(validate_factory(x), exp_msg)


  ## .gitignore missing
  x <- random_dir()
  dir.create(x, FALSE, TRUE)

  file.create(file.path(x, ".here"))
  dir.create(file.path(x, "report_sources"))
  
  exp_msg <- "file '.gitignore' is missing"
  expect_error(validate_factory(x), exp_msg)


  ## report_sources missing
  x <- random_dir()
  dir.create(x, FALSE, TRUE)

  file.create(file.path(x, ".here"))
  file.create(file.path(x, ".gitignore"))
  
  exp_msg <- "folder 'report_sources/' is missing"
  expect_error(validate_factory(x), exp_msg)

  ## duplicated report names
  x <- random_dir()
  dir.create(x, FALSE, TRUE)

  file.create(file.path(x, ".here"))
  file.create(file.path(x, ".gitignore"))
  dir.create(file.path(x, "report_sources"), FALSE, TRUE)
  file.create(file.path(x, "report_sources", "toto.Rmd"))
  dir.create(file.path(x, "report_sources", "toto"), FALSE, TRUE)
  file.create(file.path(x, "report_sources/toto", "toto.Rmd"))

  exp_msg <- paste("the following reports are duplicated:",
                   "toto.Rmd", sep = "\n")

  expect_error(validate_factory(x), exp_msg)


  ## non-rmd files in sources
  x <- random_dir()
  dir.create(x, FALSE, TRUE)

  file.create(file.path(x, ".here"))
  file.create(file.path(x, ".gitignore"))
  dir.create(file.path(x, "report_sources"), FALSE, TRUE)
  file.create(file.path(x, "report_sources", "my_data.csv"))
  file.create(file.path(x, "report_sources", "toto.html"))

  exp_msg <- paste("the following files in 'report_sources/' are not .Rmd:",
                   "my_data.csv",
                   "toto.html", sep = "\n")
  expect_warning(validate_factory(x), exp_msg)

})
