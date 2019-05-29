*********************************************************************************
* povcalnet_info                                                          		*
*! v1.0  		sept2018               by 	Jorge Soler Lopez					*
*											Espen Beer Prydz					*
*											Christoph Lakner					*
*											Ruoxuan Wu							*
*											Qinghua Zhao						*
*											World Bank Group					*
*********************************************************************************


program def povcalnet_info, rclass

version 9.0

    syntax                                  ///
                 [,                         ///
                        COUntry(string)    ///
						REGion				///
						AGGregate			///
                 ]	
				 
				 
				 
capture { 
	***************************************************
	* 1. Will load guidance database
	***************************************************
	local clear = "clear"
	capture {
		tempfile temp1000
		cap: copy "http://iresearch.worldbank.org/PovcalNet/js/initCItem2014.js" `temp1000'
		local rccopy = _rc
		cap : import delim using `temp1000',  `clear' delim(",()") stringc(_all) stripq(yes) varnames(nonames)
		local rcclear = _rc
		drop if v2==""
		drop v1
		ren v2 code
		gen countrycode=substr(code,1,3)
		drop v14
		drop v15
		ren v3 regioncode
		ren v4 uncode
		ren v5 inc
		ren v6 countryname
		ren v7 coverage
		ren v9 povline
		ren v10 ppp
		ren v12 pppimp
		ren v13 years
		drop v*
		generate coveragename = ""
		replace coveragename = "--Rural" if coverage == "R"
		replace coveragename = "--Urban" if coverage == "U"
		replace coveragename = "--National Aggregate" if coverage == "A"
	}
	
	if (`rccopy' != 0) { //Use cache if error
		cap:findfile _initCItem2014.dta
		local file `"`r(fn)'"'
		local wd : environment HOME
		if strpos(`"`file'"', "~") == 1 & !missing(`"`wd'"') {
			local file : subinstr local file"~" "`wd'"
        }
		cap: use `"`file'"', `clear'
		noi di  as result "Guidance file couldn't be updated, using local one."
		noi di  as result "Last version saved: `_dta[note1]'"
	}
	
	
	if (`rcclear' != 0) {
		noi di ""
		di  as err "You must start with an empty dataset; or enable the clear option."
		noi di ""
		exit `rcclear'
		noi di ""
		break
	}
	
	***************************************************
	* 2. Inital listing with countries and regions
	***************************************************
	
	qui cap generate codecoverage = countrycode + " (" + coverage+")"	
	
	if  ("`country'" == "") & ("`region'" == "") {
		qui{
			noi disp in y  _n "{title:Available Surveys}" 
			noi disp in y  _n "{title:Select a country or region}" 
	
			noi disp in y  _n "{title: Countries}"  
			
			quietly levelsof countrycode /*if regioncode == "`i_reg'"*/, local(countries) 
			local current_line = 0
			foreach cccc of local countries{
				local current_line = `current_line' + 1 
				local display_this = "{stata povcalnet_info, country(`cccc'): `cccc'} "
				if (`current_line' < 10) noi display in y `"`display_this'"' _continue 
				else{
					noi display in y `"`display_this'"' 
					local current_line = 0
				}
			}
			
			noi disp in y  _n "{title: Regions}"  
			noi display in y "{stata povcalnet_info, region: World Bank regions}"		
			noi display _n ""
			exit
			break
		}
	}

	***************************************************
	* 3. Listing of country surveys
	***************************************************
	
	if  ("`country'" != "") & ("`region'" == "") {
		qui{
			noi disp in y  _n "{title:Available Surveys for `country'}" 	
			preserve
			keep if countrycode == "`country'" | countrycode == upper("`country'")
			local link_detail = "http://iresearch.worldbank.org/PovcalNet/Docs/CountryDocs/`country'.htm"
			noi display `"{browse "`link_detail'" : Detailed information (browser)}"'
			quietly levelsof codecoverage , local(codecoverages)
			local current_line = 0
			local index_s = 1
			foreach i_surv of local codecoverages{
				noi disp in y  _n "`=countryname[`index_s']'`=coveragename[`index_s']'" 	
				local years_current = "`=years[`index_s']'"
				local coesp = "`=code[`index_s']'"
				local years_current: subinstr local years_current "," " ", all 
				local index_s = `index_s'+ 1 
				foreach ind_y of local years_current{
					local current_line = `current_line' + 1 
					local ind_y_c=substr("`ind_y'",1,4)
					local display_this = "{stata  povcalnet, country(`country') year(`ind_y_c') coesp(`coesp')   clear: `ind_y_c'}"		
					if (`current_line' < 10) noi display in y `"`display_this'"' _continue 
					else{
						noi display in y `"`display_this'"' 
						local current_line = 0		
					}
				}	
				noi display `"{stata  povcalnet, country(`country') year(all) coesp(`coesp')  clear: All}"'
			}
			restore
			noi display _n ""
			exit
			break
		}
	}	
	
	***************************************************
	* 4. Listing of regions
	***************************************************
	if  ("`country'" == "") & ("`region'" != "") {
		qui{
			noi disp in y  _n "{title:Available Surveys}" 
			noi disp in y  _n "{title:Select a Year}" 	
	
			quietly levelsof regioncode, local(regions)
			
			foreach i_reg of local regions{
				local current_line = 0
				noi disp in y  _n "`i_reg'" 
				local years_current = "$refyears"
				foreach ind_y of local years_current{
					local current_line = `current_line' + 1 
					local display_this = "{stata  povcalnet, region(`i_reg') year(`ind_y') aggregate clear: `ind_y'}"		
					if (`current_line' < 10) noi display in y `"`display_this'"' _continue 
					else{
						noi display in y `"`display_this'"' 
						local current_line = 0		
					}
				}
				noi display in y "{stata  povcalnet, region(`i_reg') year(all) aggregate clear: All}"				
			}
			noi display _n ""
			exit
			break
		}
	}
			
end	
