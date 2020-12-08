test_that("factory_root errors correctly", {
  expect_error(factory_root(tempdir()), "is not part of a report factory")
  expect_error(factory_root("thiswillerror"), "does not exist")

  odir <- setwd(tempdir())
  on.exit(setwd(odir))
  file.create("foo")
  on.exit(file.remove("foo"), add = TRUE, after = FALSE)
  expect_error(factory_root("foo"), "is a file, not a directory")
})

