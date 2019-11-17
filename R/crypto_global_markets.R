#' Global crypto currency market data
#'
#' Retrieve daily snapshot of market_cap and the volume traded
#' for either total crypto currency market or the altcoin market
#' only. Selecting 'total' will include bitcoin and all altcoins.
#'
#' @param market Either 'total' or 'altcoin'
#'
#' @return Daily time series of token data in a dataframe:
#'   \item{timestamp}{Timestamp (POSIXct)}
#'   \item{market_cap}{Market Cap in USD}
#'   \item{volume}{Volume traded in USD}
#'
#' @examples
#' market         <- 'total'
#' crypto_global_market <- crypto_global_market(market)
#' @export
crypto_global_market <- function(market = NULL) {
  if (is.null(market)) {
    market <- "total"
  }

  if (market != "total") {
    if (market != "altcoin") {
      message("Valid options are 'total' or 'altcoin'.", appendLF = TRUE)
      market <- "total"
    }
  }

  url <- paste0("https://graphs2.coinmarketcap.com/global/marketcap-", market)
  df <- safely_read_json(url) %>% as.data.frame()
  df[, 3] <- NULL
  names(df) <- paste0(market, "_", c("timestamp", "market_cap", "volume"))
  df[, 1] <- as.POSIXct(as.numeric(df[, 1])/1000, origin = "1970-01-01", tz = "UTC")
  crypto_global_markets <- df %>% as.data.frame()
  return(crypto_global_markets)
}
