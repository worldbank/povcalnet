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
version 9.2
args EXAMPLE
set more off
`EXAMPLE'
end


*  ----------------------------------------------------------------------------
*  1. Regional Poverty Evolution
*  ----------------------------------------------------------------------------
capture program drop example01
program example01
	povcalnet, region(all) year(all) povline(1.9 3.2 5.5) clear aggregate
	drop if regioncode == "OHI" | requestyear<1990 | regioncode == "WLD"
	keep povertyline region requestyear headcount
	replace povertyline = povertyline*100
	replace headcount = headcount*100
	tostring povertyline, replace format(%12.0f) force
	reshape wide  headcount,i(requestyear region ) j(povertyline) string
	twoway (sc headcount190 requestyear, c(l) msiz(small)) (sc headcount320 requestyear, c(l) msiz(small)) (sc headcount550 requestyear, c(l) msiz(small)) ///
		, by(reg,  title("Poverty Headcount Ratio (1990-2015), by region", si(med)) note("Source: PovcalNet", si(vsmall)) graphregion(c(white))) ///
		xlab(1990(5)2015 , labsi(vsmall)) xti("Year", si(vsmall)) ///
		ylab(0(25)100, labsi(vsmall) angle(0)) yti("Poverty headcount (%)", si(vsmall)) ///
		leg(order(1 "$1.9" 2 "$3.2" 3 "$5.5") r(1) si(vsmall)) sub(, si(small))	
end

*  ----------------------------------------------------------------------------
*  2. Categories of income and poverty in LAC
*  ----------------------------------------------------------------------------
capture program drop example02
program example02
	povcalnet, region(lac) year(last) povline(3.2 5.5 15) fillgaps clear 
	*povcalnet, region(lac) year(last) povline(3.2 5.5 15) clear 
	keep if datatype==2 & datayear>=2014 // keep income surveys
	keep povertyline countrycode countryname requestyear headcount
	replace povertyline = povertyline*100
	replace headcount = headcount*100
	tostring povertyline, replace format(%12.0f) force
	reshape wide  headcount,i(requestyear countrycode countryname ) j(povertyline) string
	gen percentage_0 = headcount320
	gen percentage_1 = headcount550 - headcount320
	gen percentage_2 = headcount1500 - headcount550
	gen percentage_3 = 100 - headcount1500
	keep countrycode countryname requestyear  percentage_*
	reshape long  percentage_,i(requestyear countrycode countryname ) j(category) 
	la define category 0 "Poor LMI (<$3.2)" 1 "Poor UMI ($3.2-$5.5)" ///
		2 "Vulnerable ($5.5-$15)" 3 "Middle class (>$15)"
	la val category category
	la var category ""
	graph bar (mean) percentage, inten(*0.7) o(category) o(countrycode, lab(labsi(small) angle(vertical))) stack asy /// 
		blab(bar, pos(center) format(%3.1f) si(tiny)) /// 
		ti("Distribution of Income in Latin America and Caribbean, by country", si(small)) ///
		note("Source: PovCalNet, using the latest survey after 2014 for each country. ", si(*.7)) ///
		graphregion(c(white)) ysize(6) xsize(6.5) legend(si(vsmall) r(3))  yti("Population share in each income category (%)", si(small)) ///
		ylab(,labs(small) nogrid angle(0))
end

*  ----------------------------------------------------------------------------
*  3. World Poverty Trend (reference year)
*  ----------------------------------------------------------------------------
capture program drop example03
program example03
	povcalnet, povline(1.9) region(all) year(all) aggregate clear
	keep if requestyear > 1989
	gen poorpop = headcount*reqyearpopulation 
	gen hcpercent = round(headcount*100, 0.1) 
	gen poorpopround = round(poorpop, 1)
	twoway (sc hcpercent requestyear if regioncode == "WLD", yaxis(1) mlab(hcpercent) mlabpos(7) c(l)) ///
		(sc poorpopround requestyear if regioncode == "WLD", yaxis(2) mlab(poorpopround) mlabpos(1) c(l)) ///
		, yti("Poverty Rate (%)" " ", size(small) axis(1))  ///
		ylab(0(10)40,labs(small) nogrid angle(0) axis(1))  ///
		yti("Number of Poor (million)", size(small) axis(2)) ///
		ylab(0(400)2000, labs(small) angle(0) axis(2))	///
		xlabel(,labs(small)) xtitle("Year", size(small))  ///
		graphregion(c(white)) ysize(5) xsize(5)  ///
		legend(order( ///
		1 "Poverty Rate (% of people living below $1.90)"  ///
		2 "Number of people who live below $1.90") si(vsmall) row(2))
end

*  ----------------------------------------------------------------------------
*  4.  Millions of poor by region (reference year) 
*  ----------------------------------------------------------------------------
capture program drop example04
program example04
	povcalnet, povline(1.9) region(all) year(all) aggregate clear
	keep if requestyear > 1989
	gen poorpop = headcount * reqyearpopulation 
	gen hcpercent = round(headcount*100, 0.1) 
	gen poorpopround = round(poorpop, 1)
	keep requestyear regioncode region poorpop
	gen 	rid=1 if regioncode=="OHI"
	replace rid=2 if regioncode=="ECA"
	replace rid=3 if regioncode=="MNA"
	replace rid=4 if regioncode=="LAC"
	replace rid=5 if regioncode=="EAP"
	replace rid=6 if regioncode=="SAS"
	replace rid=7 if regioncode=="SSA"
	replace rid=8 if regioncode=="WLD"
	keep requestyear rid poorpop
	reshape wide poorpop,i(requestyear) j(rid)
	foreach i of numlist 2(1)7{
		egen poorpopacc`i'=rowtotal(poorpop1 - poorpop`i')
	}
	twoway (area poorpop1 requestyear) ///
		(rarea poorpopacc2 poorpop1 requestyear) ///
		(rarea poorpopacc3 poorpopacc2 requestyear) ///
		(rarea poorpopacc4 poorpopacc3 requestyear) ///
		(rarea poorpopacc5 poorpopacc4 requestyear) ///
		(rarea poorpopacc6 poorpopacc5 requestyear) ///
		(rarea poorpopacc7 poorpopacc6 requestyear) ///
		(line poorpopacc7 requestyear, lwidth(midthick) lcolor(gs0)), ///
		ytitle("Millions of Poor" " ", size(small))  ///
		xtitle(" " "", size(small))  ///
		graphregion(c(white)) ysize(7) xsize(8)  ///
		ylabel(,labs(small) nogrid angle(verticle)) xlabel(,labs(small)) ///
		legend(order( ///
		1 "Rest of the World"  ///
		2 "Europe & Central Asia"  ///
		3 "Middle East & North Africa" ///
		4 "Latin America & Caribbean" ///
		5 "East Asia & the Pacific" ///
		6 "South Asia" ///
		7 "Sub-Saharan Africa" /// 
		8 "World") si(vsmall)) 
