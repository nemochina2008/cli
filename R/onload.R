
## nocov start

dummy <- function() { }

cli <- NULL

.onLoad <- function(libname, pkgname) {
  pkgenv <- environment(dummy)
  makeActiveBinding(
    "symbol",
    function() {
      ## If `cli.unicode` is set we use that
      opt <- getOption("cli.unicode",  NULL)
      if (!is.null(opt)) {
        if (isTRUE(opt)) return(symbol_utf8) else return(symbol_ascii)
      }

      ## Otherwise we try to auto-detect
      if (is_utf8_output()) {
        symbol_utf8
      } else if (is_latex_output()) {
        symbol_ascii
      } else if (is_windows()) {
        symbol_win
      } else {
        symbol_ascii
      }
    },
    pkgenv
  )
}

## nocov end
