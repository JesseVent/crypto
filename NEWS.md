# Latest updates, fixes and news for the Crypto package
![Cran](http://cranlogs.r-pkg.org/badges/grand-total/crypto) ![Cran](http://cranlogs.r-pkg.org/badges/crypto) ![Cran](http://cranlogs.r-pkg.org/badges/last-week/crypto) ![Cran](http://cranlogs.r-pkg.org/badges/last-day/crypto) [![Rdoc](http://www.rdocumentation.org/badges/version/crypto)](http://www.rdocumentation.org/packages/crypto)

### crypto major release 1.0.0
#### NEW FUNCTIONS
- **daily_market()** Retrieve timeseries market data for specific token perfect for visualisation.
- **global_market()** Retrieve timeseries global market data for all coins or alt-coins perfect for visualisation.
- **repair_dependencies()** Repair all dependant packagess and install any missing ones.
- **replace_encoding()** Converts locale encoding to use UTF-8 for better localisation and international support.
- **reset_encoding()** Resets locale encoding back to system default.

#### RENAMED/DEPRECATED FUNCTIONS
The following functions have been renamed and will be deprecated in future versions. Functionality remains the same.

```R
getCoins()      -----> crypto_history()
listCoins()     -----> crypto_list()
getExchanges()  -----> crypto_exchanges()
getPrices()     -----> crypto_prices()
crypto2xts      -----> crypto_xts()
```

### crypto release 0.1.6

---

#### NEW FUNCTION  **crypto2xts()**
- Addition of `crypto2xts()` function to convert `getCoins()` into xts object
- `crypto2xts()` can also be used to summarise into specified time periods i.e month, week

### crypto release 0.1.5

---

#### ENHANCEMENT
- Changed `listCoins()` url to the new coinmarketcap services
- Added error handling to foreach call to prevent errors where coins may not exist

### crypto release 0.1.4

---

#### BUG FIX
- Fixed rounding issue in `getCoins()` & `getPrices()` by introducing replace_na from tidyr package
- Fixed issue in `getPrices()` to do with currency conversion

### crypto release 0.1.3

---

#### NEW FUNCTION  **getExchanges()**
- Addition of `getExchanges()` function to retrieve all crypto currencies and their listed exchanges

#### BUG FIX
- Fixing defect in `getPrices()` function by adding return(prices)

### crypto release 0.1.2

---

#### NEW FUNCTION  **getPrices()**
- Addition of `getPrices()` function to retrieve current crypto currency prices

#### BUG FIX
- Minor updates to resolve CRAN errors on windows and linux

### crypto release 0.1.1

---

#### ENHANCEMENT
- Update to resolve check NOTES on different platforms.
- Included additional parameters in `getCoins()` function

### crypto release 0.1.0

---

#### NEW FUNCTIONS
- Addition of `getCoins()` function to retrieve crypto currency prices
- Addition of `listCoins()` function to retrieve list of crypto currencies
- Addition of `scraper()` helper function used in `getCoins()`
