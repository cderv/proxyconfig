

check_proxy <- function(proxy) {
  if (length(proxy) == 0) return(FALSE)
  # check for <url(:port)>
  grepl("^http(s)?://[a-zA-Z0-9\\.-]+(:[0-9]+)?$", proxy, perl = TRUE)
}

