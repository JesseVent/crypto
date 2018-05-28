#' @title crypto2xts
#' @description  Converts the \code{getCoins()} dataframe into
#'  an xts object. Provide frequency to summarise into specific
#'  time periods.
#' @note Each value in \code{frequency <- c('second', 'minute',
#' 'hour', 'day', 'week', 'month', 'year')} can have an integer
#'  in front of it to retrieve the expressed time period. i.e. 3month
#'
#' @param df data.frame from \code{getCoins()}
#' @param frequency string \code{?round_date} for help
#' @importFrom dplyr "first"
#' @importFrom dplyr "last"
#' @importFrom xts "xts"
#' @importFrom lubridate "round_date"
#' @examples
#'   \dontrun{
#'  You can lookup additional frequencies at \code{?round_date}
#'  from the lubridate package.
#'     crypto2xts(df, '.5s')
#'     crypto2xts(df, 'sec')
#'     crypto2xts(df, 'second')
#'     crypto2xts(df, 'minute')
#'     crypto2xts(df, '5 mins')
#'     crypto2xts(df, 'hour')
#'     crypto2xts(df, '2 hours')
#'     crypto2xts(df, 'day')
#'     crypto2xts(df, 'week')
#'     crypto2xts(df, 'month')
#'     crypto2xts(df, 'bimonth')
#'     crypto2xts(df, '3 months')
#'     crypto2xts(df, 'halfyear')
#'     crypto2xts(df, 'year')
#' }
#' @return xts
#' @export
crypto2xts <- function(df, frequency = NULL) {
  if (as.character(match.call()[[1]]) == "crypto2xts") {
    warning("DEPRECATED: Please use crypto_xts() instead of crypto2xts().", call. = TRUE, immediate. = TRUE)
  }
  slug <- ""
  symbol <- ""
  name <- ""
  ranknow <- ""
  high <- ""
  low <- ""
  market <- ""
  volume <- ""
  freq <- frequency
  df$date <- lubridate::round_date(df$date, freq)
  data <-
    df %>%
    dplyr::group_by(date, slug, symbol, name, ranknow) %>%
    dplyr::summarise(
      open = dplyr::first(open),
      high = max(high),
      low = min(low),
      close = dplyr::last(close),
      volume = sum(volume),
      market = dplyr::last(market)
    )
  data$volume <- round(data$volume, digits = 0)
  data$market <- round(data$market, digits = 0)
  data <- as.data.frame(data)
  results <- xts::xts(data[, 2:ncol(data)], as.POSIXct(data[, 1], format = "%d.%m.%Y %H:%M:%S"))
  return(results)
}


#' @export
#' @rdname crypto2xts
crypto_xts <- crypto2xts
