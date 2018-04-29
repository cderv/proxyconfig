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
  http_proxy <- Sys.getenv("HTTP_PROXY", unset = "")
  https_proxy <- Sys.getenv("HTTPS_PROXY", unset = "")
  no_proxy <- Sys.getenv("NO_PROXY", unset = "")
  all_empty <- vapply(list(http_proxy, https_proxy, no_proxy),
                      function(x) x == "",
                      TRUE)
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
