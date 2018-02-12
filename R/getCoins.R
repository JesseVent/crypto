#' Get historic crypto currency market data
#'
#' Scrape the crypto currency historic market tables from
#' CoinMarketCap <https://coinmarketcap.com> and display
#' the results in a date frame. This can be used to conduct
#' analysis on the crypto financial markets or to attempt
#' to predict future market movements or trends.
#'
#' @param coin string Name, symbol or slug of crypto currency, default is all tokens
#' @param limit integer Return the top n records, default is all tokens
#' @param cpu_cores integer Uses n cores for processing, default uses all cores
#' @param ... No arguments, return all coins
#' @param start_date string Start date to retrieve data from, format 'yyyymmdd'
#' @param end_date string End date to retrieve data from, format 'yyyymmdd'
#'
#' @return Crypto currency historic OHLC market data in a dataframe:
#'   \item{slug}{Coin url slug}
#'   \item{symbol}{Coin symbol}
#'   \item{name}{Coin name}
#'   \item{date}{Market date}
#'   \item{ranknow}{Current Rank}
#'   \item{open}{Market open}
#'   \item{high}{Market high}
#'   \item{low}{Market low}
#'   \item{close}{Market close}
#'   \item{volume}{Volume 24 hours}
#'   \item{market}{USD Market cap}
#'   \item{close_ratio}{Close rate, min-maxed with the high and low values that day}
#'   \item{spread}{Volatility premium, high minus low for that day}
#'
#' This is the main function of the crypto package. If you want to retrieve
#' ALL coins then do not pass a argument to getCoins(), or pass the coin name.
#'
#' Please note that the doSNOW package is required to load the progress bar on
#' both linux and macOS systems as the doParallel package does not support it.
#'
#' @importFrom magrittr "%>%"
#' @importFrom foreach "%dopar%"
#' @importFrom utils "txtProgressBar"
#' @importFrom utils "setTxtProgressBar"
#' @importFrom utils "globalVariables"
#'
#' @import stats
#'
#' @examples
#' # retrieving market history for specific crypto currency
#'
#' coin <- "kin"
#' kin_coins <- listCoins(coin)
#'
#' \dontrun{
#'
#' # retrieving market history for ALL crypto currencies
#'
#' all_coins <- getCoins()
#'
#' # retrieving this years market history for ALL crypto currencies
#'
#' all_coins <- getCoins(start_date = '20180101')
#' }
#' @name getCoins
#'
#' @export
#'
getCoins <-
  function(coin = NULL, limit = NULL, cpu_cores = NULL, start_date = NULL, end_date = NULL) {
    cat("Retrieves coin market history from CoinMarketCap. ")
    i <- "i"
    options(scipen = 999)
    coins <- listCoins(coin, start_date, end_date)
    if (!is.null(limit)) {
      coins <- coins[1:limit,]
    }
    coinnames <-
      dplyr::data_frame(
        symbol = as.character(coins$symbol),
        name = as.character(coins$name),
        rank = coins$rank,
        slug = coins$slug
      )
    length <- as.numeric(length(coins$history_url))
    zrange <- 1:as.numeric(length(coins$history_url))
    if (is.null(cpu_cores)) {
    cpu_cores <- as.numeric(parallel::detectCores(all.tests = FALSE, logical = TRUE))
    }
    ptm <- proc.time()
    cluster <- parallel::makeCluster(cpu_cores, type = "SOCK")
    doSNOW::registerDoSNOW(cluster)
    pb <- txtProgressBar(max = length, style = 3)
    progress <- function(n)
      setTxtProgressBar(pb, n)
    opts <- list(progress = progress)
    attributes <- coins$history_url
    slug <- coins$slug
    message('   If this helps you become rich please consider donating',
            appendLF = TRUE)
    message("ERC-20: 0x375923Bf82F0b728d23A5704261a6e16341fd860",
            appendLF = TRUE)
    message("XRP: rK59semLsuJZEWftxBFhWuNE6uhznjz2bK", appendLF = TRUE)
    message("LTC: LWpiZMd2cEyqCdrZrs9TjsouTLWbFFxwCj", appendLF = TRUE)
    results <-
      foreach::foreach(i = zrange,
                       .options.snow = opts,
                       .combine = rbind) %dopar% scraper(attributes[i], slug[i])
    close(pb)
    parallel::stopCluster(cluster)
    print(proc.time() - ptm)
    results <- merge(results, coinnames, by = "slug")
    marketdata <- results
    namecheck <- as.numeric(ncol(marketdata))
    ifelse(
      namecheck > 2,
      colnames(marketdata) <-
        c(
          "slug",
          "date",
          "open",
          "high",
          "low",
          "close",
          "volume",
          "market",
          "symbol",
          "name",
          "ranknow"
        ),
      NULL
    )
    marketdata <- marketdata[c(
      "slug",
      "symbol",
      "name",
      "date",
      "ranknow",
      "open",
      "high",
      "low",
      "close",
      "volume",
      "market"
    )]
    marketdata$date <-
      suppressWarnings(lubridate::mdy(unlist(marketdata$date)))
    cols <- c(5:11)
    ccols <- c(7:11)
    marketdata[, cols] <-
      apply(marketdata[, cols], 2, function(x)
        gsub(",", "", x))
    marketdata[, ccols] <-
      apply(marketdata[, ccols], 2, function(x)
        gsub("-", "0", x))
    marketdata[, cols] <-
      suppressWarnings(apply(marketdata[, cols], 2, function(x)
        as.numeric(x)))
    marketdata <- na.omit(marketdata)
    marketdata$close_ratio <-
      (marketdata$close - marketdata$low) / (marketdata$high - marketdata$low)
    marketdata$close_ratio <- round(marketdata$close_ratio, 4)
    marketdata$spread <- (marketdata$high - marketdata$low)
    marketdata$spread <- round(marketdata$spread, 2)
    results <-
      marketdata[order(marketdata$ranknow, marketdata$date, decreasing = FALSE), ]
    return(results)
  }
