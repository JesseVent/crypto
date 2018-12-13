#' Retrieves name, symbol, slug and rank for all tokens
#'
#' List all of the crypto currencies that have existed on CoinMarketCap
#' and use this to populate the URL base for scraping historical market
#' data. It retrieves name, slug, symbol and rank of crypto currencies from
#' CoinMarketCap and creates URLS for \code{scraper()} to use.
#'
#' @param coin Name, symbol or slug of crypto currency
#' @param start_date Start date to retrieve data from, format yyyymmdd
#' @param end_date Start date to retrieve data from, format yyyymmdd
#' @param coin_list 'api', 'static' or NULL
#'
#' @return Crypto currency historic OHLC market data in a dataframe:
#'   \item{symbol}{Coin symbol (not-unique)}
#'   \item{name}{Coin name}
#'   \item{slug}{Coin URL slug (unique)}
#'   \item{rank}{Current rank by market cap}
#'   \item{exchange_url}{Exchange market tables urls for scraping}
#'   \item{history_url}{Historical market tables urls for scraping}
#'
#' Required dependency that is used in function call \code{getCoins()}.
#' @importFrom tibble tibble
#' @importFrom jsonlite fromJSON
#' @importFrom lubridate today
#'
#' @examples
#' \dontrun{
#' coin <- "kin"
#' coins <- crypto_list(coin)
#'
#' # return all coins
#' coin_list <- crypto_list()
#' }
#'
#' @name crypto_list
#'
#' @export
#'
  crypto_list <- function(coin = NULL,
           start_date = NULL,
           end_date = NULL,
           coin_list = NULL) {
    if (is.null(coin_list)) {
      json   <- "https://s2.coinmarketcap.com/generated/search/quick_search.json"
      coins  <- jsonlite::fromJSON(json)
    } else {
      ifelse(coin_list == "api",
             coins <- get_coinlist_api(),
             coins <- get_coinlist_static())
    }

    if (!is.null(coin)) {
    name   <- coins$name
    slug   <- coins$slug
    symbol <- coins$symbol
    c1     <- subset(coins, toupper(name) %in% toupper(coin))
    c2     <- subset(coins, symbol %in% toupper(coin))
    c3     <- subset(coins, slug %in% tolower(coin))
    coins  <- tibble::tibble()
    if (nrow(c1) > 0) { coins     <- rbind(coins, c1) }
    if (nrow(c2) > 0) { coins     <- rbind(coins, c2) }
    if (nrow(c3) > 0) { coins     <- rbind(coins, c3) }
    if (nrow(coins) > 1L) { coins <- unique(coins) }
    }
    coins <-
      tibble::tibble(
        symbol = coins$symbol,
        name   = coins$name,
        slug   = coins$slug,
        rank   = coins$rank
      )
    if (is.null(start_date)) { start_date <- "20130428" }
    if (is.null(end_date)) { end_date <- gsub("-", "", lubridate::today()) }
    exchangeurl <- paste0("https://coinmarketcap.com/currencies/", coins$slug, "/#markets")
    historyurl <-
      paste0(
        "https://coinmarketcap.com/currencies/",
        coins$slug,
        "/historical-data/?start=",
        start_date,
        "&end=",
        end_date
      )
    exchange_url       <- c(exchangeurl)
    history_url        <- c(historyurl)
    coins$symbol       <- as.character(toupper(coins$symbol))
    coins$name         <- as.character(coins$name)
    coins$slug         <- as.character(coins$slug)
    coins$exchange_url <- as.character(exchange_url)
    coins$history_url  <- as.character(history_url)
    coins$rank         <- as.numeric(coins$rank)
    return(coins)
  }
