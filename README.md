
<!-- README.md is generated from README.Rmd. Please edit that file -->

# proxyconfig

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/proxyconfig)](https://cran.r-project.org/package=proxyconfig)
[![Travis build
status](https://travis-ci.org/cderv/proxyconfig.svg?branch=master)](https://travis-ci.org/cderv/proxyconfig)
[![Coverage
status](https://codecov.io/gh/cderv/proxyconfig/branch/master/graph/badge.svg)](https://codecov.io/github/cderv/proxyconfig?branch=master)
[![License:
MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.md)

The goal of proxyconfig is to help setting the proxy interactively.

## About proxy configuration

### Why you would need to configure a proxy ?

In professional environment, there is often a proxy you need to pass
through to escape your company network. When behind this firewall of
your company, you need to first tell R that is needs to pass the proxy
before trying to reach the url and not to use it when the url you want
to access are inside the same network.

### Examples of when it is needed

For example, behind a company proxy,

  - `install.package` won’t be able to reach the cran mirror that is
    outside.
  - `download.file` won’t be able to get a file from a url
  - `httr::GET`, `curl::curl`

The first too are base R feature and have a method argument that you can
use. Different method can have different settings. Most used is
*libcurl* that is also used by httr and curl :package:.

### Some words about proxy configuration in R

Sometimes, proxy is automatically picked up by R. It is the case on
windows where R use the *wininet* method by default, for which the
‘Internet Options’, used by Internet Explorer, are used for proxy
configuration.  
On other system, proxy must be explicity configured.

You’ll find information on *Setting Proxies* in R in the
`utils::download.file()` help page: `help("download.file", package =
"utils")` or `?download.file`.

## Installation

Currently, this <f0>\<U+009F\>\<U+0093\>\<U+00A6\> is only available on
[GitHub](https://github.com/) in development version :

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

Given a proxy url, you can set the proxy interactively using
`set_proxy`. Proxy url must be of the form *scheme://hostname\[:port\]*.

``` r
proxyconfig::set_proxy(proxy = "http://proxy.mycompany.com:3939")
```

By default, this will prompt the user for authentification ( *username*
and *password* ). You can pass them in `set_proxy` argument too to use
non-interactively. **This is not advice to pass them in clear in a
script** - this is what the interactive mode with dialog box aims to
prevent.

If you don’t have any authentification on your proxy, use empty values
explicitly.

``` r
proxyconfig::set_proxy(proxy = "http://proxy.mycompany.com:3939", username = "", password = "")
```

To prevent the proxy to be used for url on internal network domain, use
`noproxy` argument. (empty by default). This useful for a github
entreprise server or an internal cran repos for examples, respectively
on `https://github.mycompany.com` and `https://cran.mycompany.com`. Both
are on the same domain - `noproxy` is configured here to look for url on
domain mycompany.com without exiting the internal pany network through
the
proxy.

``` r
proxyconfig::set_proxy(proxy = "http://proxy.mycompany.com:3939", noproxy = ".mycompany.com")
```

If several domains (or IP addresses) are necessary, they will be
concatenated
properly.

``` r
proxyconfig::set_proxy(proxy = "http://proxy.mycompany.com:3939", noproxy = c(".mycompany.com", "163.104.50.180"))
```

### How to check what is configured ?

`set_proxy()` will set the correct environment variable for the current
session. You can verify if a proxy is currently configured with
`is_proxy_activated()`

``` r
proxyconfig::is_proxy_activated()
#> [1] TRUE
```

You can have more information using `verbose = TRUE`. (Note that
authentification is hidden when printed)

``` r
proxyconfig::is_proxy_activated(TRUE)
#> **** Proxy info
#>      HTTP_PROXY: http://***:***@proxy.mycompany.com:3939/
#>     HTTPS_PROXY: http://***:***@proxy.mycompany.com:3939/
#>        NO_PROXY: .mycompany.com, 163.104.50.180
#>      http_proxy: http://***:***@proxy.mycompany.com:3939/
#>     https_proxy: http://***:***@proxy.mycompany.com:3939/
#>        no_proxy: .mycompany.com, 163.104.50.180
#> ****
#> [1] TRUE
```

### What if a proxy is already set ?

If a proxy is already set, `set_proxy` will issue a warning (and return
false invisibly)

``` r
(set_proxy(proxy =  "https://newproxy.company.com"))
#> Warning in set_proxy(proxy = "https://newproxy.company.com"): A proxy configuration is already set.
#> Please check and unset with unset_proxy() before setting a new one
#> [1] FALSE
```

You can unset a proxy configuration with `unset_proxy()`

``` r
unset_proxy(verbose = TRUE)
#> Proxy unset
#> [1] TRUE
# proxy is correctly deactivated
is_proxy_activated(TRUE)
#> [1] FALSE
```

# TODO

This is a very new package that works for me. Among the ideas I have for
improvement

  - \[ \] Use an option mechanism to make the proxy url persistent
    across sessions
  - \[ \] Use [keyring](https://github.com/r-lib/keyring) to store and
    retrieve auth accross session
  - \[ \] Make a templating system to use proxyconfig in an internal
    package. Inspiration `ghentr` and `pkgconfig`
  - \[ \] Improve console output with `cli`
  - \[ \] Create an add-on for better interactation (and keybinding)
