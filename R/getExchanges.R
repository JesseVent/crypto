#' Get current crypto market exchanges
#'
#' Scrape the crypto currency exchange tables from
#' CoinMarketCap <https://coinmarketcap.com> and display
#' the results in a date frame. This can be used to conduct
#' analysis on the exchanges or to attempt
#' to predict exchange arbiture.
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
#'   \item{trading_pair}{Coin trading pair}
#'   \item{exchange_name}{Name of exchange}
#'   \item{last_updated}{Exchange refresh}
#'   \item{exchange_volume}{Exchange $USD volume}
#'   \item{exchange_price}{Exchange $USD price}
#'   \item{exchange_share}{Percent exchange traded}
#'   \item{coin_rank}{Rank of current coin}
#'   \item{exchange_rank}{Exchange ranking for coin}

#' If you want to retrieve ALL coins and their exchanges,
#' then do not pass a argument to getExchanges(),
#'
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
#' \dontrun{
#' # Retrieving exchange data for specific crypto currency
#'
#' coin <- "kin"
#' kin_exchanges <- getExchanges(coin)
#'
#' # retrieving market history for ALL crypto currencies
#'
#' all_exchanges <- getExchanges()
#'
#' }
#' @name getExchanges
#'
#' @export
#'
getExchanges <-
  function(coin = NULL, limit = NULL, cpu_cores = NULL, start_date = NULL, end_date = NULL) {
    if (as.character(match.call()[[1]]) == "getExchanges") {
      warning("DEPRECATED: Please use crypto_exchanges() instead of getExchanges().", call. = TRUE, immediate. = TRUE)
    }
    cat("Retrieving crypto exchange information from CoinMarketCap. ")
    i <- "i"
    options(scipen = 999)
    coins <- crypto_list(coin, start_date, end_date)
    if (!is.null(limit)) {
      coins <- coins[1:limit, ]
    }
    coinnames <-
      dplyr::data_frame(
        symbol = as.character(coins$symbol),
        name = as.character(coins$name),
        rank = coins$rank,
        slug = coins$slug
      )
    length <- as.numeric(length(coins$exchange_url))
    zrange <- 1:as.numeric(length(coins$exchange_url))
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
    attributes <- coins$exchange_url
    slug <- coins$slug
    message("   If this helps you become rich please consider donating",
      appendLF = TRUE
    )
    message("ERC-20: 0x375923Bf82F0b728d23A5704261a6e16341fd860",
      appendLF = TRUE
    )
    message("XRP: rK59semLsuJZEWftxBFhWuNE6uhznjz2bK", appendLF = TRUE)
    message("LTC: LWpiZMd2cEyqCdrZrs9TjsouTLWbFFxwCj", appendLF = TRUE)
    results <-
      foreach::foreach(
        i = zrange,
        .errorhandling = c("remove"),
        .options.snow = opts,
        .combine = rbind,
        .verbose = FALSE
      ) %dopar% scraper(attributes[i], slug[i])
    close(pb)
    parallel::stopCluster(cluster)
    print(proc.time() - ptm)
    results <- merge(results, coinnames, by = "slug")
    exchangedata <- results
    namecheck <- as.numeric(ncol(exchangedata))
    ifelse(
      namecheck > 2,
      colnames(exchangedata) <-
        c(
          "slug",
          "exchange_rank",
          "exchange_name",
          "trading_pair",
          "exchange_volume",
          "exchange_price",
          "exchange_share",
          "last_updated",
          "symbol",
          "name",
          "coin_rank"
        ),
      NULL
    )
    exchangedata <- exchangedata[c(
      "slug",
      "symbol",
      "name",
      "trading_pair",
      "exchange_name",
      "last_updated",
      "exchange_volume",
      "exchange_price",
      "exchange_share",
      "coin_rank",
      "exchange_rank"
    )]

    cols <- c(7:11)
    exchangedata[, cols] <-
      apply(exchangedata[, cols], 2, function(x)
        gsub(",|%|\\$", "", x))
    exchangedata[, cols] <-
      apply(exchangedata[, cols], 2, function(x)
        gsub("-", "0", x))
    exchangedata[, cols] <-
      apply(exchangedata[, cols], 2, function(x)
        replace(x, is.na(x), 0))
    exchangedata[, cols] <-
      suppressWarnings(apply(exchangedata[, cols], 2, function(x)
        as.numeric(x)))
    exchangedata <- na.omit(exchangedata)
    results <-
      exchangedata[order(exchangedata$coin_rank, exchangedata$exchange_rank, decreasing = FALSE), ]
    return(results)
  }

#' @export
#' @rdname getExchanges
crypto_exchanges <- getExchanges
