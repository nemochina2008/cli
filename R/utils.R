
`%||%` <- function(l, r) if (is.null(l)) r else l

make_space <- function(len) {
  strrep(" ", len)
}

strrep <- function(x, times) {
  x <- as.character(x)
  if (length(x) == 0L) return(x)
  r <- .mapply(
    function(x, times) {
      if (is.na(x) || is.na(times)) return(NA_character_)
      if (times <= 0L) return("")
      paste0(replicate(times, x), collapse = "")
    },
    list(x = x, times = times),
    MoreArgs = list()
  )

  res <- unlist(r, use.names = FALSE)
  Encoding(res) <- Encoding(x)
  res
}

is_latex_output <- function() {
  if (!("knitr" %in% loadedNamespaces())) return(FALSE)
  get("is_latex_output", asNamespace("knitr"))()
}

is_windows <-  function() {
  .Platform$OS.type == "windows"
}

apply_style <- function(text, style, bg = FALSE) {
  if (identical(text, ""))
    return(text)

  if (is.function(style)) {
    style(text)
  } else if (is.character(style)) {
    crayon::make_style(style, bg = bg)(text)
  } else if (is.null(style)) {
    text
  } else {
    stop("Not a colour name or crayon style", call. = FALSE)
  }
}

vcapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X, FUN, FUN.VALUE = character(1), ..., USE.NAMES = USE.NAMES)
}

viapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X, FUN, FUN.VALUE = integer(1), ..., USE.NAMES = USE.NAMES)
}

vlapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X, FUN, FUN.VALUE = logical(1), ..., USE.NAMES = USE.NAMES)
}

ruler <- function(width = console_width()) {
  x <- seq_len(width)
  y <- rep("-", length(x))

  y[x %% 5 == 0] <- "+"
  y[x %% 10 == 0] <- crayon::bold(as.character((x[x %% 10 == 0] %/% 10) %% 10))

  cat(y, "\n", sep = "")
  cat(x %% 10, "\n", sep = "")
}

rpad <- function(x, width = NULL) {
  if (!length(x)) return(x)
  w <- nchar(x, type = "width")
  if (is.null(width)) width <- max(w)
  paste0(x, strrep(" ", pmax(width - w, 0)))
}

lpad <- function(x, width = NULL) {
  if (!length(x)) return(x)
  w <- nchar(x, type = "width")
  if (is.null(width)) width <- max(w)
  paste0(strrep(" ", pmax(width - w, 0)), x)
}

#' @importFrom utils tail

tail_na <- function(x, n = 1) {
  tail(c(rep(NA, n), x), n)
}

#' @importFrom crayon col_substr
#' @importFrom utils head

dedent <- function(x, n = 2) {
  first_n_char <- strsplit(col_substr(x, 1, n), "")[[1]]
  n_space <- cumsum(first_n_char == " ")
  d_n_space <- diff(c(0, n_space))
  first_not_space <- head(c(which(d_n_space == 0), n + 1), 1)
  col_substr(x, first_not_space, nchar(x))
}

new_uuid <- (function() {
  cnt <- 0
  function() {
    cnt <<- cnt + 1
    paste0("cli", cnt)
  }
})()

na.omit <- function(x) {
  if (is.atomic(x)) x[!is.na(x)] else x
}
