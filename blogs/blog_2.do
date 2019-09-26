
if ("`c(username)'" == "wb384996") {
	cd "c:\Users\wb384996\OneDrive - WBG\ado\myados\povcalnet\blogs"
}
else cd "C:\Users\wb424681\OneDrive - WBG\My Documents\PovcalNet\Updates\1909 update\chart blog"

povcalnet wb, povline(1.9 3.2 5.5 15) clear
keep if year>=1990 
keep povertyline regioncode region year headcount
replace povertyline = povertyline*100
replace headcount = headcount*100
tostring povertyline, replace format(%12.0f) force
reshape wide  headcount,i(year regioncode region ) j(povertyline) string
gen percentage_0 = headcount190
gen percentage_1 = headcount320 - headcount190 
gen percentage_2 = headcount550 - headcount320
gen percentage_3 = headcount1500 - headcount550
gen percentage_4 = 100 - headcount1500
keep regioncode region year  percentage_*
reshape long  percentage_,i(year regioncode region  ) j(category) 
la define category 0 "Poor IPL (<$1.9)" 1 "Poor LMIC ($1.9-$3.2)" 2 "Poor UMIC ($3.2-$5.5)" ///
3 "Non-poor ($5.5-$15)" 4 "Middle class (>$15)"
la val category category
la var category ""

/*graph bar (mean) percentage, inten(*0.7) o(category) ///
o(regioncode, lab(labsi(small) angle(vertical))) stack asy /// 
blab(bar, pos(center) format(%3.1f) size(8pt)) /// 
ti("Distribution of Income in Latin America and Caribbean, by country", si(small)) ///
note("Source: PovcalNet, using the latest survey after 2014 for each country. ", si(*.7)) ///
graphregion(c(white)) ysize(6) xsize(6.5) legend(si(vsmall) r(3))  ///
yti("Population share in each income category (%)", si(small)) ///
ylab(,labs(small) nogrid angle(0)) scheme(s2color)
*/

graph bar (mean) percentage if regioncode=="SSA" & year>=1990, inten(*0.7) o(category) ///
o(year, lab(labsi(small) angle(vertical))) stack asy /// 
blab(bar, pos(center) format(%3.1f) size(7pt)) /// 
ti("Distribution of Income in Sub-Saharan Africa over time", si(small)) ///
graphregion(c(white)) ysize(6) xsize(6.5) legend(si(vsmall) r(2) symxsize(*.4))  ///
yti("Population share in each income category (%)", si(small)) ///
ylab(,labs(small) nogrid angle(0)) scheme(s2color) name(ssa, replace)
graph export ssa.png, as(png) hei(1000) replace

graph bar (mean) percentage if regioncode=="EAP" & year>=1990, inten(*0.7) o(category) ///
o(year, lab(labsi(small) angle(vertical))) stack asy /// 
blab(bar, pos(center) format(%3.1f) size(7pt)) /// 
ti("Distribution of Income in East Asia and Pacific over time", si(small)) ///
graphregion(c(white)) ysize(6) xsize(6.5) legend(si(vsmall) r(2) symxsize(*.4)) ///
yti("Population share in each income category (%)", si(small)) ///
ylab(,labs(small) nogrid angle(0)) scheme(s2color) name(eap, replace)
graph export eap.png, as(png) hei(1000) replace

exit
povcalnet wb, clear

twoway (scatter headcount year if regioncode=="WLD", c(l)) ///
(scatter povgap year if regioncode=="WLD", c(l)) ///
(scatter povgapsqr year if regioncode=="WLD", c(l))

twoway (scatter headcount year if regioncode=="SAS", c(l)) ///
(scatter povgap year if regioncode=="SAS", c(l)) ///
(scatter povgapsqr year if regioncode=="SAS", c(l))

twoway (scatter headcount year if regioncode=="SSA", c(l)) ///
(scatter povgap year if regioncode=="SSA", c(l)) ///
(scatter povgapsqr year if regioncode=="SSA", c(l))

*There's no middle class in SSA.
