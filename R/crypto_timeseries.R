#' Daily crypto currency market data
#'
#' Retrieve time series of market_cap, price_btc, price_usd and volume
#' of specified coin - perfect for charting or time series analysis.
#'
#' Most tokens are refreshed every 6 hours.. results may vary.

#'
#' @param coin Name, symbol or slug of crypto currency
#'
#' @return Daily time series of token data in a dataframe:
#'   \item{timestamp}{Timestamp (POSIXct)}
#'   \item{market_cap}{Market Cap in USD}
#'   \item{price_btc}{Price in BTC}
#'   \item{price_usd}{Price in USD}
#'   \item{volume}{Volume traded in USD}
#'   \item{slug}{Coin URL slug (unique)}
#'
#' @importFrom tibble tibble
#'
#' @examples
#' \dontrun{
#' coin       <- 'kin'
#' kin_charts <- crypto_timeseries(coin)
#' }
#' @export
crypto_timeseries <- function(coin = NULL) {
  if (is.null(coin)) {
    coin <- "bitcoin"
  }
  json <- "https://s2.coinmarketcap.com/generated/search/quick_search.json"
  coins <- safely_read_json(json)
  if (!is.null(coin)) {
    name <- coins$name
    slug <- coins$slug
    symbol <- coins$symbol
    c1 <- subset(coins, toupper(name) %in% toupper(coin))
    c2 <- subset(coins, symbol %in% toupper(coin))
    c3 <- subset(coins, slug %in% tolower(coin))
    coins <- tibble::tibble()
    if (nrow(c1) > 0) {
      coins <- rbind(coins, c1)
    }
    if (nrow(c2) > 0) {
      coins <- rbind(coins, c2)
    }
    if (nrow(c3) > 0) {
      coins <- rbind(coins, c3)
    }
    if (nrow(coins) > 1L) {
      coins <- unique(coins)
    }
  }
  slug <- coins$slug %>% as.character()
  url <- paste0("https://graphs2.coinmarketcap.com/currencies/", slug)
  df <- safely_read_json(url)
  if (length(df) >= 5L) {
    df$price_platform <- NULL
  }
  df <- as.data.frame(df)
  df[, c(3, 5, 7)] <- NULL
  names(df) <- c("timestamp", "market_cap", "price_btc", "price_usd", "volume")
  df$timestamp <- as.POSIXct(as.numeric(df$timestamp)/1000, origin = "1970-01-01",
    tz = "UTC")
  df$slug <- slug
  market_data <- df %>% as.data.frame()
  return(market_data)
}
