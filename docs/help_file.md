## [Home](index.md) --- [Get Started](get_started.md) --- [Visualizations examples](vis.md) --- [Help file](help_file.md) 

          Title

                  povcalnet --   Access World Bank Global Poverty and Inequality measures.
          Syntax

                povcalnet [subcommand], [Parameters Options]


              Parameters                   Description
              ------------------------------------------------------------------------------------------
                country(3-letter code)     list of country code (accepts multiples) or all.  Cannot be
                                             used with option region()
                region(WB code)            list of region code (accepts multiple) or all.  Cannot be
                                             used with option country()
                year(numlist|string)       list of years (accepts up to 10), or all, or last. Default
                                             "all".
                povline(#)                 list of poverty lines (in 2011 PPP-adjusted USD) to calculate
                                             poverty measures (accepts up to 5). Default is 1.9.

              Options                      Description
              ------------------------------------------------------------------------------------------
                clear                       replace data in memory.
                aggregate                   calculates poverty measures for regions or user-specified
                                             groups of countries instead of country-level estimated.
                coverage(string)            loads coverage level ("national", "urban", "rural", "all").
                                             Default "all".
                fillgaps                    loads all countries used to create regional aggregates.
                information                 presents a clickable version of the available surveys,
                                             countries and regions.
                iso                         uses ISO3 for country/economy codes in the output.
                ppp(#)                      allows the selection of PPP.

              subcommands                  Description
              ------------------------------------------------------------------------------------------
                information                presents a clickable version of the available surveys,
                                             countries and regions. Same as option information
                cl                         parses the parameters of the query in a one-on-one
                                             correspondence instead of the default combinational query.
                                             See below for a detailed explanation.  See below for a
                                             detailed explanation.
                wb                         downloads World Bank's regional and global aggegation
                test                       executes the last query in browser regardless of failure by
                                             povcalnet.
              ------------------------------------------------------------------------------------------

              Note: povcalnet requires internet connection.

          Sections

              Sections are presented under the following headings:

                          Command description
                          Parameters description
                          Options description
                          Subcommands
                          Stored results
                          Examples
                          Disclaimer
                          References
                          Acknowledgements
                          Authors
                          Contact
                          How to cite
                          Region and country codes

                                                  (Go up to Sections Menu)
          Description

              The povcalnet commands allows Stata users to compute poverty and inequality indicators for
              more than 160 countries and regions in the World Bank's database of household surveys. It
              has the same functionality as the PovcalNet website. PovcalNet is a computational tool
              that allows users to estimate poverty rates for regions, sets of countries or individual
              countries, over time and at any poverty line.

              PovcalNet is managed jointly by the Data and Research Group in the World Bank's
              Development Economics Division. It draws heavily upon a strong collaboration with the
              Poverty and Equity Global Practice, which is responsible for the gathering and
              harmonization of the underlying survey data.

              In addition to the mean and median, povcalnet reports the following measures for poverty
              (at achosen poverty line) and inequality:

                          -------------------------------------------
                          Poverty measures       Inequality measures
                          --------------------   --------------------
                          Headcount ratio        Gini index
                          Poverty gap            Mean log deviations
                          Poverty severity       Decile shares
                          Watts index            
                          -------------------------------------------

              The underlying welfare aggregate is per capita household income or consumption expressed
              in 2011 PPP-adjusted USD. Poverty lines are expressed in daily amounts, while means and
              medians are monthly. For more information on the definition of the indicators,  click
              here.  For more information on the methodology, click here

          Type of calculations:

              The PovcalNet API allows two types of calculations:

              Survey-year: Will load poverty measures for a reference year that is common across
                  countries. Regional and global aggregates are calculated only for reference-years.
                  Countries without a survey in the

              reference-year: are extrapolated or interpolated using national accounts growth rates, and
                  assuming distribution-neutrality.  povcalnet wb returns the global and regional
                  poverty aggregates used by the World Bank.

                  Important: Choosing option aggregate displays (population-weighted) averages for the
                  specified group of countries. Option fillgaps reports the underlying lined-up country
                  estimates for a reference-year. Poverty measures calculated for both survey-years and
                  reference-years include Headcount ratio, Poverty Gap, Squared Poverty Gap.  Inequality
                  measures, including the Gini index, mean log deviation and decile shares, are
                  calculated only in survey-years where micro data is available. Inequality measures are
                  not reported for reference-years.


          Combinatorial and one-on-one queries:

              Be default, povcalnet creates a combinatorial query of the parameters selected, so that
              the output contains all the possible combinations between country(), povline(), year(),
              and coverage(). Option ppp() is not part of the combinatorial query. Alternatively, the
              user may select the subcommand cl to parse a one-on-one (i.e., country by country)
              request. In this case, the first country listed in country() will be combined with the
              first year in year(), the first poverty lines in povline(), the first coverage area in
              coverage(), and similarly for subsequent elements in the parameter country(). If only one
              element is added to parameters povline(), year(), or coverage(), it would be applied to
              all the elements in the parameter countr(). caution: if only one element is added to
              option ppp(), it would be applied to all the countries listed in country().

                                                  (Go up to Sections Menu)
          Parameters description

              country(string)Countries and Economies Abbreviations.  If specified with year(string),
                  this option will return all the specific countries and years for which there is actual
                  survey data.  When selecting multiple countries, use the corresponding three-letter
                  codes separated by spaces. The option all is a shorthand for calling all countries.

              region(string)Regions Abbreviations If specified with year(string), this option will
                  return all the specific countries and years that belong to the specified region(s).
                  For example, region(LAC) will return all countries in Latin America and the Caribbean
                  for which there's an actual survey in the given years.  When selecting multiple
                  regions, use the corresponding three-letter codes separated by spaces. The option all
                  is a shorthand for calling all regions, which is equivalent to calling all countries.

              year(#) Four digit years are accepted. When selecting multiple years, use spaced to
                  separate them. The option all is a shorthand for calling all possible years, while the
                  last option will download the latest available year for each country.

              povline(#) The poverty lines for which the poverty measures will be calculated.  When
                  selecting multiple poverty lines, use less than 4 decimals and separate each value
                  with spaces. If left empty, the default poverty line of $1.9 is used.  Poverty lines
                  are expressed in 2011 PPP-adjusted USD per capita per day.

                                                  (Go up to Sections Menu)
          Options description

              aggregate Will calculate the aggregated poverty measures for the given set of countries or
                  regions.

                  Note 1: If option country(all) is combined with option aggregate, povcalnet executes
                  instead povcalnet wb, which returns the default global aggregates used by the World
                  Bank as explained in more detail below. In contrast, to aggregate all countries in a
                  particular reference year, users need to list them all in the country() option. One
                  way to do so is as follows:

                          . povcalnet info, clear
                          . levelsof country_code, local(all) clean 
                          . povcalnet, country(`all') year(2015) clear  aggregate

                  Note 2: Aggregation can only be done for the reference years (As of Sep 2018: 1981,
                  1984, 1987, 1990, 1993, 1996, 1999, 2002, 2005, 2008, 2010, 2011, 2012, 2013 and
                  2015). Using the option last or all, povcalnet loads the most up-to-date year(s).

              fillgaps Loads all country-level estimates that are used to create the aggregates in the
                  reference years. This means that estimates use the same reference years as aggregate
                  estimates.

                  Note: Countries without a survey in the reference-year have been extrapolated or
                  interpolated using national accounts growth rates and assuming distribution-neutrality
                  (see Chapter 6 here).  Therefore, changes at the country-level from one reference year
                  to the next need to be interpreted carefully and may not be the result of a new
                  household survey.

              iso Uses ISO3 for country/economy codes in output. However, users still need to use
                  Countries and Economies Abbreviations when calling the command (i.e. option
                  country()).

              PPP(#) Allows the selection of PPP exchange rate. This option only works if one, and only
                  one, country is selected.

              coverage(string) Selects coverage level of estimates. By default, all coverage levels are
                  loaded, but the user may select "national", "urban", or "rural".  Only one level of
                  covarege can be selected per query.

              information Presents a clickable version of the available surveys, countries and regions.
                  Selecting countries from the menu loads the survey-year estimates.  Choosing regions
                  loads the regional aggregates in the reference years.

                  Note: If option clear is added, data in memory is replaced with a PovcalNet guidance
                  database. If option clear is not included, povcalnet preserves data in memory but
                  displays a clickable interface of survey availability in the results window.

              clear replaces data in memory.

                                                  (Go up to Sections Menu)
          Subcommands

              info Same as option info above.

              cl Changes combinatorial query of parameters for one-on-one correspondence of parameters.
                  See above for a detailed explanation.

              wb Downloads World Bank's regional and global aggregation. These functions differ from
                  option aggregate in two ways: [1] wb uses a predefined set of countries in each
                  region, whereas option aggregate allows users to select their own set of countries for
                  aggregation. [2] The World Bank aggregation (queried by the wb subcommand) assumes
                  that the poverty rate for an economy without a household survey is the regional
                  average. This creates differences in two types of estimates: [a] When a region
                  includes countries without a household survey, the number of poor is different between
                  the two methods even when users query the same set of countries. The number of poor
                  according to the World Bank method is obtained as the product of the region’s
                  headcount index and the total regional population (which includes the population of
                  countries without any household survey). In contrast, when using aggregate, the number
                  of poor is the product of the region’s headcount index and the total population of the
                  economies included in the aggregation. [b] In computing the poverty estimates for the
                  world, the World Bank aggregation takes the population-weighted average of the
                  regional estimates. Each region is weighted using the total regional population,
                  including the population of countries without any household survey.  Countries without
                  a survey are thus implicitly assigned the regional poverty rate. In contrast, when
                  using the option aggregate, only countries with a survey are considered (which are
                  then weighted by their population).

              test Executes the last query in browser regardless of failure by povcalnet. It makes use
                  of the global "${pcn_query}".


          Stored results

              povcalnet stores the following in r(). Suffix _# refers to the number of poverty lines
              included in povlines():

              queries        
                r(query_ys_#)              Years
                r(query_pl_#)              Poverty lines
                r(query_ct_#)              Countries and coverages
                r(query_ds_#)              Whether aggregation was used
                r(query_#)                 concatenation of the queries above

              API parts      
                r(server)                  Protocol (http://) and server name
                r(site_name)               Site names
                r(handler)                 Action handler
                r(base)                    concatenation of server, site_name, and handler

              addtional info 
                r(queryfull_#)             Complete query
                r(npl)                     Number of poverty lines
                pcn_query                  Global macro with query information in case povcalnet fails.
                                             "${pcn_query}" to display

          Examples
                                                  (Go up to Sections Menu)

                  +--------------------+
              ----+  1. Basic examples +----------------------------------------------------------------

              1.1. Load latest available survey-year estimates for Colombia and Argentina

                  povcalnet, country(col arg) year(last) clear

              1.2. Load clickable menu

                  povcalnet, info

              1.3. Load only urban coverage level

                  povcalnet, country(all) coverage("urban") clear


                  +----------------------------------------------------+
              ----+  2. inIllustration of differences between queries  +--------------------------------

              2.1. Country estimation at $1.9 in 2015. Since there are no surveys in ARG and IND in
                  2015, results are loaded for COL and BRA

                  povcalnet, country(COL BRA ARG IND) year(2015) clear

              2.2. fill-gaps. Filling gaps for ARG and IND. Only works for reference years.

                  povcalnet, country(COL BRA ARG IND) year(2015) clear fillgaps

              2.3. Estimate aggregates over the economies listed in country().

                  povcalnet, country(COL BRA ARG IND) year(2015) clear aggregate

              2.4. World Bank aggregation (country() is not avialable)

                  povcalnet wb, clear year(2015)
                  povcalnet wb, clear region(SAR LAC)
                  povcalnet wb, clear // all reference years

              2.5. One-on-one query.

                  povcalnet cl, country(COL BRA ARG IND) year(2011) clear coverage("national national
                      urban national")

                  +-------------------------------------------------+
              ----+  3. Samples uniquely identified by country/year +-----------------------------------

                  3.1 National coverage (when available) and longest possible time series for each
                      country, even if welfare type changes from one year to another.


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

                (click to run)

                  3.2 National coverage (when available) and longest possible time series for each
                      country, restrict to same welfare type throughout.


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

                (click to run)

                  +-------------------------+
              ----+  4. Analytical examples +-----------------------------------------------------------

                  4.1 Graph of trend in poverty headcount ratio and number of poor for the world


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
                  
                (click to run)

                  4.2 Graph of trends in poverty headcount ratio by region, multiple poverty lines
                      ($1.9, $3.2, $5.5)


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
                  .               note("Source: PovcalNet", si(vsmall)) graphregion(c(white))) ///
                  .        xlab(1990(5)2015 , labsi(vsmall)) xti("Year", si(vsmall))     ///
                  .        ylab(0(25)100, labsi(vsmall) angle(0))                        ///
                  .        yti("Poverty headcount (%)", si(vsmall))                      ///
                  .        leg(order(1 "$1.9" 2 "$3.2" 3 "$5.5") r(1) si(vsmall))        ///
                  .        sub(, si(small))       scheme(s2color)
                (click to run)

                  4.3 Millions of poor by region


                  . povcalnet wb, clear
                  . keep if year > 1989
                  . gen poorpop = headcount * population 
                  . gen hcpercent = round(headcount*100, 0.1) 
                  . gen poorpopround = round(poorpop, 1)
                  . encode region, gen(rid)

                  . levelsof rid, local(regions)
                  . foreach region of local regions {
                  .       local legend = `"`legend' `region' "`: label rid `region''" "' 
                  . }

                  . keep year rid poorpop
                  . reshape wide poorpop,i(year) j(rid)
                  . foreach i of numlist 2(1)7{
                  .       egen poorpopacc`i'=rowtotal(poorpop1 - poorpop`i')
                  . }

                  . twoway (area poorpop1 year)                              ///
                  .       (rarea poorpopacc2 poorpop1 year)                      ///
                  .       (rarea poorpopacc3 poorpopacc2 year)                   ///
                  .       (rarea poorpopacc4 poorpopacc3 year)                   ///
                  .       (rarea poorpopacc5 poorpopacc4 year)                   ///
                  .       (rarea poorpopacc6 poorpopacc5 year)                   ///
                  .       (rarea poorpopacc7 poorpopacc6 year)                   ///
                  .       (line poorpopacc7 year, lwidth(midthick) lcolor(gs0)), ///
                  .       ytitle("Millions of Poor" " ", size(small))            ///
                  .       xtitle(" " "", size(small)) scheme(s2color)            ///
                  .       graphregion(c(white)) ysize(7) xsize(8)                ///
                  .       ylabel(,labs(small) nogrid angle(verticle)) xlabel(,labs(small)) ///
                  .       legend(order(`legend') si(vsmall))
                (click to run)

                  4.4 Graph of population distribution across income categories in Latin America, by
                      country


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
                  .       blab(bar, pos(center) format(%3.1f) si(tiny))                     /// 
                  .       ti("`title'", si(small)) note("`note'", si(*.7))                  ///
                  .       graphregion(c(white)) ysize(6) xsize(6.5)                         ///
                  .               legend(si(vsmall) r(3))  yti("`yti'", si(small))                ///
                  .       ylab(,labs(small) nogrid angle(0)) scheme(s2color)
                (click to run)



          Disclaimer
                                                  (Go up to Sections Menu)

              PovcalNet was developed for the sole purpose of public replication of the World Bank’s
              poverty measures for its widely used international poverty lines, including $1.90 a day
              and $3.20 a day in 2011 PPP.  The methods built into PovcalNet are considered reliable for
              that purpose.
              However, we cannot be confident that the methods work well for other purposes, including
              tracing out the entire distribution of income.  We would especially warn that estimates of
              the densities near the bottom and top tails of the distribution could be quite unreliable,
              and no attempt has been made by the World Bank’s staff to validate the tool for such
              purposes.
              The term country, used interchangeably with economy, does not imply political independence
              but refers to any territory for which authorities report separate social or economic
              statistics.

          References
                                                  (Go up to Sections Menu)

              Castaneda Aguilar, R. A., C. Lakner, J. S. Lopez, E. B. Prydz, R. Wu and Q. Zhao (2018)
                  "Estimating Global Poverty in Stata: The povcalnet command", Global Poverty Monitoring
                  Technical Note 107, World Bank. [NEED TO ADD HYPERLINK]

          Acknowledgements
                                                  (Go up to Sections Menu)

              The authors would like to thank Tony Fujs, Dean Jolliffe, Aart Kraay, Kihoon Lee, Daniel
              Mahler and , Minh Cong Nguyen and Marco Ranaldi, as well as seminar participants at the
              World Bank, for comments received on earlier versions of this code. In developing this
              code, we closely followed the example of wbopendata developed by Joao Pedro Azevedo.

                                                  (Go up to Sections Menu)
          Authors
              R.Andres Castaneda, Christoph Lakner, Espen Beer Prydz, Jorge Soler Lopez, Ruoxuan Wu,
              Qinghua Zhao

          maintainer
              R.Andres Castaneda, The World Bank
                Email:  acastanedaa@worldbank.org
                GitHub: randrescastaneda

          contact
              Any comments, suggestions, or bugs can be reported in the GitHub issues page.  All the
              files are available in the GitHub repository

          Thanks for citing povcalnet as follows
                                                  (Go up to Sections Menu)

              Castaneda Aguilar, R. A., C. Lakner, J. S. Lopez, E. B. Prydz, R. Wu and Q. Zhao (2019)
                  "povcalnet: Stata module to access World Bank’s Global Poverty and Inequality data,"
                  Statistical Software Components YYYY, Boston College Department of Economics.
                  http://ideas.repec.org/c/boc/bocode/ZZZZZ.html

              Please make reference to the date when the database was downloaded, as statistics may
              change
