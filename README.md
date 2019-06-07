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

We recommend installing the [github](https://github.com/haghish/github) Stata command by [E. F. Haghish](https://github.com/haghish)

```stata
net install github, from("https://haghish.github.io/github/")
```
Then, type the following in Stata:
```
github install worldbank/povcalnet
```

## Examples

```
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

```



