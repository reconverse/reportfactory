library(fs)

test_that("test parameteriesed report output", {
  skip_if_pandoc_not_installed()
  skip_on_os("windows")

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
    "parameterised",
    f,
    params = list(test1 = "three", test2 = "four")
  )

  # check the output
  md_file <- grep("\\.md", list_outputs(f), value = TRUE)
  md_file <- path(f, "outputs", md_file)

  expect_snapshot_file(md_file, "param_report_check.md", compare = compare_file_text)
})

test_that("test ignore_case works report output", {
  skip_if_pandoc_not_installed()
  skip_on_os("windows")

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
    "parameterised.rmd",
    f,
    ignore.case = TRUE,
    params = list(test1 = "three", test2 = "four")
  )

  # check the output
  md_file <- grep("\\.md", list_outputs(f), value = TRUE)
  md_file <- path(f, "outputs", md_file)

  expect_snapshot_file(md_file, "param_report_check.md", compare = compare_file_text)

  # Should error if not case insensitive
  expect_error(
    compile_reports(
      "parameterised.rmd",
      f,
      ignore.case = FALSE,
      params = list(test1 = "three", test2 = "four")
    )
  )
})



test_that("test output folder gets recreated if not there", {
  skip_if_pandoc_not_installed()
  skip_on_os("windows")
  skip_on_os("mac")

  # create factory
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))

  # copy test reports over
  file_copy(
    path("test_reports", "parameterised.Rmd"),
    path(f, "report_sources")
  )

  # delete outputs folder
  file.remove(file.path(f, "outputs"))

  # compile report
  compile_reports(
    "parameterised",
    f,
    params = list(test1 = "three", test2 = "four")
  )

  # check the output
  md_file <- grep("\\.md", list_outputs(f), value = TRUE)
  md_file <- path(f, "outputs", md_file)

  expect_snapshot_file(md_file, "outputs_deleted_param_report_check.md", compare = compare_file_text)
})


test_that("parameteriesed report with missing param output but input", {
  skip_if_pandoc_not_installed()
  skip_on_os("windows")

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
    "parameterised",
    f,
    params = list(test2 = "four", test3 = "five")
  )

  # check the output
  md_file <- grep("\\.md", list_outputs(f), value = TRUE)
  md_file <- path(f, "outputs", md_file)

  expect_snapshot_file(md_file, "missing_param_report_check.md", compare = compare_file_text)
})

test_that("non parameteriesed report with param input", {
  skip_if_pandoc_not_installed()
  skip_on_os("windows")

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
    "simple",
    f,
    params = list(test2 = "four", test3 = "five")
  )

  # check the output
  md_file <- grep("\\.md", list_outputs(f), value = TRUE)
  md_file <- path(f, "outputs", md_file)

  expect_snapshot_file(md_file, "nonparameterised_with_params.md", compare = compare_file_text)
})

test_that("parameteriesed report with missing param (but in environment)", {
  skip_if_pandoc_not_installed()
  skip_on_os("windows")

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
    "parameterised",
    f
  )

  # check the output
  md_file <- grep("\\.md", list_outputs(f), value = TRUE)
  md_file <- path(f, "outputs", md_file)

  expect_snapshot_file(md_file, "missing_param_but_envir.md", compare = compare_file_text)
})


