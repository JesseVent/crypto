# Latest CRAN submission comments

## crypto 0.1.5 - Minor resubmission

- Changed listCoins url to the new service
- added error handling to foreach call

### Tested on Mac OSX R 3.4.3 & WinBuild

```
Please check the log files and (if working) the binary package at:
https://win-builder.r-project.org/eKqB2fCcg57r
The files will be removed after roughly 72 hours.
Installation time in seconds: 4
Check time in seconds: 78
Status: 1 NOTE
```

**Notes regard usage of doSNOW, no alternative please see previous comments below for note resolution.**

# Previous CRAN submission comments
## crypto 0.1.4 - Minor resubmission

- Fixed rounding issue in getCoins & getPrices by introducing replace_na from tidyr package
- Addition of tidyr package to DESCRIPTION
- Fixed issue in getPrices to do with currency conversion

## crypto 0.1.3 

Apologies for resubmission, but I identified a defect in one of my functions that was returning the wrong result when packaged. Change summary is below:

- Fixing defect in getPrices function by adding return(prices)

## crypto 0.1.2

- Updated to CRAN canonical link in readme
- Changed cryptocurrency in DESCRIPTION to crypto currency to resolve spelling error
- Changed getExchanges example to \dontrun to prevent over 10 seconds error.
- doSNOW note as per previous comments, is required instead of doParallel

## crypto 0.1.1

- Update to resolve check NOTES on different platforms.
- Included additional parameters in getCoins function

## crypto 0.1.0

- Updated coinmarketcap url in DESCRIPTION to correct format
- Updated Depends: R (>= 3.4.3) to R (>= 3.4.0)
- Added URL/Bug Report links for the package on Github, and Kaggle where the data is available
- Added additional features in the data
- Added new parameters to be able to retrieve individual coin instead of all crypto by default
- Included the new parameters as @examples so they will be properly verified when running check
- Resolved issue due to merging non-distinct crypto names impacting some tokens to be duplicated
- Enhanced all the documentation and cleaned it up to make it simpler and easier to read
- Added additional notes in docs to clarify dependency on doSNOW package

# Note Resolution

The reason I am using doSNOW is due to some of the lower level features included in the package that are not included in doParallel (doSNOW last updated 2017-12-14)

The main function web scrapes over 1300+ pages, and can take anywhere from 1-10 minutes to run, but while doing so the progress bar really helps to show progression.

I did attempt to swap doSNOW over to doParallel; but using doSNOW was the only way I could get real time updates to occur and inform the user.
