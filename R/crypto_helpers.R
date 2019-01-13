#' CoinMarketCap Professional API Call
#'
#' @param url CoinMarketCap API URL
#' @importFrom httr "content" "GET" "add_headers" "accept_json"
#' @importFrom rstudioapi askForSecret
#' @importFrom jsonlite fromJSON
#' @return api results
#' @export
#' @examples
#' \dontrun{
#' cmc_api("https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest")
#' }
cmc_api  <- function(url) {
  jsonlite::fromJSON(
    httr::content(
      httr::GET(url, httr::add_headers(
        "X-CMC_PRO_API_KEY" = rstudioapi::askForSecret("coinmarketcap-apikey")),
        httr::accept_json()), "text"))
}

#' Get Updated Coinlist
#' @description Gets updated coin listing from CoinMarketCap professional API
#' and prompts user to provide CMC API key using the keyring package.
#' @importFrom dplyr select
#' @export
#' @return dataframe
#' @examples
#' \dontrun{
#' get_coinlist_api()
#'  }
get_coinlist_api <- function() {
  id <- ""
  name <- ""
  symbol <- ""
  slug <- ""
  cmc_rank <- ""
  packages <- c(is.element("keyring", utils::installed.packages()[,1]),
                is.element("rstudioapi", utils::installed.packages()[,1]))

  if (!any(packages)) {
    message("Crypto highly recommends you install keyring `install.packages(\"keyring\")` to manage your API keys.", appendLF = TRUE)
  }

  base     <- "https://pro-api.coinmarketcap.com"
  endpoint <- "/v1/cryptocurrency/listings/latest"
  params   <- "?start=1&limit=5000&convert=USD"
  url      <- paste0(base, endpoint, params)

  listings <- cmc_api(url)$data %>%
    as.data.frame() %>%
    dplyr::select(id, name, symbol, slug, cmc_rank)
  names(listings) <- c("id","name","symbol","slug","rank")
  return(listings)
}

#' Get Updated Coinlist
#' @description Gets updated coin listing from local data
#' @export
#' @return dataframe
#' @examples
#' \dontrun{
#' get_coinlist_static()
#'  }
get_coinlist_static <- function() {
  listings <- coin_list
  return(listings)
}

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
#' \dontrun{
#' sys_locale <- Sys.getlocale(category = "LC_TIME")
#' replace_encoding(sys_locale)
#' }
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
#' \dontrun{
#' sys_locale <- Sys.getlocale(category = "LC_TIME")
#' reset_encoding(sys_locale)
#' }
reset_encoding <- function(sys_locale) {
  reset_enc <- sys_locale
  if (Sys.getlocale(category = "LC_TIME") != sys_locale) {
    message("Resetting to your local encoding standard.", appendLF = TRUE)
    reset_enc <-
      Sys.setlocale(category = "LC_ALL", locale = sys_locale)
  }
  return(reset_enc)
}

#' Platform Locale
#'
#' Helper function to identify locale to use for date encoding
#' based on source platform being unix based or windows
#'
#' @return locale
#' @export
#'
#' @examples {
#' platform_locale()
#' }
platform_locale <- function() {
  sys_os <- .Platform$OS.type
  locale <- ifelse(sys_os == "unix", "en_US.UTF-8", "English_United States.1252")
  return(locale)
}

