#' CoinMarketCap Professional API Call
#'
#' @description Checks to see if keyring package is installed
#' and then if not prompts for installation
#'
#' @export
install_keyring <- function() {
  dependent_packages <- c("keyring","rstudioapi")
  message("Crypto highly recommends you install keyring to manage your API keys.", appendLF = TRUE)
  prompt <- utils::askYesNo("Install keyring?")
  if (prompt == "TRUE") {
    utils::install.packages(dependent_packages, dependencies = TRUE)
  }
}

#' CoinMarketCap Professional API Call
#'
#' @param url CoinMarketCap API URL
#' @import httr
#' @importFrom rstudioapi askForSecret
#' @importFrom jsonlite fromJSON
#' @return api results
#' @export
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
get_coinlist_api <- function() {
  id <- ""
  name <- ""
  symbol <- ""
  slug <- ""
  cmc_rank <- ""
  packages <- c(is.element("keyring", utils::installed.packages()[,1]),
                is.element("rstudioapi", utils::installed.packages()[,1]))

  if (!any(packages)) {
    install_keyring()
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
#' @description Gets updated coin listing from csv file hosted on crypto GitHub page
#' @export
get_coinlist_static <- function() {
  listings <- coin_list
  return(listings)
}
