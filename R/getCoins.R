#' Get historic crypto currency market data
#'
#' Scrape the crypto currency historic market tables from
#' Coinmarketcap <https://coinmarketcap.com> and display
#' the results in a date frame. This can be used to conduct
#' analysis on the crypto financial markets or to attempt
#' to predict future market movments or trends.
#'
#' @param coin Name, symbol or slug of crypto currency
#' @param ... No arguments, return all coins
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
#' }
#'
#' @name getCoins
#'
#' @export
#'
getCoins <-
  function(coin = NULL) {
    cat("Retrieves coin market history from coinmarketcap. ")
    i <- "i"
    options(scipen = 999)
    coins <- listCoins(coin)
    coinnames <-
      dplyr::data_frame(
        name = as.character(coins$name),
        rank = coins$rank,
        slug = coins$slug
      )
    length <- as.numeric(length(coins$url))
    zrange <- 1:as.numeric(length(coins$url))
    cpucore <-
      as.numeric(parallel::detectCores(all.tests = FALSE, logical = TRUE))
    ptm <- proc.time()
    cluster <- parallel::makeCluster(cpucore, type = "SOCK")
    doSNOW::registerDoSNOW(cluster)
    pb <- txtProgressBar(max = length, style = 3)
    progress <- function(n)
      setTxtProgressBar(pb, n)
    opts <- list(progress = progress)
    attributes <- coins$url
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
