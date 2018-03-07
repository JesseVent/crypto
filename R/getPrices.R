#' @title Get current crypto currency prices
#' @description This will retrieve the current market prices from CoinMarketCap. Data gets refreshed every 5 minutes.
#' @param coin Token name, default is all, Default: NULL
#' @param limit Return top n coins, default is all, Default: 0
#' @param currency Convert into local currency. Must be one of "AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PKR", "PLN", "RUB", "SEK", "SGD", "THB", "TRY", "TWD", "ZAR", Default: NULL
#' @return Will provide data frame of current prices
#' @details Updated every 5 minutes
#' @examples {
#' kin_price <- getPrices("kin")
#' }
#' @rdname getPrices
#' @export
#' @importFrom jsonlite read_json
#' @importFrom magrittr %>%
#' @import tidyr
getPrices <- function(coin = NULL, limit = 0, currency = NULL) {
options(scipen = 999)
url <- "https://api.coinmarketcap.com/v1/ticker/"
if (is.null(coin)) {
 url    <- paste0(url, "?limit=", limit)
}
if (!is.null(coin)) {
  url  <- paste0(url, coin, "/")
  }
if (!is.null(currency)) {
  currency <- toupper(currency)

  if (is.null(coin)) {
    url  <- paste0(url, "&convert=", currency)
  }
  if (!is.null(coin)) {
    url  <- paste0(url, "?convert=", currency)
  }
  }
prices <- jsonlite::read_json(url, simplifyVector = TRUE)
prices$market_cap_usd <- prices$market_cap_usd  %>% tidyr::replace_na(0) %>% as.numeric()
prices$available_supply <- prices$available_supply  %>% tidyr::replace_na(0) %>% as.numeric()
prices$max_supply <- prices$max_supply  %>% tidyr::replace_na(0) %>% as.numeric()
prices$total_supply <-prices$total_supply  %>% tidyr::replace_na(0) %>% as.numeric()
cols   <- c(4:14)
prices[, cols]   <- apply(prices[, cols], 2, function(x) replace(x, is.na(x), 0))
prices[, cols]   <- suppressWarnings(apply(prices[, cols], 2, function(x) as.numeric(x)))
prices[, 15]     <- as.POSIXct(as.numeric(prices[, 15]), origin = "1970-01-01")
if (!is.null(currency)) {
  concols <- c(16:18)
  prices[, concols]   <- suppressWarnings(apply(prices[, concols], 2, function(x) as.numeric(x)))
}
return(prices)
}
