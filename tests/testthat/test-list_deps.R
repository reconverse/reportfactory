test_that("list_deps works", {

  f <- new_factory(path = tempdir(), move_in = FALSE)
  on.exit(unlink(f, recursive = TRUE))
  
  # copy test reports over (as this has inline code)
  file.copy(
    file.path("test_reports", "package_calls.Rmd"),
    file.path(f, "report_sources")
  )
  
  expected_deps_package_calls <- c("purrr", "readxl", "fs")
  expected_deps_example_report <- c("here", "incidence2")
  expected_deps <- c(expected_deps_package_calls, expected_deps_example_report)
  deps <- list_deps(f)
  expect_equal(sort(deps), sort(expected_deps))
})