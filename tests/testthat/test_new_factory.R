context("Creation of report factory")

test_that("new_factory generates the right files - with templates", {

  skip_on_cran()

  zip_path <-  system.file("factory_template_default.zip",
                           package = "reportfactory")

  ref_path <- file.path(tempdir(), "ref_factory")
  unzip(zipfile = zip_path,
        exdir = ref_path)


  new_fac_path <- file.path(tempdir(), "new_factory")
  new_factory(new_fac_path, move_in = FALSE)

  ref_hashes <- tools::md5sum(dir(ref_path,
                                  recursive = TRUE,
                                  full.names = TRUE,
                                  all.files = TRUE))
  new_hashes <- tools::md5sum(dir(new_fac_path,
                                  recursive = TRUE,
                                  full.names = TRUE,
                                  all.files = TRUE))

  expect_identical(unname(ref_hashes), unname(new_hashes))

})





test_that("new_factory generates the right files - empty factory", {

  skip_on_cran()

  zip_path <-  system.file("factory_template_empty.zip",
                           package = "reportfactory")

  ref_path <- file.path(tempdir(), "ref_factory")
  unzip(zipfile = zip_path,
        exdir = ref_path)


  new_fac_path <- file.path(tempdir(), "new_factory")
  new_factory(new_fac_path, move_in = FALSE, include_template = FALSE)

  ref_hashes <- tools::md5sum(dir(ref_path,
                                  recursive = TRUE,
                                  full.names = TRUE,
                                  all.files = TRUE))
  new_hashes <- tools::md5sum(dir(new_fac_path,
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
  
})
