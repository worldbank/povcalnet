# Visualization Examples

## Global Poverty Trends 1990-2015

```stata
povcalnet wb,  clear server("http://wbgmsrech001")
	
local years = "1981|1984|1987|1990|1993|1996|1999|2002|2005|2008|2010|2011|2012|2013|2015"
keep if regexm(strofreal(year), "`years'")
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
xlabel(1980(5)2015) xscale(range(1980 2015) noextend)  ///
  legend(order( ///
  1 "Poverty Rate (% of people living below $1.90)"  ///
  2 "Number of people who live below $1.90") si(vsmall) row(2)) scheme(s2color)
```

![worldpoverty](img/worldpoverty.png =250x250)
