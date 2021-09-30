*********************************************************************************
*povcalnet_examples-: Auxiliary program for -povcalnet-                    		*
*! v1.0  		sept2018               by 	Jorge Soler Lopez					*
*											Espen Beer Prydz					*
*											Christoph Lakner					*
*											Ruoxuan Wu							*
*											Qinghua Zhao						*
*											World Bank Group					*
*! based on JP Azevedo wbopendata_examples										*
*********************************************************************************

*  ----------------------------------------------------------------------------
*  0. Main program
*  ----------------------------------------------------------------------------

capture program drop povcalnet_examples
program povcalnet_examples
version 11.0
args EXAMPLE
set more off
`EXAMPLE'
end


*  ----------------------------------------------------------------------------
*  World Poverty Trend (reference year)
*  ----------------------------------------------------------------------------
program define pcn_example01

	povcalnet wb,  clear

	keep if year > 1989
	keep if regioncode == "WLD"	
  gen poorpop = headcount*population 
  gen hcpercent = round(headcount*100, 0.1) 
  gen poorpopround = round(poorpop, 1)

  twoway (sc hcpercent year, yaxis(1) mlab(hcpercent)           ///
           mlabpos(7) mlabsize(vsmall) c(l))                    ///
         (sc poorpopround year, yaxis(2) mlab(poorpopround)     ///
           mlabsize(vsmall) mlabpos(1) c(l)),                   ///
         yti("Poverty Rate (%)" " ", size(small) axis(1))       ///
         ylab(0(10)40, labs(small) nogrid angle(0) axis(1))     ///
         yti("Number of Poor (million)", size(small) axis(2))   ///
         ylab(0(400)2000, labs(small) angle(0) axis(2))         ///
         xlabel(,labs(small)) xtitle("Year", size(small))       ///
         graphregion(c(white)) ysize(5) xsize(5)                ///
         legend(order(                                          ///
         1 "Poverty Rate (% of people living below $1.90)"      ///
         2 "Number of people who live below $1.90") si(vsmall)  ///
         row(2)) scheme(s2color)

end
*  ----------------------------------------------------------------------------
*  Millions of poor by region (reference year) 
*  ----------------------------------------------------------------------------
program define pcn_example02
	povcalnet wb, clear
	keep if year > 1989
	gen poorpop = headcount * population 
	gen hcpercent = round(headcount*100, 0.1) 
	gen poorpopround = round(poorpop, 1)
	encode region, gen(rid)

	levelsof rid, local(regions)
	foreach region of local regions {
		local legend = `"`legend' `region' "`: label rid `region''" "'
	}

	keep year rid poorpop
	reshape wide poorpop,i(year) j(rid)
	foreach i of numlist 2(1)7{
		egen poorpopacc`i'=rowtotal(poorpop1 - poorpop`i')
	}

	twoway (area poorpop1 year)                              ///
		(rarea poorpopacc2 poorpop1 year)                      ///
		(rarea poorpopacc3 poorpopacc2 year)                   ///
		(rarea poorpopacc4 poorpopacc3 year)                   ///
		(rarea poorpopacc5 poorpopacc4 year)                   ///
		(rarea poorpopacc6 poorpopacc5 year)                   ///
		(rarea poorpopacc7 poorpopacc6 year)                   ///
		(line poorpopacc7 year, lwidth(midthick) lcolor(gs0)), ///
		ytitle("Millions of Poor" " ", size(small))            ///
		xtitle(" " "", size(small)) scheme(s2color)            ///
		graphregion(c(white)) ysize(7) xsize(8)                ///
		ylabel(,labs(small) nogrid angle(verticle)) xlabel(,labs(small)) ///
		legend(order(`legend') si(vsmall))
end

*  ----------------------------------------------------------------------------
*  Categories of income and poverty in LAC
*  ----------------------------------------------------------------------------
program pcn_example03
	povcalnet, region(lac) year(last) povline(3.2 5.5 15) clear 
	keep if datatype==2 & year>=2014             // keep income surveys
	keep povertyline countrycode countryname year headcount
	replace povertyline = povertyline*100
	replace headcount = headcount*100
	tostring povertyline, replace format(%12.0f) force
	reshape wide  headcount,i(year countrycode countryname ) j(povertyline) string
	
	gen percentage_0 = headcount320
	gen percentage_1 = headcount550 - headcount320
	gen percentage_2 = headcount1500 - headcount550
	gen percentage_3 = 100 - headcount1500
	
	keep countrycode countryname year  percentage_*
	reshape long  percentage_,i(year countrycode countryname ) j(category) 
	la define category 0 "Poor LMI (< $3.2)" 1 "Poor UMI ($3.2-$5.5)" ///
		                 2 "Vulnerable ($5.5-$15)" 3 "Middle class (> $15)"
	la val category category
	la var category ""

	local title "Distribution of Income in Latin America and Caribbean, by country"
	local note "Source: PovcalNet, using the latest survey after 2014 for each country."
	local yti  "Population share in each income category (%)"

	graph bar (mean) percentage, inten(*0.7) o(category) o(countrycode, ///
	  lab(labsi(small) angle(vertical))) stack asy                      /// 
		blab(bar, pos(center) format(%3.1f) si(tiny))                     /// 
		ti("`title'", si(small)) note("`note'", si(*.7))                  ///
		graphregion(c(white)) ysize(6) xsize(6.5)                         ///
			legend(si(vsmall) r(3))  yti("`yti'", si(small))                ///
		ylab(,labs(small) nogrid angle(0)) scheme(s2color)
end

*  ----------------------------------------------------------------------------
* Trend of Gini 
*  ----------------------------------------------------------------------------
program pcn_example04
povcalnet, country(arg gha tha) year(all) clear
	replace gini = gini * 100
	keep if datayear > 1989
	twoway (connected gini datayear if countrycode == "ARG")  ///
		(connected gini datayear if countrycode == "GHA")       ///
		(connected gini datayear if countrycode == "THA"),      /// 
		ytitle("Gini Index" " ", size(small))                   ///
		xtitle(" " "", size(small)) ylabel(,labs(small) nogrid  ///
		angle(verticle)) xlabel(,labs(small))                   ///
		graphregion(c(white)) scheme(s2color)                   ///
		legend(order(1 "Argentina" 2 "Ghana" 3 "Thailand") si(small) row(1)) 
		
end	   

*  ----------------------------------------------------------------------------
*  Growth incidence curves
*  ----------------------------------------------------------------------------
program pcn_example05
  povcalnet, country(arg gha tha) year(all)  clear
	reshape long decile, i(countrycode datayear) j(dec)
	
	egen panelid=group(countrycode dec)
	replace datayear=int(datayear)
	xtset panelid datayear
	
	replace decile=10*decile*mean
	gen g=(((decile/L5.decile)^(1/5))-1)*100
	
	replace g=(((decile/L7.decile)^(1/7))-1)*100 if countrycode=="GHA"
	replace dec=10*dec
	
	twoway (sc g dec if datayear==2016 & countrycode=="ARG", c(l)) ///
			(sc g dec if datayear==2005 & countrycode=="GHA", c(l))    ///
			(sc g dec if datayear==2015 & countrycode=="THA", c(l)),   ///
			yti("Annual growth in decile average income (%)" " ",      ///
			size(small))  xlabel(0(10)100,labs(small))                 ///
			xtitle("Decile group", size(small)) graphregion(c(white))  ///
			legend(order(1 "Argentina(2011-2016)"                      ///
			2 "Ghana(1998-2005)" 3 "Thailand(2010-2015)")              ///
			si(vsmall) row(1)) scheme(s2color)

end

*  ----------------------------------------------------------------------------
*  Gini & per capita GDP
*  ----------------------------------------------------------------------------
program pcn_example06
	set checksum off
	wbopendata, indicator(NY.GDP.PCAP.PP.KD) long clear
	tempfile PerCapitaGDP
	save `PerCapitaGDP', replace
	
	povcalnet, povline(1.9) country(all) year(last) clear iso
	keep countrycode countryname year gini
	drop if gini == -1
	* Merge Gini coefficient with per capita GDP
	merge m:1 countrycode year using `PerCapitaGDP', keep(match)
	replace gini = gini * 100
	drop if ny_gdp_pcap_pp_kd == .
	twoway (scatter gini ny_gdp_pcap_pp_kd, mfcolor(%0)       ///
		msize(vsmall)) (lfit gini ny_gdp_pcap_pp_kd),           ///
		ytitle("Gini Index" " ", size(small))                   ///
		xtitle(" " "GDP per Capita per Year (in 2011 USD PPP)", ///
		size(small))  graphregion(c(white)) ysize(5) xsize(7)   ///
		ylabel(,labs(small) nogrid angle(verticle))             ///
		xlabel(,labs(small)) scheme(s2color)                    ///
    legend(order(1 "Gini Index" 2 "Fitted Value") si(small))
end




*  ----------------------------------------------------------------------------
*  Regional Poverty Evolution
*  ----------------------------------------------------------------------------
program define pcn_example07
	povcalnet wb, povline(1.9 3.2 5.5) clear
	drop if inlist(regioncode, "OHI", "WLD") | year<1990 
	keep povertyline region year headcount
	replace povertyline = povertyline*100
	replace headcount = headcount*100
	
	tostring povertyline, replace format(%12.0f) force
	reshape wide  headcount,i(year region) j(povertyline) string
	
	local title "Poverty Headcount Ratio (1990-2015), by region"

	twoway (sc headcount190 year, c(l) msiz(small))  ///
	       (sc headcount320 year, c(l) msiz(small))  ///
	       (sc headcount550 year, c(l) msiz(small)), ///
	       by(reg,  title("`title'", si(med))        ///
	       	note("Source: PovcalNet", si(vsmall)) graphregion(c(white))) ///
	       xlab(1990(5)2015 , labsi(vsmall)) xti("Year", si(vsmall))     ///
	       ylab(0(25)100, labsi(vsmall) angle(0))                        ///
	       yti("Poverty headcount (%)", si(vsmall))                      ///
	       leg(order(1 "$1.9" 2 "$3.2" 3 "$5.5") r(1) si(vsmall))        ///
	       sub(, si(small))	scheme(s2color)
end





// ------------------------------------------------------------------------
// National level and longest available series (temporal change in welfare)
// ------------------------------------------------------------------------

program define pcn_example08

povcalnet, clear

* keep only national
bysort countrycode datatype year: egen _ncover = count(coveragetype)
gen _tokeepn = ( (inlist(coveragetype, 3, 4) & _ncover > 1) | _ncover == 1)

keep if _tokeepn == 1

* Keep longest series per country
by countrycode datatype, sort:  gen _ndtype = _n == 1
by countrycode : replace _ndtype = sum(_ndtype)
by countrycode : replace _ndtype = _ndtype[_N] // number of datatype per country

duplicates tag countrycode year, gen(_yrep)  // duplicate year

bysort countrycode datatype: egen _type_length = count(year) // length of type series
bysort countrycode: egen _type_max = max(_type_length)   // longest type series
replace _type_max = (_type_max == _type_length)

* in case of same length in series, keep consumption
by countrycode _type_max, sort:  gen _ntmax = _n == 1
by countrycode : replace _ntmax = sum(_ntmax)
by countrycode : replace _ntmax = _ntmax[_N]  // number of datatype per country


gen _tokeepl = ((_type_max == 1 & _ntmax == 2) | ///
	             (datatype == 1 & _ntmax == 1 & _ndtype == 2) | ///
	             _yrep == 0)

keep if _tokeepl == 1
drop _*

end

// ------------------------------------------------------------------------
// National level and longest available series of same welfare type
// ------------------------------------------------------------------------

program define pcn_example09

povcalnet, clear

* keep only national
bysort countrycode datatype year: egen _ncover = count(coveragetype)
gen _tokeepn = ( (inlist(coveragetype, 3, 4) & _ncover > 1) | _ncover == 1)

keep if _tokeepn == 1
* Keep longest series per country
by countrycode datatype, sort:  gen _ndtype = _n == 1
by countrycode : replace _ndtype = sum(_ndtype)
by countrycode : replace _ndtype = _ndtype[_N] // number of datatype per country


bysort countrycode datatype: egen _type_length = count(year)
bysort countrycode: egen _type_max = max(_type_length)
replace _type_max = (_type_max == _type_length)

* in case of same length in series, keep consumption
by countrycode _type_max, sort:  gen _ntmax = _n == 1
by countrycode : replace _ntmax = sum(_ntmax)
by countrycode : replace _ntmax = _ntmax[_N]  // max 


gen _tokeepl = ((_type_max == 1 & _ntmax == 2) | ///
	             (datatype == 1 & _ntmax == 1 & _ndtype == 2)) | ///
               _ndtype == 1

keep if _tokeepl == 1
drop _*

end

// ------------------------------------------------------------------------
// Calculate regional and global aggregates from country-level lined-up data
// ------------------------------------------------------------------------

program define pcn_example10


//1.4 Population regional
insheet using "http://iresearch.worldbank.org/PovcalNet/js/regionalpopulation.js", clear
split v1, p(, ]) g(a)
drop v1
drop if _n==1

replace a1="regioncode" if _n==1
drop if a1=="null"
renvars, map("population"+word(@[1], 1))
renvars populationregioncode, map(substr("@", 11, .))
drop population
drop if _n==1

reshape long population, i(regioncode) j(year)
destring population, replace
keep if year>1980 & year<2020
tempfile pop
save `pop'

//regioncodes
povcalnet, clear year(last)
keep regioncode countrycode 
duplicates drop
tempfile regions
save `regions'

*******************************************************************************
//					2.REGIONAL AND GLOBAL AGGREGATES			//
*******************************************************************************
//line-up country-level headcounts from povcalnet 
povcalnet, fillgaps clear 
keep if coveragetype==3 | coveragetype==4 | countrycode=="ARG" | countrycode=="SUR"
keep countrycode year headcount population

//merge regioncodes
merge m:1 countrycode using `regions', nogen

keep regioncode countrycode year headcount population  
 
collapse headcount [aw=population] , by(regioncode year)
sort year regioncode

merge 1:1 regioncode year using `pop', nogen
gen poorpop=headcount*population

tempfile regional
save `regional'
bys year: egen globalpop=sum(population)

collapse globalpop (mean) headcount [aw=population], by(year)
ren globalpop population
gen poorpop=headcount*population
append using `regional'

replace regioncode="WLD" if regioncode==""

sort year regioncode
br if year==2017
tempfile aggregates

save `aggregates', replace 

*******************************************************************************
//					3.PREPARE POP DATA	FOR COVERAGE CALCULATIONS		//
*******************************************************************************
//1.1 Population all countries: this includes countries with no poverty estimates for which regional headcount is assumed
*requires renvars
insheet using "http://iresearch.worldbank.org/PovcalNet/js/population.js", clear
split v1, p(, ]) g(a)
keep if a3!="" | a1=="SXM" | a1=="PSE"

drop v1
replace a1="countrycode" if _n==1
renvars, map("population"+word(@[1], 1))
renvars populationcountrycode, map(substr("@", 11, .))

drop population
drop if _n==1

reshape long population, i(countrycode) j(year)
destring population, replace
keep if year>1980 & year<2020
tempfile pop
save `pop'

//1.2 Regions all countries
*requires renvars
insheet using "http://iresearch.worldbank.org/PovcalNet/js/population.js", clear
split v1, p(, ]) g(a)
keep a1 
drop if _n==1 | _n==2

