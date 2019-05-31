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

    syntax                ///
      [,                  ///
        COUntry(string)   ///
        REGion(string)    ///
        YEAR(string)      ///
        POVLine(string)   ///
        PPP(string)       ///
        NOSUMmary         ///
        ISO               ///
        CLEAR             ///
        AUXiliary         ///
        ORIginal          ///
        INFOrmation       ///
        COUNTRYEStimates  ///
        COESP(string)     ///
        SERVER(string)    ///
      ]     

quietly {

	************************************************
	* 0. Housekeeping
	************************************************
	
	local base="http://iresearch.worldbank.org/PovcalNet/PovcalNetAPI.ashx"

	if "`server'"!=""  {
		local base="`server'/PovcalNetAPI.ashx"
	} 
    
	if  ("`country'" != "") & ("`region'" != ""){
        di  as err "Either provide country or region, but not both. Please try again."
        exit 198
    }
	
	if  ("`year'" == ""){
        di  as err "Provide a year, set of years; or all for all years. Please try again."
        exit 198
    }
	
	if ("`coesp'" != "") local auxiliary = "auxiliary"
	
	if ("`ppp'" != "") local ppp_condition = "&PPP0=`ppp'"
	
	
	***************************************************
	* 1. Will load guidance database
	***************************************************
	
	povcalnet_info, clear justdata
	
	***************************************************
	* 2. Keep selected countries and save codes
	***************************************************
	gen keep_this = 0
	local country = lower("`country'")
	replace countrycode = lower(countrycode)
	
	if  ("`country'" != ""){
		foreach country_l of local country {
			replace keep_this = 1 if countrycode == "`country_l'"
		}
		if "`country'" == "all" replace keep_this = 1
	}
	
	local groupedby = lower("`groupedby'")
	local region_type = "regioncode"
	if ("`groupedby'" == "un")  local region_type = "uncode"
	if (inlist("`groupedby'","income","in","inc")) local region_type = "inc"
	

	if  ("`region'" != ""){
	local region = lower("`region'")
	replace `region_type'  = lower(`region_type')
		foreach region_l of local region{
			replace keep_this = 1 if `region_type' == "`region_l'"
		}
		if "`region'" == "all" replace keep_this = 1
	}
	
	keep if keep_this == 1
	if ("`coesp'" != "") keep if code == "`coesp'"
	
	local obs = _N
	if (`obs' == 0) {
        di  as err "{p 4 4 2}No surveys found matching your criteria. You could use the {stata povcalnet_info: guided selection} instead. {p_end}"
		exit 
		break
    }
	***************************************************
	* 3. Keep selected years and construct the request
	***************************************************
	if "`auxiliary'" == ""{
		bys countrycode: gen number = _N
		gen tag_delete = 1 if (number>2 & inlist(coverage,"R","U"))
		drop if tag_delete == 1
	}
	local y_comma: subinstr local year " " ",", all
	if ("`year'" == "last") local y_comma = "all"
	if ("`countryestimates'" == "") local year_param = "surveyyears=`y_comma'"	
	if ("`countryestimates'" != "") local year_param = "refyears=`y_comma'&display=c&groupedby=wb&"
	local obs = _N
	local year_ok = 0
	forvalues i_obs = 1/`obs'{
		local country_v = "`=code[`i_obs']',"+"`country_v'"
		foreach i_year of local year{
			local position = strpos("`=years[`i_obs']'","`i_year'")
				if `position'>0 {
					local year_ok = `year_ok'+1
				}
			if ("`i_year'"=="all") | ("`i_year'"=="last") local year_ok = 1
		}
	}
	
	if ("`countryestimates'"!="") local year_ok = 1
	
	if (`year_ok' == 0) {
        di  as err "{p 4 4 2}No surveys found matching your criteria. You could use the {stata povcalnet_info: guided selection} instead. {p_end}"
		exit 20
		break
    }
	
	local parameter =	"`year_param'&Countries=`country_v'&"

	***************************************************
	* 4. Request and copying
	***************************************************
	tempfile finalfile
	tempfile tempcopy
	local queryfull = "`parameter'PovertyLine=`povline'&format=csv"
	cap : copy "`base'?`parameter'PovertyLine=`povline'&format=csv" `tempcopy'
	local rccopy = _rc
	cap : insheet using `tempcopy', clear name	 
	local rc3 = _rc
	
	if (`rc3' != 0) {
		noi di ""
		di  as err "You must start with an empty dataset; or enable the clear option."
		noi di ""
		exit `rc3'
		noi di ""
		break
	}
	
	local obs = _N
	
	if ("`rccopy'" == "") {
		noi di ""
		noi di as err "{p 4 4 2} There was no data downloaded. {p_end}"
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
	
	
	qui cap gen median = .
	qui cap rename  prmld  mld
	foreach v of varlist polarization median gini mld decile? decile10 {   
		qui cap replace `v'=. if `v'==-1 | `v' == 0
	}

	cap drop if ppp==""
	qui cap drop  polarization 
	qui cap drop  svyinfoid 
	if ("`countryestimates'"!="") qui cap drop median gini mld decile*
	qui count
	local obs=`r(N)'

	replace coveragetype = "1" if coveragetype == "R"
	replace coveragetype = "2" if coveragetype == "U"
	replace coveragetype = "4" if coveragetype == "A"
	replace coveragetype = "3" if coveragetype == "N"
	destring coveragetype, force replace
	label define coveragetype 1 "Rural" 2 "Urban" 3 "National" 4 "National (Aggregate)" 
	label values coveragetype coveragetype
	
	
	replace datatype = "1" if datatype == "X"
	replace datatype = "2" if datatype == "Y"
	destring datatype, force replace
	qui cap label define datatype 1 "Consumption" 2 "Income"
	qui cap label values datatype datatype
	qui cap label var isinterpolated "Data is interpolated"
	qui cap label var countrycode "Country/Economy Code"
	qui cap label var usemicrodata "Data comes from grouped or microdata"
	qui cap label var countryname "Country/Economy Name"
	qui cap label var regioncode "Region Code"
	qui cap label var region "Region Name"
	qui cap label var coveragetype "Coverage"
	qui cap label var requestyear "Year you requested"
	qui cap label var datayear "Survey year"
	qui cap label var datatype "Welfare measured by income or consumption"
	qui cap label var ppp "Purchasing Power Parity"
	qui cap label var povertyline "Poverty line in PPP$ (per capita per day)"
	qui cap label var mean "Average monthly per capita income/consumption in PPP$"
	qui cap label var headcount "Poverty Headcount"
	qui cap label var povgap "Poverty Gap."
	qui cap label var povgapsqr "Squared poverty gap."
	qui cap label var watts "Watts index"
	qui cap label var gini "Gini index"
	qui cap label var median "Median monthly income or expenditure in PPP$"
	qui cap label var mld "Mean Log Deviation"
	qui cap label var reqyearpopulation "Population in year"
	
	cap sort countrycode requestyear
	
	return local queryfull  "`queryfull'"
}		
	
end

