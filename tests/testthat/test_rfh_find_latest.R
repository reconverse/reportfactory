context("Helper function to find latest files: rfh_find_latest")


# test that the right file is returned

test_that("rfh_find_latest works well", {
  
  skip_on_cran()

  ## create random factory and toy files
  odir <- getwd()
  random_factory(tempdir())

  file.create(file.path("data", "linelist_2020-10-01.xlsx"))
  file.create(file.path("data", "linelist_2020-10-12.csv"))
  file.create(file.path("data", "linelist.xlsx"))
  file.create(file.path("data", "contacts.xlsx"))
  file.create(file.path("data", "death_linelist_2020-10-13.xlsx"))
  cat("This is a test\n", file = file.path("data", "notes_2020-01-01.txt"))

  ## test a few paths
  expect_identical("/data/death_linelist_2020-10-13.xlsx",
                   sub(getwd(), "", rfh_find_latest("linelist")))
  expect_identical("/data/linelist_2020-10-12.csv",
                   sub(getwd(), "", rfh_find_latest("^linelist")))
  
  ## test that we can actually read the file
  expected <- "This is a test"
  actual <- readLines(rfh_find_latest("notes", quiet = TRUE))
  expect_identical(expected, actual)

  ## test expected errors / messages
  msg <- "Some files matching requested pattern have no 'yyyy-mm-dd' date"
  expect_message(rfh_find_latest("linelist"), msg)

  msg <- "No 'yyyy-mm-dd' date in files matching requested pattern."
  expect_error(rfh_find_latest("contacts"),
               msg)

  msg <- "No file matching pattern 'foobar' found in"
  expect_message(rfh_find_latest("foobar"),
                 msg)
  
  setwd(odir)
  
})
