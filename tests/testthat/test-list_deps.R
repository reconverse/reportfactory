library(fs)

test_that("non parsing list_deps works", {

  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))

  # copy test reports over (as this has inline code)
  file_copy(path("test_reports", "package_calls.Rmd"), path(f, "report_sources"))
  file_copy(path("test_reports", "example.R"), path(f, "report_sources"))

  # non parsed expected_deps
  expected_deps_package_calls_rmd <- c("purrr", "readxl", "fs", "rmarkdown")
  expected_deps_example_r <- c("fs", "yaml", "callr", "utils", "rprojroot")
  expected_deps_example_report <- c("base", "knitr", "fs")
  expected_deps <- c(expected_deps_package_calls_rmd,
                     expected_deps_example_r,
                     expected_deps_example_report)

  deps <- list_deps(f)
  expect_equal(sort(deps), sort(unique(expected_deps)))
})


test_that("parsing list_deps works", {

  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))

  # copy test reports over (as this has inline code)
  file_copy(path("test_reports", "package_calls.Rmd"), path(f, "report_sources"))
  file_copy(path("test_reports", "example.R"), path(f, "report_sources"))

  # non parsed expected_deps
  expected_deps_package_calls_rmd <- c("purrr", "readxl", "fs", "rmarkdown")
  expected_deps_example_r <- c("fs", "yaml", "callr", "utils", "rprojroot")
  expected_deps_example_report <- c("knitr", "fs")
  expected_deps <- c(expected_deps_package_calls_rmd,
                     expected_deps_example_r,
                     expected_deps_example_report)

  deps <- list_deps(f, parse_first = TRUE)
  expect_equal(sort(deps), sort(unique(expected_deps)))
})

