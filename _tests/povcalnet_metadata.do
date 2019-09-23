/*==================================================
project:       Transform csv into dta
Author:        R.Andrés Castañeda 
----------------------------------------------------
Creation Date:    12 Sep 2019 - 16:07:04
==================================================*/

/*==================================================
              0: Program set up
==================================================*/

cd "c:/Users/wb384996/OneDrive - WBG/ado/myados/povcalnet"

*##s
//========================================================
// load data and transform
//========================================================

import excel using "_tests/Key variables in the Price framework - Tableau.xlsx", /* 
 */  case(lower)  sheet("CPI template information") clear firstrow

keep code year datatype comparability survey_coverage
rename code countrycode


* create coveragetype
gen coveragetype = .
replace coveragetype = 3 if survey_coverage == "N"
replace coveragetype = 2 if survey_coverage == "U"
replace coveragetype = 1 if survey_coverage == "R"
replace coveragetype = 4 if (coveragetype == 3 & /* 
                           */ inlist(countrycode, "CHN", "IDN", "IND"))

* Create datatype
gen     dt = . 
replace dt = 1 if lower(datatype) == "c"
replace dt = 2 if lower(datatype) == "i"

expand 2 if dt == ., gen(tag)

replace dt = 1 if (tag == 0 & dt == .)
replace dt = 2 if (tag == 1 & dt == .)

drop datatype survey_coverage tag
rename dt datatype

duplicates drop

drop if comparability == .
saveold "_tests/povcalnet_metadata_errors.dta", replace

//------------ Fix errors

replace coveragetype = 2 if countrycode == "URY" & year <= 2005
replace datatype = 2 if countrycode == "CHN" & inlist(year, 1981, 1984, 1987)
replace datatype = 1 if countrycode == "MEX" &  year == 1984
replace datatype = 1 if countrycode == "TKM" &  year == 1998

replace coveragetype = 3 if countrycode == "SUR" &  year == 1999
replace coveragetype = 3 if countrycode == "RWA" &  year == 1984
replace coveragetype = 3 if countrycode == "ECU" &  year == 1987
replace coveragetype = 3 if countrycode == "BOL" &  year == 1990
replace coveragetype = 3 if countrycode == "AGO" &  year == 2000

replace coveragetype = 2 if countrycode == "FSM" &  year == 2000
replace coveragetype = 2 if countrycode == "ECU" &  year == 1995
replace coveragetype = 2 if countrycode == "COL" &  year == 1991

replace coveragetype = 1 if countrycode == "ETH" &  year == 1981

order countrycode year coveragetype datatype comparability

saveold "_tests/povcalnet_metadata.dta", replace
export delimited using "_tests/povcalnet_metadata.csv", /* 
 */ replace delimiter(",")

exit
/* End of do-file */
*##e
* ><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
