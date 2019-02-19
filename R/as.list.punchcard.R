#' convert a punchcard object to a list
#'
#' @param x a punchcard object
#'
#' @return a list
#'
#' @export
#' @examples
#'
#' x <- c("contacts_2019-02-19.Rmd", "linelist_2019-01-31.Rmd", "linelist_2019-02-19.Rmd")
#' class(x) <- "punchcard"
#' x
#' as.list(x)
as.list.punchcard <- function(x) {

  the_reports <- gsub("(^.+)_[0-9]{4}-[0-9]{2}-[0-9]{2}.Rmd$", "\\1", x, perl = TRUE)

  verslist <- split(x, the_reports)

  verslist
}
