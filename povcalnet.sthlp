{smcl}
{* *! version 1.0 14 aug 2019}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install wbopendata" "ssc install wbopendata"}{...}
{vieweralsosee "Help wbopendata (if installed)" "help wbopendata"}{...}
{viewerjumpto 	"Command description"   "povcalnet##desc"}{...}
{viewerjumpto "Parameters description"   "povcalnet##param"}{...}
{viewerjumpto "Options description"   "povcalnet##options"}{...}
{viewerjumpto "Subcommands"   "povcalnet##subcommands"}{...}
{viewerjumpto "Stored results"   "povcalnet##return"}{...}
{viewerjumpto "Examples"   "povcalnet##Examples"}{...}
{viewerjumpto "Disclaimer"   "povcalnet##disclaimer"}{...}
{viewerjumpto "How to cite"   "povcalnet##howtocite"}{...}
{viewerjumpto "References"   "povcalnet##references"}{...}
{viewerjumpto "Acknowledgements"   "povcalnet##acknowled"}{...}
{viewerjumpto "Authors"   "povcalnet##authors"}{...}
{viewerjumpto "Regions" "povcalnet_countries##regions"}{...}
{viewerjumpto "Countries" "povcalnet_countries##countries"}{...}
{title:Title}

{p2colset 9 24 22 2}{...}
{p2col :{hi:povcalnet} {hline 2}}Access World Bank Global Poverty and Inequality measures.{p_end}
{p2colreset}{...}
{title:Syntax}

