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


//========================================================
// load data and transform
//========================================================

import delimited using "_tests/povcalnet_metadata.csv", /* 
 */ clear case(lower) 

rename code countrycode

* create coveragetype
gen coveragetype = .
replace coveragetype = 3 if survey_coverage == "N"
replace coveragetype = 2 if survey_coverage == "U"
replace coveragetype = 1 if survey_coverage == "R"
replace coveragetype = 4 if (coveragetype == 3 &  /* 
 */ inlist(countrycode, "CHN", "IDN", "IND"))


* Create datatype

gen dt = . 
replace dt = 1 if lower(datatype) == "c"
replace dt = 2 if lower(datatype) == "i"

expand 2 if dt == ., gen(tag)
replace dt = 1 if (tag == 0 & dt == .)
replace dt = 2 if (tag == 1 & dt == .)

drop datatype survey_coverage tag
rename dt datatype

duplicates drop

//------------ Fix errors

drop if comparability == 2 & countrycode == "NIC"

replace coveragetype = 2 if countrycode == "URY" & year <= 2005

saveold "_tests/povcalnet_metadata.dta", replace

 exit
/* End of do-file */

* ><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><
