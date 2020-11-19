test_that("new_factory generates the right files - with templates", {
    
  odir <- getwd()
  f <- new_factory(path = tempdir(), move_in = FALSE)
  on.exit(unlink(f, recursive = TRUE))

  expect_identical(odir, getwd())
  
  expected_location <- file.path(tempdir(), "new_factory")
  
  expect_true(dir.exists(expected_location))
  expect_identical(f, expected_location)

  all_files <- list.files(
    file.path(tempdir(), "new_factory"),
    all.files = TRUE,
    recursive = TRUE,
    include.dirs = TRUE
  )
  
  expected_files <- c(
    "report_sources",
    "report_sources/example_report.Rmd",
    ".here",
    ".gitignore",
    "new_factory.Rproj",
    "README.md",
    "data",
    "data/clean",
    "data/raw",
    "scripts"
    )
    
    expect_identical(sort(expected_files), sort(all_files))
})

test_that("new_factory generates the right files - empty factory", {
  
  odir <- getwd()
  f <- new_factory(path = tempdir(), include_template = FALSE, move_in = TRUE)
  on.exit({
    unlink(f, recursive = TRUE)
    setwd(odir)
  })

  expected_location <- file.path(tempdir(), "new_factory")
  expect_true(dir.exists(expected_location))
  expect_identical(f, expected_location)
  expect_identical(f, getwd())
  
  all_files <- list.files(
    expected_location,
    all.files = TRUE,
    recursive = TRUE,
    include.dirs = TRUE
  )
  
  expected_files <- c(
    "report_sources",
    ".here",
    ".gitignore",
    "new_factory.Rproj",
    "README.md"
    )
    
    expect_identical(sort(expected_files), sort(all_files))
})
