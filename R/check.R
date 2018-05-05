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
#'   is_proxy_activated(verbose = TRUE)
#'
#' @export
is_proxy_activated <- function(verbose = FALSE) {
  proxy_env <- c("HTTP_PROXY", "HTTPS_PROXY", "NO_PROXY")
  # use also http_proxy, https_proxy and no_proxy
  proxy_env <- c(proxy_env, tolower(proxy_env))
  set_proxy_env <- purrr::set_names(purrr::map_chr(proxy_env, Sys.getenv, unset = NA_character_), proxy_env)
  all_empty <- purrr::map_lgl(set_proxy_env, ~ identical(.x, NA_character_))
  if (all(all_empty)) return(FALSE)
  if (verbose) {
    # redact auth if print is asked
    redacted_proxy_url <- function(proxy_url) {
      parsed_url <- httr::parse_url(proxy_url)
      redacted_proxy <- modifyList(
        parsed_url,
        list(
          username = redact_string(parsed_url$username),
          password = redact_string(parsed_url$password)
        )
      )
      httr::build_url(redacted_proxy)
    }
    msg <- glue::glue(
      "***** Proxy Info",
      "  HTTP_PROXY: { redacted_http }",
      "  HTTPS_PROXY: { redacted_https }",
      "  NO_PROXY: { no_proxy }",
      "*****",
      .sep = "\n",
      no_proxy = no_proxy,
      redacted_http = redacted_proxy_url(http_proxy),
      redacted_https = redacted_proxy_url(https_proxy)
    )
    message(msg)
  }
  TRUE
}
