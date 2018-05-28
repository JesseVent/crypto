![alt text](https://github.com/JesseVent/Crypto-Market-Scraper/blob/dd67704fea43f4e77e07435924e5fe4ede4b73ab/dataset-cover.png?raw=true "Cryptocurrency Market Data Banner")
![Cran](http://cranlogs.r-pkg.org/badges/grand-total/crypto) ![Cran](http://cranlogs.r-pkg.org/badges/crypto) ![Cran](http://cranlogs.r-pkg.org/badges/last-week/crypto) ![Cran](http://cranlogs.r-pkg.org/badges/last-day/crypto) [![Rdoc](http://www.rdocumentation.org/badges/version/crypto)](http://www.rdocumentation.org/packages/crypto)

## Historical Cryptocurrency Prices For ALL Tokens!

Retrieves all the open, high, low, close values for all cryptocurrencies. This retrieves data from CoinMarketCap's historical prices, exchange details and current prices API.

- Retrieves historical crypto currency data `getCoins()`
- Retrieves current crypto currency prices `getPrices()`
- Retrieves list of all crypto currencies `listCoins()`
- Retrieves all crypto exchanges and their listings `getExchanges()`
- Converts/summarises historical data into xts objects `crypto2xts`

### Prerequisites

Below are the high level dependencies for the package to install correctly.

```
R (>= 3.4.0), foreach, rvest, xml2, doSNOW

# Ubuntu 
sudo apt install libxml2-dev libcurl4-openssl-dev libssl-dev
```

### Installing

The _crypto_ R-package is installable through CRAN or through github.

```R
# Installing via CRAN
install.packages("crypto", dependencies = TRUE)

# Installing via Github
devtools::install_github("jessevent/crypto")
```

## Package Usage

These are the main functions that are added so far and a brief summary of what they do. Additional parameters are viewable in the documentation for each function.

> Please give this package a star if you find it helpful

```R
library(crypto)

# Retrieve crypto market history for all-to-n coins
?getCoins
will_i_get_rich <- crypto_history(limit=50)

# Retrieve crypto market history for specific coin
?getCoins
will_i_get_rich_from <- crypto_history("kin")

# Get list of coins and rank
?listCoins
rich_list <- crypto_list()

# Retrieve current crypto market details
?getPrices
am_i_rich_now <- crypto_prices()

# Retrieve exchange details for all coins or specific coin
?getExchanges
where_do_i_get_rich <- crypto_exchanges()

# Convert and/or summarise market history into xts object
?crypto2xts
when_will_i_get_rich <- crypto_xts(will_i_get_rich, "week")

# Get timeseries market data for token for displaying in charts
?daily_market
show_me_getting_rich <- daily_market('bitcoin')

# Get timeseries global market data for all coins or alt coins for displaying in charts
?global_market
show_me_everyone_getting_rich <- global_market()
```

## Package Issues
> Please run the below before raising an issue, then include the output from sessionInfo()
```R
crypto::repair_dependencies()

print(sessionInfo())
```

## Built With :heart_eyes_cat: R

- [Kaggle](https://www.kaggle.com/jessevent/all-crypto-currencies) - Get this dataset on kaggle!
- [CoinSpot](https://coinspot.com.au?affiliate=9V5G4) - Invest $AUD into Crypto today!
- [CoinMarketCap](https://coinmarketcap.com/) - Providing amazing data @CoinMarketCap
- [CRAN](https://CRAN.R-project.org/package=crypto) - The CRAN repository for crypto

### Author/License

- **Jesse Vent** - Package Author - [jessevent](https://github.com/jessevent)

This project is licensed under the MIT License - see the
<license.md> file for details</license.md>

### Acknowledgments

- Thanks to the team at <https://coinmarketcap.com> for the great work they do and to the team at CoinTelegraph where the images were sourced.
- Please star this if you find it useful, and remember the crypto currency market is volatile by nature, please be responsible if trading.
- If by chance you do manage to make your fortune through some game-changing model, I'd appreciate your consideration in the below :)

  ```
  ERC-20: 0x375923Bf82F0b728d23A5704261a6e16341fd860
  XRP: rK59semLsuJZEWftxBFhWuNE6uhznjz2bK
  LTC: LWpiZMd2cEyqCdrZrs9TjsouTLWbFFxwCj
  ```
