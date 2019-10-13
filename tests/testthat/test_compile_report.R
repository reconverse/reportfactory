context("Test report compilation")


test_that("Compilation can handle multiple outputs", {
  skip_on_cran()
  odir <- getwd()
  on.exit(setwd(odir))
  
  setwd(tempdir())
  random_factory(include_examples = TRUE)

  compile_report(list_reports(pattern = "foo")[1], quiet = TRUE, other = "test")
  outputs <- sub("([[:alnum:]_-]+/){2}", "",
                     list_outputs())

  outputs <- sort(outputs)
  ref <- c("figures/boxplots-1.pdf", "figures/boxplots-1.png",
           "figures/violins-1.pdf", "figures/violins-1.png",
           "foo_2018-06-29.html", "outputs_base.csv" )

  expect_identical(ref, outputs)
})

test_that("Compilation can take params and pass to markdown::render", {
  skip_on_cran()
  odir <- getwd()
  on.exit(setwd(odir))

  setwd(tempdir())
  factory <- random_factory(include_examples = TRUE)
  report <- list_reports(pattern = "foo")[1]
  
  foo_value <- "testzfoo"
  update_reports(params = 
                   list(foo = foo_value, show_stuff = TRUE, bar = letters))
  
  expect_match(
    list_outputs()[length(list_outputs())],
    paste("foo", foo_value, "show_stuff_TRUE_bar_a_b_c_d", sep = "_"))
})

test_that("`clean_report_sources = TRUE` removes unprotected non Rmd files", {
  # tests the following criteria:
    # 1. IMPORTANT: A deeply nested .Rmd file AND its directories are not,
        # removed, including in nested directories
    # 2. Files that are not .Rmd are removed
    # 3. Empty directories are removed
  skip_on_cran()
  odir <- getwd()
  on.exit(setwd(odir))
  
  setwd(tempdir())
  random_factory(include_examples = TRUE)
  
  csv1_filename <- "report_sources/other_stuff/bad_csv.csv"
  write.csv(data.frame(trash = "file"), csv1_filename)
  
  nested_dir <- "report_sources/another_one"
  dir.create(nested_dir)
  csv2_filename <- "report_sources/another_one/bad_csv2.csv"
  write.csv(data.frame(another = "file"), csv2_filename)
  
  protected_dir <- "report_sources/contacts/x"
  dir.create(protected_dir)
  protected_dir <- "report_sources/contacts/x/protected_dir"
  dir.create(protected_dir)
  moved_report <- list_reports(pattern = "contacts")[1]
  protected_filename <- "report_sources/contacts/x/protected_dir/important.Rmd"
  file.rename(paste0(getwd(), "/report_sources/contacts/", moved_report),
              paste0(getwd(), "/", protected_filename))

  empty_dirname <- "report_sources/empty_dir"
  empty_dir <- dir.create(empty_dirname)
  
  orig_source_files <- list.files("report_sources", include.dirs = TRUE,
                                 all.files = TRUE, recursive = TRUE)
  
  report <- list_reports(pattern = "foo")[1]
  compile_report(report, clean_report_sources = TRUE)
  # compile_report(report)
  
  clean_source_files <- list.files("report_sources", include.dirs = TRUE,
                                      all.files = TRUE, recursive = TRUE)
  clean_source_files
  removed <- setdiff(orig_source_files, clean_source_files)
  removed <- paste0("report_sources/", removed)
  to_remove <- c(nested_dir, csv2_filename, empty_dirname,  csv1_filename)
  expect_equal(length(removed), length(to_remove))
  expect_setequal(to_remove, removed)
  expect_equal(file.exists(protected_filename), TRUE)
})

test_that("Logging can handle multiple outputs", {
  
  skip_on_cran()
  
  setwd(tempdir())
  random_factory(include_examples = TRUE)
  compile_report(list_reports(
    pattern = "foo")[1], quiet = TRUE, params = list("other" = "test"))
  
  log_file <- rio::import(".compile_log.xlsx")
  
  expect_equal(log_file$params.other[nrow(log_file)], "test")
  expect_equal(log_file$quiet[nrow(log_file)], "TRUE")
  expect_equal(nrow(log_file), 2)
  
  # compiling another report to be sure the log does not remove data
  compile_report(list_reports(
    pattern = "foo")[1], quiet = FALSE, params = list("other" = "test", "more" = list("things", "foo")))
  
  log_file <- rio::import(".compile_log.xlsx")
  
  expect_equal(log_file$params.other[nrow(log_file)], "test")
  expect_equal(nrow(log_file), 3)
})
