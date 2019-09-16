Stata client to the Povcalnet API
==================================

[![githubrelease](https://img.shields.io/github/release/worldbank/povcalnet/all.svg?label=current+release)](https://github.com/worldbank/povcalnet/releases)

The `povcalnet` Stata command allows Stata users to compute poverty and inequality
indicators for more than 160 countries and regions the World Bank's database of
household surveys. It has the same functionality as the PovcalNet website. PovcalNet
is a computational tool that allows users to estimate poverty rates for regions,
sets of countries or individual countries, over time and at any poverty line.

PovcalNet is managed jointly by the Data and Research Group in the World Bank's
Development Economics Division. It draws heavily upon a strong collaboration with
the Poverty and Equity Global Practice, which is responsible for the gathering and
harmonization of the underlying survey data.

## Installation 

### From SSC (Not yet available)

```stata
ssc install povcalnet
```

### From GitHub 

#### Proper installation (Might not be available in your computer due to firewall restriction of your organization. See alternative installation below if this is your case).
We recommend installing the [github](https://github.com/haghish/github) Stata command by [E. F. Haghish](https://github.com/haghish)

```stata
net install github, from("https://haghish.github.io/github/")
github install worldbank/povcalnet
```

Alternatively you could install the package by typing the followinf line, 

```stata
net install povcalnet, from("https://raw.githubusercontent.com/worldbank/povcalnet/master/")
```

#### Alternative installation from GitHub in case the options above do not work due to firewall restrictions.

1. Click on the green icon "Clone or Download" above. 
2. Download the package as zip. 
3. Extract the files with extension `.ado` and `.sthlp` only, and place them in the directory `c:/ado/plus/p`
4. type `discard` in Stata. 
