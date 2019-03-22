#' Get historic crypto currency market data
#'
#' Scrape the crypto currency historic market tables from
#' CoinMarketCap <https://coinmarketcap.com> and display
#' the results in a date frame. This can be used to conduct
#' analysis on the crypto financial markets or to attempt
#' to predict future market movements or trends.
#'
#' @param coins string if NULL retrieve all currently existing coins (crypto_list()),
#' or provide list of crypto currencies in the crypto_list() format (e.g. current and dead coins since 2015)
#' @param limit integer Return the top n records, default is all tokens
#' @param start_date string Start date to retrieve data from, format 'yyyymmdd'
#' @param end_date string End date to retrieve data from, format 'yyyymmdd'
#' @param coin_list string Valid values are 'api', 'static' or NULL
#' @param sleep integer Seconds to sleep for between API requests
#
#' @return Crypto currency historic OHLC market data in a dataframe and additional information via attribute "info":
#'   \item{slug}{Coin url slug}
#'   \item{symbol}{Coin symbol}
#'   \item{name}{Coin name}
#'   \item{date}{Market date}
#'   \item{open}{Market open}
#'   \item{high}{Market high}
#'   \item{low}{Market low}
#'   \item{close}{Market close}
#'   \item{volume}{Volume 24 hours}
#'   \item{market}{USD Market cap}
#'   \item{close_ratio}{Close rate, min-maxed with the high and low values that day}
#'   \item{spread}{Volatility premium, high minus low for that day}
#'   \item{start_date}{in info: Begin of historic data}
#'   \item{end_date}{in info: End of historic data}
#'   \item{message}{in info: Either "Success" when data was available or error message from scraper}
#'
#' This is the main function of the crypto package. If you want to retrieve
#' ALL coins then do not pass a argument to crypto_history(), or pass the coin name.
#'
#' @importFrom dplyr '%>%' 'mutate' 'arrange' 'left_join' 'group_by' 'ungroup' 'slice'
#' @importFrom tidyr 'replace_na'
#' @importFrom crayon 'make_style'
#' @importFrom grDevices 'rgb'
#' @importFrom tibble 'tibble' 'as_tibble' 'rowid_to_column'
#' @importFrom cli 'cat_bullet'
#' @importFrom lubridate 'mdy'
#'
#' @import progress
#' @import stats
#'
#' @examples
#' \dontrun{
#'
#' # Retrieving market history for ALL crypto currencies
#' all_coins <- crypto_history(limit = 1)
#'
#' # Retrieving this years market history for ALL crypto currencies
#' all_coins <- crypto_history(start_date = '20180101')
#'
#' # Retrieve 2015 history for all 2015 crypto currencies
#' coin_list_2015 <- crypto_list(start_date_hist="20150101",end_date_hist="20151231",date_gap="months")
#' coins_2015 <- crypto_history(coins = coin_list_2015, start_date = "20150101", end_date="20151231")
#' }
#' @name crypto_history
#'
#' @export
#'
crypto_history <- function(coins = NULL, limit = NULL, start_date = NULL, end_date = NULL,
  coin_list = NULL, sleep = NULL) {
  pink <- crayon::make_style(grDevices::rgb(0.93, 0.19, 0.65))
  options(scipen = 999)
  i <- "i"
  low <- NULL
  high <- NULL
  close <- NULL
  ranknow <- NULL

  message(cli::cat_bullet("If this helps you become rich please consider donating",
    bullet = "heart", bullet_col = pink))
  message("ERC-20: 0x375923Bf82F0b728d23A5704261a6e16341fd860", appendLF = TRUE)
  message("XRP: rK59semLsuJZEWftxBFhWuNE6uhznjz2bK", appendLF = TRUE)
  message("\n")
  # only if no coins are provided
  if (is.null(coins)) coins <- crypto_list(coin=NULL, start_date, end_date, coin_list)

  if (!is.null(limit))
    coins <- coins[1:limit, ]

  coin_names <- tibble::tibble(symbol = coins$symbol, name = coins$name,slug = coins$slug)
  to_scrape <- tibble::tibble(attributes = coins$history_url, slug = coins$slug)
  loop_data <- vector("list", nrow(to_scrape))
  loop_info <- vector("list", nrow(to_scrape))

  message(cli::cat_bullet("Scraping historical crypto data", bullet = "pointer",
    bullet_col = "green"))
  pb <- progress_bar$new(format = ":spin [:current / :total] [:bar] :percent in :elapsedfull ETA: :eta",
    total = nrow(to_scrape), clear = FALSE)

  for (i in seq_len(nrow(to_scrape))) {
    pb$tick()
    temp <- scraper(to_scrape$attributes[i], to_scrape$slug[i], sleep)
    loop_info[[i]] <- temp$info
    loop_data[[i]] <- temp$data
  }

  results <- do.call(rbind, loop_data) %>% tibble::as_tibble()
  results_info <- do.call(rbind, loop_info) %>% tibble::as_tibble()

  if (length(results) == 0L)
    stop("No data currently exists for this crypto currency.", call. = FALSE)

  market_data <- results %>% left_join(coin_names, by = "slug")
  colnames(market_data) <- c("date", "open", "high", "low", "close", "volume",
    "market", "slug", "symbol", "name")

  history_results <- market_data %>%
    # create fake ranknow
    dplyr::left_join(market_data %>% dplyr::group_by(symbol) %>% dplyr::arrange(desc(date)) %>% dplyr::slice(1) %>% dplyr::ungroup() %>%
                       tibble::rowid_to_column("ranknow") %>% dplyr::select(slug,ranknow), by="slug") %>%
    dplyr::select(slug,symbol,name,date,ranknow,open,high,low,close,volume,market) %>%
    dplyr::mutate(date=lubridate::mdy(date, locale = platform_locale())) %>%
    dplyr::mutate_at(vars(open,high,low,close,volume,market),~gsub(",","",.)) %>%
    dplyr::mutate_at(vars(high,low,close,volume,market),~gsub("-","0",.)) %>%
    dplyr::mutate_at(vars(open,high,low,close,volume,market),~as.numeric(tidyr::replace_na(.,0))) %>%
    dplyr::mutate(close_ratio = (close - low)/(high - low) %>% round(4) %>% as.numeric(),
                  spread = (high - low) %>% round(2) %>% as.numeric()) %>%
    dplyr::mutate_at(vars(close_ratio),~as.numeric(tidyr::replace_na(.,0))) %>%
    dplyr::group_by(symbol) %>%
    dplyr::arrange(ranknow,desc(date))
  # info output
  coins_info <- coins %>% left_join(results_info,by="slug")
  out <- history_results; attr(out,"info") <- coins_info
  return(out)
}
