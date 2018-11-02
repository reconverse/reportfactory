context("Creation of report factory")


test_that("new_factory generates the right files", {

  skip_on_cran()
  pkg_path     <- system.file("factory_template", package = "reportfactory")
  tim          <- as.integer(Sys.time())
  ref_path     <- file.path(tempdir(), paste0(tim, "ref_factory"))
  new_fac_path <- file.path(tempdir(), paste0(tim, "new_factory"))
  dir.create(ref_path)
  file.copy(list.files(pkg_path, 
                       all.files = TRUE,
                       full.names = TRUE,
                       no.. = TRUE),
            to = ref_path,
            overwrite = TRUE,
            recursive = TRUE
           )

  make_gitignore(file.path(ref_path, ".gitignore"))
  cat("", file = file.path(ref_path, ".here"))
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




test_that("working directory unchanged", {

  skip_on_cran()


  new_dir <- function() {
    rnd  <- paste(sample(0:9, 20, replace = TRUE), collapse = "")
    file.path(tempdir(), paste("factory_test", rnd, sep = "_"))
  }

  odir <- getwd()
  new_factory(x <- new_dir(), move_in = FALSE)

  ## new_factory with move_in = FALSE should not alter the working directory
  expect_identical(odir, getwd())

  update_reports(quiet = TRUE, factory = x)


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
