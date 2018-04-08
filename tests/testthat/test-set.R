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