test_that("integer index for reports", {
  skip_if_pandoc_not_installed()
  skip_on_os("windows")

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
  compile_reports(idx, f, timestamp = "test")
  nms <- path_ext_remove(list_reports(f))[idx]
  nms <- paste(nms, collapse = "|")
  expected_files <- c(
    file.path("simple", "test", "simple.Rmd"),
    file.path("simple", "test", "simple.html"),
    file.path("simple", "test", "simple.md"),
    file.path("simple", "test", "simple_files", "figure-gfm", "pressure-1.png"),
    file.path("dimple", "test", "dimple.Rmd"),
    file.path("dimple", "test", "dimple.html"),
    file.path("dimple", "test", "dimple.md"),
    file.path("dimple", "test", "dimple_files", "figure-gfm", "pressure-1.png"),
    file.path("parameterised", "test", "parameterised.Rmd"),
    file.path("parameterised", "test", "parameterised.md")
  )
  expected_files <- expected_files[grepl(nms, expected_files)]

  output_files <- list_outputs(f)

  expect_true(all(
    mapply(
      grepl,
      pattern = sort(expected_files),
      x = sort(output_files),
      MoreArgs = list(fixed = TRUE)
    )
  ))


})


test_that("logical index for reports", {
  skip_if_pandoc_not_installed()
  skip_on_os("windows")

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
  compile_reports(idx, f, timestamp = "test")
  nms <- path_ext_remove(list_reports(f))[idx]
  nms <- paste(nms, collapse = "|")
  expected_files <- c(
    file.path("simple", "test", "simple.Rmd"),
    file.path("simple", "test", "simple.html"),
    file.path("simple", "test", "simple.md"),
    file.path("simple", "test", "simple_files", "figure-gfm", "pressure-1.png"),
    file.path("dimple", "test", "dimple.Rmd"),
    file.path("dimple", "test", "dimple.html"),
    file.path("dimple", "test", "dimple.md"),
    file.path("dimple", "test", "dimple_files", "figure-gfm", "pressure-1.png"),
    file.path("parameterised", "test", "parameterised.Rmd"),
    file.path("parameterised", "test", "parameterised.md")
  )
  expected_files <- expected_files[grepl(nms, expected_files)]


  output_files <- list_outputs(f)
  expect_true(all(
    mapply(
      grepl,
      pattern = sort(expected_files),
      x = sort(output_files),
      MoreArgs = list(fixed = TRUE)
    )
  ))

})


test_that("figures folders copied correctly reports", {
  skip_if_pandoc_not_installed()
  skip_on_os("windows")

  # create factory
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))

  # copy test reports over
  file_copy(
    path = path("test_reports", "simple_with_figures_folder.Rmd"),
    path(f, "report_sources")
  )

  file_delete(path(f, "report_sources", "example_report.Rmd"))

  # compile report
  compile_reports(factory = f, timestamp = "test")
  nms <- path_ext_remove(list_reports(f))
  nms <- paste(nms, collapse = "|")
  expected_files <- c(
    file.path("simple_with_figures_folder", "test", "simple_with_figures_folder.Rmd"),
    file.path("simple_with_figures_folder", "test", "simple_with_figures_folder.html"),
    file.path("simple_with_figures_folder", "test", "figures", "pressure-1.png")
  )
  expected_files <- expected_files[grepl(nms, expected_files)]


  output_files <- list_outputs(f)
  expect_true(all(
    mapply(
      grepl,
      pattern = sort(expected_files),
      x = sort(output_files),
      MoreArgs = list(fixed = TRUE)
    )
  ))

})


test_that("compiling with no reports errors correctly", {
  skip_if_pandoc_not_installed()
  skip_on_os("windows")

  # create factory
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))

  # delete only report present
  file_delete(path(f, "report_sources", "example_report.Rmd"))

  expect_error(
    compile_reports(factory = f),
    "No reports found in",
    fixed = TRUE
  )

})


test_that("compiling with invalid index errors correctly", {
  skip_if_pandoc_not_installed()
  skip_on_os("windows")

  # create factory
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))

  expect_error(
    compile_reports(2, factory = f),
    "Unable to match reports with the given index",
    fixed = TRUE
  )

})


test_that("compiling with incorrect report name errors correctly", {
  skip_if_pandoc_not_installed()
  skip_on_os("windows")

  # create factory
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))

  expect_error(
    compile_reports("test", factory = f),
    "Unable to find matching reports to compile",
    fixed = TRUE
  )

})


