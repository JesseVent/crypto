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
