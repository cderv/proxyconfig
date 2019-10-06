
<!-- README.md is generated from README.Rmd. Please edit that file -->

# proxyconfig

<!-- badges: start -->

[![Azure pipelines build
status](https://img.shields.io/azure-devops/build/cderv/4dae08f7-f565-42a4-9f15-198bb572a0f9/1)](https://dev.azure.com/cderv/proxyconfig/_build/latest?definitionId=1&branchName=master)
[![Azure pipelines test
status](https://img.shields.io/azure-devops/tests/cderv/proxyconfig/1?color=brightgreen&compact_message)](https://dev.azure.com/cderv/proxyconfig/_build/latest?definitionId=1&branchName=master)
[![Azure pipelines coverage
status](https://img.shields.io/azure-devops/coverage/cderv/proxyconfig/1)](https://dev.azure.com/cderv/proxyconfig/_build/latest?definitionId=1&branchName=master)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/proxyconfig)](https://CRAN.R-project.org/package=proxyconfig)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.md)
[![Travis build
status](https://travis-ci.com/cderv/proxyconfig.svg?branch=master)](https://travis-ci.com/cderv/proxyconfig)
[![Codecov test
coverage](https://codecov.io/gh/cderv/proxyconfig/branch/master/graph/badge.svg)](https://codecov.io/gh/cderv/proxyconfig?branch=master)
<!-- badges: end -->

The goal of proxyconfig is to help setting the proxy interactively.

## About proxy configuration

### Why would you need to configure a proxy ?

In a corporate environment, there is often a proxy you need to pass
through to escape your company network. When behind this firewall of
your company, you need to first tell R that it needs to pass the proxy
before trying to reach the url and not to use it when the url you want
to access are inside the same network.

### Examples of when it is needed

For example, behind a company proxy,

  - `install.package` won’t be able to reach a cran mirror that is
    outside like `https://https://cloud.r-project.org/`
  - `download.file` won’t be able to get a file from a url
  - `httr::GET`, `curl::curl` won’t be able to be used for web url.

The first two are R base features and have a `method` argument that you
can use to help configure correctly. Different methods can have
different settings. The most used is *libcurl* that is also used by
`httr` and `curl` :package:.

### Some words about proxy configuration in R

Sometimes, proxy is automatically picked up by R. It is the case on
windows where R uses the *wininet* method by default, for which the
‘Internet Options’, from Internet Explorer or Edge, are used for proxy
configuration. On other system, proxy must often be explicity
configured.

You’ll find information about *Setting Proxies* in R in the
`utils::download.file()` help page: `help("download.file", package =
"utils")` or `?download.file`.

## Installation

Currently, this package is only available on Github in development
version :

``` r
# install.packages("devtools")
devtools::install_github("cderv/proxyconfig")
```

or using

``` r
source("https://install-github.me/cderv/proxyconfig")
```

## How to use `proxyconfig`

### How to set the proxy

Given a proxy url, you can set the proxy interactively using `set_proxy`
using `proxy` argument. Proxy url must be of the form
*scheme://hostname\[:port\]*.

``` r
proxyconfig::set_proxy(proxy = "http://proxy.mycompany.com:3939")
```

You can also use `options(proxyconfig.proxy =
"http://proxy.mycompany.com:3939")` so that it knows which url to use as
default. You can use `usethis::edit_r_profile()` to open the user
*.Rprofile* and add the option.

Then when in *.Rprofile*, you can call directly

``` r
proxyconfig::set_proxy()
```

By default if username and password not provided, this will prompt the
user for authentification. You can pass them in `set_proxy` argument too
to use non-interactively. **This is not advice to pass them in clear in
a script** - this is what the interactive mode with dialog box aims to
prevent.

If you don’t have any authentification for your proxy, use empty values
explicitly.

``` r
proxyconfig::set_proxy(proxy = "http://proxy.mycompany.com:3939", username = "", password = "")
```

To prevent the proxy to be used for url on internal network domain, use
`noproxy` argument. (empty by default). This useful for a github
entreprise server or an internal cran repos for example, respectively on
`https://github.mycompany.com` and `https://cran.mycompany.com`. Both
are on the same domain - `noproxy` is configured here to look for url on
domain mycompany.com without exiting the internal pany network through
the proxy.

``` r
proxyconfig::set_proxy(proxy = "http://proxy.mycompany.com:3939", noproxy = ".mycompany.com")
```

If several domains (or IP addresses) are necessary, they will be
concatenated properly.

``` r
proxyconfig::set_proxy(proxy = "http://proxy.mycompany.com:3939", noproxy = c(".mycompany.com", "163.104.50.180"))
```

### How to check what is configured ?

`set_proxy()` will set the correct environment variable for the current
session. You can verify if a proxy is currently configured with
`is_proxy_activated()`

``` r
proxyconfig::is_proxy_activated()
```

You can have more information using `verbose = TRUE`. (Note that
authentification is hidden when printed)

``` r
proxyconfig::is_proxy_activated(TRUE)
```

### What if a proxy is already set ?

If a proxy is already set, `set_proxy` will issue a warning (and return
false invisibly)

``` r
(proxyconfig::set_proxy(proxy =  "https://newproxy.company.com"))
```

You can unset a proxy configuration with `unset_proxy()`

``` r
proxyconfig::unset_proxy(verbose = TRUE)
# proxy is correctly deactivated
proxyconfig::is_proxy_activated(TRUE)
```

# TODO

This is a very new package that works for me. Among the ideas I have for
improvement

  - [ ] Use an option mechanism to make the proxy url persistent across
    sessions
  - [ ] Use [keyring](https://github.com/r-lib/keyring) to store and
    retrieve auth accross session
  - [ ] Make a templating system to use proxyconfig in an internal
    package. Inspiration `ghentr` and `pkgconfig`
  - [ ] Improve console output with `cli`
  - [ ] Create an add-on for better interactation (and keybinding)
