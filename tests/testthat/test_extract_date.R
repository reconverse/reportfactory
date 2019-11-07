
context("Extract dates")

test_that("The date is extracted from a string",{
  x <- "contacts_2017-10-29"
  expected <- "2017-10-29"
  actual <- extract_date(x)
  expect_equal(expected, actual)
})


