*********************************************************************************
* povcalnet_aggquery                                                            *
*! v1.0  		sept2018               by 	Jorge Soler Lopez					*
*											Espen Beer Prydz					*
*											Christoph Lakner					*
*											Ruoxuan Wu							*
*											Qinghua Zhao						*
*											World Bank Group					*
*********************************************************************************

program def povcalnet_aggquery, rclass

version 9.0

    syntax                    ///
      [,                      ///
				COUntry(string)       ///
				REGion(string)        ///
				YEAR(string)          ///
				POVLine(string)       ///
				CLEAR                 ///
				NOSUMmary             ///
				PPP(string)           ///
				fillgaps      ///
				SERVER(string)        ///
				coverage(string)      /// just for compatibility witn povcalnt_query
				pause                 /// for debugging
      ]     

if ("`pause'" == "pause") pause on
else                      pause off
			
quietly {
	***************************************************
	* 0. Housekeeping
	***************************************************

	local base="http://iresearch.worldbank.org/PovcalNet/PovcalNetAPI.ashx"

	if "`server'"!=""  {
		local base="`server'/PovcalNetAPI.ashx"
	} 
    
	if  ("`country'" == "") & ("`region'" == ""){
    di  as err "Either provide country(ies) or region(s), or all. Please try again."
    exit 198
  }

	
	***************************************************
	* 1. Will load guidance database
	***************************************************
	
	povcalnet_info, clear justdata `pause'
	
	***************************************************
	* 2. Keep selected countries and save codes
	***************************************************
	
	if ("`country'" != "") {
		gen keep_this = 0
		local country_l = `""`country'""'
		local country_l: subinstr local country_l " " `"", ""', all

		replace keep_this = 1 if inlist(country_code, `country_l')
		if lower("`country'") == "all" replace keep_this = 1
		
		keep if keep_this == 1
		
		local obs = _N
		if (`obs' == 0) {
			di  as err "{p 4 4 2}No surveys found matching your criteria. You could use the {stata povcalnet_info: guided selection} instead. {p_end}"
			error
		}
		levelsof code, local(country_f) sep(,) clean
	}
	
	***************************************************
	* 3. Request and copying
	***************************************************
	
	local y_comma: subinstr local year " " ",", all
	if "`year'" == "last" local y_comma = "all"
	
	if ("`country'" != "") {
		local country_query = "Countries=`country_f'&GroupedBy=Customized&"
	}
	if ("`region'" != "") {
		local country_query = "Countries=all&GroupedBy=WB&"
	}
	
	tempfile temp1
	local queryfull = "`country_query'YearSelected=`y_comma'&PovertyLine=`povline'&format=csv"
	copy "`base'?`queryfull'" `temp1'
	insheet using `temp1', `clear' name

	pause aggquery - after loading data 
	
	if  ("`region'" != "") {
		tempvar keep_this
		gen `keep_this' = 0
		local region_l = `""`region'""'
		local region_l: subinstr local region_l " " `"", ""', all

		replace `keep_this' = 1 if inlist(regioncid, `region_l')
		if lower("`region'") == "all" replace `keep_this' = 1
		keep if `keep_this' == 1 
	}
	
	pause aggquery - after droping by region 
	
	local obs = _N
	if (`obs' == 0){
		noi di ""
		noi di as err "{p 4 4 2} There was no data downloaded. {p_end}"
		noi di ""
		noi dis as text "{p 4 4 2} Please check that all parameters are correct and try again. {p_end}"
		noi dis as text  `"{p 4 4 2} References year can only be 1981, 1984, 1987, 1990, 1993, 1996, 1999, 2002, 2005, 2008, 2010, 2011, 2012, 2013 and 2015 (As of Sep 2018). Due to the constant updating of the PovCalNet databases, using the option {it:last} or {it:all} will load the years most updated year(s). {p_end}"'
		noi di ""
		error 20
	}
	
	if  ("`year'" == "last"){
		tempvar `maximum_y'
		bys regioncid: egen `maximum_y' = max(requestyear)
		keep if `maximum_y' ==  requestyear
	}
	
	***************************************************
	* 4. Renaming and labelling
	***************************************************
	

	rename regioncid regioncode
	rename regiontitle region
	rename hc headcount
	rename pg povgap
	rename p2 povgapsqr
	rename population reqyearpopulation
	
	label var requestyear "Year you requested"
	label var povertyline "Poverty line in PPP$ (per capita per day)"
	label var mean  "Average monthly per capita income/consumption in PPP$"
	label var headcount "Poverty Headcount"
	label var povgap "Poverty Gap"
	label var povgapsqr "Squared poverty gap"
	label var reqyearpopulation "Population in year"
	
	
	local Snames region regioncode requestyear  povertyline /* 
	 */ povgap povgapsqr reqyearpopulation 

	local Rnames region_title region_code request_year poverty_line  /* 
	 */ poverty_gap poverty_gap_sq population
	 
	local i = 0
	foreach var of local Snames {
		local ++i
		rename `var' `: word `i' of `Rnames''
	}
	
	order region_title region_code request_year poverty_line mean /* 
	 */ headcount poverty_gap poverty_gap_sq population
	
	return local queryfull  "`queryfull'"
}

end

	