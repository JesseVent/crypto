#' Daily cryptocurrency market data
#'
#' Retrieve timeseries of market_cap, price_btc, price_usd and volume
#' of specified coin - perfect for charting or timeseries analysis.
#'
#' Most tokens are refreshed every 6 hours.. results may vary.

#'
#' @param coin Name, symbol or slug of crypto currency
#'
#' @return Daily timeseries of token data in a dataframe:
#'   \item{timestamp}{Timestamp (POSIXct)}
#'   \item{market_cap}{Market Cap in USD}
#'   \item{price_btc}{Price in BTC}
#'   \item{price_usd}{Price in USD}
#'   \item{volume}{Volume traded in USD}
#'   \item{slug}{Coin URL slug (unique)}
#'
#' @examples
#' \dontrun{
#' coin       <- "kin"
#' kin_charts <- daily_market(coin)
#' }
#' @export
daily_market <- function(coin = NULL) {
  if (is.null(coin)) {
    coin <- "bitcoin"
  }
  json             <- "https://s2.coinmarketcap.com/generated/search/quick_search.json"
  coins            <- jsonlite::read_json(json, simplifyVector = TRUE)
  name             <- coins$name
  slug             <- coins$slug
  symbol           <- coins$symbol
  c1               <- subset(coins, name   == coin)
  c2               <- subset(coins, symbol == coin)
  c3               <- subset(coins, slug   == coin)

  if (nrow(c1) > 0)
    coins <- c1
  if (nrow(c2) > 0)
    coins <- c2
  if (nrow(c3) > 0)
    coins <- c3

  slug             <- coins$slug %>% as.character()
  url              <- paste0("https://graphs2.coinmarketcap.com/currencies/", slug)
  df               <- jsonlite::fromJSON(url, flatten = TRUE)
  if(length(df) >= 5L){
    df$price_platform <- NULL
  }
  df <- as.data.frame(df)
  df[, c(3, 5, 7)] <- NULL
  names(df)    <-
    c("timestamp",
      "market_cap",
      "price_btc",
      "price_usd",
      "volume")
  df$timestamp <-
    as.POSIXct(as.numeric(df$timestamp) / 1000,
               origin = "1970-01-01",
               tz     = "UTC")
 df$slug       <- slug
 market_data   <- df %>% as.data.frame()
  return(market_data)
}
