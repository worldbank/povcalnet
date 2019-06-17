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
					noDIPSQuery                  ///
        ] 

if ("`pause'" == "pause") pause on
else                      pause off

qui {

	/*==================================================
        	Defaults           
	==================================================*/
	
	*---------- API defaults
	
	if "`server'"!=""  {
		local base="`server'/PovcalNet/PovcalNetAPI.ashx"
	} 
	else {
		local serveri    = "http://iresearch.worldbank.org"
		local site_name = "PovcalNet"
		local handler   = "PovcalNetAPI.ashx"		
		local base      = "`serveri'/`site_name'/`handler'"
	}
	
	return local server    = "`serveri'`server'"
	return local site_name = "`site_name'"
	return local handler   = "`handler'"
	return local base      = "`base'"
	
	*---------- lower case subcommand
	local subcommand = lower("`subcommand'")
	
	*---------- Test
	if ("`subcommand'" == "test") {
		if ("${pcn_query}" == "") {
			noi di as err "global pcn_query does not exist. You cannot test the query."
			error
		}
		local fq = "`base'?${pcn_query}"
		view browse "`fq'"
		exit
	}
	
	*---------- Modify country(all) with aggregate
	if (lower("`country'") == "all" & "`aggregate'" != "") {
		local country ""
		local aggregate ""
		local subcommand "wb"
		local wb_change 1
		noi disp as res "Warning: " as text " {cmd:povclanet, country(all) aggregate} " /* 
	  */	"is equivalent to {cmd:povcalnet wb}. " _n /* 
	  */ " if you want to aggregate all countries by survey years, " /* 
	  */ "you need to parse the list of countries in {it:country()} option."
	}
	else {
		local wb_change 0
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
	
	*---------- Info
	if regexm("`subcommand'", "^info")	{
		local information = "information"
		local subcommand  = "information"
	}

	*---------- Subcommand consistency 
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

	*---------- Country Level (one-on-one query)
	if ("`subcommand'" == "cl") {
		noi povcalnet_cl, country("`country'")  ///
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
		global pcn_query = "`query'"

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
		
		pause after downdload
		
		*---------- Clean data
		povcalnet_clean `rtype', year("`year'") `iso' /* 
		 */ rc(`rc') region(`region') `pause'
	
		pause after cleaning
		
	/*==================================================
           Display Query
	==================================================*/
		
	if ("`dipsquery'" == "") {
		noi di as res _n "{title: Query at \$`i_povline' poverty line}"
		noi di as res "{hline}"
		noi di as res "Year:"         as txt _col(20) "`query_ys'"
		noi di as res "Country:"      as txt _col(20) "`query_ct'"
		noi di as res "Poverty line:" as txt _col(20) "`query_pl'"
		noi di as res "Aggregation:"  as txt _col(20) "`query_ds'"
		noi di as res "PPP:"          as txt _col(20) "`query_pp'"
		noi di as res _dup(20) "-"
		noi di as res "No. Obs:"      as txt _col(20) c(N)
		noi di as res "{hline}"
	}
	
	/*==================================================
           Append data
	==================================================*/			
		if (`wb_change' == 1) {
			keep if region_code == "WLD"
		}
		append using `povcalf'
		save `povcalf', replace
		
		* local queryfull`f'  "`r(queryfull)'"
	
	} // end of povline loop
	return local npl = `f'
	

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