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

#### Temporal installation

1. Click on the green icon "Clone or Download" above. 
2. Download the package as zip. 
3. Extract the files with extension `.ado` and `.sthlp` only, and place them in the directory `c:/ado/plus/p`
4. type `discard` in Stata. 

#### Proper installation (Not yet available due to World Bank network restrictions).
We recommend installing the [github](https://github.com/haghish/github) Stata command by [E. F. Haghish](https://github.com/haghish)

```stata
net install github, from("https://haghish.github.io/github/")
```
Then, type the following in Stata:
```stata
github install worldbank/povcalnet
```

## Examples

```stata
* Retrieve ONE country with default parameters

povcalnet, country("ALB") clear

* Retrieve MULTIPLE countries with default parameters

povcalnet, country("all") clear

povcalnet, country("ALB CHN") clear

* Change poverty line
povcalnet, country("ALB CHN") povline(10) clear

povcalnet, country("ALB CHN") povline(5 10) clear

* Select specific years

povcalnet, country("ALB") year("2002 2012") clear
povcalnet, country("ALB") year("2002 2020") clear  // just 2002
cap noi povcalnet, country("ALB") year("2020") clear       // error

povcalnet, country("ALB") year("2002") clear

* Change coverage

povcalnet, country("all") coverage("urban") clear

povcalnet, country("all") coverage("rural") clear

povcalnet, country("all") coverage("national") clear

povcalnet, country("all") coverage("rural national") clear

* Aggregation
povcalnet, country("ALB CHN") aggregate clear

povcalnet, country("all")  aggregate clear 

povcalnet, country("all")  aggregate year(last) clear 

povcalnet, aggregate region(LAC) clear 

povcalnet, aggregate region(all) clear 


* Fill gaps when surveys are missing for specific year

povcalnet, country("ALB CHN") fillgaps clear 
povcalnet, country("ALB CHN") fillgaps coverage("national") clear

* PPP

povcalnet, country("ALB CHN") ppp(50 100) clear


* Country level (one-on-one) request
povcalnet cl, country("ALB CHN")       /*
            */	povline(1.9 2.0)          /*
            */  year("all")           /*
            */  ppp(40 30) clear

						
povcalnet cl, country("DOL DOM")           /*  get info only for DOM
            */	coverage("national")      /*
            */  year(2002)             /*
            */  povline(10) clear

						
povcalnet cl, country("COL DOM")           /*  get info for both
            */	coverage("national")      /*
            */  year(all)             /*
            */  povline(4) clear

						
povcalnet cl, country("COL DOM")            /*  
            */	coverage("urban national")  /*
            */  year(all)                   /*
            */  povline(4) clear

						
*----------  Understanding requests and aggregates
// --------------------------
// Basic Syntax  and defaults
// ------------------------

****** Main defaults
** all survey years, all coverages, 1.9 USD poverty. 
povcalnet

** filter by country
povcalnet, country(COL) clear

** Filter by year (only surveys avaialable in that year)
povcalnet, year(2017) clear

** Filter by coverage (national, urban, rural)
povcalnet, coverage(urban) clear

** Poverty lines
povcalnet, povline(3.2) clear

// ------------------------
// Povcalnet features
// ------------------------

** fill gaps (Reference Years)
* regular 
povcalnet, country(COL BRA ARG IND) year(2015) clear 

* fill gaps
povcalnet, country(COL BRA ARG IND) year(2015) clear  fillgaps

** Customized Aggregate
povcalnet, country(COL BRA ARG IND) year(2015) clear  aggregate

***** Aggregating all countries

** using country(all)
povcalnet, country(all) year(2015) clear  aggregate

** parsing the list of all countries 
povcalnet info, clear
levelsof country_code, local(all) clean 
povcalnet, country(`all') year(2015) clear  aggregate

***** WB aggregates
povcalnet wb, clear  year(2015)
povcalnet wb, clear  region(SAR LAC)
povcalnet wb, clear             // all reference years

* one-on-one query
povcalnet cl, country(COL BRA ARG IND) year(2011) clear coverage("national national urban national")


// ------------------------
// advance options  and features
// --------------------

* Different national coverages
povcalnet, coverage(national) country(IND COL) clear

* PPP option

```


