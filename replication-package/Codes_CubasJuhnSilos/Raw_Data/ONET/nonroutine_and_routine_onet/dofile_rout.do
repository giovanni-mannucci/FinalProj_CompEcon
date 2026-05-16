clear


 
forvalues X=22/26{ 
import delimited "./`X'.txt", delimiters(tab) varnames(1) asdouble
save "./`X'.dta",replace
clear
}

use "./22.dta"
forvalues X=23/26{ 
merge 1:1 soc using `X'.dta
drop _merge
}
replace soc=subinstr(soc, "-", "",.) 
destring soc,replace
save "../../../Stata_Raw_Data/merged_char_rout", replace

forvalues X=22/26{ 
erase "./`X'.dta"
}
