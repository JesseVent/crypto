#' Historical table scraper
#'
#' This web scrapes the historic price tables from CoinMarketCap
#' and provides back a dataframe for the coin provided as an input.
#' This function is a dependency of getCoins and is used
#' as part of a loop to retrieve all crypto currencies.
#'
#' @param attributes URL generated from \code{listCoins()}
#' @param slug Unique identifier required for merging
#'
#' @return Raw OHLC market data in a dataframe:
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
#'
#' This function is not to be called individually by a user but is to be
#' consumed as part of the getCoins.
#'
#' @importFrom dplyr "%>%"
#' @importFrom rvest "html_nodes"
#' @importFrom xml2 "read_html"
#'
#' @examples
#' \dontrun{
#' # Only to be executed by getCoins
#' scraper(attributes)
#' }
#'
#' @name scraper
#'
#' @export
#'
scraper <- function(attributes, slug) {
  . <- "."
  history_url <- as.character(attributes)
  coin_slug <- as.character(slug)
  cpage <-
    xml2::read_html(history_url,
      handle = curl::new_handle("useragent" = "Mozilla/5.0")
    )
  cnodes <-
    cpage %>%
    rvest::html_nodes(css = "table") %>%
    .[1] %>%
    rvest::html_table(fill = TRUE) %>%
    replace(!nzchar(.), NA)
  scraper <- data.frame(cnodes = cnodes)
  scraper <- Reduce(rbind, cnodes)
  scraper$slug <- as.character(coin_slug)
  return(scraper)
}
