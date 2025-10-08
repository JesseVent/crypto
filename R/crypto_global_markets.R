#' Global crypto currency market data
#'
#' Retrieve daily snapshot of market_cap and the volume traded
#' for either total crypto currency market or the altcoin market
#' only. Selecting 'total' will include bitcoin and all altcoins.
#'
#' @param market Either 'total' or 'altcoin'
#'
#' @return Daily time series of token data in a dataframe:
#'   \item{timestamp}{Timestamp (POSIXct)}
#'   \item{market_cap}{Market Cap in USD}
#'   \item{volume}{Volume traded in USD}
#'
#' @importFrom dplyr '%>%' 'mutate' 'select' 'group_by' 'ungroup'
#' @importFrom tidyr 'spread'
#' @importFrom reshape2 'melt'
#' @importFrom tibble 'tibble' 'as_tibble'
#' @importFrom lubridate 'ymd_hms'
#'
#' @note The API this uses often will change, please raise an issue on GitHub if errors persist.
#'
#' @examples
#' \dontrun{
#' ##
#' market <- 'total'
#' crypto_global_market <- crypto_global_market(market)
#' }
#' @export
crypto_global_market <- function(market = NULL) {
  L1        <- ""
  timestamp <- ""
  type      <- ""
  value     <- ""
  .         <- "."

  if (is.null(market)) {
    market <- "total"
  }

  if (market != "total") {
    if (market != "altcoin") {
      message("Valid options are 'total' or 'altcoin'.", appendLF = TRUE)
      market <- "total"
    }
  }
  scope <- ifelse(market == "total", "chart", "chart_altcoin")
  time  <- floor(as.numeric(Sys.time()))
  base  <- "https://web-api.coinmarketcap.com/v1/global-metrics/quotes/"
  api   <- "historical?format="
  url   <- paste0(base, api, scope, "&interval=1d&time_end=", time, "&time_start=2013-04-28")
  data  <- safely_read_json(url)[[2]] %>%
    reshape2::melt() %>%
    tibble::as_tibble() %>%
    dplyr::mutate(timestamp = as.numeric(lubridate::ymd_hms(L1)),
           ts_id     = 1:nrow(.))
  data$type <- ifelse((data$ts_id %% 2) == 0, 'volume', 'market_cap')

  crypto_global_markets <- data %>%
    dplyr::select(timestamp, type, value) %>%
    dplyr::group_by(timestamp) %>%
    tidyr::spread(type, value) %>% dplyr::ungroup() %>%
    dplyr::mutate(timestamp = as.POSIXct(as.numeric(timestamp),
      origin = "1970-01-01", tz = "UTC")) %>% as.data.frame()

  return(crypto_global_markets)
}
