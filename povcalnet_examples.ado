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
	drop if region_code == "OHI" | request_year<1990 | region_code == "WLD"
	keep poverty_line region_title request_year headcount
	replace poverty_line = poverty_line*100
	replace headcount = headcount*100
	tostring poverty_line, replace format(%12.0f) force
	reshape wide  headcount,i(request_year region_title ) j(poverty_line) string
	twoway (sc headcount190 request_year, c(l) msiz(small)) (sc headcount320 request_year, c(l) msiz(small)) (sc headcount550 request_year, c(l) msiz(small)) ///
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
	keep if data_type==2 & data_year>=2014 // keep income surveys
	keep poverty_line country_code country_name request_year headcount
	replace poverty_line = poverty_line*100
	replace headcount = headcount*100
	tostring poverty_line, replace format(%12.0f) force
	reshape wide  headcount,i(request_year country_code country_name ) j(poverty_line) string
	gen percentage_0 = headcount320
	gen percentage_1 = headcount550 - headcount320
	gen percentage_2 = headcount1500 - headcount550
	gen percentage_3 = 100 - headcount1500
	keep country_code country_name request_year  percentage_*
	reshape long  percentage_,i(request_year country_code country_name ) j(category) 
	la define category 0 "Poor LMI (<$3.2)" 1 "Poor UMI ($3.2-$5.5)" ///
		2 "Vulnerable ($5.5-$15)" 3 "Middle class (>$15)"
	la val category category
	la var category ""
	graph bar (mean) percentage, inten(*0.7) o(category) o(country_code, lab(labsi(small) angle(vertical))) stack asy /// 
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

	povcalnet wb,  clear

	keep if year > 1989
	keep if regioncode == "WLD"	
  gen poorpop = headcount*population 
  gen hcpercent = round(headcount*100, 0.1) 
  gen poorpopround = round(poorpop, 1)

  twoway (sc hcpercent year, ///
         yaxis(1) mlab(hcpercent) mlabpos(7) mlabsize(vsmall) c(l)) ///
         (sc poorpopround year,  ///
         yaxis(2) mlab(poorpopround) mlabsize(vsmall) mlabpos(1) c(l)), ///
    yti("Poverty Rate (%)" " ", size(small) axis(1))  ///
    ylab(0(10)40, labs(small) nogrid angle(0) axis(1))  ///
    yti("Number of Poor (million)", size(small) axis(2)) ///
    ylab(0(400)2000, labs(small) angle(0) axis(2))  ///
    xlabel(,labs(small)) xtitle("Year", size(small))  ///
    graphregion(c(white)) ysize(5) xsize(5)  ///
    legend(order( ///
    1 "Poverty Rate (% of people living below $1.90)"  ///
    2 "Number of people who live below $1.90") si(vsmall) row(2)) scheme(s2color)

end

*  ----------------------------------------------------------------------------
*  4.  Millions of poor by region (reference year) 
*  ----------------------------------------------------------------------------
capture program drop example04
program example04
	povcalnet, povline(1.9) region(all) year(all) aggregate clear
	keep if request_year > 1989
	gen poorpop = headcount * population 
	gen hcpercent = round(headcount*100, 0.1) 
	gen poorpopround = round(poorpop, 1)
	keep request_year region_code region_title poorpop
	gen 	rid=1 if region_code=="OHI"
	replace rid=2 if region_code=="ECA"
	replace rid=3 if region_code=="MNA"
	replace rid=4 if region_code=="LAC"
	replace rid=5 if region_code=="EAP"
	replace rid=6 if region_code=="SAS"
	replace rid=7 if region_code=="SSA"
	replace rid=8 if region_code=="WLD"
	keep request_year rid poorpop
	reshape wide poorpop,i(request_year) j(rid)
	foreach i of numlist 2(1)7{
		egen poorpopacc`i'=rowtotal(poorpop1 - poorpop`i')
	}
	twoway (area poorpop1 request_year) ///
		(rarea poorpopacc2 poorpop1 request_year) ///
		(rarea poorpopacc3 poorpopacc2 request_year) ///
		(rarea poorpopacc4 poorpopacc3 request_year) ///
		(rarea poorpopacc5 poorpopacc4 request_year) ///
		(rarea poorpopacc6 poorpopacc5 request_year) ///
		(rarea poorpopacc7 poorpopacc6 request_year) ///
		(line poorpopacc7 request_year, lwidth(midthick) lcolor(gs0)), ///
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
	rename countrycode country_code
	tempfile PerCapitaGDP
	save `PerCapitaGDP', replace
	
	povcalnet, povline(1.9) country(all) year(last) clear iso
	keep country_code country_name request_year gini
	rename request_year year
	drop if gini == -1
	* Merge Gini coefficient with per capita GDP
	merge m:1 country_code year using `PerCapitaGDP'
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
	twoway (connected gini data_year if country_code == "ARG" & data_year > 1989)  ///
		(connected gini data_year if country_code == "GHA" & data_year > 1989)  ///
		(connected gini data_year if country_code == "THA" & data_year > 1989),  /// 
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
	reshape long decile, i(country_code data_year) j(dec)
	egen panelid=group(country_code dec)
	replace data_year=int(data_year)
	xtset panelid data_year
	replace decile=10*decile*mean
	gen g=(((decile/L5.decile)^(1/5))-1)*100
	replace g=(((decile/L7.decile)^(1/7))-1)*100 if country_code=="GHA"
	replace dec=10*dec
	twoway 	(sc g dec if data_year==2016 & country_code=="ARG", c(l)) ///
			(sc g dec if data_year==2005 & country_code=="GHA", c(l)) ///
			(sc g dec if data_year==2015 & country_code=="THA", c(l)) ///
			, yti("Annual growth in decile average income (%)" " ", size(small))  ///
			xlabel(0(10)100,labs(small)) xtitle("Decile group", size(small))  ///
			graphregion(c(white)) ///
			legend(order(1 "Argentina(2011-2016)"  2 "Ghana(1998-2005)" 3 "Thailand(2010-2015)") si(vsmall) row(1))
end

