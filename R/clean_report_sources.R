#' Clean the folder report_sources
#'
#' This function removes undesirable files and folders present in `report_sources`
#' except for:
#' * `Rmd` files
#' * `README*` files
#' * `cache/` (unless `remove_cache` is `FALSE`)
#'
#' @author Thibaut Jombart
#'
#'
#' @param factory the path to a report factory; defaults to the current working
#'   directory
#'
#' @param quiet a logical indicating if the function should throw a message if
#'   content gets removed; defaults to `FALSE`
#'
#' @param remove_cache a logical indicating if `cache` folder should be kept
#'
#' @export
#'
#' @examples
#'  
#'  odir <- getwd()
#'  setwd(tempdir())
#'  random_factory(include_examples = FALSE)
#'
#' dir.create(file.path("report_sources", "_archive"))
#'
#' ## check initial content
#' dir("report_sources", all.files = TRUE)
#'
#' ## add crap
#' crap_files <- c("toto.txt",
#'                 "#toto.Rmd#",
#'                 "toto.Rmd~",
#'                 "some_file.html",
#'                 ".hidden")
#' crap_folders <- c("figures",
#'                   "cache",
#'                   "outputs_xlsx")
#'
#' file.create(file.path("report_sources", crap_files))
#' sapply(file.path("report_sources", crap_folders), dir.create)
#'
#' ## check content with all crap
#' dir("report_sources", all.files = TRUE)
#'
#' clean_report_sources()
#'
#' ## check content after cleanup
#' dir("report_sources", all.files = TRUE)
#' setwd(odir)
#' 

clean_report_sources <- function(factory = getwd(), quiet = FALSE,
                                 remove_cache = TRUE) {

  ## The approach is is:
  
  ## 1. list all content of report_sources/
  ## 2. define regexp for protected content
  ## 3. identify protected files from regexp
  ## 4. diff with all content to identify what to remove
  ## 5. remove stuff that needs to be, with a message if needed

  ## set working directory
  validate_factory(factory, warnings = FALSE)

  odir <- getwd()
  on.exit(setwd(odir))
  setwd(factory)


  ## 1. list all content of report_sources/
  folder_content <- dir("report_sources",
                        all.files = TRUE,
                        full.names = TRUE,
                        include.dirs = TRUE)

  ## 2. define regexp for protected content
  protected <- c("report_sources/.$",
                 "report_sources/..$",
                 "report_sources/_archive$",
                 "report_sources/_archive/.*$",
                 "report_sources/README.*$",
                 "report_sources/.*[.][rR][Mm][Dd]$"
                 )

  if (!remove_cache) {
    protected <- c(protected,
                   "report_sources/cache$",
                   "report_sources/cache/.*$")
  }

  ## 3. identify protected files from regexp
  to_keep <- lapply(protected, grep, folder_content, value = TRUE)
  to_keep <- unlist(to_keep)

  ## 4. diff with all content to identify what to remove
  to_remove <- setdiff(folder_content, to_keep)  

  ## 5. remove stuff that needs to be, with a message if needed
  if (length(to_remove) > 0) {
    if (!quiet) {
      to_remove_txt <- paste(to_remove, collapse = "\n")
      msg <- paste0("The following files in `report_sources/` ",
                   "are not rmarkdown sources \nand will be removed:\n\n",
                   to_remove_txt,
                   "\n")
      message(msg)
    }
    
    unlink(to_remove, recursive = TRUE)
  }

  invisible(NULL)

}
