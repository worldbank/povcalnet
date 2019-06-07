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

 syntax [anything(name=subcommand)]        ///
        [,                             ///
          COUNtry(string)              /// 
          REGion(string)               ///
          YEAR(string)                 /// 
          POVline(numlist max=10)      /// 
          PPP(numlist max=10)          /// 
          AGGregate                    ///
          CLEAR                        ///
          AUXiliary                    ///
          INFOrmation                  ///
					coverage(string)             ///
          ISO                          /// Standard ISO codes
          SERVER(string)               /// internal use
          COESP(passthru)              /// internal use
					groupedby(passthru)          /// internal use
					pause                        /// debugging
					FILLgaps                     ///
        ] 

if ("`pause'" == "pause") pause on
else                      pause off

qui {

	/*==================================================
        	Defaults           
	==================================================*/
	
	*---------- Info
	if regexm("`subcommand'", "^info")	local information = "information"
	
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
	
	*---------- Country
	if ("`country'" == "" & "`region'" == "") local country "all"
	if ("`country'" != "") {
		if (lower("`country'") != "all") local country = upper("`country'")
		else                             local country "all"
	}
	
	*---------- subcommand
	if inlist("`subcommand'", "cl", "countryl", "countrylevel") & /* 
 */	(lower("`country'") == "all") {
		noi disp in red "you cannot use option {it:countr(all)} with subcommand {it:cl}"
		error 197
  }
	
	*---------- PPP
	if (lower("`country'") == "all" & "`ppp'" != "") {
		noi disp as err "Option {it:ppp()} is not allowed with {it:country(all)}"
		error
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
	if inlist("`subcommand'", "cl", "countryl", "countrylevel") {
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
	
	tempfile povcalf
	save `povcalf', empty 
	
	local f = 0
	
	foreach i_povline of local povline {	
		local ++f 
		noi `commanduse',   country("`country'")  ///
			 region("`region'")                     ///
			 year("`year'")                         ///
			 povline("`i_povline'")                 ///
			 ppp("`i_ppp'")                         ///
			 server("`server'")                     ///
			 `coesp'                                ///
			 `auxiliary'                            ///
			 `clear'                                ///
			 `information'                          ///
			 `iso'                                  ///
			 `original'                             ///
			 `fillgaps'                             ///
			 `pause'                                ///
			 `groupedby'                            ///
			 coverage(`coverage')
		return add
		
		append using `povcalf'
		save `povcalf', replace
		
		* local queryfull`f'  "`r(queryfull)'"
	
	} // end of povline loop
	
	local obs = _N 
	if (`obs' != 0) {
		noi di as result "{p 4 4 2}Succesfully loaded `obs' observations.{p_end}"
	}
	
	

} // end of qui
end


