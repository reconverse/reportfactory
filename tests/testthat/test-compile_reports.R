library(fs)

test_that("test parameteriesed report output", {
  
  # create factory
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))
  
  # copy test reports over
  file_copy(
    path("test_reports", "parameterised.Rmd"),
    path(f, "report_sources")
  )
  
  # compile report
  compile_reports(
    f,
    "parameterised",
    params = list(test1 = "three", test2 = "four")
  )

  # check the output
  md_file <- grep("\\.md", list_outputs(f), value = TRUE)
  md_file <- path(f, "outputs", md_file)
  skip_on_os("windows")
  expect_snapshot_file(md_file, "param_report_check.md", binary = FALSE)
})


test_that("parameteriesed report with missing param output but input", {
  
  # create factory
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))
  
  # copy test reports over
  file_copy(
    path("test_reports", "parameterised_with_missing.Rmd"),
    path(f, "report_sources")
  )
  
  # compile report
  compile_reports(
    f,
    "parameterised",
    params = list(test2 = "four", test3 = "five")
  )

  # check the output
  md_file <- grep("\\.md", list_outputs(f), value = TRUE)
  md_file <- path(f, "outputs", md_file)
  skip_on_os("windows")
  expect_snapshot_file(md_file, "missing_param_report_check.md", binary = FALSE)
})

test_that("non parameteriesed report with param input", {
  
  # create factory
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))
  
  # copy test reports over
  file_copy(
    path("test_reports", "simple2.Rmd"),
    path(f, "report_sources")
  )
  
  # compile report
  compile_reports(
    f,
    "simple",
    params = list(test2 = "four", test3 = "five")
  )

  # check the output
  md_file <- grep("\\.md", list_outputs(f), value = TRUE)
  md_file <- path(f, "outputs", md_file)
  skip_on_os("windows")
  expect_snapshot_file(md_file, "nonparameterised_with_params.md", binary = FALSE)
})

test_that("parameteriesed report with missing param (but in environment)", {
  
  # create factory
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))
  
  # copy test reports over
  file_copy(
    path("test_reports", "parameterised_with_missing.Rmd"),
    path(f, "report_sources")
  )

  params = list(test2 = "four", test3 = "five")
  
  # compile report
  compile_reports(
    f,
    "parameterised"    
  )

  # check the output
  md_file <- grep("\\.md", list_outputs(f), value = TRUE)
  md_file <- path(f, "outputs", md_file)
  skip_on_os("windows")
  expect_snapshot_file(md_file, "missing_param_but_envir.md", binary = FALSE)
})


test_that("integer index for reports", {
  
  # create factory
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))
  
  # copy test reports over
  file_copy(
    path = c(
      path("test_reports", "simple.Rmd"),
      path("test_reports", "parameterised.Rmd")
    ),
    path(f, "report_sources")
  )

  file_copy(
    path("test_reports", "simple.Rmd"),
    path(f, "report_sources", "dimple.Rmd")
  )

  file_delete(path(f, "report_sources", "example_report.Rmd"))


  
  # compile report
  idx <- c(1, 3)
  compile_reports(f, idx)
  nms <- path_ext_remove(list_reports(f))[idx] 
  nms <- paste(nms, collapse = "|")
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
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))
  
  # copy test reports over
  file_copy(
    path = c(
      path("test_reports", "simple.Rmd"),
      path("test_reports", "parameterised.Rmd")
    ),
    path(f, "report_sources")
  )

  file_copy(
    path("test_reports", "simple.Rmd"),
    path(f, "report_sources", "dimple.Rmd")
  )

  file_delete(path(f, "report_sources", "example_report.Rmd"))


  
  # compile report
  idx <- c(TRUE, FALSE)
  compile_reports(f, idx)
  nms <- path_ext_remove(list_reports(f))[idx] 
  nms <- paste(nms, collapse = "|")
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


