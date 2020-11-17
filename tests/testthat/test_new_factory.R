context("Creation of report factory")

test_that("new_factory generates the right files - with templates", {

  skip_on_cran()

  ref_path <-  system.file("factory_template_default",
                           package = "reportfactory")

  x <- random_factory(tempdir(), move_in = FALSE)

  ref_hashes <- tools::md5sum(dir(ref_path,
                                  recursive = TRUE,
                                  full.names = TRUE,
                                  all.files = TRUE))
  new_hashes <- tools::md5sum(dir(x,
                                  recursive = TRUE,
                                  full.names = TRUE,
                                  all.files = TRUE))

  expect_identical(unname(ref_hashes), unname(new_hashes))

})





test_that("new_factory generates the right files - empty factory", {

  skip_on_cran()

  ref_path <-  system.file("factory_template_empty",
                           package = "reportfactory")

  x <- random_factory(tempdir(), include_template = FALSE, move_in = FALSE)

  ref_hashes <- tools::md5sum(dir(ref_path,
                                  recursive = TRUE,
                                  full.names = TRUE,
                                  all.files = TRUE))
  new_hashes <- tools::md5sum(dir(x,
                                  recursive = TRUE,
                                  full.names = TRUE,
                                  all.files = TRUE))

  expect_identical(unname(ref_hashes), unname(new_hashes))

})




test_that("working directory changes as expected", {

  skip_on_cran()

  ## with no change
  odir <- getwd()
  new_factory(tempdir(), move_in = FALSE)

  ## new_factory with move_in = FALSE should not alter the working directory
  expect_identical(odir, getwd())


  ## with a change
  factory_dir <- new_factory(tempdir(), move_in = TRUE)
  expect_identical(getwd(), factory_dir)

  setwd(odir)
  
})
