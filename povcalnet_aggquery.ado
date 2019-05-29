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

    syntax                                  ///
                 [,                         ///
                        COUntry(string)    ///
						REGion(string)		///
                        YEAR(string)		///
						POVLine(string) 	///
						NOSUMmary			///
						CLEAR				///
						PPP(string)			///
						COUNTRYEStimates  	///
						SERVER(string)		///
                 ]				 
				 
quietly {
	***************************************************
	* 0. Housekeeping
	***************************************************

	local base="http://iresearch.worldbank.org/PovcalNet/PovcalNetAPI.ashx"

	if "`server'"!=""  {
		local base="`server'/PovcalNetAPI.ashx"
	} 
    
	if  ("`country'" != "") & ("`region'" != ""){
        di  as err "Either provide country or region, but not both. Please try again."
        exit 198
    }
	
	if  ("`country'" == "") & ("`region'" == ""){
        di  as err "Either provide country(ies) or region(s), or all. Please try again."
        exit 198
    }

	
	***************************************************
	* 1. Will load guidance database
	***************************************************
	
	capture {
		tempfile temp1000
		cap: copy "http://iresearch.worldbank.org/PovcalNet/js/initCItem2014.js" `temp1000'
		local rccopy = _rc
		cap : import delim using `temp1000',  `clear' delim(",()") stringc(_all) stripq(yes) varnames(nonames)
		local rcclear = _rc
		drop if v2==""
		drop v1
		ren v2 code
		gen countrycode=substr(code,1,3)
		drop v14
		drop v15
		ren v3 regioncode
		ren v4 uncode
		ren v5 inc
		ren v6 countryname
		ren v7 coverage
		ren v9 povline
		ren v10 ppp
		ren v12 pppimp
		ren v13 years
		drop v*
		generate coveragename = ""
		replace coveragename = "--Rural" if coverage == "R"
		replace coveragename = "--Urban" if coverage == "U"
		replace coveragename = "--National Aggregate" if coverage == "A"
	}
	
	if (`rccopy' != 0) { //Use cache if error
		cap:findfile _initCItem2014.dta
		local file `"`r(fn)'"'
		local wd : environment HOME
		if strpos(`"`file'"', "~") == 1 & !missing(`"`wd'"') {
			local file : subinstr local file"~" "`wd'"
        }
		cap: use `"`file'"', `clear'
		noi di  as result "Guidance file couldn't be updated, using local one."
		noi di  as result "Last version saved: `_dta[note1]'"
	}
	
	
	if (`rcclear' != 0) {
		noi di ""
		di  as err "You must start with an empty dataset; or enable the clear option."
		noi di ""
		exit `rcclear'
		noi di ""
		break
	}
	
	***************************************************
	* 2. Keep selected countries and save codes
	***************************************************
	
	if  ("`country'" != ""){
	gen keep_this = 0
	local country = lower("`country'")
	replace countrycode = lower(countrycode)
	
	foreach country_l of local country{
		replace keep_this = 1 if countrycode == "`country_l'"
	}
	if "`country'" == "all" replace keep_this = 1
	
	keep if keep_this == 1
	
	local obs = _N
	if (`obs' == 0) {
        di  as err "{p 4 4 2}No surveys found matching your criteria. You could use the {stata povcalnet_info: guided selection} instead. {p_end}"
		exit 
		break
    }

	forvalues i_obs = 1/`obs'{
		local country_f = "`country_f'"+"`=code[`i_obs']'"+","
	}
	}
	
	***************************************************
	* 3. Request and copying
	***************************************************
	
	local y_comma: subinstr local year " " ",", all
	if "`year'" == "last" local y_comma = "all"
	if ("`country'" != "") local country_query = "Countries=`country_f'&GroupedBy=Customized&"
	if ("`region'" != "") local country_query = "Countries=all&GroupedBy=WB&"
	local region = lower("`region'")
	tempfile temp1
	local queryfull = "`country_query'YearSelected=`y_comma'&PovertyLine=`povline'&format=csv"
	copy "`base'?`queryfull'" `temp1'
	cap : insheet using `temp1', `clear' name
	local rc3 = _rc
	if (`rc3' != 0) {
		noi di ""
		di  as err "You must start with an empty dataset; or enable the clear option."
		noi di ""
		exit `rc3'
		noi di ""
		break
	}
	gen to_keep = 0
	foreach i_reg of local region{
		replace to_keep = 1 if lower(regioncid) == "`i_reg'"
	}
	if ("`region'" == "all" | "`region'" == "") replace to_keep = 1 
	qui cap keep if to_keep == 1
	qui cap drop to_keep


	local obs = _N
	if (`obs' == 0){
		noi di ""
		noi di as err "{p 4 4 2} There was no data downloaded. {p_end}"
		noi di ""
		noi dis as text "{p 4 4 2} Please check that all parameters are correct and try again. {p_end}"
		noi dis as text  `"{p 4 4 2} References year can only be 1981, 1984, 1987, 1990, 1993, 1996, 1999, 2002, 2005, 2008, 2010, 2011, 2012, 2013 and 2015 (As of Sep 2018). Due to the constant updating of the PovCalNet databases, using the option {it:last} or {it:all} will load the years most updated year(s). {p_end}"'
		noi di ""
		break
		exit 20
	}
	
	if  ("`year'" == "last"){
		bys regioncid: egen maximum_y = max(requestyear)
		keep if maximum_y ==  requestyear
		drop maximum_y
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

	return local queryfull  "`queryfull'"
}

end

	