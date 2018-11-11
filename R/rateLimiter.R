#' @title Initiate Timelog Environment
#' @description Initiates environment for storage of time logs for rate limit checks
#'
#' @return environment
#'
#' @examples
#' \dontrun{
#' initate_timelog()
#' }
#' @export
#'
initiate_timelog <- function() {
  crypto_log <<- new.env()
  assign("api", NULL, envir = crypto_log)
}

#' @title Check Timelog
#' @description Checks records added to the log environment in the
#' last 60 seconds for use in rate limit checks
#'
#' @return integer
#'
#' @examples
#' \dontrun{
#' check_timelog()
#' }
#' @export
#'
check_timelog <- function() {
  as.numeric(
    length(
      local(api, envir = crypto_log)[local(api, envir = crypto_log) > (Sys.time() - 60)]
      )
    )
}

#' @title Append timelog
#' @description Appends new entry to the timelog environment
#'  on execution of \code{log_rate_limit()}.
#'
#' @return timestamp
#'
#' @examples
#' \dontrun{
#' append_timelog()
#' }
#' @export
#'
append_timelog <- function() {
#  if (exists("crypto_log") == FALSE) {
#    crypto_log  <- new.env()
#    api      <- assign("api", NULL, envir = crypto_log)
#  }
  if (is.null(local(api, envir = crypto_log))) {
    api  <- local(api, envir = crypto_log)
    time <- Sys.time()
    assign("api", time, envir = crypto_log)
  } else {
    api  <- local(api, envir = crypto_log)
    time <- append(api, Sys.time(), after = length(api))
    assign("api", time, envir = crypto_log)
  }
}

#' @title Use Rate Limit
#' @description Apply rate limiter to function call which
#' stores variables inside an environment on execution to
#' ensure rate limits on API requests are adhered to.
#'
#' @param call Function to receive and apply rate limit on.
#' @param limit Integer for rate limit per minute. DEfault is 30.
#' @param verbose Logical to display progress messaging. Default is FALSE
#'
#' @return Expected output of function called
#'
#' @examples
#' \dontrun{
#' fun_function <- function(x,y) (x+y) / y
#' use_rate_limit(fun_function(6+16), 10, verbose = FALSE)
#' }
#' @export
#'
use_rate_limit <- function(call, limit = 30, verbose = FALSE) {
  execution <- FALSE
  while (execution == FALSE) {
    check   <- check_timelog()
    if (check == 0) {
      if (verbose) cat("First logging request", fill = TRUE)
      append_timelog()
    }
    if (check >= (limit - 5)) {
      if (verbose) cat(paste("Check =", check, " GT limit.. sleeping"), fill = TRUE)
      Sys.sleep(5)
    }

    check <- check_timelog()
    if (check < limit) {
      if (verbose) cat(paste("Check =", check, " Less than limit.. attempting."), fill = TRUE)
      check  <- check_timelog()
      append_timelog()
      if (verbose) cat("Logging request and attempting function", fill = TRUE)
      output <- call
      Sys.sleep(1)
      return(output)
      if (verbose) cat("Setting 'Execution' to 'TRUE'.", fill = TRUE)
      execution <- TRUE
    }
    if (verbose) cat("Waiting to execute..", fill = TRUE)
  }
  if (verbose) cat("Execution successful!", fill = TRUE)
  return(output)
}

.onLoad <- function(libname, pkgname) {
  crypto_log          <- new.env()
  crypto_log$api      <- NULL
  initiate_timelog()
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Coinmarketcap have now introduced a rate limiter on their API service. As such you may experience issues retrieving large amounts of data using crypto_history.")
  crypto_log          <- new.env()
  crypto_log$api      <- NULL
  initiate_timelog()
}
