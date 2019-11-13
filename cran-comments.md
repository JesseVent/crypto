# Latest CRAN submission comments
### crypto minor release 1.1.2
To resolve advice from CRAN around elegant handling of web service error messages I have introduced new wrapper function to handle error/warning messages and updated the references in the rest of the package to match.

** Rhub results **
```
> rhub::last_check()

── crypto 1.1.2: OK

  Build ID:   crypto_1.1.2.tar.gz-088621685dd54a7cbef656f197b4b335
  Platform:   Windows Server 2008 R2 SP1, R-devel, 32/64 bit
  Submitted:  21h 34m 31.2s ago
  Build time: 6m 51.3s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── crypto 1.1.2: OK

  Build ID:   crypto_1.1.2.tar.gz-a61ada3b32574e51a816ec8c7c65d80a
  Platform:   Ubuntu Linux 16.04 LTS, R-release, GCC
  Submitted:  21h 34m 31.2s ago
  Build time: 17m 37.5s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── crypto 1.1.2: OK

  Build ID:   crypto_1.1.2.tar.gz-0301f11569e64d90af1778f7b441fd8b
  Platform:   Fedora Linux, R-devel, clang, gfortran
  Submitted:  21h 34m 31.2s ago
  Build time: 20m 0.8s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```

### crypto minor release 1.1.1
To resolve the following [crypto ERRORs and NOTEs under R-oldrelease](https://cran.r-project.org/web/checks/check_results_crypto.html)

Thanks for letting me know

**Changes**

-   Added new function to handle UTF-8 encoding dynamically on windows and unix bases systems
-   Removed install_keyring() function which required utils::askYesNo which is only available for R >= 3.5
-   Removed keyring from Imports to fix CRAN note

I have opted to provide message advising to install keyring package instead of prompting installation of keyring package through use of askYesNo, as my preference is for the package to work for R 3.4

**Expected Note**

```
Possibly mis-spelled words in DESCRIPTION:
  crypto (4:24, 4:230)
  Cryptocurrency (3:8)
```

**Note Comments**

The following words are now included in the oxford dictionary:

-   crypto - [Crypto Oxford Dictionary Entry](https://en.oxforddictionaries.com/definition/us/crypto)
-   cryptocurrency - [Cryptocurrency Oxford Dictionary Entry](https://en.oxforddictionaries.com/definition/cryptocurrency)

**Winbuilder Check Results**
```
Your package crypto_1.1.1.tar.gz has been built (if working) and checked for Windows.
Please check the log files and (if working) the binary package at:
https://win-builder.r-project.org/4axVQenM4q1a
The files will be removed after roughly 72 hours.
Installation time in seconds: 11
Check time in seconds: 194
Status: 1 NOTE
R version 3.5.2 (2018-12-20)
```

**Rhub Check Results**
```
> rhub::list_package_checks(howmany = 6)
  package version status submitted             platform
1  crypto   1.1.1   note   ~2h ago   fedora-clang-devel
2  crypto   1.1.1   note   ~2h ago   ubuntu-gcc-release
3  crypto   1.1.1   note   ~2h ago windows-x86_64-devel
4  crypto   1.1.1     ok   ~2h ago   fedora-clang-devel
5  crypto   1.1.1   note   ~2h ago   ubuntu-gcc-release
6  crypto   1.1.1   note   ~2h ago windows-x86_64-devel
```


### crypto major release 1.1.0

-   Significant changes to entire package due to upgrade to CMC API.
-   All parallel processing functionality has been removed (Yay no more doSNOW notes!).
-   All previously notified functions that were deprecated are now removed.
-   Better progress bar and API key handling introduced.
-   Removed redundant functions no longer required.
-   Added helper functions to assist with dependency management.

**Checks Completed On RHub**
**Winbuilder Check Results**

    Your package crypto_1.2.0.tar.gz has been built (if working) and checked for Windows.
    Please check the log files and (if working) the binary package at:
    https://win-builder.r-project.org/N53I6FsQ14bU
    The files will be removed after roughly 72 hours.
    Installation time in seconds: 10
    Check time in seconds: 100
    Status: OK
    R version 3.5.1 (2018-07-02)

### crypto bug fix 1.0.4

-   fixing dependency bug by including dplyr:bind_rows

**Notes regard usage of doSNOW, no alternative please see previous comments below for note resolution.**

### crypto minor release 1.0.3

-   turning off verbose mode from `crypto_history()` function
-   added additional check in `encoding.R` to not change locale for existing windows UTF-8 encoding
-   updating crypto_exchanges to include new columns to resolve GitHub issue
-   other minor bug fixes

**Notes regard usage of doSNOW, no alternative please see previous comments below for note resolution.**

## crypto 1.0.2 - Minor resubmission

My sincere apologies for the resubmission, wasting your time was not my intention

-   Option .verbose changed from TRUE to FALSE in crypto_history() function.
-   Changed if(match.call) function to ifelse to resolve warning message when calling function

## crypto 1.0.1 - CRAN resubmission

-   Added list length check into daily_market function to handle different length columns


    Your package crypto_1.0.0.tar.gz has been built (if working) and checked for Windows.
    Please check the log files and (if working) the binary package at:
    https://win-builder.r-project.org/nJgAFzn14Xf3
    The files will be removed after roughly 72 hours.
    Installation time in seconds: 13
    Check time in seconds: 161
    Status: 1 NOTE
    R Under development (unstable) (2018-05-27 r74786)

## crypto 1.0.0 - Major Submission

-   Added two new usable functions `global_market()` and `daily_market()` which retrieve timeseries data for charts and visualisations
-   Added two new functions `replace_encoding()` and `reset_encoding()` to handle locale encoding issues which will change encoding to UTF-8, then at end of function call will reset back to users original locale setting. **Github Issue: Data inconsistency #19**
-   Added messaging to notify user of locale changes
-   Added deprecation messages to `getCoins(), listCoins(), getPrices(), getExchanges() and crypto2xts()` functions to warn about the function names changing to `crypto_history(), crypto_list(), crypto_prices(), crypto_exchanges() and crypto_xts()` respectively.
-   Added helper function `repair_dependencies()` to prompt user to reinstall dependant packages based on feedback from github issues **Github Issue: Error when running getCoins #20**

**Notes regard usage of doSNOW, no alternative please see previous comments below for note resolution.**

# Previous CRAN submission comments

## crypto 0.1.7 - CRAN resubmission fix

-   Update to new maintainer email address at cryptopackage@icloud.com
-   Confirmation/approval provided via email trail with Uwe linked to 0.1.6 submission
-   Update to LICENSE file to align with CRAN template as per note
-   Added winbuilder check results to cran-comments

## crypto 0.1.6 - Minor resubmission

-   Added crypto2xts function to getCoins() into xts object
-   crypto2xts can be summarised by time periods
-   Addition of 'xts' package to DESCRIPTION
-   Addition of NEWS file
-   In DESCRIPTION changed contact email address to align with Github

**Please let me know if email address change is not allowed, just trying to protect my own privacy a bit more as I have been getting a large amount of unsolicited contact through different channels and trying to consolidate public contact details.**

### Tested on Mac OSX R 3.5.0 & WinBuild

    Your package crypto_0.1.6.tar.gz has been built (if working) and checked for Windows.
    Please check the log files and (if working) the binary package at:
    https://win-builder.r-project.org/grYhYUjUETas
    The files will be removed after roughly 72 hours.
    Installation time in seconds: 8
    Check time in seconds: 127
    Status: 1 NOTE
    R Under development (unstable) (2018-04-28 r74669)

## crypto 0.1.5 - Minor resubmission

-   Changed listCoins url to the new service
-   added error handling to foreach call

## crypto 0.1.4 - Minor resubmission

-   Fixed rounding issue in getCoins & getPrices by introducing replace_na from tidyr package
-   Addition of tidyr package to DESCRIPTION
-   Fixed issue in getPrices to do with currency conversion

## crypto 0.1.3

Apologies for resubmission, but I identified a defect in one of my functions that was returning the wrong result when packaged. Change summary is below:

-   Fixing defect in getPrices function by adding return(prices)

## crypto 0.1.2

-   Updated to CRAN canonical link in readme
-   Changed cryptocurrency in DESCRIPTION to crypto currency to resolve spelling error
-   Changed getExchanges example to \\dontrun to prevent over 10 seconds error.
-   doSNOW note as per previous comments, is required instead of doParallel

## crypto 0.1.1

-   Update to resolve check NOTES on different platforms.
-   Included additional parameters in getCoins function

## crypto 0.1.0

-   Updated coinmarketcap url in DESCRIPTION to correct format
-   Updated Depends: R (>= 3.4.3) to R (>= 3.4.0)
-   Added URL/Bug Report links for the package on Github, and Kaggle where the data is available
-   Added additional features in the data
-   Added new parameters to be able to retrieve individual coin instead of all crypto by default
-   Included the new parameters as @examples so they will be properly verified when running check
-   Resolved issue due to merging non-distinct crypto names impacting some tokens to be duplicated
-   Enhanced all the documentation and cleaned it up to make it simpler and easier to read
-   Added additional notes in docs to clarify dependency on doSNOW package

# Note Resolution

The reason I am using doSNOW is due to some of the lower level features included in the package that are not included in doParallel (doSNOW last updated 2017-12-14)

The main function web scrapes over 1300+ pages, and can take anywhere from 1-10 minutes to run, but while doing so the progress bar really helps to show progression.

I did attempt to swap doSNOW over to doParallel; but using doSNOW was the only way I could get real time updates to occur and inform the user.
