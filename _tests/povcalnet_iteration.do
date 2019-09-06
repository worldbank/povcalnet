/*==================================================
project:       Iterate povlines values to get specific shares of population
Author:        R.Andres Castaneda 
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

// ------------------------------------------------------------------------
// Initial conditions
// ------------------------------------------------------------------------
* Get data by country - lined up to requested years

** Initial conditions (it could be any number)
local pl         = 1   // MODIFY (if you want): starting point (it could be any positive number)
local country    = "CHL"      // MODIFY
local year       = "last"         // MODIFY: Year of analysis.

local goals      = "0.1 0.5 0.9"  // MODIFY: deciles or any population share. 
local tolerance  = .0001          // MODIFY (if you want)
local ni         = 40             // number of iterations before failing


tempname M        // matrix with results

// ------------------------------------------------------------------------
// loop over goals
// ------------------------------------------------------------------------

foreach goal of local goals {

	disp _n as text "iterations for goal `goal':"

	local s          = 0    // iteration stage counter
	local num        = 1    // numerator
	local i          = 0    // general counter
  local delta      = 3    // MODIFY (if you want): Initial change of povline value

	qui povcalnet, countr(`country') povline(`pl') clear year(`year')
	local attempt = headcount[1]

	while (round(`attempt', `tolerance') != `goal' & `s' <= `ni') {
		local ++i
		if (`attempt' < `goal') {  // before crossing goal
			local pl = `pl' + `delta'
			local below = 1
		}
		if (`attempt' > `goal') {  // first time above goal
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

exit 
