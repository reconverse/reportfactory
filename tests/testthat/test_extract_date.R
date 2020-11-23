
context("Extract dates")

# basic test with a single date
test_that("The date is extracted from a signle string", {
  x <- "contacts_2017-10-29"
  expected <- as.Date("2017-10-29")
  actual <- extract_date(x)
  expect_equal(expected, actual)
})




# vectorised version
test_that("Date extraction works on vectors of characters", {

  expected <- structure(c(NA, NA, 18273), class = "Date")
  actual <- extract_date(c("foo", "bar", "2020-01-12"))
  expect_identical(expected, actual)
  
})
