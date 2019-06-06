{smcl}
{hline}
{* 31Auot2018 }{...}
help for {hi:povcalnet}{right:World Bank}
{hline}

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
{synoptline}

{pstd}
{err:Note}: {cmd:povcalnet} requires internet connection.

{marker sections}{...}
{title:Sections}

{pstd}
Sections are presented under the following headings:

		{it:{help povcalnet##desc:Command description}}
		{it:{help povcalnet##param:Parameters description}}
		{it:{help povcalnet##options:Options description}}
		{it:{help povcalnet##Examples:Examples}}
		{it:{help povcalnet##disclaimer:Disclaimer}}
		{it:{help povcalnet##howtocite:How to cite}}
		{it:{help povcalnet##references:References}}
		{it:{help povcalnet##acknowled:Acknowledgements}}
		{it:{help povcalnet##authors:Authors}}


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
dddd

{marker param}{...}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}
{title:Parameters description}

{dlgtab: Parameters}

{synopt:{opt country(string)}}{help povcalnet##countries:Countries and Economies Abbreviations and Acronyms}. If specified with {opt year(string)},
this option will return all the specific countries and years for which there is actual survey data. 
When selecting multiple countries please use the three letters code with spaces. The option {it:all} is as shorthand for calling all countries.{p_end}

{synopt:{opt region(string)}}{help povcalnet##regions:Regions Abbreviations and Acronyms}  If specified with {opt year(string)}, this option will return all the specific countries and years that belong to the specified region(s). 
For example, {opt region(LAC)} will bring all countries in Latin America and the Caribbean for which there's an actual survey in the given years. 
When selecting multiple regions please use the three letters code with spaces. The option {it:all} is as shorthand for calling all regions, which is equivalent to calling all countries.
{p_end}

{synopt:{opt year(#)}} Four digit years are accepted. When selecting multiple years please separate each with spaces. 
The option {it:all} is a shorthand for calling all possible years, while the {it:last} option will download the latest available year for each country.
{p_end}

{synopt:{opt povline(#)}} The poverty lines for which the poverty calculations will be done. When selecting multiple poverty lines please use less than 4 decimals and separate each line with spaces.
If left empty, the default poverty line of $1.9 is used.
Poverty lines are expressed in 2011 PPP-adjusted USD per capita per day. 
{p_end}


{marker options}{...}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}
{title:Options description}

{dlgtab:Options}
{phang}
{opt aggregate} Will calculate the aggregated poverty measures for the given set of countries or regions.

{p 8 8 2}{err:Note}: Aggregation can only be done for 1981, 1984, 1987, 1990, 1993, 1996, 1999, 2002, 2005, 2008, 2010, 2011, 2012, 2013 and 2015 (As of Sep 2018). 
Due to the constant updating of the PovCalNet databases, using the option {it:last} or {it:all} will load the years most updated year(s).{p_end}

{phang}
{opt fillgaps} Loads all country-level estimates that are used to create the  
aggregates in the reference years. This means that estimates use the same reference 
years as aggregate estimates. 

{p 8 8 2}{err:Note}: Countries without a survey in the reference-year have been extrapolated or interpolated using national accounts growth rates (see Chapter 6
{browse "https://openknowledge.worldbank.org/bitstream/handle/10986/20384/9781464803611.pdf":here}).
Therefore, changes at the country-level from one reference year to the next need to be interpreted carefully and may not be the result of a new household survey.{p_end}

{phang}
{opt iso} uses ISO3 for country/economy codes in output. Users should use {help povcalnet##countries:Countries and Economies Abbreviations and Acronyms} when calling the command.

{phang}
{opt PPP}{cmd:(#)} allows the selection of an specific PPP. This option will only work if only one country is selected.

{phang}
{opt coverage(string)} (replaces option {it:auxiliary}) Selects coverage level of estimates. 
By default all coverage levels are loaded, but the user may select "national", "urban", or "rural" level. For now, only one level of covarege can be selected. 

{phang}
{opt auxiliary} ({err:Not longer available}) In countries where national aggregates are
 estimated by creating a weighted sum of urban and rural surveys, the national estimate is reported by default.
Specifying  {opt auxiliary} will load the underlying urban and rural surveys.

{p 8 8 2}{err:Note}: As of September 2018, this applies to China, India and Indonesia. Distributional statistics (e.g. Gini, decile shares) are typically reported only for the urban and rural distributions separately,
so auxiliary needs to specified to obtain these estimates.{p_end}

{phang}
{opt information} Presents a clickable version of the available surveys, countries and regions. Selecting countries from the menu loads the survey-year estimates.
Choosing regions loads the regional aggregates in the reference years.

{phang}
{opt clear} replace data in memory.


{marker Examples}{...}
{title:Examples}{p 50 20 2}{p_end}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}

{p 8 12}Load latest available survey-year estimates for Colombia and Argentina{p_end}
{p 8 12}{stata povcalnet, country(col arg) year(last) clear}{p_end}

{p 8 12}Load clickable menu{p_end}
{p 8 12}{stata povcalnet, info}{p_end}

{p 8 12}Load only urban coverage level{p_end}
{p 8 12}{stata povcalnet, country(all) coverage("urban") clear}{p_end} 

{p 8 12}Graph of trend in poverty headcount ratio and number of poor for the world

{cmd}
	. povcalnet, povline(1.9) region(all) year(all) aggregate clear
	. keep if requestyear > 1989
	. gen poorpop = headcount*reqyearpopulation 
	. gen hcpercent = round(headcount*100, 0.1) 
	. gen poorpopround = round(poorpop, 1)
	. twoway (sc hcpercent requestyear if regioncode == "WLD", yaxis(1) mlab(hcpercent) mlabpos(7) c(l)) ///
	. (sc poorpopround requestyear if regioncode == "WLD", yaxis(2) mlab(poorpopround) mlabpos(1) c(l)) ///
	. ti("Poverty Rate (%)" " ", size(small) axis(1))  ///
	. b(0(10)40,labs(small) nogrid angle(0) axis(1))  ///
	. ("Number of Poor (million)", size(small) axis(2)) ///
	. b(0(400)2000, labs(small) angle(0) axis(2))	///
	. bel(,labs(small)) xtitle("Year", size(small))  ///
	. graphregion(c(white)) ysize(5) xsize(5)  ///
	. legend(order( ///
	. 1 "Poverty Rate (% of people living below $1.90)"  ///
	. 2 "Number of people who live below $1.90") si(vsmall) row(2))
{txt}      ({stata "povcalnet_examples example03":click to run})

{p 8 12}Graph of population distribution across income categories in Latin America, by country

{cmd}
	. povcalnet, region(lac) year(last) povline(3.2 5.5 15) clear 
	. keep if datatype==2 & datayear>=2014 // keep income surveys
	. keep povertyline countrycode countryname requestyear headcount
	. replace povertyline = povertyline*100
	. replace headcount = headcount*100
	. tostring povertyline, replace format(%12.0f) force
	. reshape wide  headcount,i(requestyear countrycode countryname ) j(povertyline) string
	. gen percentage_0 = headcount320
	. gen percentage_1 = headcount550 - headcount320
	. gen percentage_2 = headcount1500 - headcount550
	. gen percentage_3 = 100 - headcount1500
	. keep countrycode countryname requestyear  percentage_*
	. reshape long  percentage_,i(requestyear countrycode countryname ) j(category) 
	. la define category 0 "Poor LMI (<$3.2)" 1 "Poor UMI ($3.2-$5.5)" ///
	. 	2 "Vulnerable ($5.5-$15)" 3 "Middle class (>$15)"
	. la val category category
	. la var category ""
	. graph bar (mean) percentage, inten(*0.7) o(category) o(countrycode, lab(labsi(small) angle(vertical))) stack asy /// 
	. 	blab(bar, pos(center) format(%3.1f) si(tiny)) /// 
	. 	ti("Distribution of Income in Latin America and Caribbean, by country", si(small)) ///
	. 	note("Source: PovCalNet, using the latest survey after 2014 for each country. ", si(*.7)) ///
	. 	graphregion(c(white)) ysize(6) xsize(6.5) legend(si(vsmall) r(3)) ///
	. 	yti("Population share in each income category (%)", si(small)) ///
		ylab(,labs(small) nogrid angle(0))
{txt}      ({stata "povcalnet_examples example02":click to run})

{p 8 12}Graph of trends in poverty headcount ratio by region, multiple poverty lines ($1.9, $3.2, $5.5)


{cmd}	
	. povcalnet, region(all) year(all) povline(1.9 3.2 5.5) clear aggregate
	. drop if regioncode == "OHI" | requestyear<1990 | regioncode == "WLD"
	. keep povertyline region requestyear headcount
	. replace povertyline = povertyline*100
	. replace headcount = headcount*100
	. tostring povertyline, replace format(%12.0f) force
	. reshape wide  headcount,i(requestyear region ) j(povertyline) string
	. twoway (sc headcount190 requestyear, c(l) msiz(small)) ///
	. (sc headcount320 requestyear, c(l) msiz(small)) (sc headcount550 requestyear, c(l) msiz(small)) ///
	. 	, by(reg,  title("Poverty Headcount Ratio (1990-2015), by region", si(med)) ///
	. 	note("Source: PovcalNet", si(vsmall)) graphregion(c(white))) ///
	. 	xlab(1990(5)2015 , labsi(vsmall)) xti("Year", si(vsmall)) ///
	. 	ylab(0(25)100, labsi(vsmall) angle(0)) yti("Poverty headcount (%)", si(vsmall)) ///
	. 	leg(order(1 "$1.9" 2 "$3.2" 3 "$5.5") r(1) si(vsmall)) sub(, si(small))
{txt}      ({stata "povcalnet_examples example01":click to run})

{p 8 12} Millions of poor by region (by aggregation - reference year) 

	. povcalnet, povline(1.9) region(all) year(all) aggregate clear
	. keep if requestyear > 1989
	. gen poorpop = headcount * reqyearpopulation 
	. gen hcpercent = round(headcount*100, 0.1) 
	. gen poorpopround = round(poorpop, 1)
	. keep requestyear regioncode region poorpop
	. gen 	rid=1 if regioncode=="OHI"
	. replace rid=2 if regioncode=="ECA"
	. replace rid=3 if regioncode=="MNA"
	. replace rid=4 if regioncode=="LAC"
	. replace rid=5 if regioncode=="EAP"
	. replace rid=6 if regioncode=="SAS"
	. replace rid=7 if regioncode=="SSA"
	. replace rid=8 if regioncode=="WLD"
	. keep requestyear rid poorpop
	. reshape wide poorpop,i(requestyear) j(rid)
	. foreach i of numlist 2(1)7{
	. 	egen poorpopacc`i'=rowtotal(poorpop1 - poorpop`i')
	. }
	. twoway (area poorpop1 requestyear) ///
	. 	(rarea poorpopacc2 poorpop1 requestyear) ///
	. 	(rarea poorpopacc3 poorpopacc2 requestyear) ///
	. 	(rarea poorpopacc4 poorpopacc3 requestyear) ///
	. 	(rarea poorpopacc5 poorpopacc4 requestyear) ///
	. 	(rarea poorpopacc6 poorpopacc5 requestyear) ///
	. 	(rarea poorpopacc7 poorpopacc6 requestyear) ///
	. 	(line poorpopacc7 requestyear, lwidth(midthick) lcolor(gs0)), ///
	. 	ytitle("Millions of Poor" " ", size(small))  ///
	. 	xtitle(" " "", size(small))  ///
	. 	graphregion(c(white)) ysize(7) xsize(8)  ///
	. 	ylabel(,labs(small) nogrid angle(verticle)) xlabel(,labs(small)) ///
	. 	legend(order( ///
	. 	1 "Rest of the World"  ///
	. 	2 "Europe & Central Asia"  ///
	. 	3 "Middle East & North Africa" ///
	. 	4 "Latin America & Caribbean" ///
	. 	5 "East Asia & the Pacific" ///
	. 	6 "South Asia" ///
	. 	7 "Sub-Saharan Africa" /// 
	. 	8 "World") si(vsmall)) 
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


{marker howtocite}{...}
{title:Thanks for citing {cmd:povcalnet} as follows}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}

{p 8 12 2}XXX (2018) "povcalnet: Stata module to access World Bank’s Global Poverty and Inequality data," Statistical Software Components YYYY, Boston College Department of Economics. http://ideas.repec.org/c/boc/bocode/ZZZZZ.html {p_end}


{marker references}{...}
{title:References}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}

    {p 8 12 2}XXX (2018) "How to use PovcalNet from Stata", Global Poverty Monitoring Technical Note 7, World Bank. [NEED TO ADD HYPERLINK]{p_end}

	
	
{marker regions}{...}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}
{title:Region Codes}

{synoptset 33 tabbed}{...}
{synopthdr: Regions}
{col 6}{hline 70}
{synopt:{opt  EAP }} East Asia and Pacific{p_end}
{synopt:{opt  ECA }} Europe and Central Asia{p_end}
{synopt:{opt  HIC }} Other High Income{p_end}
{synopt:{opt  LAC }} Latin America and the Caribbean{p_end}
{synopt:{opt  MNA }} Middle East and North Africa{p_end}
{synopt:{opt  SAS }} South Asia{p_end}
{synopt:{opt  SSA }} Sub-Saharan Africa{p_end}
{col 6}{hline 70}
{p 6 6 0 76}{err:Note}: {it:Other High Income} includes the advanced economies; 
all other economies are included in geographic regions, as defined by the World Bank.{p_end}


	
{marker countries}{...}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}
{title:Country and Economy Acronyms}

{synoptset 33 tabbed}{...}
{synopthdr: Country/Economy}
{synoptline}
{synopt:{opt  ALB }} Albania{p_end}
{synopt:{opt  DZA }} Algeria{p_end}
{synopt:{opt  AGO }} Angola{p_end}
{synopt:{opt  ARG }} Argentina{p_end}
{synopt:{opt  ARM }} Armenia{p_end}
{synopt:{opt  AUS }} Australia{p_end}
{synopt:{opt  AUT }} Austria{p_end}
{synopt:{opt  AZE }} Azerbaijan{p_end}
{synopt:{opt  BGD }} Bangladesh{p_end}
{synopt:{opt  BLR }} Belarus{p_end}
{synopt:{opt  BEL }} Belgium{p_end}
{synopt:{opt  BLZ }} Belize{p_end}
{synopt:{opt  BEN }} Benin{p_end}
{synopt:{opt  BTN }} Bhutan{p_end}
{synopt:{opt  BOL }} Bolivia{p_end}
{synopt:{opt  BIH }} Bosnia and Herzegovina{p_end}
{synopt:{opt  BWA }} Botswana{p_end}
{synopt:{opt  BRA }} Brazil{p_end}
{synopt:{opt  BGR }} Bulgaria{p_end}
{synopt:{opt  BFA }} Burkina Faso{p_end}
{synopt:{opt  BDI }} Burundi{p_end}
{synopt:{opt  CPV }} Cabo Verde{p_end}
{synopt:{opt  CMR }} Cameroon{p_end}
{synopt:{opt  CAN }} Canada{p_end}
{synopt:{opt  CAF }} Central African Republic{p_end}
{synopt:{opt  TCD }} Chad{p_end}
{synopt:{opt  CHL }} Chile{p_end}
{synopt:{opt  CHN }} China{p_end}
{synopt:{opt  COL }} Colombia{p_end}
{synopt:{opt  COM }} Comoros{p_end}
{synopt:{opt  ZAR }} Congo, Democratic Republic of{p_end}
{synopt:{opt  COG }} Congo, Republic of{p_end}
{synopt:{opt  CRI }} Costa Rica{p_end}
{synopt:{opt  CIV }} Cote d'Ivoire{p_end}
{synopt:{opt  HRV }} Croatia{p_end}
{synopt:{opt  CYP }} Cyprus{p_end}
{synopt:{opt  CZE }} Czech Republic{p_end}
{synopt:{opt  DNK }} Denmark{p_end}
{synopt:{opt  DJI }} Djibouti{p_end}
{synopt:{opt  DOM }} Dominican Republic{p_end}
{synopt:{opt  ECU }} Ecuador{p_end}
{synopt:{opt  EGY }} Egypt, Arab Republic of{p_end}
{synopt:{opt  SLV }} El Salvador{p_end}
{synopt:{opt  EST }} Estonia{p_end}
{synopt:{opt  SWZ }} Eswatini{p_end}
{synopt:{opt  ETH }} Ethiopia{p_end}
{synopt:{opt  FJI }} Fiji{p_end}
{synopt:{opt  FIN }} Finland{p_end}
{synopt:{opt  FRA }} France{p_end}
{synopt:{opt  GAB }} Gabon{p_end}
{synopt:{opt  GMB }} Gambia, The{p_end}
{synopt:{opt  GEO }} Georgia{p_end}
{synopt:{opt  DEU }} Germany{p_end}
{synopt:{opt  GHA }} Ghana{p_end}
{synopt:{opt  GRC }} Greece{p_end}
{synopt:{opt  GTM }} Guatemala{p_end}
{synopt:{opt  GIN }} Guinea{p_end}
{synopt:{opt  GNB }} Guinea-Bissau{p_end}
{synopt:{opt  GUY }} Guyana{p_end}
{synopt:{opt  HTI }} Haiti{p_end}
{synopt:{opt  HND }} Honduras{p_end}
{synopt:{opt  HUN }} Hungary{p_end}
{synopt:{opt  ISL }} Iceland{p_end}
{synopt:{opt  IND }} India{p_end}
{synopt:{opt  IDN }} Indonesia{p_end}
{synopt:{opt  IRN }} Iran, Islamic Republic of{p_end}
{synopt:{opt  IRQ }} Iraq{p_end}
{synopt:{opt  IRL }} Ireland{p_end}
{synopt:{opt  ISR }} Israel{p_end}
{synopt:{opt  ITA }} Italy{p_end}
{synopt:{opt  JAM }} Jamaica{p_end}
{synopt:{opt  JPN }} Japan{p_end}
{synopt:{opt  JOR }} Jordan{p_end}
{synopt:{opt  KAZ }} Kazakhstan{p_end}
{synopt:{opt  KEN }} Kenya{p_end}
{synopt:{opt  KIR }} Kiribati{p_end}
{synopt:{opt  KOR }} Korea, Republic of{p_end}
{synopt:{opt  KSV }} Kosovo{p_end}
{synopt:{opt  KGZ }} Kyrgyz Republic{p_end}
{synopt:{opt  LAO }} Lao People's Democratic Republic{p_end}
{synopt:{opt  LVA }} Latvia{p_end}
{synopt:{opt  LBN }} Lebanon{p_end}
{synopt:{opt  LSO }} Lesotho{p_end}
{synopt:{opt  LBR }} Liberia{p_end}
{synopt:{opt  LTU }} Lithuania{p_end}
{synopt:{opt  LUX }} Luxembourg{p_end}
{synopt:{opt  MKD }} Macedonia, former Yugoslav Republic of{p_end}
{synopt:{opt  MDG }} Madagascar{p_end}
{synopt:{opt  MWI }} Malawi{p_end}
{synopt:{opt  MYS }} Malaysia{p_end}
{synopt:{opt  MDV }} Maldives{p_end}
{synopt:{opt  MLI }} Mali{p_end}
{synopt:{opt  MLT }} Malta{p_end}
{synopt:{opt  MRT }} Mauritania{p_end}
{synopt:{opt  MUS }} Mauritius{p_end}
{synopt:{opt  MEX }} Mexico{p_end}
{synopt:{opt  FSM }} Micronesia, Federated States of{p_end}
{synopt:{opt  MDA }} Moldova{p_end}
{synopt:{opt  MNG }} Mongolia{p_end}
{synopt:{opt  MNE }} Montenegro{p_end}
{synopt:{opt  MAR }} Morocco{p_end}
{synopt:{opt  MOZ }} Mozambique{p_end}
{synopt:{opt  MMR }} Myanmar{p_end}
{synopt:{opt  NAM }} Namibia{p_end}
{synopt:{opt  NPL }} Nepal{p_end}
{synopt:{opt  NLD }} Netherlands{p_end}
{synopt:{opt  NIC }} Nicaragua{p_end}
{synopt:{opt  NER }} Niger{p_end}
{synopt:{opt  NGA }} Nigeria{p_end}
{synopt:{opt  NOR }} Norway{p_end}
{synopt:{opt  PAK }} Pakistan{p_end}
{synopt:{opt  PAN }} Panama{p_end}
{synopt:{opt  PNG }} Papua New Guinea{p_end}
{synopt:{opt  PRY }} Paraguay{p_end}
{synopt:{opt  PER }} Peru{p_end}
{synopt:{opt  PHL }} Philippines{p_end}
{synopt:{opt  POL }} Poland{p_end}
{synopt:{opt  PRT }} Portugal{p_end}
{synopt:{opt  ROU }} Romania{p_end}
{synopt:{opt  RUS }} Russian Federation{p_end}
{synopt:{opt  RWA }} Rwanda{p_end}
{synopt:{opt  WSM }} Samoa{p_end}
{synopt:{opt  STP }} Sao Tome and Principe{p_end}
{synopt:{opt  SEN }} Senegal{p_end}
{synopt:{opt  SRB }} Serbia{p_end}
{synopt:{opt  SYC }} Seychelles{p_end}
{synopt:{opt  SLE }} Sierra Leone{p_end}
{synopt:{opt  SVK }} Slovak Republic{p_end}
{synopt:{opt  SVN }} Slovenia{p_end}
{synopt:{opt  SLB }} Solomon Islands{p_end}
{synopt:{opt  ZAF }} South Africa{p_end}
{synopt:{opt  SSD }} South Sudan{p_end}
{synopt:{opt  ESP }} Spain{p_end}
{synopt:{opt  LKA }} Sri Lanka{p_end}
{synopt:{opt  LCA }} St. Lucia{p_end}
{synopt:{opt  SDN }} Sudan{p_end}
{synopt:{opt  SUR }} Suriname{p_end}
{synopt:{opt  SWE }} Sweden{p_end}
{synopt:{opt  CHE }} Switzerland{p_end}
{synopt:{opt  SYR }} Syrian Arab Republic{p_end}
{synopt:{opt  TJK }} Tajikistan{p_end}
{synopt:{opt  TZA }} Tanzania{p_end}
{synopt:{opt  THA }} Thailand{p_end}
{synopt:{opt  TMP }} Timor-Leste{p_end}
{synopt:{opt  TGO }} Togo{p_end}
{synopt:{opt  TON }} Tonga{p_end}
{synopt:{opt  TTO }} Trinidad and Tobago{p_end}
{synopt:{opt  TUN }} Tunisia{p_end}
{synopt:{opt  TUR }} Turkey{p_end}
{synopt:{opt  TKM }} Turkmenistan{p_end}
{synopt:{opt  TUV }} Tuvalu{p_end}
{synopt:{opt  UGA }} Uganda{p_end}
{synopt:{opt  UKR }} Ukraine{p_end}
{synopt:{opt  GBR }} United Kingdom{p_end}
{synopt:{opt  USA }} United States{p_end}
{synopt:{opt  URY }} Uruguay{p_end}
{synopt:{opt  UZB }} Uzbekistan{p_end}
{synopt:{opt  VUT }} Vanuatu{p_end}
{synopt:{opt  VEN }} Venezuela, Republica Bolivariana de{p_end}
{synopt:{opt  VNM }} Vietnam{p_end}
{synopt:{opt  WBG }} West Bank and Gaza{p_end}
{synopt:{opt  YEM }} Yemen, Republic of{p_end}
{synopt:{opt  ZMB }} Zambia{p_end}
{synopt:{opt  ZWE }} Zimbabwe{p_end}

{marker acknowled}{...}
{title:Acknowledgements}
{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}

{p 4 4 2}The authors would like to thank R. Andres Castaneda Aguilar, Kihoon Lee and Minh Cong Nguyen for comments received on earlier versions of this code.{p_end}
{p 4 4 2}In developing this code, we closely followed the example of wbopendata developed by Joao Pedro Azevedo. {p_end} 


{p 40 20 2}(Go up to {it:{help povcalnet##sections:Sections Menu}}){p_end}
{marker authors}{...}
{title:Authors}
	{p 4 4 2}Christoph Lakner, Espen Beer Prydz, Jorge Soler Lopez, Ruoxuan Wu, Qinghua Zhao{p_end}
	{p 4 4 2}Any questions or suggestions for improvements should be directed to Data at worldbank.org{p_end}

{title:contributor}
{p 4 4 4}R.Andres Castaneda, The World Bank{p_end}
{p 6 6 4}Email: {browse "acastanedaa@worldbank.org":  acastanedaa@worldbank.org}{p_end}
{p 6 6 4}GitHub:{browse "https://github.com/randrescastaneda": randrescastaneda }{p_end}

{title:contact}
{phang}
Any comment, suggestion, or bug can be reported in the 
{browse "https://github.com/worldbank/povcalnet/issues" :GitHub issues page}.
All the files are avaialble in the {browse "https://github.com/worldbank/povcalnet": GitHub repository}
	
{title:Also see}
{psee}
Online:  {help wbopendata}  (if installed)
{p_end}
