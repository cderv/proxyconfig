context("test-set.R")

test_that("set_proxy stop if wrong proxy", {
  expect_error(set_proxy())
  expect_error(set_proxy(proxy = NULL))
  expect_error(set_proxy(proxy = "34#YU"))
})

test_that("build_http_env correctly", {
  expect_equal(build_http_env("http://proxy-url.com:3232", "its", "me"),
               "http://its:me@proxy-url.com:3232/")
})

test_that("proxy is correctly unset", {
  withr::with_envvar(
    c(http_proxy = dummy_proxy_url, https_proxy = dummy_proxy_url, no_proxy = ".dummy.domain"),
    {
      expect_true(unset_proxy(FALSE))
      expect_identical(Sys.getenv("http_proxy", unset = "unset"), "unset")
      expect_identical(Sys.getenv("https_proxy", unset = "unset"), "unset")
      expect_identical(Sys.getenv("no_proxy", unset = "unset"), "unset")
    })
  withr::with_envvar(
    c(http_proxy = dummy_proxy_url, https_proxy = dummy_proxy_url, no_proxy = ".dummy.domain"),
    {
      expect_message(unset_proxy(TRUE), regexp = "Proxy unset", fixed = TRUE)
    }
  )
})
