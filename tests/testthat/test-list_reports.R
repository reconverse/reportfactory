library(fs)

test_that("list_reports works from outside factory", {
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))
  
  nested_dir <- path(f, "report_sources", "nested")
  dir_create(nested_dir)
  file_create(path(nested_dir, "nested.Rmd"))
  file_create(path(nested_dir, "nested.noshow"))

  expected_reports <- c("example_report.Rmd", file.path("nested", "nested.Rmd"))
  expect_equal(sort(unclass(list_reports(f))), sort(expected_reports))
  expect_equal(unclass(list_reports(f, "nested")), file.path("nested", "nested.Rmd"))
})

test_that("list_reports works from inside factory", {
  odir <- getwd()
  f <- new_factory(path = path_temp(), move_in = TRUE)

  on.exit(setwd(odir))
  on.exit(dir_delete(f), add = TRUE)
  
  
  nested_dir <- path(f, "report_sources", "nested")
  dir_create(nested_dir)
  file_create(path(nested_dir, "nested", ext = "Rmd"))
  file_create(path(nested_dir, "nested", ext = ".noshow"))

  expected_reports <- c("example_report.Rmd", file.path("nested", "nested.Rmd"))
  expect_equal(sort(unclass(list_reports())), sort(expected_reports))
})
