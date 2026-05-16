** merge male overwork , ratios, shift work and average educ with cps to create regression data 



use "./6_a.dta"

preserve

** merge ratios 

merge m:1 occ_94 using "./6.2_ratios/ratios_94.dta"

drop _merge 

merge m:1 occ_563 using "./6.2_ratios/ratios_563.dta"

drop _merge 

merge m:1 occ_22 using "./6.2_ratios/ratios_22.dta"

drop _merge 

** merge average education 

merge m:1 occ_94 using "./6.4_avgeduc/6.4_avg_educ94.dta"

drop _merge

merge m:1 occ_563 using "./6.4_avgeduc/6.4_avg_educ563.dta"

drop _merge 

merge m:1 occ_22 using "./6.4_avgeduc/6.4_avg_educ22.dta"

drop _merge 

** merge male overwork 


merge m:1 occ_94 using "./6.5_male_overwork/6.5_male_overwork94.dta"

drop _merge

merge m:1 occ_563 using "./6.5_male_overwork/6.5_male_overwork563.dta"

drop _merge 

merge m:1 occ_22 using "./6.5_male_overwork/6.5_male_overwork22.dta"

drop _merge 

save 6_b_reg.dta,replace


