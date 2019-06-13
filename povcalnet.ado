*! version 0.1.0  	<sept2018>
/*=======================================================
Program Name: dotemplate.ado
Author:		  Jorge Soler Lopez
            Espen Beer Prydz	
            Christoph Lakner	
            Ruoxuan Wu				
            Qinghua Zhao			
            World Bank Group	

project:	  Stata package to easily query the [PovcalNet API](http://iresearch.worldbank.org/PovcalNet/docs/PovcalNet%20API.pdf) 
Dependencies: The World Bank - DEC
-----------------------------------------------------------------------
Creation Date: 		  Sept 2018
References:	
Output:		dta file
=======================================================*/


program def povcalnet, rclass

set checksum off //temporarily bypasses controls of files taken from internet

version 9.0

 syntax [anything(name=subcommand)]    ///
        [,                             ///
          COUNtry(string)              /// 
          REGion(string)               ///
          YEAR(string)                 /// 
          POVline(numlist max=10)      /// 
          PPP(numlist max=10)          /// 
          AGGregate                    ///
          CLEAR                        ///
          INFOrmation                  ///
					coverage(string)             ///
          ISO                          /// Standard ISO codes
          SERVER(string)               /// internal use
					pause                        /// debugging
					FILLgaps                     ///
					noQUERY                      ///
        ] 

if ("`pause'" == "pause") pause on
else                      pause off

