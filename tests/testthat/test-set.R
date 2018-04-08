context("test-set.R")

test_that("build_http_env correctly", {
  expect_equal(build_http_env("http://proxy-url.com:3232", "its", "me"),
               "http://its:me@proxy-url.com:3232/")
})
