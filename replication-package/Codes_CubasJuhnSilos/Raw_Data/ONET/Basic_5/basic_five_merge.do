/* merge 5 basic characteristics into .dta format*/
clear

set more off

forvalues i=1/5{
import delimited "./`i'-5.txt", delimiters(tab) varnames(1) asdouble
destring soc,replace
destring onet_ch_`i',replace 
save "./`i'.dta",replace
clear
}

** merge all characteristics by soc. 
use "./1.dta"
forval i=2/5{

merge 1:1 soc using "./`i'.dta"
drop _merge 

}
save "../../../Stata_Raw_Data/basic_five_merged.dta", replace

forvalues i=1/5{
erase "./`i'.dta"
}


