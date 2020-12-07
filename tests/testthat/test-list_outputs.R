library(fs)

test_that("list_output works with nested and unnested files", {
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

  compile_reports(f)
  output_files <- list_outputs(f)
  expected_files <- c(
    "simple\\/(.*)\\/simple.Rmd",
    "simple\\/(.*)\\/simple.html",
    "simple\\/(.*)\\/simple.md",
    "simple\\/(.*)\\/simple_files\\/figure-gfm\\/pressure-1.png",
    "nested\\/parameterised\\/(.*)\\/parameterised.Rmd",
    "nested\\/parameterised\\/(.*)\\/parameterised.md"
    )

    expect_true(
      all(
        mapply(grepl, pattern = sort(expected_files), x = sort(output_files))
      )
    )


    output_files <- list_outputs(f, "simple")
    expected_files <- c(
      "simple\\/(.*)\\/simple.Rmd",
      "simple\\/(.*)\\/simple.html",
      "simple\\/(.*)\\/simple.md",
      "simple\\/(.*)\\/simple_files\\/figure-gfm\\/pressure-1.png"
    )

    expect_true(
      all(
        mapply(grepl, pattern = sort(expected_files), x = sort(output_files))
      )
    )
})


test_that("list_output works, one file compiled", {
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))

  # copy test reports over
  nested_dir <- path(f, "report_sources", "nested")
  dir_create(nested_dir)
  file_copy(
    path("test_reports", "parameterised.Rmd"),
    nested_dir
  )

  compile_reports(f, "parameterised")
  output_files <- list_outputs(f)
  expected_files <- c(
    "nested\\/parameterised\\/(.*)\\/parameterised.Rmd",
    "nested\\/parameterised\\/(.*)\\/parameterised.md"
    )

    expect_true(
      all(
        mapply(grepl, pattern = sort(expected_files), x = sort(output_files))
      )
    )
})


test_that("list_output works, with subfolders", {
  f <- new_factory(path = path_temp(), move_in = FALSE)
  on.exit(dir_delete(f))

  # copy test reports over
  nested_dir <- path(f, "report_sources", "nested")
  dir_create(nested_dir)
  file_copy(
    path("test_reports", "parameterised.Rmd"),
    nested_dir
  )

  compile_reports(f, "parameterised", subfolder = "bob")
  output_files <- list_outputs(f)
  expected_files <- c(
    "nested\\/parameterised\\/bob\\/(.*)\\/parameterised.Rmd",
    "nested\\/parameterised\\/bob\\/(.*)\\/parameterised.md"
    )

    expect_true(
      all(
        mapply(grepl, pattern = sort(expected_files), x = sort(output_files))
      )
    )
})
