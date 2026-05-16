clear 

import delimited using "./occs_labels.txt", delimiters(tab) varnames(1)
drop occ_563
drop occ_94
drop occ_22
rename occ_22_value occ_22
rename occ_94_value occ_94
rename occ_563_value occ_563

save "../../Stata_Raw_Data/final_occs.dta", replace
