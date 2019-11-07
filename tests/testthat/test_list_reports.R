
context("List reports")

test_that("list reports returns equal values in new_factory", {
  odir <- getwd()
  on.exit(setwd(odir))
  
  destination <- file.path(tempdir(), "new_factory")
  destination
  new_factory(destination)
  
  expected <- 1
  actual <- length(list_reports(destination))

  expect_equal(expected, actual)  
  })

