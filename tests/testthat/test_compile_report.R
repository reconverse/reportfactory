context("Test report compilation")


test_that("Compilation can handle multiple outputs", {

  skip_on_cran()

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

test_that("Compilation can handle multiple outputs", {
  
  skip_on_cran()
  
  setwd(tempdir())
  random_factory(include_examples = TRUE)
  compile_report(list_reports(
    pattern = "foo")[1], quiet = TRUE, params = list("other" = "test"))
  
  log_file <- read.csv(".compile_log.csv", stringsAsFactors = FALSE)
  
  expect_equal(log_file$other[nrow(log_file)], "test")
  expect_equal(nrow(log_file), 2)
})