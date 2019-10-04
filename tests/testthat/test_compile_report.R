context("Test report compilation")


test_that("Compilation can handle multiple outputs", {
  skip_on_cran()
  odir <- getwd()
  on.exit(setwd(odir))
  setwd(tempdir())
  
  random_factory(include_examples = TRUE)

  compile_report(list_reports(pattern = "foo")[1], quiet = TRUE)
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
  update_reports(render_params = 
                   list(foo = foo_value, show_stuff = TRUE, bar = letters))
  
  testthat::expect_match(
    list_outputs()[length(list_outputs())],
    paste("foo", foo_value, "show_stuff_TRUE_bar_a_b_c_d", sep = "_"))
})
