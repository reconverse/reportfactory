#' Print a punchcard object
#'
#' @export
#' @noRd
print.punchcard <- function(x, ...) {
 
  verslist <- as.list(x)
  verslist <- lapply(verslist, function(i) {
    gsub("^.+_([0-9]{4}-[0-9]{2}-[0-9]{2}).Rmd$", "\\1", i, perl = TRUE)
  })

  for (i in names(verslist)) {
    versions <- paste(verslist[[i]], collapse = '", "')
    cat(sprintf("// report \"%s\":\n", i))
    cat(sprintf("   versions: \"%s\"\n", versions))
  }

}

