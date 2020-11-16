context("Test random_alphanum")


test_that("random_alphanum() creates expected output", {

  skip_on_cran()

  ## check output
  expect_identical(nchar(random_alphanum(10)), 10L)
  expect_identical(nchar(random_alphanum(1)), 1L)
  expect_identical("", random_alphanum(0))

  ## check error message
  expect_error(random_alphanum(), "`n` no provided, with no default")
  
})
