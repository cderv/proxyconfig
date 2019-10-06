library(testthat)
library(proxyconfig)

if (requireNamespace("xml2")) {
  test_check("proxyconfig", reporter = MultiReporter$new(reporters = list(JunitReporter$new(file = "test-results.xml"), CheckReporter$new())))
} else {
  test_check("proxyconfig")
}
