context("test-zzz.R")

test_that("redact string and keep maximum 3 character", {
  expect_equal(redact_string("test"), "***")
  expect_equal(redact_string("test", redact_char = "#"), "###")
})
