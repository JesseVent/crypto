# Cryptocurrency Market Data

## Historical Cryptocurrency Prices For ALL Tokens!

Retrieves all the open, high, low, close values for all cryptocurrencies. This retrieves data from CoinMarketCap's historical tables.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
R (>= 3.4.3), foreach, rvest, xml2
```

### Installing

For now installation is through devtools::install_github("jessevent/crypto") until the cran package is accepted.

### Installing crypto via Github

```
library(devtools)
install_github("jessevent/crypto")
```

### Installing crypto via CRAN

- Waiting for approval to be added as CRAN package

```
install.packages("crypto")
```

## Usage

### Load Crypto Package

```
library(crypto)
```

### Retrieve All Cryptocurrencies Market History

This is the main function of this package and once ran will go and scrape all the historical tables of all the different cryptocurrencies listed on CoinMarketCap and turn it into a data frame.

```
will_i_get_rich <- getCoins()
```

### Output

I've had to go over the code with a fine tooth comb to get it compatible with CRAN so there have been significant enhancements to how some of the field conversions have been undertaken and the data being cleaned. This should eliminate a few issues around number formatting or unexpected handling of scientific notations.

```
Observations: 656,772
Variables: 10
$ symbol  <chr> "BTC", "BTC", "BTC", "BTC", "BTC", "BTC", "BTC", "BTC", "BTC", "BTC", "BTC", "BTC", "B...
$ date    <date> 2013-04-28, 2013-04-29, 2013-04-30, 2013-05-01, 2013-05-02, 2013-05-03, 2013-05-04, 2...
$ open    <dbl> 135.30, 134.44, 144.00, 139.00, 116.38, 106.25, 98.10, 112.90, 115.98, 112.25, 109.60,...
$ high    <dbl> 135.98, 147.49, 146.93, 139.89, 125.60, 108.13, 115.00, 118.80, 124.66, 113.44, 115.78...
$ low     <dbl> 132.10, 134.00, 134.05, 107.72, 92.28, 79.10, 92.50, 107.14, 106.64, 97.70, 109.60, 10...
$ close   <dbl> 134.21, 144.54, 139.00, 116.99, 105.21, 97.75, 112.50, 115.91, 112.30, 111.50, 113.57,...
$ volume  <dbl> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...
$ market  <dbl> 1500520000, 1491160000, 1597780000, 1542820000, 1292190000, 1180070000, 1089890000, 12...
$ name    <chr> "Bitcoin", "Bitcoin", "Bitcoin", "Bitcoin", "Bitcoin", "Bitcoin", "Bitcoin", "Bitcoin"...
$ ranknow <dbl> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,...
```

## Built With :heart: R

- [Kaggle](https://www.kaggle.com/jessevent/all-crypto-currencies) - Get this dataset on kaggle!
- [CoinSpot](https://coinspot.com.au?affiliate=9V5G4) - Invest $AUD into Crypto today!
- [CoinMarketCap](https://coinmarketcap.com/) - Providing amazing data @CoinMarketCap

## Authors

- **Jesse Vent** - _Initial work_ - [jessevent](https://github.com/jessevent)

## License

This project is licensed under the MIT License - see the <LICENSE.md> file for details

## Acknowledgments

- Thanks to the team at <https://coinmarketcap.com> for the great work they do and to the team at CoinTelegraph where the images were sourced.

- Please star this if you find it useful, and remember the crypto currency market is volatile by nature, please be responsible if trading.

- If by chance you do manage to make your fortune through some game-changing model, I'd appreciate your consideration in the below :)

- BTC: 1LPjH7KyH5aD65pTBhByXFCFXZNTUVdeRY

- ETH: 0x375923Bf82F0b728d23A5704261a6e16341fd860
