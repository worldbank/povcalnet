*********************************************************************************
* povcalnet_query                                                               *
*! v1.0  		sept2018               by 	Jorge Soler Lopez					*
*											Espen Beer Prydz					*
*											Christoph Lakner					*
*											Ruoxuan Wu							*
*											Qinghua Zhao						*
*											World Bank Group					*
*********************************************************************************
program def povcalnet_query, rclass

version 9.0

    syntax ,                   ///
      YEAR(string)             ///
      COUntry(string)          ///
      [                       ///
        REGion(string)         ///
        POVLine(string)        ///
        PPP(string)            ///
        NOSUMmary              ///
        ISO                    ///
        CLEAR                  ///
        AUXiliary              ///
        ORIginal               ///
        INFOrmation            ///
        COESP(string)          ///
        SERVER(string)         ///
				groupedby(string)      ///
				coverage(string)       ///
				pause                  /// for debugging
				fillgaps               ///
      ]

if ("`pause'" == "pause") pause on
else                      pause off
			
quietly {

	************************************************
	* 0. Housekeeping
	************************************************

	local base="http://iresearch.worldbank.org/PovcalNet/PovcalNetAPI.ashx"

	if "`server'"!=""  {
		local base="`server'/PovcalNetAPI.ashx"
	}

	if ("`coesp'" != "") local auxiliary = "auxiliary"

	if ("`ppp'" != "") local ppp_condition = "&PPP0=`ppp'"

	local region = upper("`region'")

	***************************************************
	* 1. Will load guidance database
	***************************************************

	povcalnet_info, clear justdata `pause'

	***************************************************
	* 2. Keep selected countries and save codes
	***************************************************

	*---------- keep if coverage is selected
	if ("`coverage'" != "all") {
		local cv_comma = `""`coverage'""'
		local cv_comma: subinstr local cv_comma " " `"", ""', all
		keep if inlist(coverage_level, `cv_comma')
	}
	
	*---------- Keep selected country
	gen keep_this = 0
	if ("`country'" != "") {
		local country_l = `""`country'""'
		local country_l: subinstr local country_l " " `"", ""', all

		replace keep_this = 1 if inlist(country_code, `country_l')
		if lower("`country'") == "all" replace keep_this = 1
	}

	*---------- Group by wb, un, or income region
	local groupedby = lower("`groupedby'")
	local region_type = "wb_region"
	if ("`groupedby'" == "un")  local region_type = "un_region"
	if (inlist("`groupedby'","income","in","inc")) local region_type = "income_region"

	* If region is selected instead of countries
	if  ("`region'" != "") {
		local region_l = `""`region'""'
		local region_l: subinstr local region_l " " `"", ""', all

		replace keep_this = 1 if inlist(`region_type', `region_l')
		if lower("`region'") == "all" replace keep_this = 1
	}

	keep if keep_this == 1
	if ("`coesp'" != "") keep if code == "`coesp'"

	local obs = _N
	if (`obs' == 0) {
		di  as err "{p 4 4 2}No surveys found matching your criteria. You could use the {stata povcalnet_info: guided selection} instead. {p_end}"
		error
  }

	***************************************************
	* 3. Keep selected years and construct the request
	***************************************************
	 /* 
	if "`auxiliary'" == "" {
		bys country_code: gen number = _N
		gen tag_delete = 1 if (number>2 & inlist(coverage_level,"rural","urban"))
		drop if tag_delete == 1
	}
  */
	
	
	if ("`i_year'"=="all") | ("`i_year'"=="last") | ("`fillgaps'"!="") {
	 local year_ok = 1
	}
	}
	
	local y_comma: subinstr local year " " ",", all
	if ("`year'" == "last") local y_comma = "all"
	if ("`fillgaps'" == "") local year_param = "surveyyears=`y_comma'"
	if ("`fillgaps'" != "") local year_param = "refyears=`y_comma'&display=c&"
	local obs = _N
	local year_ok = 0
	forvalues i_obs = 1/`obs'{
		local country_v = "`=code[`i_obs']',"+"`country_v'"
		foreach i_year of local year{
			local position = strpos("`=year[`i_obs']'","`i_year'")
				if `position'>0 {
					local year_ok = `year_ok'+1
				}
			if ("`i_year'"=="all") | ("`i_year'"=="last") local year_ok = 1
		}
	}

	if ("`fillgaps'"!="") local year_ok = 1

	if (`year_ok' == 0) {
        di  as err "{p 4 4 2}No surveys found matching your criteria. You could use the {stata povcalnet_info: guided selection} instead. {p_end}"
		error 20
    }

	local parameter =	"`year_param'&Countries=`country_v'&"

	***************************************************
	* 4. Request and copying
	***************************************************
	
	*---------- download the data
	tempfile finalfile
	tempfile tempcopy
	local queryfull = "`parameter'PovertyLine=`povline'&format=csv"
	cap copy "`base'?`parameter'PovertyLine=`povline'&format=csv" `tempcopy'
	local rccopy = _rc
	insheet using `tempcopy', clear name

	*---------- Clean data
	povcalnet_clean 1, year("`year'") `iso' region(`region') rccopy(`rccopy')
	
	return local queryfull  "`queryfull'"
	
	
} // end of qui

end

