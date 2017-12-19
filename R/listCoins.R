#' Retrieve Cryptocurrencies
#'
#' This is called automatically as part of \code{getCoins()}.
#' It retrieves name, slug, symbol and rank of cryptocurrencies from
#' CoinMarketCap and creates URLS for \code{scraper()} to use.
#'
#' @return Returns data frame of coin listings for getting
#'  coin names, rank and slugs for use in \code{getCoins()}
#'  and populating the urls for use in \code{scraper()}.
#'  \tabular{lccclcccl}{
#'   symbol \tab  \tab  \tab  \tab chr \tab  \tab  \tab  \tab "KIN"\cr
#'   name \tab  \tab  \tab  \tab chr \tab  \tab  \tab  \tab "Kin"\cr
#'   slug \tab  \tab  \tab  \tab chr \tab  \tab  \tab  \tab "kin"\cr
#'   rank \tab  \tab  \tab  \tab dbl \tab  \tab  \tab  \tab 104\cr
#' }
#' @export
listCoins <- function() {
  today <- gsub("-", "", lubridate::today())
  json <-
    "https://files.coinmarketcap.com/generated/search/quick_search.json"
  coins <- jsonlite::read_json(json, simplifyVector = TRUE)
  coins <-
    data.frame(
      symbol = coins$symbol,
      name = coins$name,
      slug = coins$slug,
      rank = coins$rank
    )
  length <- as.numeric(length(coins$slug))
  cmcurl <-
    paste0(
      "https://coinmarketcap.com/currencies/",
      coins$slug,
      "/historical-data/?start=20130428&end=",
      today
    )
  baseurl <- c(cmcurl)
  coins$symbol <- as.character(toupper(coins$symbol))
  coins$name <- as.character(coins$name)
  coins$slug <- as.character(baseurl)
  coins$rank <- as.numeric(coins$rank)
  return(coins)
}
