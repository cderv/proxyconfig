context("test-check.R")

test_that("proxy environement variable are not set", {
  withr::with_envvar(
    c(http_proxy = NA, https_proxy = NA, no_proxy = NA),
    expect_false(is_proxy_activated(FALSE))
  )
  withr::with_envvar(
    c(http_proxy = dummy_proxy_url, https_proxy = NA, no_proxy = NA),
    expect_true(is_proxy_activated(FALSE))
  )
})

test_that("proxy environment variable are set", {
  withr::with_envvar(
    c(http_proxy = dummy_proxy_url, https_proxy = dummy_proxy_url, no_proxy = ".dummy.domain"),
    {
      expect_true(is_proxy_activated(FALSE))
      expect_message(is_proxy_activated(TRUE))
    }
  )
})

test_that("hide username and password when printing", {
 expect_identical(redacted_proxy_url("https://its:me@user.com:3434/"), "https://***:***@user.com:3434/")
 expect_identical(redacted_proxy_url("https://user.com:3434/"), "https://user.com:3434/")
})
