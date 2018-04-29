#' Ask interactively for authentification
#'
#' This will use if available in this order
#' + RStudio IDE prompt
#' + Console input
#'
#'
#' @param prompt text prompt to user
#'
#' @return _invisibly_ the input of the user
#' @export
#'
#' @examples
#' if (interactive()) {
#'  pwd <- read_password("password")
#' }
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
  invisible(pwd)
}
