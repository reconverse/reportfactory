test_that("list_reports works from outside factory", {
  f <- new_factory(path = tempdir(), move_in = FALSE)
  on.exit(unlink(f, recursive = TRUE))
  
  nested_dir <- file.path(f, "report_sources", "nested")
  dir.create(nested_dir)
  file.create(file.path(nested_dir, "nested.Rmd"))
  file.create(file.path(nested_dir, "nested.noshow"))

  expected_reports <- c("example_report.Rmd", "nested/nested.Rmd")
  expect_equal(sort(unclass(list_reports(f))), sort(expected_reports))
  expect_equal(unclass(list_reports(f, "nested")), "nested/nested.Rmd")
})

test_that("list_reports works from inside factory", {
  odir <- getwd()
  f <- new_factory(path = tempdir(), move_in = TRUE)

  on.exit(setwd(odir))
  on.exit(unlink(f, recursive = TRUE), add = TRUE)
  
  
  nested_dir <- file.path(f, "report_sources", "nested")
  dir.create(nested_dir)
  file.create(file.path(nested_dir, "nested.Rmd"))
  file.create(file.path(nested_dir, "nested.noshow"))

  expected_reports <- c("example_report.Rmd", "nested/nested.Rmd")
  expect_equal(sort(unclass(list_reports())), sort(expected_reports))
})
