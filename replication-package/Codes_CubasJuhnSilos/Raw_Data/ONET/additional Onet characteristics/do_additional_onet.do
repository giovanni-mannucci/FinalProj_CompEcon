* Directly download the 10 ONET characteristics from the ONET website and then 
* merge into dataset 
clear
forval i=6/21{
import delimited "./`i'.txt", delimiters(tab) varnames(1) asdouble
destring soc,replace
destring onet_ch_`i',replace 
save "./`i'.dta", replace
clear
}




** merge all characteristics by soc. 
use "./6.dta"
forval i=7/21{
merge 1:1 soc using "./`i'.dta"
drop _merge 

}

 


save "../../../Stata_Raw_Data/onet_merged_char_additional.dta",replace 


forval i=6/21{
erase "./`i'.dta"
}
