library(fs)

test_that("new_factory generates the right files - defaults + no move_in", {
    
  odir <- getwd()
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))

  expect_identical(odir, getwd())
  
  expected_location <- path(path_temp(), "new_factory")
  
  expect_true(dir_exists(expected_location))
  expect_equal(f, unclass(expected_location))

  all_files <- list.files(
    path(path_temp(), "new_factory"),
    all.files = TRUE,
    recursive = TRUE,
    include.dirs = TRUE
  )
  
  expected_files <- c(
    "report_sources",
    file.path("report_sources", "example_report.Rmd"),
    "outputs",
    "factory_config",
    ".here",
    ".gitignore",
    "README.md",
    "data",
    file.path("data", "clean"),
    file.path("data", "raw"),
    file.path("data", "raw", "example_data.csv"),
    "scripts"
    )
    
    expect_equal(sort(all_files), sort(expected_files))
})

test_that("new_factory generates the right files - empty factory + move_in", {
  
  odir <- getwd()
  f <- new_factory(path = path_temp(), create_README = FALSE, 
                   create_example_report = FALSE, create_data_folders = FALSE,
                   create_scripts_folder = FALSE, use_here = FALSE,
                   create_gitignore = FALSE)
  on.exit(setwd(odir))
  on.exit(dir_delete(f), add = TRUE, after = TRUE)

  expected_location <- path(path_temp(), "new_factory")
  expect_true(dir.exists(expected_location))
  expect_equal(f, unclass(expected_location))
  if (unname(Sys.info()['sysname'] == "Darwin")) {
    expect_equal(paste0("/private", unclass(f)), getwd())
  } else {
    expect_equal(unclass(f), getwd())
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
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))
  expect_error(new_factory(path = path_temp()), "already exists. Aborting.")
})