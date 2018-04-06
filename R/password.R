read_password <- function(prompt) {
  if (requireNamespace("rstudioapi", quietly = T)) {
    pwd <- rstudioapi::askForPassword(prompt)
  } else if (exists(".rs.askForPassword")) {
    pwd <- .rs.askForPassword(prompt)
  } else {
    pwd <- readline(prompt)
  }
  if (is.null(pwd)) {
    message("Cancelled operation")
    return(NULL)
  }
  pwd
}
