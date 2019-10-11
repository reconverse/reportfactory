context("Extract strings")


test_that("String returned matches the pattern provided",{
  x <- "I love RECON"
  pattern <- "[A-Z]{5}"
  expected <- "RECON"
  actual <- extract_string(x, pattern)
  expect_equal(expected, actual)
})


test_that("String returned is the correct class", {
  x <- "I love RECON"
  pattern <- "[A-Z]{5}"
  expect_that(extract_string(x, pattern), is_a('character'))
})



