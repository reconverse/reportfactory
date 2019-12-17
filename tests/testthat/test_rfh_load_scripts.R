context("Helper function to load scripts: rfh_load_scripts")


## NULL test: check that messages are okay when nothing to load

test_that("rfh_load_scripts works in the absence of scripts", {
  
  skip_on_cran()

  odir <- getwd()
  random_factory()
  
  expect_message(rfh_load_scripts(), "No `.R` files in `scripts/`", fixed = FALSE)    
  expect_message(rfh_load_scripts(), "No `.R` files in `src/`", fixed = FALSE)    

  setwd(odir)
  
  })




## test loading of a script in scripts/
## - test messages
## - test that the script has been loaded using a toy variable

test_that("rfh_load_scripts loads scripts in /scripts", {
  
  skip_on_cran()

  odir <- getwd()
  random_factory()
  
  ## create scripts
  if (!dir.exists("scripts")) {
    dir.create("scripts")
  }
  toto_value <- round(runif(1), 5)
  cat(sprintf("toto <- %f", toto_value),
      file = "scripts/toto.R", append = FALSE)
  
  expect_message(rfh_load_scripts(), "Loading the following `.R`  files in `scripts/`", fixed = FALSE)    
  expect_message(rfh_load_scripts(), "toto.R", fixed = FALSE)    
  expect_message(rfh_load_scripts(), "No `.R` files in `src/`", fixed = FALSE)    

  expect_identical(toto, toto_value)
  
  setwd(odir)
  
})





## test loading of a script in src/
## - test messages
## - test that the script has been loaded using a toy variable

test_that("rfh_load_scripts loads scripts in /src", {
  
  skip_on_cran()

  odir <- getwd()
  random_factory()
  
  ## create src
  if (!dir.exists("src")) {
    dir.create("src")
  }
  titi_value <- round(runif(1), 5)
  cat(sprintf("titi <- %f", titi_value),
      file = "src/titi.R", append = FALSE)
  
  expect_message(rfh_load_scripts(), "Loading the following `.R`  files in `src/`", fixed = FALSE)    
  expect_message(rfh_load_scripts(), "titi.R", fixed = FALSE)    
  expect_message(rfh_load_scripts(), "No `.R` files in `scripts/`", fixed = FALSE)    

  expect_identical(titi, titi_value)

  setwd(odir)
  
})







## test that loaded objects are in the parent environment
## - test messages
## - test that the script has been loaded using a toy variable
## - test that the loaded objects are in the parent environment, by calling
##   `rfh_load_scripts` from within a function; the object defined in the loaded
##   scripts should only be present in the function's environment

test_that("rfh_load_scripts loads scripts in the right environment", {
  
  skip_on_cran()

  odir <- getwd()
  random_factory()
  
  ## create src
  if (!dir.exists("src")) {
    dir.create("src")
  }
  titi_value <- round(runif(1), 5)
  cat(sprintf("titi <- %f", titi_value),
      file = "src/titi.R", append = FALSE)

  f <- function(...) {
    rfh_load_scripts(...)
    as.list(environment())
  }
  
  expect_message(f(), "Loading the following `.R`  files in `src/`", fixed = FALSE)    
  expect_message(f(), "titi.R", fixed = FALSE)    
  expect_message(f(), "No `.R` files in `scripts/`", fixed = FALSE)    

  expect_identical(f(quiet = TRUE)$titi, titi_value)
  expect_false(exists("titi"))
  
  setwd(odir)
  
})
