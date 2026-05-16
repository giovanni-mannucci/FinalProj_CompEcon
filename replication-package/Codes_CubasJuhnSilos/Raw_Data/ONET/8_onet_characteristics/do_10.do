* Directly download the 10 ONET characteristics from the ONET website and then 
* merge into dataset 
clear

forval i=1/10{
import delimited "./`i'.txt", delimiters(tab) varnames(1) asdouble
destring soc,replace
destring onet_ch_`i',replace 
save "./`i'.dta",replace
clear
}




** merge all characteristics by soc. 
use "./1.dta"
forval i=2/10{

merge 1:1 soc using "./`i'.dta"
drop _merge 

}

drop onet_ch_8 onet_ch_10
rename onet_ch_1 onet_ch_27
rename onet_ch_2 onet_ch_28
rename onet_ch_3 onet_ch_29
rename onet_ch_4 onet_ch_30
rename onet_ch_7 onet_ch_31
rename onet_ch_9 onet_ch_32
rename onet_ch_6 onet_ch_33
rename onet_ch_5 onet_ch_34


save "../../../Stata_Raw_Data/onet_merged_char_10.dta",replace 

forval i=1/10{
erase "./`i'.dta"
}
