/*==================================================
project:       Iterate povlines values to get specific shares of population
Author:        R.Andres Castaneda and Christoph Lakner
Dependencies:  The World Bank
----------------------------------------------------
Creation Date:    05 sep 2019
Modification Date:   
Do-file version:    01
References:      https://github.com/worldbank/povcalnet
Output:             
==================================================*/
	
/*==================================================
            0: Program set up
==================================================*/

version 14
drop _all

if ("`c(username)'" == "wb424681") {
	cd "C:\Users\wb424681\OneDrive - WBG\My Documents\PovcalNet\Requests\201909 p10 and p90 for Marta Roig"
}

if ("`c(username)'" == "wb384996") {
	cd "p:\02.personal\wb384996\temporal\stata"
}


*Prep data file to store results:
tempfile percentiles
save `percentiles', emptyok

// ------------------------------------------------------------------------
// Initial conditions
// ------------------------------------------------------------------------
* Get data by country - lined up to requested years

** Initial conditions (it could be any number)
local pl         = 1   // MODIFY (if you want): starting point (it could be any positive number)
local year       = "last"         // MODIFY: Year of analysis.
*local country    = "CHN"     // MODIFY
local goals      = "0.1 0.5 0.9"  // MODIFY: deciles or any population share. 
local tolerance  = .00001          // MODIFY (if you want)
local ni         = 40             // number of iterations before failing

local countries = "COD CAF"      // MODIFY

** Get the country codes to loop over. 

if (inlist("`countries'", "all", "")) {
	povcalnet info, clear
	levelsof country_code, clean
	local countries = "`r(levels)'"	
}

** get proper names for variables of Output
foreach g of local goals {
	local  p = strtoname("p`=`g'*100'")
	local pnames "`pnames' `p'"
}


// ------------------------------------------------------------------------
// loop over countries
// ------------------------------------------------------------------------

foreach country of local countries {
	*Define coverage variable:	
	if "`country'"=="ARG" 		local coverage="urban"
	else						local coverage="national"

	tempname M N      // matrix with results
	// ------------------------------------------------------------------------
	// loop over goals
	// ------------------------------------------------------------------------

	foreach goal of local goals {

		disp _n as text "iterations for goal `goal':"

		local s          = 0    // iteration stage counter
		local num        = 1    // numerator
		local i          = 0    // general counter
	  local delta      = 3    // MODIFY (if you want): Initial change of povline value

		qui povcalnet, countr(`country') povline(`pl') clear year(`year') coverage(`coverage')
		local attempt = headcount[1]

		while (round(`attempt', `tolerance') != `goal' & `s' <= `ni') {
			local ++i
			if (`attempt' < `goal') {  // before crossing goal
				while (`pl' + `delta' < 0) {
					local delta = `delta'*2
				}
				local pl = `pl' + `delta'
				local below = 1
			}
			if (`attempt' > `goal') {  // first time above goal
				while (`pl'-`delta' < 0) {
					local delta = `delta'/2
				}
				local pl  =  `pl'-`delta'
				local below = 0
			}
			
			*** Call data
			qui povcalnet, countr(`country') povline(`pl') clear year(`year')
			local attempt = headcount[1]
			
			disp in y "`s':" in w _col(5) "pl:" _col(10) `pl' _col(21) "attempt:" _col(28) `attempt'
			
			if ( (`attempt' > `goal' & `below' == 1) | /* 
			 */  (`attempt' < `goal' & `below' == 0) ) { 
				local ++s
				if mod(`s',2) local one = -1
				else          local one =  1
				
				local num = (2*`num')+`one'
				local den = 2^`s'
				local delta =  (`num'/`den')*`delta'
				
			} // end of condition to change the value of delta
		}  // end of while

		mat `M' = nullmat(`M') \ `goal', `pl'

	}

	// ------------------------------------------------------------------------
	// Display results
	// ------------------------------------------------------------------------

	mat colnames `M' = goal value

	mat list `M'

	mat `N'=`M'[1...,2]'	// transpose matrix
	mat colnames `N' = `pnames'

	*Save in a data file
	drop _all
	svmat `N', n(col)

	gen countrycode="`country'"

	*Append to main results file.
	append using `percentiles'
	save `percentiles', replace
} // end of countries loop

exit 






