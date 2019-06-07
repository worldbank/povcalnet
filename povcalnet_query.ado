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
      [                       ///
				COUntry(string)       ///
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
	
	*---------- Check that at least one year is available
	if ("`year'"=="all") | ("`year'"=="last") | ("`fillgaps'"!="") {
	 local year_ok = 1
	}
	else {
		split year, parse(,) gen(yr)
		putmata Y=(yr*), replace
		drop yr*
		mata: y = tokens(st_local("year"));     /* 
		 */	 c = 0;                             /* 
		 */	 for (i = 1; i <= cols(y); i++) {;  /* 
		 */	 		c = c + anyof(Y, y[i]);         /*  
		 */	 };                                 /* 
		 */	 st_local("year_ok", strofreal(c))
	}
	
	if (`year_ok' == 0) {
		di  as err "years selected do not match any survey year for any country." _n /* 
		  */	"You could type {stata povcalnet info} to check availability."
		error 20
  }
	
	
	/*==================================================
           Create Queries
	==================================================*/
	
	*---------- Year query
	local y_comma: subinstr local year " " ",", all
	if ("`year'" == "last") local y_comma = "all"
	if ("`fillgaps'" == "") local year_q = "surveyyears=`y_comma'"
	if ("`fillgaps'" != "") local year_q = "refyears=`y_comma'&display=c"
	
	*---------- Country query
	levelsof code, local(country_q) sep(,) clean
	local country_q = "Countries=`country_q'"
	
	
	*---------- Poverty lines query
	local povline_q = "PovertyLine=`povline'"
	
	*---------- Full Query
	local query = "`year_q'&`country_q'&`povline_q'&format=csv"
	return local query  "`query'"
	
	***************************************************
	* 4. Request and copying
	***************************************************
	
	*---------- download data
	tempfile clfile
	local queryfull "`base'?`query'"
	return local queryfull = "`queryfull'"
	
	
	local rc = 0

	cap copy "`queryfull'" `clfile'
	if (_rc == 0) {
		cap insheet using `clfile', clear name
		if (_rc != 0) local rc "in"
	} 
	else {
		local rc "copy"
	} 

	*---------- Clean data
	povcalnet_clean 1, year("`year'") `iso' rc(`rc')

	
	
} // end of qui

end

