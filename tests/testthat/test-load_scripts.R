library(fs)

test_that("load_scripts works when files exist", {
  
  # create factory
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))
  
  cat("a <- 1L", file = path(f, "scripts", "a.R"))
  cat("b <- 2L + a", file = path(f, "scripts", "b.R"))

  load_scripts(f)
  expect_identical(b, 3L)
})


test_that("messages and errors as expected", {
  
  # create factory
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))
  expect_message(load_scripts(f), "No `.R` files in")
  expect_error(load_scripts(f, "bob"), "does not exist")
})