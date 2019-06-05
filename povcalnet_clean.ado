/*==================================================
project:       Clean data downloaded from Povcalnet API
Author:        R.Andres Castaneda 
Dependencies:  The World Bank
----------------------------------------------------
Creation Date:     5 Jun 2019 - 17:09:04
Modification Date:   
Do-file version:    01
References:          
Output:             dta
==================================================*/

/*==================================================
                        0: Program set up
==================================================*/
program define povcalnet_clean, rclass

syntax anything(name=type),      ///
             [                   ///
								year(string)     ///
								region(string)   ///
								iso              ///
								rccopy(numlist)  ///
             ]



/*==================================================
              1: type 1
==================================================*/

if ("`type'" == "1") {
	
	local obs = _N

	if ("`rccopy'" != "0") {
		noi di ""
		noi di as err "{p 4 4 2} It was not possible to download data from the PovcalNet API. {p_end}"
		noi di ""
		noi dis as text `"{p 4 4 2} (1) Please check your internet connection by {browse "http://iresearch.worldbank.org/PovcalNet/home.aspx" :clicking here}{p_end}"'
		noi dis as text `"{p 4 4 2} (3) Please consider ajusting your Stata timeout parameters. For more details see {help netio}. {p_end}"'
		noi dis as text `"{p 4 4 2} (4) Please send us an email to report this error by {browse "mailto:data@worldbank.org, ?subject= povcalnet query error 20 at `c(current_date)' `c(current_time)': `queryspec' "  :clicking here} or writing to:  {p_end}"'
		noi dis as result `"{p 12 4 2} email: " as input "data@worldbank.org  {p_end}"'
		noi dis as result `"{p 12 4 2} subject: " as input "povcalnet query error 20 at `c(current_date)' `c(current_time)': `queryspec'  {p_end}"'
		noi di ""
		noi di ""
		break
		exit 20
	}

	if (`obs' == 0){
		noi di ""
		noi di as err "{p 4 4 2} There was no data downloaded. {p_end}"
		noi di ""
		noi dis as text "{p 4 4 2} Please check that all parameters are correct and try again. {p_end}"
		noi dis as text  `"{p 4 4 2} You could use the {stata povcalnet_info:guided selection} instead. {p_end}"'
		noi dis as text  `"{p 4 4 2} References year can only be 1981, 1984, 1987, 1990, 1993, 1996, 1999, 2002, 2005, 2008, 2010, 2011, 2012, 2013 and 2015 (As of Sep 2018). Due to the constant updating of the PovCalNet databases, using the option {it:last} or {it:all} will load the years most updated year(s). {p_end}"'
		noi di ""
		break
		exit 20
	}

	if  ("`year'" == "last"){
		bys countrycode: egen maximum_y = max(requestyear)
		keep if maximum_y ==  requestyear
		drop maximum_y
	}


	***************************************************
	* 5. Labeling/cleaning
	***************************************************

	order countrycode countryname regioncode coveragetype requestyear datayear datatype isinterpolated usemicrodata



	if "`iso'"!="" {
		cap replace countrycode="XKX" if countrycode=="KSV"
		cap replace countrycode="TLS" if countrycode=="TMP"
		cap replace countrycode="PSE" if countrycode=="WBG"
		cap replace countrycode="COD" if countrycode=="ZAR"
	}

	rename  prmld  mld
	foreach v of varlist polarization median gini mld decile? decile10 {
		qui cap replace `v'=. if `v'==-1 | `v' == 0
	}

	cap drop if ppp==""
	cap drop  svyinfoid
	
	pause query - after replacing invalid values to missing values
	
	* cap drop  polarization
	qui count
	local obs=`r(N)'

	replace coveragetype = "1" if coveragetype == "R"
	replace coveragetype = "2" if coveragetype == "U"
	replace coveragetype = "4" if coveragetype == "A"
	replace coveragetype = "3" if coveragetype == "N"
	destring coveragetype, force replace
	label define coveragetype 1 "Rural"     /* 
	 */                       2 "Urban"     /* 
	 */                       3 "National"  /* 
	 */                       4 "National (Aggregate)", modify
	 
	label values coveragetype coveragetype


	replace datatype = "1" if datatype == "X"
	replace datatype = "2" if datatype == "Y"
	destring datatype, force replace
	label define datatype 1 "Consumption" 2 "Income", modify
	label values datatype datatype

	label var isinterpolated    "Data is interpolated"
	label var countrycode       "Country/Economy Code"
	label var usemicrodata      "Data comes from grouped or microdata"
	label var countryname       "Country/Economy Name"
	label var regioncode        "Region Code"
	label var region            "Region Name"
	label var coveragetype      "Coverage"
	label var requestyear       "Year you requested"
	label var datayear          "Survey year"
	label var datatype          "Welfare measured by income or consumption"
	label var ppp               "Purchasing Power Parity"
	label var povertyline       "Poverty line in PPP$ (per capita per day)"
	label var mean              "Average monthly per capita income/consumption in PPP$"
	label var headcount         "Poverty Headcount"
	label var povgap            "Poverty Gap."
	label var povgapsqr         "Squared poverty gap."
	label var watts             "Watts index"
	label var gini              "Gini index"
	label var median            "Median monthly income or expenditure in PPP$"
	label var mld               "Mean Log Deviation"
	label var reqyearpopulation "Population in year"


	* Standardize names with R package

	local Snames countrycode countryname regioncode coveragetype requestyear /* 
	 */ datayear datatype isinterpolated usemicrodata povertyline /* 
	 */ povgap povgapsqr reqyearpopulation 

	local Rnames country_code country_name region_code coverage_type request_year /*
	 */ data_year data_type is_interpolated use_microdata poverty_line    /*
	 */ poverty_gap poverty_gap_sq  population 

	local i = 0
	foreach var of local Snames {
		local ++i
		rename `var' `: word `i' of `Rnames''
	}
	 
	sort country_code request_year coverage_type

	*if ("`fillgaps'"!="") drop median gini mld decile*  // why dropping this?
}

/*==================================================
              2: for Aggregate requests
==================================================*/

if ("`type'" == "2") {




}




/*==================================================
              3: 
==================================================*/





end
exit
/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

Notes:
1.
2.
3.


Version Control:


