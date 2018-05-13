#' Check if proxy url is valid
#'
#' Checked against perl regex `"^http(s)?://[a-zA-Z0-9\\.-]+(:[0-9]+)?$"`
#'
#' @param proxy a character
#'
#' @return `TRUE` if proxy is valide
#' @keywords internal
#' @examples
#' \dontrun{
#' check_proxy("http://10.132.23.444:3232")
#' }
check_proxy <- function(proxy) {
  if (length(proxy) == 0) return(FALSE)
  # check for <url(:port)>
  grepl("^http(s)?://[a-zA-Z0-9\\.-]+(:[0-9]+)?$", proxy, perl = TRUE)
}

