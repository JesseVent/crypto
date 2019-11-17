#' Historical table scraper
#'
#' This web scrapes the historic price tables from CoinMarketCap
#' and provides back a dataframe for the coin provided as an input.
#' This function is a dependency of getCoins and is used
#' as part of a loop to retrieve all crypto currencies.
#'
#' @param attributes URL generated from \code{listCoins()}
#' @param slug Unique identifier required for merging
#' @param sleep Duration to sleep to resolve rate limiter
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
#' @importFrom dplyr "%>%" "mutate"
#' @importFrom tibble "as_tibble"
#' @importFrom rvest "html_nodes" "html_table"
#' @importFrom xml2 "read_html"
#' @importFrom curl "new_handle"
#'
scraper <- function(attributes, slug, sleep = NULL) {
  .            <- "."
  history_url  <- as.character(attributes)
  coin_slug    <- as.character(slug)
  rate_msg     <- "Rate limit hit. Sleeping for 60 seconds."
  if (!is.null(sleep)) {Sys.sleep(sleep)}

  page <- tryCatch(
    xml2::read_html(history_url, handle = curl::new_handle("useragent" = "Mozilla/5.0")),
    error = function(e) e)

  if (inherits(page, "error")) {
    closeAllConnections()
    message("\n")
    message(cli::cat_bullet(rate_msg, bullet = "warning", bullet_col = "red"), appendLF = TRUE)
    Sys.sleep(65)
    page <- xml2::read_html(history_url,
                            handle = curl::new_handle("useragent" = "Mozilla/5.0"))
  }

  table     <- rvest::html_nodes(page, css = "table") %>% rvest::html_table(fill = TRUE)
  df_length <- lapply(table, function(x) nrow(x)) %>% which.max()
  result    <- table %>% .[df_length] %>% replace(!nzchar(.), NA)
  scraper   <- result[[1]] %>% tibble::as_tibble() %>% dplyr::mutate(slug = coin_slug)

  return(scraper)
}
