context("Creation of report factory")


test_that("new_factory generates the right files", {

  skip_on_cran()

  ## time <- format(Sys.time(), "%Y-%m-%d_%H-%M-%S")
  ## out <- file.path(tempdir(), paste("new_factory", time, sep = "_"))

  ref_path <-  system.file("factory_template", package = "reportfactory")

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




test_that("update_reports compiles recent reports okay", {

  skip_on_cran()

  time <- format(Sys.time(), "%Y-%m-%d_%H-%M-%S")
  new_fac_path <- file.path(tempdir(), paste("new_factory", time, sep = "_"))
  new_factory(new_fac_path, move_in = FALSE)

  odir <- getwd()
  update_reports(quiet = TRUE, factory = new_fac_path)


  ## update_reports should not alter the working directory
  expect_identical(odir, getwd())

  ## The following does not work, merely because html documents produced seem to
  ## be timestamped.

  ## out_path <- file.path(new_fac_path, "report_outputs")

  ## hashes <- tools::md5sum(dir(out_path,
  ##                             recursive = TRUE,
  ##                             full.names = TRUE,
  ##                             all.files = TRUE))
  ## hashes <- sort(unname(hashes))
  ## expect_equal_to_reference(hashes, file = "rds/hashes.rds")


})
