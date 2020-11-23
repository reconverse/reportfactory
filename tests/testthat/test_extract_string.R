context("Extract strings")

test_that("String returned matches the pattern provided", {
  x <- "I love RECON"
  pattern <- "[A-Z]{5}"
  expected <- "RECON"
  actual <- extract_string(x, pattern)
  expect_equal(expected, unname(actual))
})





test_that("String returned is the correct class", {
  x <- "I love RECON"
  pattern <- "[A-Z]{5}"
  expect_that(extract_string(x, pattern), is_a("character"))
})






test_that("Vectors of characters are well handled", {
  x <- c("asd", "45", "4555asd")
  extract_string(x, pattern = "[0-9][:alpha:]")
  expected <- c(NA, NA, "5a")
  expect_equal(expected, unname(actual))
})
