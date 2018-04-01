read_Password <- function(prompt) {
  if (requireNamespace("rstudioapi", quietly = T)) {
    pwd <- rstudioapi::askForPassword(prompt)
  } else if (exists(".rs.askForPassword")) {
    pwd <- .rs.askForPassword(prompt)
  } else {
    pwd <- readline(prompt)
  }
  return(pwd)
}
