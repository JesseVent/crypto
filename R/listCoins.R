#' Retrieves name, symbol, slug and rank for all tokens
#'
#' List all of the crypto currencies that have existed on Coinmarketcap
#' and use this to populate the URL base for scraping historical market
#' data. It retrieves name, slug, symbol and rank of cryptocurrencies from
#' CoinMarketCap and creates URLS for \code{scraper()} to use.
#'
#' @param coin Name, symbol or slug of crypto currency
#' @param ... No arguments, return all coins
#' @param start_date Start date to retrieve data from, format yyyymmdd
#' @param end_date Start date to retrieve data from, format yyyymmdd
#'
#' @return Crypto currency historic OHLC market data in a dataframe:
#'   \item{symbol}{Coin symbol (not-unique)}
#'   \item{name}{Coin name}
#'   \item{slug}{Coin URL slug (unique)}
#'   \item{rank}{Current rank by market cap}
#'   \item{url}{Historical market tables urls for scraping}
#'
#' Required dependency that is used in function call \code{getCoins()}.
#'
#' @examples
#' # return specific coin
#'
#' coin <- "kin"
#' coins <- listCoins(coin)
#'
#' \dontrun{
#'
#' # return all coins
#' coin_list <- listCoins()
#' }
#'
#' @name listCoins
#'
#' @export
#'
listCoins <- function(coin = NULL, start_date = NULL, end_date = NULL) {
  json <-
    "https://files.coinmarketcap.com/generated/search/quick_search.json"
  coins <- jsonlite::read_json(json, simplifyVector = TRUE)
  name <- coins$name
  slug <- coins$slug
  symbol <- coins$symbol
  c1 <- subset(coins, name == coin)
  c2 <- subset(coins, symbol == coin)
  c3 <- subset(coins, slug == coin)
  if (nrow(c1) > 0)
    coins <- c1
  if (nrow(c2) > 0)
    coins <- c2
  if (nrow(c3) > 0)
    coins <- c3
  coins <-
    data.frame(
      symbol = coins$symbol,
      name = coins$name,
      slug = coins$slug,
      rank = coins$rank
    )
  length <- as.numeric(length(coins$slug))
  if (is.null(start_date)) {
  start_date <- "20130428"
  }
  if (is.null(end_date)) {
  end_date <- gsub("-", "", lubridate::today())
  }
  cmcurl <-
    paste0(
      "https://coinmarketcap.com/currencies/",
      coins$slug,
      "/historical-data/?start=",
       start_date,
       "&end=",
       end_date
    )
  baseurl <- c(cmcurl)
  coins$symbol <- as.character(toupper(coins$symbol))
  coins$name <- as.character(coins$name)
  coins$slug <- as.character(coins$slug)
  coins$url <- as.character(baseurl)
  coins$rank <- as.numeric(coins$rank)
  return(coins)
}
