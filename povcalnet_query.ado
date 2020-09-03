*********************************************************************************
* povcalnet_query                                                               *
*********************************************************************************
program def povcalnet_query, rclass

version 11.0

syntax [anything(name=subcommand)]    ///
[,                       ///
YEAR(string)          ///
COUntry(string)       ///
REGion(string)         ///
POVLine(string)        ///
POPShare(string)	   ///
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
aggregate              ///
wb                     ///
]

if ("`pause'" == "pause") pause on
else                      pause off

quietly {
	
	************************************************
	* 0. Housekeeping
	************************************************
	
	if ("`ppp'" != "") local ppp_q = "&PPP0=`ppp'"
	return local query_pp = "`ppp_q'"
	
	local region = upper("`region'")
	
	*---------- Make sure at least one reference year is selected
	
	if ("`year'" != "all" & ("`wb'" != "" | "`aggregate'" != "")) {	
		local  page "`server'/js/common_NET.js"
		scalar page = fileread(`"`page'"')
		scalar page = subinstr(page, `"""', "",.)
		
		if  regexm(page, "var AllRefYears = \[([^;]+)\]") local ref_years_l = regexs(1)
		local ref_years_l "`ref_years_l', last"
		
		local ref_years: subinstr local ref_years_l ", " " ", all
		
		local no_ref: list year - ref_years
		
		if (`: list no_ref === year') {
			noi disp as err "Not even one of the years select belong to the following reference years: " _n /* 
			*/ " `ref_years_l'"
			error
		}
		
		if ("`no_ref'" != "") {
			noi disp in y "Warning: `no_ref' is/are not part of reference years: `ref_years_l'"
		}
	}
	
	
	
	***************************************************
	* 1. Will load guidance database
	***************************************************
	
	povcalnet_info, clear justdata `pause' server(`server')
	
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
	if ("`country'" != "" & lower("`country'") != "all") {
		foreach c of local country {
			replace keep_this = 1 if (country_code == "`c'")
		}
	}
	
	if lower("`country'") == "all" replace keep_this = 1
	
	
	* If region is selected instead of countries
	if  ("`region'" != "") {
		local region_l = `""`region'""'
		local region_l: subinstr local region_l " " `"", ""', all
		
		replace keep_this = 1 if inlist(wb_region, `region_l')
		if lower("`region'") == "all" replace keep_this = 1
	}
	
	keep if keep_this == 1
	
	local obs = _N
	if (`obs' == 0) {
		di  as err "No surveys found matching your criteria. You could use the " /*  
	  */ " {stata povcalnet_info: guided selection} instead."
		error
	}
	
  pause query - after filtering conditions of country and region
	
	***************************************************
	* 3. Keep selected years and construct the request
	***************************************************
	
	*---------- Check that at least one year is available
	if ("`wb'" == "" & "`aggregate'" == "") {
		if ("`year'"=="all") | ("`year'"=="last") | ("`fillgaps'"!="") {
			local year_ok = 1
		}
		else {
			local yearcheck 0
			split year, parse(,) gen(yr)
			levelsof country_code, local(cts)
			
			foreach ct of local cts {	
				putmata Y=(yr*) if country_code == "`ct'", replace
				
				mata: y = tokens(st_local("year"));     /* 
				*/	 c = 0;                             /* 
				*/	 for (i = 1; i <= cols(y); i++) {;  /* 
					*/	 		c = c + anyof(Y, y[i]);         /*  
				*/	 };                                 /* 
				*/	 st_local("year_ok", strofreal(c))
				
				if (`year_ok' == 0) {
					
					di as err _n "Warning: " in smcl "{text}years selected for `ct' do not match any survey year." _n /* 
					*/	"{text}You could type {stata povcalnet_info, country(`ct') clear} to check availability." 
				
				} 
				else {
					if (`yearcheck' == 0 ) {
						local yearcheck 1
					}	
				}
				
			} // end of countries loop
			
			if (`yearcheck' == 0) {
				noi disp as err _n "the countries and years selected do not match any year available."
				error
			}
			drop yr*
		}
		
	}
	
	/*==================================================
	Create Queries
	==================================================*/
	
	*---------- Year and Display query
	local y_comma: subinstr  local year " " ",", all
	if ("`year'" == "last")  local y_comma = "all"
	
	
	if ("`fillgaps'" == "")  {
		local year_q = "SurveyYears=`y_comma'"
		local disp_q = ""
	}
	else  {
		local year_q = "YearSelected=`y_comma'" 
		local disp_q = "&display=c"
	}
	
	if ("`aggregate'" != "") {
		local year_q = "YearSelected=`y_comma'" 
		local disp_q = "&display=R"
	}
	if ("`wb'" != "") {
		local year_q = "YearSelected=`y_comma'"
		local disp_q = "&GroupedBy=WB"
	}
	
	return local query_ys = "`year_q'"
	return local query_ds = "`disp_q'"
	
	*---------- Country query
	
	if ("`wb'" != "") {
		local country_q = "Countries=all"
	} 
	else {
		levelsof code, local(country_q) sep(,) clean
		local country_q = "Countries=`country_q'"
	}
	return local query_ct = "`country_q'"
	
	if ("`popshare'" != ""){
		*----------Population share query 
		local popshare_q = "QP=`popshare'"
		return local query_ps = "`popshare_q'"
	}
	else {
		*---------- Poverty lines query
		local povline_q = "PovertyLine=`povline'"
		return local query_pl = "`povline_q'"
		
	}
	
	
} // end of qui

end

exit
/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

Notes:
1.
2.
3.


Version Control:


