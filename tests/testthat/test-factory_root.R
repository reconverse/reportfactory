library(fs)
test_that("factory_root errors correctly", {
  expect_error(factory_root(path_temp()), "is not part of a report factory")
  expect_error(factory_root("thiswillerror"), "does not exist")

  odir <- setwd(tempdir())
  on.exit(setwd(odir))
  file_create("foo")
  expect_error(factory_root("foo"), "is a file, not a directory")
  file_delete("foo")
})

