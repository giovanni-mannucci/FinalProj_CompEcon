use "./2.2_atus_data#1_merge.dta"

gen occ_563_orig =teio1ocd

drop _merge 

merge m:1 occ_563_orig using "../../../Stata_Raw_Data/final_occs.dta"


drop _merge 


save "./2.3_atus_data#1_occs.dta", replace