gen region="EAP" if a1=="East Asia and Pacific"
replace region="ECA" if a1=="Europe and Central Asia"
replace region="LAC" if a1=="Latin America and the Caribbean"
replace region="MNA" if a1=="Middle East and North Africa"
replace region="OHI" if a1=="Other high Income"
replace region="SAS" if a1=="South Asia"
replace region="SSA" if a1=="Sub-Saharan Africa"

encode (region), gen(regioncode)
replace regioncode=regioncode[_n-1] if regioncode==.

keep if region==""
drop region
ren a1 countrycode
drop if countrycode=="null"

merge 1:m countrycode using `pop', nogen

decode regioncode, gen(regioncode1)
drop regioncode 
ren regioncode1 regioncode
 
tempfile all
save `all'


//1.3 Argentina Rural: Urban data used in global poverty, rural population gets regional headcount (see Methodology section in PovcalNet website)
povcalnet , fillgaps count(arg) clear
keep countrycode population year
ren population pop_urban

merge 1:1 countrycode year using `all'
drop if _merge==2
drop _merge

gen pop_rural=population-pop_urban
keep regioncode countrycode year pop_rural 
renam pop_rural population

append using `all'
tab countrycode if year==1981

tempfile population
save `population' , replace

*******************************************************************************
//					4.COVERAGE RULE							//
*******************************************************************************
//income group classification data
import excel using "https://databank.worldbank.org/data/download/site-content/OGHIST.xls", clear sheet ("Country Analytical History") cellrange(A5:AI240) firstrow

rename A code
rename Banks economy
drop if missing(code)

// Creating income classifications for countries that didn't exist
// Giving Kosovo Serbia's income classification before it became a separate country
*br if inlist(code,"SRB","XKX")
foreach var of varlist FY08-FY09 {
replace `var' = "UM" if code=="XKX"
}
// Giving Serbia, Montenegro and Kosovo Yugoslavia's income classification before they become separate countries
*br if inlist(code,"YUG","SRB","MNE","XKX")
foreach var of varlist FY94-FY07 {
replace `var' = "LM" if inlist(code,"SRB","MNE","XKX")
}
drop if code=="YUG"
// Giving all Yugoslavian countries Yugoslavia's income classification before they became separate countries
*br if inlist(code,"YUGf","HRV","SVN","MKD","BIH","SRB","MNE","XKX")
foreach var of varlist FY89-FY93 {
replace `var' = "UM" if inlist(code,"HRV","SVN","MKD","BIH","SRB","MNE","XKX")
}
drop if code=="YUGf"
// Giving Czeck and Slovakia Czeckoslovakia's income classification before they became separate countries
*br if inlist(code,"CSK","CZE","SVK")
foreach var of varlist FY92-FY93 {
replace `var' = "UM" if inlist(code,"HRV","CZE","SVK")
}
drop if code=="CSK"
// Dropping three economies that are not among the WB's 218 economies
drop if inlist(code,"MYT","ANT","SUN")

// Changing variable names
local year = 1988
foreach var of varlist FY89-FY21 {
rename `var' y`year'
local year = `year' + 1
}
drop economy
// Reshaping to long format
reshape long y, i(code) j(year)
rename y incgroup_historical
replace incgroup_historical = "" if incgroup_historical==".."

// Assume income group carries backwards when missing
//only until 1978: 3 years window for first global number in 1981
expand 11 if year==1988
bysort code (year): replace year=1977+_n if year==1988
tab year

// Changing label/format
replace incgroup = "High income"         if incgroup=="H"
replace incgroup = "Upper middle income" if incgroup=="UM"
replace incgroup = "Lower middle income" if inlist(incgroup,"LM","LM*")
replace incgroup = "Low income"          if incgroup=="L"

label var incgroup_historical "Income group - historically"
label var code "Country code"
label var year "Year"

isid code year
ren code countrycode

save "CLASS.dta", replace


********************************************************************************
			//query povcalnet survey data for three years window
********************************************************************************

povcalnet, clear
//keep only national coverage
keep if coveragetype==3 | coveragetype==4 | countrycode=="ARG" | countrycode=="SUR"
//if both income and consumption, choose consumption
bys countrycode year: egen min=min(datatype)
keep if datatype==min
isid countrycode year
keep regioncode countrycode datayear
tempfile surveyyears
save `surveyyears' , replace

//calculate coverage: both regional and lic/lmic
forvalues y=1981/2019{
	
	
	//merge income classification
		
		use CLASS.dta, clear
		keep if year==`y'
		
		merge 1:m countrycode using `surveyyears' ,nogen
		//three years window
		replace year=`y' if year==.
		gen covered = (abs(year-datayear)<=3)
		
		//keep countries with a survey within three years window
		keep if covered==1
		keep countrycode covered
		duplicates drop
		tempfile covered 
		save `covered'

		use CLASS.dta, clear
		keep if year==`y'
		merge 1:m countrycode year using `population' 
		drop if _merge==2 //keep only reference year
		drop _merge
		bys countrycode year: egen min_pop=min(population)
		replace countrycode="ARG-Rural" if countrycode=="ARG" & min_pop<population //criterion to identify ARG-Rural
		drop min_pop
		
		merge 1:1 countrycode using `covered', nogen
		replace covered=0 if covered==.

		preserve
		collapse covered [aw=population], by(year)
		gen regioncode = "WLD"
		tempfile world
		save    `world'

		restore
		preserve
		// Income group
		gen LICLMIC = inlist(incgroup,"Low income","Lower middle income")
		keep if LICLMIC ==1
		collapse covered [aw=pop], by(year)
		gen incgroup = "LICLMIC"
		tempfile LICLMIC
		save    `LICLMIC'
		restore
		
		// Regional coverage
		collapse covered [aw=pop], by(year regioncode)
		append using `world'
		append using `LICLMIC'
		replace regioncode="WLD" if incgroup=="LICLMIC"
		tempfile year`y'
		save `year`y''
}

use `year1981', clear

forvalues y=1982/2019{
	append using `year`y''
}

//criteria for coverage
gen coverage=0
replace coverage=1 if covered>0.50


//both World and LICLMIC above 0.5 for coverage to be satisfied
collapse (min) coverage, by (regioncode year)	

// merge with aggregates calculated above
merge 1:1 regioncode year using `aggregates' ,nogen

replace headcount=. if coverage==0
replace poorpop=. if coverage==0
drop coverage
sort year regioncode

br 

end 