qui {

	/*==================================================
        	Defaults           
	==================================================*/
	
	*---------- API defaults

	local base="http://iresearch.worldbank.org/PovcalNet/PovcalNetAPI.ashx"
	
	local server    = "http://iresearch.worldbank.org"
	local site_name = "PovcalNet"
	local handler   = "PovcalNetAPI.ashx"
	
	return local server    = "`server'"
	return local site_name = "`site_name'"
	return local handler   = "`handler'"
	
	if "`server'"!=""  {
		local base="`server'/PovcalNetAPI.ashx"
	} else {
		local base "`server'/`site_name'/`handler'"
	}
	return local base "`base'"
	
	*---------- Info
	if regexm("`subcommand'", "^info")	{
		local information = "information"
		local subcommand  = "information"
	}
	
	*---------- Year
	if (wordcount("`year'") > 10){
		noi disp as err "Too many years specified."
		exit 198
	}

	if ("`year'" == "") local year "all"
	* 
	
	*---------- Coverage
	if ("`coverage'" == "") local coverage = "all"
	local coverage = lower("`coverage'")
	
	foreach c of local coverage {	
		if !inlist(lower("`c'"), "national", "rural", "urban", "all") {
			noi disp in red `"option {it:coverage()} must be "national", "rural",  "urban" or "all" "'
			error
		}
	}
	
	*---------- Poverty line
	if ("`povline'" == "") local povline = 1.9
	
	
	*---------- Subcommand consistency 
	local subcommand = lower("`subcommand'")
	if !inlist("`subcommand'", "wb", "information", "cl", "") {
		noi disp as err "subcommand must be either {it:wb}, {it:cl}, or {it:info}"
		error 
	}
	
	
	*---------- One-on-one execution
	if ("`subcommand'" == "cl" & lower("`country'") == "all") {
		noi disp in red "you cannot use option {it:countr(all)} with subcommand {it:cl}"
		error 197
  }
	
	*---------- PPP
	if (lower("`country'") == "all" & "`ppp'" != "") {
		noi disp as err "Option {it:ppp()} is not allowed with {it:country(all)}"
		error
	}
	
	*---------- WB aggregate
	
	if ("`subcommand'" == "wb") {
		if ("`country'" != "") {
			noi disp as err "option {it:country()} is not allowed with subcommand {it:wb}"
			error
		}
		noi disp as res "Note: " as txt "subcommand {it:wb} only accepts options " _n  /* 
		 */ "{it:region()} and {it:year()}"
	}
	
	
	*---------- Country
	if ("`country'" == "" & "`region'" == "") local country "all"
	if ("`country'" != "") {
		if (lower("`country'") != "all") local country = upper("`country'")
		else                             local country "all"
	}
	
	/*==================================================
		    Dependencies         
	==================================================*/

	if ("${pcn_cmds_ssc}" == "") {
		local cmds missings
		
		noi disp in y "Note: " in w "{cmd:povcalnet} requires the packages below: " /* 
		 */ _n in g "`cmds'"
		 
		foreach cmd of local cmds {
			capture which `cmd'
			if (_rc != 0) {
				ssc install `cmd'
				noi disp in g "{cmd:`cmd'} " in w _col(15) "installed"
			}
		}

		adoupdate `cmds', ssconly
		if ("`r(pkglist)'" != "") adoupdate `r(pkglist)', update ssconly
		global pcn_cmds_ssc = 1  // make sure it does not execute again per session
	}


	/*==================================================
		     Main conditions
	==================================================*/
	
	if ("`information'" == "") {
		if (c(N) != 0 & "`clear'" == "" & /* 
		 */ "`information'" == "") {
			noi di as err "You must start with an empty dataset; or enable the option {it:clear}."
			error 4
		}
		drop _all
	}
		
	*---------- Country and region
	if  ("`country'" != "") & ("`region'" != "") {
		noi disp in r "options {it:country()} and {it:region()} are mutally exclusive"
		error
	}

	if ("`aggregate'" != "") {
		if ("`ppp'" != ""){
			noi di  as err "Option PPP cannot be combined with aggregate."
			error 198
		}
		local agg_display = "Aggregation in base year(s) `year'"
	}

	if (wordcount("`country'")>2) {
		if ("`ppp'" != ""){
			noi di as err "Option PPP can only be used with one country."
			error 198
		}
	}

	
	/*==================================================
					     Execution 
	==================================================*/
	pause povcalnet - before execution
	
	*---------- Information
	if ("`information'" != ""){
		noi povcalnet_info, `clear' `pause'
		exit
	}
	
	*---------- WB
	
	
	
	*---------- Build Query
	* povcalnet_build, 
	
	
	*---------- Country Level (one-on-one query)
	if ("`subcommand'" == "cl") {
		povcalnet_cl, country("`country'")  ///
			 year("`year'")                   ///
			 povline("`povline'")             ///
			 ppp("`ppp'")                     ///
			 server("`server'")               ///
			 coverage(`coverage')             /// 
			 `clear'                          ///
			 `iso'                            ///
			 `pause'
		return add
		exit
	}
	
	
	*---------- Regular query and Aggregate Query
	if  ("`aggregate'" == "") local commanduse = "povcalnet_query"
	else                      local commanduse = "povcalnet_aggquery" 
	
	if ("`subcommand'" == "wb") {
		local wb "wb"
	}
	else local wb ""
	
	
	tempfile povcalf
	save `povcalf', empty 
	
	local f = 0
	
	foreach i_povline of local povline {	
		local ++f 
		
	/*==================================================
           Create Query
	==================================================*/
		povcalnet_query,   country("`country'")  ///
			 region("`region'")                     ///
			 year("`year'")                         ///
			 povline("`i_povline'")                 ///
			 ppp("`i_ppp'")                         ///
			 coverage(`coverage')                   ///
			 `clear'                                ///
			 `information'                          ///
			 `iso'                                  ///
			 `fillgaps'                             ///
			 `aggregate'                            ///
			 `wb'                                   ///
			 `pause'                                ///
			 `groupedby'                            ///
			
			
		local query_ys = "`r(query_ys)'"
    local query_ct = "`r(query_ct)'"
    local query_pl = "`r(query_pl)'"
    local query_ds = "`r(query_ds)'"
    local query_pp = "`r(query_pp)'"
		
		return local query_ys_`f' = "`query_ys'"
		return local query_ct_`f' = "`query_ct'"
		return local query_pl_`f' = "`query_pl'"
		return local query_ds_`f' = "`query_ds'"
		return local query_pp_`f' = "`query_pp'"
		
		*---------- Query
		local query = "`query_ys'&`query_ct'&`query_pl'`query_pp'`query_ds'&format=csv"
		return local query_`f' "`query'"

		*---------- Base + query
		local queryfull "`base'?`query'"
		return local queryfull_`f' = "`queryfull'"
		
		
	/*==================================================
           Download  and clean data
	==================================================*/
		
		*---------- download data
		local rc = 0
		tempfile clfile
		cap copy "`queryfull'" `clfile'
		if (_rc == 0) {
			cap insheet using `clfile', clear name
			if (_rc != 0) local rc "in"
		} 
		else {
			local rc "copy"
		} 

		if ("`aggregate'" == "" & "`wb'" == "") {
			 local rtype 1
		}
		else {
			local rtype 2
		}
		
		*---------- Clean data
		povcalnet_clean `rtype', year("`year'") `iso' /* 
		 */ rc(`rc') region(`region') `pause'
	
		
	/*==================================================
           Append data
	==================================================*/	
		
		
		append using `povcalf'
		save `povcalf', replace
		
		* local queryfull`f'  "`r(queryfull)'"
	
	} // end of povline loop
	pause after query
	local obs = _N 
	if (`obs' != 0) {
		noi di as result "{p 4 4 2}Succesfully loaded `obs' observations.{p_end}"
	}
	
	if ("`query'" == "") {
		noi disp in y "{title:Available Surveys}: " in g "Select a country or region" 
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


disp as res "{hline 60}"
disp as res "Year query:" as txt ""