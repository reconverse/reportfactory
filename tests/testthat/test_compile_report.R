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
           "foo_2018-06-29.html", "outputs_base.csv")

  expect_identical(ref, outputs)
  
  base_refs <- unlist(lapply(ref, basename))
  log_entry <- readRDS(".compile_log.rds")[[1]]
  log_outputs <- unlist(lapply(log_entry$output_files, basename))
  expect_identical(base_refs, log_outputs)
})

test_that("Compilation can take params and creates dynamic file name", {
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
  
  warning_message <- "the following files in 'report_sources/' are not .Rmd"
  expect_warning(
    compile_report(report, clean_report_sources = TRUE, quiet = TRUE), 
    regexp = warning_message)
  

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

test_that("Compile logs activity in an rds file", {
  skip_on_cran()
  
  odir <- getwd()
  on.exit(setwd(odir))
  
  setwd(tempdir())
  factory_name <- "foo"
  random_factory(include_examples = TRUE)
  compile_report(list_reports(
    pattern = factory_name)[1],
    quiet = TRUE,
    params = list(other = "test"))
  
  log_file <- readRDS(".compile_log.rds")
  expect_equal(attr(log_file, "factory_name"), factory_name)
  init_time <- attr(log_file, "initialized_at")
  expect_equal(as.Date(init_time), Sys.Date())
  
  log_entry <- log_file[[1]]
  other_param <- log_entry$compile_init_env$params$other
  expect_equal(other_param, "test")
  quiet_arg <- log_entry$compile_init_env$quiet
  expect_equal(quiet_arg, TRUE)
  
  ## compiling another report to be sure the log does not remove data 
    ## or have merge issues
  dots_args <- list("lots" = data.frame(a = c(10,20)))
  compile_report(list_reports(pattern = factory_name)[1], 
                 quiet = FALSE, 
                 params = list("other" = "two",
                               "more" = list("thing" = "foo")),
                extra = dots_args)
  
  log_file <- readRDS(".compile_log.rds")
  
  log_entry <- log_file[[2]]
  other_param <- log_entry$compile_init_env$params$other
  expect_equal(other_param, "two")
  log_dots_args <- log_entry$dots$extra
  expect_equal(is.data.frame(log_dots_args$lots), TRUE)
  log_output_dir <- log_entry$output_dir
  ## Expect to have the two initalize values plus two log entries
  expect_equal(length(log_file), 2)
})

