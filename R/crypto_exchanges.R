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
#' @param start_date string Start date to retrieve data from, format 'yyyymmdd'
#' @param end_date string End date to retrieve data from, format 'yyyymmdd'
#' @param sleep integer Seconds to sleep for between API requests
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
#' then do not pass a argument to crypto_exchanges(),
#'
#' @importFrom dplyr '%>%' 'mutate' 'arrange'
#' @importFrom tidyr 'replace_na'
#' @importFrom crayon 'make_style'
#' @importFrom grDevices 'rgb'
#' @importFrom tibble 'tibble' 'as.tibble'
#' @importFrom cli 'cat_bullet'
#' @importFrom lubridate 'mdy'
#'
#' @examples
#' \dontrun{
#' # Retrieving exchange data for specific crypto currency
#'
#' coin <- 'kin'
#' kin_exchanges <- crypto_exchanges(coin)
#'
#' # retrieving market history for ALL crypto currencies
#'
#' all_exchanges <- crypto_exchanges()
#'
#' }
#' @name crypto_exchanges
#'
#' @export
#'
crypto_exchanges <- function(coin = NULL, limit = NULL, start_date = NULL, end_date = NULL, 
  sleep = NULL) {
  pink <- crayon::make_style(grDevices::rgb(0.93, 0.19, 0.65))
  options(scipen = 999)
  coin_rank <- NULL
  exchange_rank <- NULL
  i <- "i"
  message(cli::cat_bullet("If this helps you become rich please consider donating", 
    bullet = "heart", bullet_col = pink))
  message("ERC-20: 0x375923Bf82F0b728d23A5704261a6e16341fd860", appendLF = TRUE)
  message("XRP: rK59semLsuJZEWftxBFhWuNE6uhznjz2bK", appendLF = TRUE)
  
  coins <- crypto_list(coin, start_date, end_date, coin_list)
  
  if (!is.null(limit)) {
    coins <- coins[1:limit, ]
  }
  
  coin_names <- tibble::tibble(symbol = coins$symbol, name = coins$name, rank = coins$rank, 
    slug = coins$slug)
  to_scrape <- tibble::tibble(attributes = coins$exchange_url, slug = coins$slug)
  loop_data <- vector("list", nrow(to_scrape))
  message("\n")
  message(cli::cat_bullet("Scraping crypto exchange data", bullet = "pointer", 
    bullet_col = "green"))
  pb <- progress_bar$new(format = ":spin [:current / :total] [:bar] :percent in :elapsedfull ETA: :eta", 
    total = nrow(to_scrape), clear = FALSE)
  
  for (i in seq_len(nrow(to_scrape))) {
    pb$tick()
    loop_data[[i]] <- scraper(to_scrape$attributes[i], to_scrape$slug[i], sleep)
  }
  
  results <- do.call(rbind, loop_data) %>% tibble::as.tibble()
  
  if (length(results) == 0L) 
    stop("No data currently exists for this crypto currency.", call. = FALSE)
  
  exchange_data <- merge(results, coin_names, by = "slug")
  colnames(exchange_data) <- c("slug", "exchange_rank", "exchange_name", "trading_pair", 
    "exchange_volume", "exchange_price", "exchange_share", "category", "fee_type", 
    "last_updated", "symbol", "name", "coin_rank")
  exchange_data <- exchange_data[c("slug", "symbol", "name", "trading_pair", "exchange_name", 
    "category", "fee_type", "last_updated", "exchange_volume", "exchange_price", 
    "exchange_share", "coin_rank", "exchange_rank")]
  
  exchange_data[, 9:13] <- apply(exchange_data[, 9:13], 2, function(x) gsub(",|%|\\$", 
    "", x))
  exchange_data[, 9:13] <- apply(exchange_data[, 9:13], 2, function(x) gsub("-", 
    "0", x))
  exchange_data[, 9:13] <- apply(exchange_data[, 9:13], 2, function(x) tidyr::replace_na(x, 
    0))
  exchange_data[, 9:13] <- suppressWarnings(apply(exchange_data[, 9:13], 2, function(x) as.numeric(x)))
  exchange_data <- na.omit(exchange_data)
  exchange_results <- exchange_data %>% arrange(coin_rank, exchange_rank)
  return(exchange_results)
}
