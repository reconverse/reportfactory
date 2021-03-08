library(fs)

test_that("list_output works with nested and unnested files", {
  skip_if_pandoc_not_installed()
  skip_on_os("windows")
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))

  # copy test reports over
  file_copy(
    path("test_reports", "simple.Rmd"),
    path(f, "report_sources")
  )
  nested_dir <- path(f, "report_sources", "nested")
  dir_create(nested_dir)
  file_copy(
    path("test_reports", "parameterised.Rmd"),
    nested_dir
  )

  # remove the other example report
  file_delete(path(f, "report_sources", "example_report.Rmd"))

  compile_reports(factory = f, timestamp = "test")
  output_files <- list_outputs(f)
  expected_files <- c(
    file.path("simple", "test", "simple.Rmd"),
    file.path("simple", "test", "simple.html"),
    file.path("simple", "test", "simple.md"),
    file.path("simple", "test", "simple_files", "figure-gfm", "pressure-1.png"),
    file.path("nested", "parameterised", "test", "parameterised.Rmd"),
    file.path("nested", "parameterised", "test", "parameterised.md")
  )

  expect_true(all(
    mapply(
      grepl,
      pattern = sort(expected_files),
      x = sort(output_files),
      MoreArgs = list(fixed = TRUE)
    )
  ))

  output_files <- list_outputs(f, "simple")
  expected_files <- c(
    file.path("simple", "test", "simple.Rmd"),
    file.path("simple", "test", "simple.html"),
    file.path("simple", "test", "simple.md"),
    file.path("simple", "test", "simple_files", "figure-gfm", "pressure-1.png")
  )

   expect_true(all(
    mapply(
      grepl,
      pattern = sort(expected_files),
      x = sort(output_files),
      MoreArgs = list(fixed = TRUE)
    )
  ))
})


test_that("list_output works, one file compiled", {
  skip_if_pandoc_not_installed()
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))

  # copy test reports over
  nested_dir <- path(f, "report_sources", "nested")
  dir_create(nested_dir)
  file_copy(
    path("test_reports", "parameterised.Rmd"),
    nested_dir
  )

  compile_reports(factory = f, "parameterised", timestamp = "test")
  output_files <- list_outputs(f)
  expected_files <- c(
    file.path("nested", "parameterised", "test", "parameterised.Rmd"),
    file.path("nested", "parameterised", "test", "parameterised.md")
  )

  expect_true(all(
    mapply(
      grepl,
      pattern = sort(expected_files),
      x = sort(output_files),
      MoreArgs = list(fixed = TRUE)
    )
  ))

})


test_that("list_output works, with subfolders", {
  skip_if_pandoc_not_installed()
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))

  # copy test reports over
  nested_dir <- path(f, "report_sources", "nested")
  dir_create(nested_dir)
  file_copy(
    path("test_reports", "parameterised.Rmd"),
    nested_dir
  )

  compile_reports(factory = f, "parameterised", timestamp = "test", subfolder = "bob")
  output_files <- list_outputs(f)
  expected_files <- c(
    file.path("nested", "parameterised", "bob", "test", "parameterised.Rmd"),
    file.path("nested", "parameterised", "bob", "test", "parameterised.md")
  )

  expect_true(all(
    mapply(
      grepl,
      pattern = sort(expected_files),
      x = sort(output_files),
      MoreArgs = list(fixed = TRUE)
    )
  ))
})
