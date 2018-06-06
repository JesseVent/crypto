#' Check locale encoding
#'
#' Helper function to ensure encoding is UTF-8
#'
#' @param sys_locale string system locale
#' @return Sets system variable to UTF-8
#'
#' @export
#' @name replace_encoding
#'
#' @examples
#' sys_locale <- Sys.getlocale(category = "LC_TIME")
#' replace_encoding(sys_locale)
#'
replace_encoding <- function(sys_locale) {
  new_locale <- "en_US.UTF-8"
  if (!endsWith(sys_locale, "UTF-8")) {
    if (!endsWith(sys_locale, "1252")) {
      msg <-
        paste(
          "Temporarily changing locale encoding from",
          sys_locale,
          "to UTF-8. Will reset back to",
          sys_locale
        )
      warning(msg, call. = TRUE, immediate. = TRUE)
      sys_os <- .Platform$OS.type
      ifelse(
        sys_os == "unix",
        new_locale <-
          Sys.setlocale(category = "LC_ALL", locale = "en_US.UTF-8"),
        new_locale <-
          Sys.setlocale(category = "LC_ALL", locale = "English_United States.1252")
      )
    }
  }
  return(new_locale)
}

#' Reset locale encoding
#'
#' Helper function to reset encoding from UTF-8 back
#' to R sessions original locale value.
#'
#' @param sys_locale string Original system locale
#' @return Sets locale back to original value
#'
#' @export
#' @name reset_encoding
#'
#' @examples
#' sys_locale <- Sys.getlocale(category = "LC_TIME")
#' reset_encoding(sys_locale)
#'
reset_encoding <- function(sys_locale) {
  reset_enc <- sys_locale
  if (Sys.getlocale(category = "LC_TIME") != sys_locale) {
    message("Resetting to your local encoding standard.", appendLF = TRUE)
    reset_enc <-
      Sys.setlocale(category = "LC_ALL", locale = sys_locale)
  }
  return(reset_enc)
}

#' Installs all dependant packages
#'
#' Helper function to install dependencies
#'
#' @return dependant packages
#' @export
#' @name repair_dependencies
#' @examples
#' \dontrun{
#' # Fix dependency issues by reinstalling all
#' fix_crypto <- repair_dependencies()
#' }
repair_dependencies <- function() {
  dependent_packages <-
    c(
      "Rcpp",
      "tidyselect",
      "rlang",
      "dplyr",
      "parallel",
      "iterators",
      "tibble",
      "purrr",
      "glue",
      "pillar",
      "zoo",
      "bindr",
      "lattice",
      "stringr",
      "xts",
      "grid",
      "yaml",
      "doSNOW",
      "tidyr",
      "stringi",
      "jsonlite",
      "pkgconfig",
      "magrittr",
      "R6",
      "httr",
      "tools",
      "snow",
      "assertthat",
      "bindrcpp",
      "codetools",
      "compiler",
      "lubridate",
      "curl",
      "xml2",
      "rvest",
      "foreach"
    )
  message("Crypto must install the following packages: ", appendLF = TRUE)
  message(paste0(dependent_packages, ", "), appendLF = TRUE)
  prompt <- utils::askYesNo("Install dependant packages?")
  if (prompt == "TRUE") {
    utils::install.packages(dependent_packages, dependencies = TRUE)
  }
  return(dependent_packages)
}
