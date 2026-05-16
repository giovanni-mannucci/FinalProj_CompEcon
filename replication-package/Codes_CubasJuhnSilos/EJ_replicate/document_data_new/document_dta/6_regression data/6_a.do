
set more off
clear


use ../5_data_#5.dta, clear


drop occ_563_orig occ_563 occ_94 occ_22  bratio_work563_8to5pm bratio_s_work563_8to5pm 

drop bratio_work22_8to5pm bratio_s_work22_8to5pm 

gen occ_563_orig =peio1ocd

*replace occ_563_02_10=1815 if occ_563_02_10==1810

egen z=group(tucaseid tulineno)

duplicates drop z, force 

drop z

* all unique atus and cps individuals now. 

drop _merge 

merge m:1 occ_563_orig using "../../../../Stata_Raw_Data/final_occs.dta"

drop if _merge!=3 & occ_563_orig>0
drop _merge 

save 6_a.dta,replace

