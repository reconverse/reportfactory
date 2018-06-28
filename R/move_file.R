
## x is the path of an existing file
## tip from Rich Fitzjohn

move_file <- function(from, to) {
  dir.create(dirname(to), FALSE, TRUE)
  file.copy(from, to, overwrite = TRUE)
  unlink(from)
}
