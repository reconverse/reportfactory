test_that("test parameteriesed report output", {
  
  # create factory
  f <- new_factory(path = tempdir(), move_in = FALSE)
  on.exit(unlink(f, recursive = TRUE))
  
  # copy test reports over
  file.copy(
    file.path("test_reports", "parameterised.Rmd"),
    file.path(f, "report_sources")
  )
  
  # compile report
  compile_reports(
    f,
    "parameterised",
    params = list(test1 = "three", test2 = "four")
  )

  # check the output
  md_file <- grep("\\.md", list_outputs(f), value = TRUE)
  md_file <- file.path(f, "outputs", md_file)
  skip_on_os("windows")
  expect_snapshot_file(md_file, "param_report_check.md", binary = FALSE)
})


test_that("parameteriesed report with missing param output but input", {
  
  # create factory
  f <- new_factory(path = tempdir(), move_in = FALSE)
  on.exit(unlink(f, recursive = TRUE))
  
  # copy test reports over
  file.copy(
    file.path("test_reports", "parameterised_with_missing.Rmd"),
    file.path(f, "report_sources")
  )
  
  # compile report
  compile_reports(
    f,
    "parameterised",
    params = list(test2 = "four", test3 = "five")
  )

  # check the output
  md_file <- grep("\\.md", list_outputs(f), value = TRUE)
  md_file <- file.path(f, "outputs", md_file)
  skip_on_os("windows")
  expect_snapshot_file(md_file, "missing_param_report_check.md", binary = FALSE)
})

test_that("non parameteriesed report with param input", {
  
  # create factory
  f <- new_factory(path = tempdir(), move_in = FALSE)
  on.exit(unlink(f, recursive = TRUE))
  
  # copy test reports over
  file.copy(
    file.path("test_reports", "simple2.Rmd"),
    file.path(f, "report_sources")
  )
  
  # compile report
  compile_reports(
    f,
    "simple",
    params = list(test2 = "four", test3 = "five")
  )

  # check the output
  md_file <- grep("\\.md", list_outputs(f), value = TRUE)
  md_file <- file.path(f, "outputs", md_file)
  skip_on_os("windows")
  expect_snapshot_file(md_file, "nonparameterised_with_params.md", binary = FALSE)
})

test_that("parameteriesed report with missing param (but in environment)", {
  
  # create factory
  f <- new_factory(path = tempdir(), move_in = FALSE)
  on.exit(unlink(f, recursive = TRUE))
  
  # copy test reports over
  file.copy(
    file.path("test_reports", "parameterised_with_missing.Rmd"),
    file.path(f, "report_sources")
  )

  params = list(test2 = "four", test3 = "five")
  
  # compile report
  compile_reports(
    f,
    "parameterised"    
  )

  # check the output
  md_file <- grep("\\.md", list_outputs(f), value = TRUE)
  md_file <- file.path(f, "outputs", md_file)
  skip_on_os("windows")
  expect_snapshot_file(md_file, "missing_param_but_envir.md", binary = FALSE)
})


test_that("integer index for reports", {
  
  # create factory
  f <- new_factory(path = tempdir(), move_in = FALSE)
  on.exit(unlink(f, recursive = TRUE))
  
  # copy test reports over
  file.copy(
    from = c(
      file.path("test_reports", "simple.Rmd"),
      file.path("test_reports", "parameterised.Rmd")
    ),
    to = file.path(f, "report_sources")
  )

  file.copy(
    file.path("test_reports", "simple.Rmd"),
    file.path(f, "report_sources", "dimple.Rmd")
  )

  file.remove(file.path(f, "report_sources", "example_report.Rmd"))


  
  # compile report
  idx <- c(1, 3)
  compile_reports(f, idx)
  nms <- sub("\\.[a-zA-Z0-9]*$", "", list_reports(f))
  nms <- paste(nms[idx], collapse = "|")
  expected_files <- c(
    "simple\\/(.*)\\/simple.Rmd",
    "simple\\/(.*)\\/simple.html",
    "simple\\/(.*)\\/simple.md",
    "simple\\/(.*)\\/simple_files\\/figure-gfm\\/pressure-1.png",
    "dimple\\/(.*)\\/dimple.Rmd",
    "dimple\\/(.*)\\/dimple.html",
    "dimple\\/(.*)\\/dimple.md",
    "dimple\\/(.*)\\/dimple_files\\/figure-gfm\\/pressure-1.png",
    "parameterised\\/(.*)\\/parameterised.Rmd",
    "parameterised\\/(.*)\\/parameterised.md"
  )
  expected_files <- expected_files[grepl(nms, expected_files)]
  
  output_files <- list_outputs(f)
  expect_true(
      all(
        mapply(grepl, pattern = sort(expected_files), x = sort(output_files))
      )
    )

})


test_that("logical index for reports", {
  
  # create factory
  f <- new_factory(path = tempdir(), move_in = FALSE)
  on.exit(unlink(f, recursive = TRUE))
  
  # copy test reports over
  file.copy(
    from = c(
      file.path("test_reports", "simple.Rmd"),
      file.path("test_reports", "parameterised.Rmd")
    ),
    to = file.path(f, "report_sources")
  )

  file.copy(
    file.path("test_reports", "simple.Rmd"),
    file.path(f, "report_sources", "dimple.Rmd")
  )

  file.remove(file.path(f, "report_sources", "example_report.Rmd"))


  
  # compile report
  idx <- c(TRUE, FALSE)
  compile_reports(f, idx)
  nms <- sub("\\.[a-zA-Z0-9]*$", "", list_reports(f))
  nms <- paste(nms[idx], collapse = "|")
  expected_files <- c(
    "dimple\\/(.*)\\/dimple.Rmd",
    "dimple\\/(.*)\\/dimple.html",
    "dimple\\/(.*)\\/dimple.md",
    "dimple\\/(.*)\\/dimple_files\\/figure-gfm\\/pressure-1.png",
    "simple\\/(.*)\\/simple.Rmd",
    "simple\\/(.*)\\/simple.html",
    "simple\\/(.*)\\/simple.md",
    "simple\\/(.*)\\/simple_files\\/figure-gfm\\/pressure-1.png",
    "parameterised\\/(.*)\\/parameterised.Rmd",
    "parameterised\\/(.*)\\/parameterised.md"
  )
  expected_files <- expected_files[grepl(nms, expected_files)]
  
  output_files <- list_outputs(f)
  expect_true(
      all(
        mapply(grepl, pattern = sort(expected_files), x = sort(output_files))
      )
    )

})
