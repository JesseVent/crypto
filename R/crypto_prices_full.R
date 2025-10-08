#' @title Get full listing current crypto currency prices
#' @description This will retrieve the current market prices from CoinMarketCap. Data gets refreshed every 5 minutes and will iterate over all tokens to return the full list of prices.
#' @param limit Return top n coins, default is all, Default: 0
#' @return Will provide data frame of current prices
#' @details Updated every 5 minutes
#' @examples
#' \dontrun{
#' all_prices <- crypto_prices_full()
#' }
#' @rdname crypto_prices_full
#' @export
#' @importFrom dplyr '%>%' 'bind_rows'
#' @importFrom tibble 'tibble'
#'
crypto_prices_full <- function(limit = NULL) {
  iteration <- 1
  coin_list <- crypto_list()
  if (!is.null(limit))
    coin_list <- coin_list[1:limit,]
  iterations  <- ceiling(nrow(coin_list) / 100)
  iterator    <- tibble::tibble(iteration = seq(1:iterations), value = iteration * 100 - 100)
  results     <- lapply(iterator$value, function(x) {
      crypto_prices(offset = x)
    }) %>% dplyr::bind_rows()
  return(results)
}
