#' Retrieves name, symbol, slug and rank for all tokens at specific historic date
#'
#' List all of the crypto currencies that have existed on CoinMarketCap on specific date.
#' This can be used to add "dead" coins to the list of coins retrieved by `crypto_list()`.
#' Use this to populate/add to the URL base for scraping historical market
#' data. It retrieves name, slug, symbol and rank of crypto currencies from
#' CoinMarketCap and creates URLS for \code{scraper()} to use.
#'
#' @param coin Name, symbol or slug of crypto currency
#' @param start_date Start date to retrieve data from, format yyyymmdd
#' @param end_date End date to retrieve data from, format yyyymmdd, if not provided, today will be assumed
#' @param start_date_hist Start date to retrieve coin history from, format yyyymmdd
#' @param end_date_hist End date to retrieve coin history from, format yyyymmdd, if not provided, today will be assumed
#' @param coin_list 'api', 'static' or NULL
#' @param date_gap 'months'
#'
#' @return Crypto currency historic OHLC market data in a dataframe:
#'   \item{symbol}{Coin symbol (not-unique)}
#'   \item{name}{Coin name}
#'   \item{slug}{Coin URL slug (unique)}
#'   \item{exchange_url}{Exchange market tables urls for scraping}
#'   \item{history_url}{Historical market tables urls for scraping}
#'
#' Required dependency that is used in function call \code{getCoins()}.
#' @importFrom tibble tibble
#' @importFrom jsonlite fromJSON
#' @importFrom lubridate today ymd
#' @importFrom dplyr left_join mutate rename
#'
#' @examples
#' \dontrun{
#' coin <- "kin"
#' coins <- crypto_list(coin)
#'
#' # return all coins
#' coin_list <- crypto_list()
#'
#' # return all coins listed in 2015
#' coin_list_2015 <- crypto_list(start_date_hist="20150101",end_date_hist="20151231",date_gap="months")
#'
#' @name crypto_list
#'
#' @export
#'
  crypto_list <- function(coin = NULL,
           start_date = NULL,
           end_date = NULL,
           start_date_hist = NULL,
           end_date_hist = NULL,
           coin_list = NULL,
           date_gap ="months") {
    # get current coins
    if (is.null(coin_list)) {
      out_list <- out_list_recent <- NULL
      if (!is.null(start_date_hist)){
        # create dates
        if (is.null(end_date_hist)) end_date_hist <- lubridate::today()
        dates <- as.Date(seq(ymd(start_date_hist),ymd(end_date_hist),date_gap))
        for (i in 1:length(dates)){
          attributes <- paste0("https://coinmarketcap.com/historical/",format(dates[i], "%Y%m%d"),"/")
          out_list <- rbind(out_list,scraper_hist(attributes, sleep = NULL) %>% dplyr::mutate(hist_date=dates[i]))
        }
      }
      coins <- out_list
      # always get list for data validation
      json   <- "https://s2.coinmarketcap.com/generated/search/quick_search.json"
      out_list_recent  <- jsonlite::fromJSON(json)
      # validate name & slug via symbol from recent list
      if (!is.null(coins)){
        coins <- coins %>% rename(symbol=Symbol,name=Name) %>% dplyr::left_join(out_list_recent %>% select(symbol,name,slug) %>% dplyr::rename(slug_main=slug, name_main=name),by="symbol") %>%
          dplyr::mutate(name=ifelse(is.na(name_main),name,name_main),slug=ifelse(is.na(slug_main),slug,slug_main)) %>% dplyr::select(symbol, name, slug, hist_date)
      }
      if (is.null(end_date_hist)|is.null(coins)){
        coins <- rbind(out_list,out_list_recent %>% select(name,symbol,slug) %>% dplyr::mutate(hist_date=lubridate::today()))
      }
    } else {
      ifelse(coin_list == "api",
             coins <- get_coinlist_api(),
             coins <- get_coinlist_static())
    }
    # get historic coins
    if (!is.null(coin)) {
    name   <- coins$name %>% unique()
    slug   <- coins$slug %>% unique()
    symbol <- coins$symbol %>% unique()
    c1     <- subset(coins, toupper(name) %in% toupper(coin))
    c2     <- subset(coins, symbol %in% toupper(coin))
    c3     <- subset(coins, slug %in% tolower(coin))
    coins  <- tibble::tibble()
    if (nrow(c1) > 0) { coins     <- rbind(coins, c1 %>% select(-hist_date)) }
    if (nrow(c2) > 0) { coins     <- rbind(coins, c2 %>% select(-hist_date)) }
    if (nrow(c3) > 0) { coins     <- rbind(coins, c3 %>% select(-hist_date)) }
    if (nrow(coins) > 1L) { coins <- unique(coins) }
    }
    coins <-
      tibble::tibble(
        symbol = coins$symbol,
        name   = coins$name,
        slug   = coins$slug
      ) %>% unique
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
    return(coins)
  }
