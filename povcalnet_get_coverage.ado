/*==================================================
project:       Censor regional agregates on base of population rule
Author:        David L. Vargas 
E-email:       dvargasm@worldbank.org
url:           
Dependencies:  The World Bank Group
----------------------------------------------------
Creation Date:     7 Apr 2020 - 09:54:24
Modification Date:   
Do-file version:    01
References:          
Output:             
==================================================*/

/*==================================================
              0: Program set up
==================================================*/
program define povcalnet_get_coverage, rclass
syntax [anything], [ ///
clear ///
]
version 16


/*==================================================
              1: Extract regional population
==================================================*/
qui {
	local page "http://iresearch.worldbank.org/povcalnet/js/common_NET.js"
	scalar page = fileread(`"`page'"')
	scalar page = subinstr(page, `"""', "",.)

	if  regexm(page, "(popShare\[[^\n]+)") scalar rawshares = regexs(1)
	if  regexm(page, "var AllRefYears = ([^;]+)") local years = regexs(1)
	local years = subinstr("`years'", "[", "",.)
	local years = subinstr("`years'", "]", "",.)
	local years = subinstr("`years'", ",", " ",.)

	// a matrix for ease work
	mata: raw = J(0,1," ")

	// populate matrix
	local i = 0
	while regexm(rawshares, "popShare(\[[^;]+)") == 1 {
		local ++i
		scalar sline = regexs(1)
		scalar rawshares = regexr(rawshares, "popShare(\[[^;]+)" , "")
		mata: raw = (raw\st_strscalar("sline"))
	}

	/*==================================================
				  2: send to Stata and clean up 
	==================================================*/

	drop _all
	set obs `i'
	mata: varnames = st_addvar("strL", ("raw"))
	mata: st_sstore(.,varnames, raw)

	replace raw = subinstr(raw, `"""', "", .)
	replace raw = subinstr(raw, "[", "", .)
	replace raw = subinstr(raw, "]", "", .)
	replace raw = subinstr(raw, " ", "", .)
	gen regioncode = regexs(1) if regexm(raw, "([^=]+)")
	gen share = regexs(1) if regexm(raw, "=(.+)")
	split share, par(",")
	drop share raw

	loc j = 0
	foreach y of local years{
		loc ++j
		rename share`j' share`y'
	}

	reshape long share, i(regioncode) j(year)
	destring share, replace

	lab var share "Population coverage share"

} // end of qui

noi di as result "Coverage data loaded into memory"

end
exit
/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

Notes:
1.
2.
3.


Version Control:


