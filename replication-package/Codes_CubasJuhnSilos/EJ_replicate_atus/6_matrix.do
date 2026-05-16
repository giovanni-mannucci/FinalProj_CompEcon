use "5_wrk_hcare_id.dta"
preserve

 merge m:1 id using 6_year_tucaseid.dta
 drop _merge

 save "7_final_wrk_hcare.dta",replace
 
 
 save "1.2_data_#1.dta", replace
 
 restore 
 clear
  
  
  use "1.2_data_#1.dta"
  
  drop n
  
  save ,replace 
