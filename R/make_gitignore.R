#' Create a .gitignore file and write to a file
#'
#' @param file a file path
#' @return the results of writeChar()
#' @noRd
make_gitignore <- function(file) {
  ignore <- "
    # Editor files
    *.swp
    *~

    # reportfactory files
    report_outputs
  
    # History files
    .Rhistory
    .Rapp.history

    # Session Data files
    .RData

    # Example code in package build process
    *-Ex.R

    # Output files from R CMD build
    /*.tar.gz

    # Output files from R CMD check
    /*.Rcheck/

    # RStudio files
    .Rproj.user/

    # produced vignettes
    vignettes/*.html
    vignettes/*.pdf

    # OAuth2 token, see https://github.com/hadley/httr/releases/tag/v0.3
    .httr-oauth

    # knitr and R markdown default cache directories
    /*_cache/
    /cache/

    # Temporary files created by R markdown
    *.utf8.md
    *.knit.md
  "

  ignore <- gsub("\n    ", "\n", ignore)
  ignore
  writeLines(ignore, file)
}
