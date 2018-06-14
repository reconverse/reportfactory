
## Locate the directory of a file

locate_file_directory <- function(x) {
  sub("[^/]+$", "", x)
}
