#' Verify if a proxy is configured
#'
#' This checks for any set environment variable relevant to proxy
#'
#' @param verbose if `TRUE` will print a summary of configuration. Authentification
#'   is redacted for printing
#'
#' @return `TRUE` is a proxy is configured. `FALSE` otherwise.
#'
#' @examples
#' \dontrun{
#'   is_proxy_activated(verbose = TRUE)
#' }
#' @export
is_proxy_activated <- function(verbose = FALSE) {
  proxy_env <- c("HTTP_PROXY", "HTTPS_PROXY", "NO_PROXY")
  # use also http_proxy, https_proxy and no_proxy
  proxy_env <- c(proxy_env, tolower(proxy_env))
  set_proxy_env <- purrr::set_names(purrr::map(proxy_env, Sys.getenv, unset = NA_character_), proxy_env)
  all_empty <- purrr::map_lgl(set_proxy_env, ~ identical(.x, NA_character_))
  if (all(all_empty)) return(FALSE)
  if (verbose) {
    # filter http env proxy from no_proxy
    http_env <- grepl("^HTTP", names(set_proxy_env), ignore.case = TRUE)
    # hide username and password
    http_env_redacted <- purrr::modify_if(set_proxy_env, http_env, redacted_proxy_url)
    msg <- glue::glue("
                      **** Proxy info
                           HTTP_PROXY: {HTTP_PROXY}
                          HTTPS_PROXY: {HTTPS_PROXY}
                             NO_PROXY: {NO_PROXY}
                           http_proxy: {http_proxy}
                          https_proxy: {https_proxy}
                             no_proxy: {no_proxy}
                      ****
                      ",
                      .envir = http_env_redacted,
                      .na = "<unset>", .sep = "\n")
    message(msg)
  }
  TRUE
}

# when printing proxy, redact auth with three star
redacted_proxy_url <- function(proxy_url) {
  parsed_url <- httr::parse_url(proxy_url)
  parsed_url$username <- if (!is.null(parsed_url$username)) "***"
  parsed_url$password <- if (!is.null(parsed_url$password)) "***"
  httr::build_url(parsed_url)
}
