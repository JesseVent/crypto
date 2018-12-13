#' @title crypto_xts
#' @description  Converts the \code{getCoins()} dataframe into
#'  an xts object. Provide frequency to summarise into specific
#'  time periods.
#' @note Each value in \code{frequency <- c('second', 'minute',
#' 'hour', 'day', 'week', 'month', 'year')} can have an integer
#'  in front of it to retrieve the expressed time period. i.e. 3month
#'
#' @param df data.frame from \code{getCoins()}
#' @param frequency string \code{?round_date} for help
#'
#' @importFrom dplyr "first" "last" "summarise" "group_by"
#' @importFrom xts "xts"
#' @importFrom lubridate "round_date"
#' @examples
#'   \dontrun{
#'  You can lookup additional frequencies at \code{?round_date}
#'  from the lubridate package.
#'     crypto_xts(df, '.5s')
#'     crypto_xts(df, 'sec')
#'     crypto_xts(df, 'second')
#'     crypto_xts(df, 'minute')
#'     crypto_xts(df, '5 mins')
#'     crypto_xts(df, 'hour')
#'     crypto_xts(df, '2 hours')
#'     crypto_xts(df, 'day')
#'     crypto_xts(df, 'week')
#'     crypto_xts(df, 'month')
#'     crypto_xts(df, 'bimonth')
#'     crypto_xts(df, '3 months')
#'     crypto_xts(df, 'halfyear')
#'     crypto_xts(df, 'year')
#' }
#' @return xts
#' @export
crypto_xts <- function(df, frequency = NULL) {
  slug    <- ""
  symbol  <- ""
  name    <- ""
  ranknow <- ""
  high    <- ""
  low     <- ""
  market  <- ""
  volume  <- ""
  freq    <- frequency
  df$date <- lubridate::round_date(df$date, freq)
  data <- df %>%
    dplyr::group_by(date, slug, symbol, name, ranknow) %>%
    dplyr::summarise(
      open   = dplyr::first(open),
      high   = max(high),
      low    = min(low),
      close  = dplyr::last(close),
      volume = sum(volume),
      market = dplyr::last(market))

  data$volume <- round(data$volume, digits = 0)
  data$market <- round(data$market, digits = 0)
  data        <- as.data.frame(data)
  xts_results     <- xts::xts(data[, 2:ncol(data)], as.POSIXct(data[, 1],
                 format = "%d.%m.%Y %H:%M:%S"))
  return(xts_results)
}