end

*  ----------------------------------------------------------------------------
*  5.  Gini & per capita GDP
*  ----------------------------------------------------------------------------
capture program drop example05
program example05
	set checksum off
	wbopendata, indicator(NY.GDP.PCAP.PP.KD) long clear
	tempfile PerCapitaGDP
	save `PerCapitaGDP', replace
	
	povcalnet, povline(1.9) country(all) year(last) clear iso
	keep countrycode countryname requestyear gini
	rename requestyear year
	drop if gini == -1
	* Merge Gini coefficient with per capita GDP
	merge m:1 countrycode year using `PerCapitaGDP'
	keep if _merge == 3
	drop _merge
	replace gini = gini * 100
	drop if ny_gdp_pcap_pp_kd == .
	twoway (scatter gini ny_gdp_pcap_pp_kd, mfcolor(%0) msize(vsmall)) (lfit gini ny_gdp_pcap_pp_kd), ///
			ytitle("Gini Index" " ", size(small))  ///
			xtitle(" " "GDP per Capita per Year (in 2011 USD PPP)", size(small))  ///
			graphregion(c(white)) ysize(5) xsize(7)  ///
			ylabel(,labs(small) nogrid angle(verticle)) xlabel(,labs(small)) ///
			legend(order(1 "Gini Index" 2 "Fitted Value") si(small))
end

*  ----------------------------------------------------------------------------
*  6. Trend of Gini 
*  ----------------------------------------------------------------------------
capture program drop example06
program example06
	povcalnet, country(arg gha tha) year(all) clear
	replace gini = gini * 100
	twoway (connected gini datayear if countrycode == "ARG" & datayear > 1989)  ///
		(connected gini datayear if countrycode == "GHA" & datayear > 1989)  ///
		(connected gini datayear if countrycode == "THA" & datayear > 1989),  /// 
		ytitle("Gini Index" " ", size(small)) xtitle(" " "", size(small))  ///
		ylabel(,labs(small) nogrid angle(verticle)) xlabel(,labs(small)) ///
		graphregion(c(white))   ///
		legend(order(1 "Argentina" 2 "Ghana" 3 "Thailand") si(small) row(1)) 
		
end	   
*  ----------------------------------------------------------------------------
*  7. Growth incidence curves
*  ----------------------------------------------------------------------------
capture program drop example07
program example07	   
	povcalnet, country(arg gha tha) year(all)  clear
	reshape long decile, i(countrycode datayear) j(dec)
	egen panelid=group(countrycode dec)
	replace datayear=int(datayear)
	xtset panelid datayear
	replace decile=10*decile*mean
	gen g=(((decile/L5.decile)^(1/5))-1)*100
	replace g=(((decile/L7.decile)^(1/7))-1)*100 if countrycode=="GHA"
	replace dec=10*dec
	twoway 	(sc g dec if datayear==2016 & countrycode=="ARG", c(l)) ///
			(sc g dec if datayear==2005 & countrycode=="GHA", c(l)) ///
			(sc g dec if datayear==2015 & countrycode=="THA", c(l)) ///
			, yti("Annual growth in decile average income (%)" " ", size(small))  ///
			xlabel(0(10)100,labs(small)) xtitle("Decile group", size(small))  ///
			graphregion(c(white)) ///
			legend(order(1 "Argentina(2011-2016)"  2 "Ghana(1998-2005)" 3 "Thailand(2010-2015)") si(vsmall) row(1))
end
