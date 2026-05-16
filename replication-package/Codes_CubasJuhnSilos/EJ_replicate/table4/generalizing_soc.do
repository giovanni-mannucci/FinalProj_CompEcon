/* put occupational codes (the crosswalk from 2010 to 2018) in stata format*/
clear
set more off
import delimited "../../Raw_Data/ONET/10_18_crosswalk.txt", delimiters(tab) varnames(1) asdouble
rename v1 soc
rename v3 gen_soc
drop chiefexecutives
destring soc, replace force
save "generalizing_soc.dta", replace
