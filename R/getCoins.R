#' getCoins Get historical market listings
#'
#' This is the main function of this package and once run
#' will go and scrape all the historical tables of all the
#' different cryptocurrencies listed on CoinMarketCap and
#' turn it into a dataset.
#'
#' @return Returns a data frame with over 650k rows for your pleasure.
#'  \tabular{lccclcccl}{
#'    symbol \tab  \tab  \tab  \tab chr \tab  \tab  \tab  \tab KIN \cr
#'    date \tab  \tab  \tab  \tab date \tab  \tab  \tab  \tab 17/12/17 \cr
#'    open \tab  \tab  \tab  \tab dbl \tab  \tab  \tab  \tab 0.000088 \cr
#'    high \tab  \tab  \tab  \tab dbl \tab  \tab  \tab  \tab 0.000137 \cr
#'    low \tab  \tab  \tab  \tab dbl \tab  \tab  \tab  \tab 0.000083 \cr
#'    close \tab  \tab  \tab  \tab dbl \tab  \tab  \tab  \tab 0.000125 \cr
#'    volume \tab  \tab  \tab  \tab dbl \tab  \tab  \tab  \tab 557972 \cr
#'    market \tab  \tab  \tab  \tab dbl \tab  \tab  \tab  \tab 66221100 \cr
#'    name \tab  \tab  \tab  \tab chr \tab  \tab  \tab  \tab Kin \cr
#'    ranknow \tab  \tab  \tab  \tab int \tab  \tab  \tab  \tab 104 \cr
#' }
#' @importFrom magrittr "%>%"
#' @importFrom foreach "%dopar%"
#' @importFrom utils "txtProgressBar"
#' @importFrom utils "setTxtProgressBar"
#' @importFrom utils "globalVariables"
#' @import stats
#'
#' @examples
#' \dontrun{
#' getCoins()
#' }
#' @export
getCoins <-
  function() {
    cat("Retrieves coin market history from coinmarketcap. ")
    i <- "i"
    options(scipen = 999)
    coins <- listCoins()
    coinnames <-
      dplyr::data_frame(
        symbol = as.character(coins$symbol),
        name = as.character(coins$name),
        rank = coins$rank
      )
    length <- as.numeric(length(coins$slug))
    zrange <- 1:as.numeric(length(coins$slug))
    cpucore <-
      as.numeric(parallel::detectCores(all.tests = FALSE, logical = TRUE))
    ptm <- proc.time()
    cluster <- parallel::makeCluster(cpucore, type = "SOCK")
    doSNOW::registerDoSNOW(cluster)
    pb <- txtProgressBar(max = length, style = 3)
    progress <- function(n)
      setTxtProgressBar(pb, n)
    opts <- list(progress = progress)
    attributes <- coins$slug
    message('   If this helps you become rich please consider donating',
            appendLF = TRUE)
    message("ETH:  0x375923Bf82F0b728d23A5704261a6e16341fd860",
            appendLF = TRUE)
    message("BTC:  1LPjH7KyH5aD65pTBhByXFCFXZNTUVdeRY", appendLF = TRUE)
    results <-
      foreach::foreach(i = zrange,
                       .options.snow = opts,
                       .combine = rbind) %dopar% scraper(attributes[i])
    close(pb)
    parallel::stopCluster(cluster)
    print(proc.time() - ptm)
    results <- merge(results, coinnames)
    marketdata <- results
    namecheck <- ncol(marketdata)
    ifelse(
      namecheck > 2,
      colnames(marketdata) <-
        c(
          "symbol",
          "date",
          "open",
          "high",
          "low",
          "close",
          "volume",
          "market",
          "name",
          "ranknow"
        ),
      NULL
    )
    marketdata$date <-
      suppressWarnings(lubridate::mdy(unlist(marketdata$date)))
    cols <- c(3:8)
    ccols <- c(5:8)
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
    results <-
      marketdata[order(marketdata$ranknow, marketdata$date, decreasing = FALSE),]
    return(results)
  }
