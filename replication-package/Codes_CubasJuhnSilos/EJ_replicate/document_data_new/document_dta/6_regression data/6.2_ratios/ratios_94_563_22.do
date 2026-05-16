** keep occupations where full time atus individuals between 18-65 ( those used in the creation of bunching anc conc. ratios ratios) are more than 100. 

use "../../3_br_cr/3_data_#3.dta"



preserve


** for 94

keep if teage >=18 & teage<=65
keep if tehrusl1>=35

duplicates drop tucaseid,force

bysort occ_94: egen total94=sum(tulineno)

drop if total94<100

duplicates drop occ_94,force 



keep  occ_94   cr_94_wt_std bratio_s_hcare94_8to5pm bratio_s_work94_8to5pm 

save "./ratios_94.dta",replace 

restore

preserve

** for 563 

keep if teage >=18 & teage<=65
keep if tehrusl1>=35

duplicates drop tucaseid,force

bysort occ_563: egen total563=sum(tulineno)

drop if total563<100

duplicates drop occ_563,force 

keep  occ_563  cr_563_wt_std bratio_s_hcare563_8to5pm bratio_s_work563_8to5pm 

save "./ratios_563.dta",replace 

restore

preserve

*** for 22


keep if teage >=18 & teage<=65
keep if tehrusl1>=35

duplicates drop tucaseid,force

bysort occ_22: egen total22=sum(tulineno)

drop if total22<100

duplicates drop occ_22,force 

keep  occ_22  cr_22_wt_std bratio_s_hcare22_8to5pm bratio_s_work22_8to5pm 

save "./ratios_22.dta",replace 