{p 6 16 2}
{cmd:povcalnet} [{it:subcommand}]{cmd:,} 
[{it:{help povcalnet##Options2:Parameters}} {it:{help povcalnet##options:Options}}]


{synoptset 27 tabbed}{...}
{synopthdr:Parameters}
{synoptline}
{synopt :{opt coun:try:}(ISO code)}list of country code (accepts multiples) or {it:all}. 
Cannot be used with option {it:region()}{p_end}
{synopt :{opt reg:ion}(WB code)}list of region code (accepts multiple) or {it:all}. 
Cannot be used with option {it:country()}{p_end}
{synopt :{opt year:}(numlist|string)}list of years (accepts up to 10),  or {it:all}, or {it:last}. Default "all".{p_end}
{synopt :{opt pov:line:}(#)}list of poverty lines (in 2011 PPP-adjusted USD) to calculate
 poverty measures (accepts up to 5). Default is 1.9.{p_end}

{synoptset 27 tabbed}{...}
{synopthdr:Options}
{synoptline}
{synopt :{opt clear}} replace data in memory.{p_end}
{synopt :{opt agg:regate}} calculates poverty measures for regions instead of countries.{p_end}
{synopt :{opt coverage(string)}} loads coverage level ("national", "urban", "rural", "all"). Default "all".{p_end}
{synopt :{opt fill:gaps}} loads all countries used to create regional aggregates.{p_end}
{synopt :{opt info:rmation}} presents a clickable version of the available surveys, countries and regions.{p_end}
{synopt :{opt iso}} uses ISO3 for country/economy codes in the output. {p_end}
{synopt :{opt ppp}{cmd:(#)}} allows the selection of an specific PPP. {p_end}

{synoptset 27 tabbed}{...}
{synopthdr:subcommands}
{synoptline}
{synopt :{opt info:rmation}}presents a clickable version of the available surveys, 
countries and regions. Same as option{it:information}{p_end}
{synopt :{opt cl}}parses the parameters of the query in a one-on-one correspondance of 
rather than the default combinational query. See{help povcalnet##typesq: bellow} 
for a detailed explanation.{p_end}
{synopt :{opt wb}}download World Bank's regional and global aggegation{p_end}
{synopt :{opt test}}executes the last query in browser regardless of failure by 
{cmd:povcalnet}.{p_end}
{synoptline}

{pstd}
{bf:Note}: {cmd:povcalnet} requires internet connection.

{marker sections}{...}
{title:Sections}

{pstd}
Sections are presented under the following headings:

		{it:{help povcalnet##desc:Command description}}
		{it:{help povcalnet##param:Parameters description}}
		{it:{help povcalnet##options:Options description}}
		{it:{help povcalnet##subcommands:Subcommands}}
		{it:{help povcalnet##return:Stored results}}
		{it:{help povcalnet##Examples:Examples}}
		{it:{help povcalnet##disclaimer:Disclaimer}}
		{it:{help povcalnet##references:References}}
		{it:{help povcalnet##acknowled:Acknowledgements}}
		{it:{help povcalnet##authors:Authors}}
		{it:{help povcalnet##contact:Contact}}
		{it:{help povcalnet##howtocite:How to cite}}
		{it:{help povcalnet_countries:Region and country codes}}

{marker desc}{...}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}
{title:Description}

{pstd}
The {cmd:povcalnet} commands allows Stata users to compute poverty and inequality
 indicators for more than 160 countries and regions the World Bank's database of household
 surveys. It has the same functionality as the PovcalNet website. PovcalNet is a 
 computational tool that allows users to estimate poverty rates for regions, sets of 
 countries or individual countries, over time and at any poverty line.

{pstd}
PovcalNet is managed jointly by the Data and Research Group in the World Bank's
 Development Economics Division. It draws heavily upon a strong collaboration with the 
 Poverty and Equity Global Practice, which is responsible for the gathering and 
 harmonization of the underlying survey data. 

{pstd}
{cmd:povcalnet} reports the following measures at the chosen poverty line and 
these inequality measures:

		{hline 43}
		Poverty measures{col 40}Inequality measures
		{hline 20}{col 40}{hline 20}
		Headcount        {col 40}Gini index
		Poverty gap      {col 40}Mean log deviations
		Poverty severity {col 40}decile shares
		Watts index      {col 40}
		{hline 43}

{pstd}
The underlying welfare aggregate is per capita household income or consumption
 expressed in 2011 PPP-adjusted USD. Poverty lines are expressed in daily amounts, while 
 means and medians are monthly. For more information on the definition of the indicators,
 {browse "http://iresearch.worldbank.org/PovcalNet/Docs/dictionary.html": click here}. 
 For more information on the methodology,{browse "http://iresearch.worldbank.org/PovcalNet/methodology.aspx": click here}

{marker typesc}{...}
{title:Type of calculations}:

{pstd}
The PovcalNet API allows two type of calculations:

{phang}
{opt Survey-year}: Will load poverty and inequality measures for one or several 
countries, at the survey-year, without aggregation. Each observation is a 
country-survey-year. This is the default query.

{phang}
{opt reference-year}: Will load poverty measures for reference years 
that are common across most countries. Regional and global aggregates are calculated 
only in reference-years. Countries without a survey in the reference-year 
are extrapolated or interpolated using national accounts growth rates. 

{pin}
{err:Important}: Choosing option  {it:aggregate}  displays regional (population-weighted) 
averages. While option {it:fillgaps} reports the underlying lined-up estimates to the 
reference year at the country level. Poverty measures calculated in the {cmd:survey-year} and 
{cmd:reference-year} types of calculation will include Headocount, Poverty Gap, Squared Poverty Gap. 
Inequality measures, including the Gini coefficient, Watts index, Mean log Deviation 
and Decile Distibution, are calculated only in {cmd:survey-year} where micro data is available.
Inequality measures are not reported for {cmd:reference-year}.

{marker typesq}{...}
{title:Combinatorial and one-on-one queries}:

{pstd}
Be default, {cmd:povcalnet} creates a combinatorial query of the parameters selected, 
so that the output contains all the possible combinations between {it:country()}, 
{it:povline()}, {it:year()}, and {it:coverage()}. Option {it:ppp()} is not part of the 
combinatorial query. Alternatively, the user may select the subcommand {it:cl} to parse a 
one-on-one (i.e., country by country) request. In this case, the first country listed in 
{it:country()} will be combined with the first year in {it:year()}, the first poverty lines
in {it:povline()} and the first coverage area in {it:coverage()}, and so on a so forth 
with subsequent countries. If only one element is added to parameters 
{it:povline()}, {it:year()}, or {it:coverage()}, it would be replicated as many times 
as elements parameter {it:countr()} has. {err:caution}: if only one element is added 
to option {it:ppp()}, it would be rippled to all the countries in {it:country()}. 

{marker param}{...}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}
{title:Parameters description}

{phang}
{opt country(string)}{help povcalnet##countries:Countries and Economies Abbreviations and Acronyms}. 
If specified with {opt year(string)},
this option will return all the specific countries and years for which there is actual survey data. 
When selecting multiple countries please use the three letters code with spaces. The option 
{it:all} is as shorthand for calling all countries.

{phang}
{opt region(string)}{help povcalnet##regions:Regions Abbreviations and Acronyms}  If 
specified with {opt year(string)}, this option will return all the specific countries 
and years that belong to the specified region(s). 
For example, {opt region(LAC)} will bring all countries in Latin America and the 
Caribbean for which there's an actual survey in the given years. 
When selecting multiple regions please use the three letters code with spaces. The 
option {it:all} is as shorthand for calling all regions, which is equivalent to calling all countries.

{phang}
{opt year(#)} Four digit years are accepted. When selecting multiple years 
please separate each with spaces. The option {it:all} is a shorthand for calling all 
possible years, while the {it:last} option will download the latest available year 
for each country.

{phang}
{opt povline(#)} The poverty lines for which the poverty calculations will be done. 
When selecting multiple poverty lines please use less than 4 decimals and separate 
each line with spaces. If left empty, the default poverty line of $1.9 is used.
Poverty lines are expressed in 2011 PPP-adjusted USD per capita per day.

{marker options}{...}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}
{title:Options description}

{phang}
{opt aggregate} Will calculate the aggregated poverty measures for the given set of 
countries or regions.

{p 8 8 2}{err:Note 1}: If option {it:country({ul:all})} is combined with 
option {it:aggregate}, {cmd:povcalnet} executes instead {cmd: povcalnet wb}. 
This forced behavior is implemented to be consistent with the 
{browse "http://iresearch.worldbank.org/PovcalNet/povDuplicateWB.aspx":default global aggregates} 
presented in PovcalNet. If you want instead to aggregate all countries by survey years, 
you may list them all in the {it:country()} option. One way to do so may be as follows:{p_end}
{cmd}
		. povcalnet info, clear
		. levelsof country_code, local(all) clean 
		. povcalnet, country(`all') year(2015) clear  aggregate
{txt}
{p 8 8 2}{err:Note 2}: Aggregation can only be done for 1981, 1984, 1987, 1990, 1993, 
1996, 1999, 2002, 2005, 2008, 2010, 2011, 2012, 2013 and 2015 (As of Sep 2018). 
Due to the constant updating of the PovCalNet databases, using the option {it:last} 
or {it:all} will load the years most updated year(s).{p_end}

{phang}
{opt fillgaps} Loads all country-level estimates that are used to create the  
aggregates in the reference years. This means that estimates use the same reference 
years as aggregate estimates. 

{p 8 8 2}{err:Note}: Countries without a survey in the reference-year have been 
extrapolated or interpolated using national accounts growth rates (see Chapter 6
{browse "https://openknowledge.worldbank.org/bitstream/handle/10986/20384/9781464803611.pdf":here}).
Therefore, changes at the country-level from one reference year to the next need 
to be interpreted carefully and may not be the result of a new household survey.{p_end}

{phang}
{opt iso} uses ISO3 for country/economy codes in output. Users should use {help povcalnet##countries:Countries and Economies Abbreviations and Acronyms} when 
calling the command.

{phang}
{opt PPP}{cmd:(#)} allows the selection of an specific PPP. This option will only 
work if only one country is selected.

{phang}
{opt coverage(string)} (replaces option {it:auxiliary}) Selects coverage level of 
estimates. 
By default all coverage levels are loaded, but the user may select "national", 
"urban", or "rural" level. For now, only one level of covarege can be selected. 

{marker optinfo}{...}
{phang}
{opt information} Presents a clickable version of the available surveys, countries 
and regions. Selecting countries from the menu loads the survey-year estimates.
Choosing regions loads the regional aggregates in the reference years. 

{p 8 8 2}{err:Note}: If option {it:clear} is added, data in memory would be replaced with a PovcalNet 
guidence database. If option {it:clear} is {ul:not} included, {cmd:povcalnet} 
preserves data in memory  but displays a clickabe interface of surveys availability 
in the results window.{p_end}

{phang}
{opt clear} replaces data in memory.

{marker subcommands}{...}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}
{title:Subcommands}

{phang}
{opt info} Does the same thing as option {it:info} {help povcalnet##optinfo:above}. 

{phang}
{opt cl} Changes combinatorial query of parameters for one-on-one correspondace of 
parameters. See {help povcalnet##typesq:above} for detailes explanation. 

{phang}
{opt wb} Downloads World Bank's regional and global aggregation. This functions differes 
from the option {it:aggregate} in two senses: [1] {it:wb} uses a predefined set of countries
in each region, whereas option {it:aggregate} allows the user to select their own set 
of countries for aggregation. [2] the number of poor is different between the two methods
evern thought the set of countries is the same. This is so because, when using {it:wb} 
the number of poor in each region is the product of the region’s headcount index and 
total regional population. This assumes that the poverty rate for an economy without a household 
survey is the regional average. In contrast, when using {it:aggregate}, the number of 
poor is the product of the region’s headcount index and the total population of the 
economies included in the aggregation. 

{phang}
{opt test} executes the last query in browser regardless of failure by 
{cmd:povcalnet}. It makes use of the global "${pcn_query}".


{marker return}{...}
{title:Stored results}{p 50 20 2}{p_end}

{pstd}
{cmd:povcalnet} stores the following in {cmd:r()}. Suffix _{it:#} refers to the number of 
poverty lines included in {it:povlines()}:

{p2col 5 20 24 2: queries}{p_end}
{synopt:{cmd:r(query_ys_{it:#})}}Query of years{p_end}
{synopt:{cmd:r(query_pl_{it:#})}}Query of poverty lines{p_end}
{synopt:{cmd:r(query_ct_{it:#})}}Query of countries and coverages{p_end}
{synopt:{cmd:r(query_ds_{it:#})}}Query of aggregation display{p_end}
{synopt:{cmd:r(query_{it:#})}}concatenation of the queries above{p_end}

{p2col 5 20 24 2: API parts}{p_end}
{synopt:{cmd:r(server)}}Protocol (http://) and server name{p_end}
{synopt:{cmd:r(site_name)}}Site names{p_end}
{synopt:{cmd:r(handler)}}Action handler{p_end}
{synopt:{cmd:r(base)}}concatenation of server, site_name, and handler{p_end}

{p2col 5 20 24 2: addtional info}{p_end}
{synopt:{cmd:r(queryfull_{it:#})}}concatenation of base and query_{it:#} by "?"{p_end}
{synopt:{cmd:r(npl)}}Number of poverty lines{p_end}
{synopt:{cmd:pcn_query}}global with query information in case {cmd:povcalnet} fails. 
"${pcn_query}" to display {p_end}

{marker Examples}{...}
{title:Examples}{p 50 20 2}{p_end}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}

{dlgtab: 1. basic examples}

{phang}
1.1. Load latest available survey-year estimates for Colombia and Argentina

{phang2}
{stata povcalnet, country(col arg) year(last) clear} 

{phang}
1.2. Load clickable menu

{phang2}
{stata povcalnet, info}

{phang}
1.3. Load only urban coverage level

{phang2}
{stata povcalnet, country(all) coverage("urban") clear}


{dlgtab: 2. Differences in queries}

{phang}
2.1. Country estimation at $1.9 in 2015. Since there is no survey in ARG and IND in 
2015, only results are loaded for COL and BRA

{phang2}
{stata povcalnet, country(COL BRA ARG IND) year(2015) clear}

{phang}
2.2. fill gaps. Fill gaps for ARG and IND. Only works for reference years. 

{phang2}
{stata povcalnet, country(COL BRA ARG IND) year(2015) clear  fillgaps}

{phang}
2.3. Aggregate economies listed in {it:country()} as if they were one. 

{phang2}
{stata povcalnet, country(COL BRA ARG IND) year(2015) clear  aggregate}

{phang}
2.4. WB aggregates ({it:country()} is not avialable)

{phang2}
{stata povcalnet wb, clear  year(2015)}{p_end}
{phang2}
{stata povcalnet wb, clear  region(SAR LAC)}{p_end}
{phang2}
{stata povcalnet wb, clear}       // all reference years{p_end}

{phang}
2.5. one-on-one query. 

{phang2}
{stata povcalnet cl, country(COL BRA ARG IND) year(2011) clear coverage("national national urban national")}

{dlgtab: 3. Samples uniquely identified by country/year}

{phang2}
{ul:3.1} National coverage (when available) and longest possible time series for each country, 
{it:even if} welfare type changes from one year to another.

{cmd}
	. povcalnet, clear

	* keep only national
	. bysort countrycode datatype year: egen _ncover = count(coveragetype)
	. gen _tokeepn = ( (inlist(coveragetype, 3, 4) & _ncover > 1) | _ncover == 1)

	. keep if _tokeepn == 1

	* Keep longest series per country
	. by countrycode datatype, sort:  gen _ndtype = _n == 1
	. by countrycode : replace _ndtype = sum(_ndtype)
	. by countrycode : replace _ndtype = _ndtype[_N] // number of datatype per country

	. duplicates tag countrycode year, gen(_yrep)  // duplicate year

	.bysort countrycode datatype: egen _type_length = count(year) // length of type series
	.bysort countrycode: egen _type_max = max(_type_length)   // longest type series
	.replace _type_max = (_type_max == _type_length)

	* in case of same elngth in series, keep consumption
	. by countrycode _type_max, sort:  gen _ntmax = _n == 1
	. by countrycode : replace _ntmax = sum(_ntmax)
	. by countrycode : replace _ntmax = _ntmax[_N]  // number of datatype per country


	. gen _tokeepl = ((_type_max == 1 & _ntmax == 2) | ///
	.                (datatype == 1 & _ntmax == 1 & _ndtype == 2) | ///
	.                _yrep == 0)
	. 
	. keep if _tokeepl == 1
	. drop _*

{txt}      ({stata "povcalnet_examples example08":click to run})

{phang2}
{ul:3.2} National coverage (when available) and longest possible time series for each country, {it:either all consumption, or all income}

{cmd}
	. bysort countrycode datatype year: egen _ncover = count(coveragetype)
	. gen _tokeepn = ( (inlist(coveragetype, 3, 4) & _ncover > 1) | _ncover == 1)

	. keep if _tokeepn == 1
	* Keep longest series per country
	. by countrycode datatype, sort:  gen _ndtype = _n == 1
	. by countrycode : replace _ndtype = sum(_ndtype)
	. by countrycode : replace _ndtype = _ndtype[_N] // number of datatype per country


	. bysort countrycode datatype: egen _type_length = count(year)
	. bysort countrycode: egen _type_max = max(_type_length)
	. replace _type_max = (_type_max == _type_length)

	* in case of same elngth in series, keep consumption
	. by countrycode _type_max, sort:  gen _ntmax = _n == 1
	. by countrycode : replace _ntmax = sum(_ntmax)
	. by countrycode : replace _ntmax = _ntmax[_N]  // max 


	. gen _tokeepl = ((_type_max == 1 & _ntmax == 2) | ///
	.               (datatype == 1 & _ntmax == 1 & _ndtype == 2)) | ///
	.               _ndtype == 1

	. keep if _tokeepl == 1
	. drop _*

{txt}      ({stata "povcalnet_examples example09":click to run})

{dlgtab: 4. Analytical examples}

{phang2}
{ul:4.1} Graph of trend in poverty headcount ratio and number of poor for the world

{cmd}
	. povcalnet wb,  clear

	. keep if year > 1989
	. keep if regioncode == "WLD"	
	. gen poorpop = headcount*population 
	. gen hcpercent = round(headcount*100, 0.1) 
	. gen poorpopround = round(poorpop, 1)

	. twoway (sc hcpercent year, yaxis(1) mlab(hcpercent)           ///
	.          mlabpos(7) mlabsize(vsmall) c(l))                    ///
	.        (sc poorpopround year, yaxis(2) mlab(poorpopround)     ///
	.          mlabsize(vsmall) mlabpos(1) c(l)),                   ///
	.        yti("Poverty Rate (%)" " ", size(small) axis(1))       ///
	.        ylab(0(10)40, labs(small) nogrid angle(0) axis(1))     ///
	.        yti("Number of Poor (million)", size(small) axis(2))   ///
	.        ylab(0(400)2000, labs(small) angle(0) axis(2))         ///
	.        xlabel(,labs(small)) xtitle("Year", size(small))       ///
	.        graphregion(c(white)) ysize(5) xsize(5)                ///
	.        legend(order(                                          ///
	.        1 "Poverty Rate (% of people living below $1.90)"      ///
	.        2 "Number of people who live below $1.90") si(vsmall)  ///
	.        row(2)) scheme(s2color)
	
{txt}      ({stata "povcalnet_examples example03":click to run})

{phang2}
{ul:4.2} Graph of population distribution across income categories in Latin America, by country

{cmd}
	. povcalnet, region(lac) year(last) povline(3.2 5.5 15) fillgaps clear 
	. keep if datatype==2 & year>=2014             // keep income surveys
	. keep povertyline countrycode countryname year headcount
	. replace povertyline = povertyline*100
	. replace headcount = headcount*100
	. tostring povertyline, replace format(%12.0f) force
	. reshape wide  headcount,i(year countrycode countryname ) j(povertyline) string
	
	. gen percentage_0 = headcount320
	. gen percentage_1 = headcount550 - headcount320
	. gen percentage_2 = headcount1500 - headcount550
	. gen percentage_3 = 100 - headcount1500
	
	. keep countrycode countryname year  percentage_*
	. reshape long  percentage_,i(year countrycode countryname ) j(category) 
	. la define category 0 "Poor LMI (< $3.2)" 1 "Poor UMI ($3.2-$5.5)" ///
		                 2 "Vulnerable ($5.5-$15)" 3 "Middle class (> $15)"
	. la val category category
	. la var category ""

	. local title "Distribution of Income in Latin America and Caribbean, by country"
	. local note "Source: PovCalNet, using the latest survey after 2014 for each country."
	. local yti  "Population share in each income category (%)"

	. graph bar (mean) percentage, inten(*0.7) o(category) o(countrycode, ///
	.   lab(labsi(small) angle(vertical))) stack asy                      /// 
	. 	blab(bar, pos(center) format(%3.1f) si(tiny))                     /// 
	. 	ti("`title'", si(small)) note("`note'", si(*.7))                  ///
	. 	graphregion(c(white)) ysize(6) xsize(6.5)                         ///
	. 		legend(si(vsmall) r(3))  yti("`yti'", si(small))                ///
	. 	ylab(,labs(small) nogrid angle(0)) scheme(s2color)
{txt}      ({stata "povcalnet_examples example02":click to run})

{phang2}
{ul:4.3} Graph of trends in poverty headcount ratio by region, multiple poverty lines ($1.9, $3.2, $5.5)

{cmd}	
	. povcalnet wb, povline(1.9 3.2 5.5) clear
	. drop if inlist(regioncode, "OHI", "WLD") | year<1990 
	. keep povertyline region year headcount
	. replace povertyline = povertyline*100
	. replace headcount = headcount*100
	
	. tostring povertyline, replace format(%12.0f) force
	. reshape wide  headcount,i(year region) j(povertyline) string
	
	. local title "Poverty Headcount Ratio (1990-2015), by region"

	. twoway (sc headcount190 year, c(l) msiz(small))  ///
	.        (sc headcount320 year, c(l) msiz(small))  ///
	.        (sc headcount550 year, c(l) msiz(small)), ///
	.        by(reg,  title("`title'", si(med))        ///
	.        	note("Source: PovcalNet", si(vsmall)) graphregion(c(white))) ///
	.        xlab(1990(5)2015 , labsi(vsmall)) xti("Year", si(vsmall))     ///
	.        ylab(0(25)100, labsi(vsmall) angle(0))                        ///
	.        yti("Poverty headcount (%)", si(vsmall))                      ///
	.        leg(order(1 "$1.9" 2 "$3.2" 3 "$5.5") r(1) si(vsmall))        ///
	.        sub(, si(small))	scheme(s2color)
{txt}      ({stata "povcalnet_examples example01":click to run})

{phang2}
{ul:4.4} Millions of poor by region (by aggregation - reference year) 

{cmd}
	. povcalnet wb, clear
	. keep if year > 1989
	. gen poorpop = headcount * population 
	. gen hcpercent = round(headcount*100, 0.1) 
	. gen poorpopround = round(poorpop, 1)
	. encode region, gen(rid)

	. levelsof rid, local(regions)
	. foreach region of local regions {
	. 	local legend = `"`legend' `region' "`: label rid `region''" "'
	. }

	. keep year rid poorpop
	. reshape wide poorpop,i(year) j(rid)
	. foreach i of numlist 2(1)7{
	. 	egen poorpopacc`i'=rowtotal(poorpop1 - poorpop`i')
	. }

	. twoway (area poorpop1 year)                              ///
	. 	(rarea poorpopacc2 poorpop1 year)                      ///
	. 	(rarea poorpopacc3 poorpopacc2 year)                   ///
	. 	(rarea poorpopacc4 poorpopacc3 year)                   ///
	. 	(rarea poorpopacc5 poorpopacc4 year)                   ///
	. 	(rarea poorpopacc6 poorpopacc5 year)                   ///
	. 	(rarea poorpopacc7 poorpopacc6 year)                   ///
	. 	(line poorpopacc7 year, lwidth(midthick) lcolor(gs0)), ///
	. 	ytitle("Millions of Poor" " ", size(small))            ///
	. 	xtitle(" " "", size(small)) scheme(s2color)            ///
	. 	graphregion(c(white)) ysize(7) xsize(8)                ///
	. 	ylabel(,labs(small) nogrid angle(verticle)) xlabel(,labs(small)) ///
	. 	legend(order(`legend') si(vsmall))
{txt}      ({stata "povcalnet_examples example04":click to run})

{marker disclaimer}{...}
{title:Disclaimer}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}

{p 4 4 2}PovcalNet was developed for the sole purpose of public replication of the World Bank’s poverty measures for its widely used international poverty lines, including $1.90 a day and $3.20 a day in 2011 PPP. 
The methods built into PovcalNet are considered reliable for that purpose. 
{p_end}
{p 4 4 2}However, we cannot be confident that the methods work well for other purposes, including tracing out the entire distribution of income. 
We would especially warn that estimates of the densities near the bottom and top tails of the distribution could be quite unreliable, and no attempt has been made by the World Bank’s staff to validate the tool for such purposes.
{p_end}
{p 4 4 2}The term country, used interchangeably with economy, does not imply political independence but refers to any territory for which authorities report separate social or economic statistics.
{p_end}

{marker references}{...}
{title:References}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}

    {p 8 12 2}XXX (2018) "How to use PovcalNet from Stata", Global Poverty Monitoring Technical Note 7, World Bank. [NEED TO ADD HYPERLINK]{p_end}

{marker acknowled}{...}
{title:Acknowledgements}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}

{p 4 4 2}The authors would like to thank R. Andres Castaneda Aguilar, Kihoon Lee and Minh Cong Nguyen for comments received on earlier versions of this code.{p_end}
{p 4 4 2}In developing this code, we closely followed the example of wbopendata developed by Joao Pedro Azevedo. {p_end} 

{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}
{marker authors}{...}
{title:Authors}
	{p 4 4 2}R.Andres Castaneda, Christoph Lakner, Espen Beer Prydz, Jorge Soler Lopez, Ruoxuan Wu, Qinghua Zhao{p_end}

{title:maintainer}
{p 4 4 4}R.Andres Castaneda, The World Bank{p_end}
{p 6 6 4}Email: {browse "acastanedaa@worldbank.org":  acastanedaa@worldbank.org}{p_end}
{p 6 6 4}GitHub:{browse "https://github.com/randrescastaneda": randrescastaneda }{p_end}

{marker contact}{...}
{title:contact}
{phang}
Any comment, suggestion, or bug can be reported in the 
{browse "https://github.com/worldbank/povcalnet/issues" :GitHub issues page}.
All the files are avaialble in the {browse "https://github.com/worldbank/povcalnet": GitHub repository}

{marker howtocite}{...}
{title:Thanks for citing {cmd:povcalnet} as follows}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}

{p 8 12 2}XXX (2019) "povcalnet: Stata module to access World Bank’s Global Poverty and Inequality data," Statistical Software Components YYYY, Boston College Department of Economics. http://ideas.repec.org/c/boc/bocode/ZZZZZ.html {p_end}




