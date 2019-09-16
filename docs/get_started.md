# Getting Started

Here are some examples on how to use the `povcalnet` command. 

## Default Options

Be default `povcalnet` returns poverty estimates at \$1.9 usd a day in 2011 PPP for all the surveys available at three different levels of coverage depending on availability; national, urban, and rural areas. 

```stata

```



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



