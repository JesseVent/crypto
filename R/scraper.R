#' Scraping Historical Tables from CMC
#'
#' Retrieves historical tables from CoinMarketCap for the input token.
#' This function is a dependency of \code{getCoins()}
#' and is used as part of the loop to retrieve all cryptocurrencies.
#'
#' @param attributes Singular url input from \code{listCoins()}
#
#' @return Returns data.frame of scraped results.
#'  \tabular{lccclcccl}{
#'   Date \tab  \tab  \tab  \tab chr \tab  \tab  \tab  \tab "Dec 17, 2017"\cr
#'   Open \tab  \tab  \tab  \tab dbl \tab  \tab  \tab  \tab 0.000088\cr
#'   High \tab  \tab  \tab  \tab dbl \tab  \tab  \tab  \tab 0.000137\cr
#'   Low \tab  \tab  \tab  \tab dbl \tab  \tab  \tab  \tab 0.000083\cr
#'   Close \tab  \tab  \tab  \tab dbl \tab  \tab  \tab  \tab 0.000125\cr
#'   Volume \tab  \tab  \tab  \tab chr \tab  \tab  \tab  \tab 557,972\cr
#'   Market \tab  \tab  \tab  \tab chr \tab  \tab  \tab  \tab 66,221,100\cr
#'   symbol \tab  \tab  \tab  \tab chr \tab  \tab  \tab  \tab "KIN"\cr
#' }
#'
#' @importFrom magrittr "%>%"
#' @importFrom rvest "html_nodes"
#' @importFrom xml2 "read_html"
#' @export
scraper <- function(attributes) {
  . <- "."
  cpage <- xml2::read_html(attributes, handle = curl::new_handle("useragent" = "Mozilla/5.0"))
  cnames <- cpage %>% rvest::html_nodes(css = ".col-sm-4 .text-large") %>% rvest::html_text(trim = TRUE) %>% replace(!nzchar(.), NA)
  cnodes <- cpage %>% rvest::html_nodes(css = "table") %>% .[1] %>% rvest::html_table(fill = TRUE) %>%
    replace(!nzchar(.), NA)
  scraper <- data.frame(cnodes = cnodes)
  scraper <- Reduce(rbind, cnodes)
  scraper$symbol <- gsub("\\(||\\n|\\)", "", toupper(cnames))
  scraper$symbol <- as.character(strsplit(scraper$symbol, " ")[[1]][1])
  return(scraper)
}
