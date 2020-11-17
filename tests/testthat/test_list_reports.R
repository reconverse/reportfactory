
context("List reports")

test_that("list_reports lists all Rmd files in report_sources", {
  odir <- getwd()

  x <- random_factory(tempdir())
  
  expected <- basename(
    list.files(file.path(x, "report_sources"),
               pattern = ".Rmd$"))

  expect_equal(sort(expected),
               sort(list_reports()))

  setwd(odir)
  
})
