
context("Extract Base")

## Extract the base name of a report, i.e. keeping anything before the date.

test_that("All characters before the date are kept", {
  x <- "contacts_2017-10-29"
  expected <- "contacts"
  actual <- extract_base(x)
  expect_equal(expected, actual)
})
