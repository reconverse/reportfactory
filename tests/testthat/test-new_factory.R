test_that("new_factory generates the right files - defaults + no move_in", {
    
  odir <- getwd()
  f <- new_factory(path = tempdir(), move_in = FALSE)
  on.exit(unlink(f, recursive = TRUE))

  expect_identical(odir, getwd())
  
  expected_location <- file.path(tempdir(), "new_factory")
  
  expect_true(dir.exists(expected_location))
  expect_equal(f, expected_location)

  all_files <- list.files(
    file.path(tempdir(), "new_factory"),
    all.files = TRUE,
    recursive = TRUE,
    include.dirs = TRUE
  )
  
  expected_files <- c(
    "report_sources",
    "report_sources/example_report.Rmd",
    "outputs",
    "factory_config",
    ".here",
    ".gitignore",
    "README.md",
    "data",
    "data/clean",
    "data/raw",
    "data/raw/example_data.csv",
    "scripts"
    )
    
    expect_equal(sort(all_files), sort(expected_files))
})

test_that("new_factory generates the right files - empty factory + move_in", {
  
  odir <- getwd()
  f <- new_factory(path = tempdir(), create_README = FALSE, 
                   create_example_report = FALSE, create_data_folders = FALSE,
                   create_scripts_folder = FALSE, use_here = FALSE,
                   create_gitignore = FALSE)
  on.exit(setwd(odir))
  on.exit(unlink(f, recursive = TRUE), add = TRUE, after = TRUE)

  expected_location <- file.path(tempdir(), "new_factory")
  expect_true(dir.exists(expected_location))
  expect_equal(f, expected_location)
  if (unname(Sys.info()['sysname'] == "Darwin")) {
    expect_equal(paste0("/private", f), getwd())
  } else {
    expect_equal(f, getwd())
  }
  
  all_files <- list.files(
    expected_location,
    all.files = TRUE,
    recursive = TRUE,
    include.dirs = TRUE
  )
  
  expected_files <- c(
    "report_sources",
    "outputs",
    "factory_config"
    )
    
    expect_identical(sort(all_files), sort(expected_files))
})

test_that("new_factory won't let you overwrite existing folder", {
  f <- new_factory(path = tempdir(), move_in = FALSE)
  on.exit(unlink(f, recursive = TRUE))
  expect_error(new_factory(path = tempdir()), "already exists. Aborting.")
})