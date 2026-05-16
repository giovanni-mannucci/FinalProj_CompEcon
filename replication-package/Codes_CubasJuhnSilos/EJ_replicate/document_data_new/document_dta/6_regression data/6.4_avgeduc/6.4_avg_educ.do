** average education 


use "../6_a.dta"

preserve



 keep if prtage>=18 & prtage<=65 

 ****** average education for 94

  
 bysort occ_94: egen avg_educ94=wtmean(peeduca),weight(tubwgt)
 
 
  duplicates drop occ_94,force 
  
  keep occ_94  avg_educ94 
  
  save "./6.4_avg_educ94.dta",replace
  
  restore
  
  preserve 
  
  *** avg educ for 563 
  
  
  keep if prtage>=18 & prtage<=65 
  bysort occ_563: egen avg_educ563=wtmean(peeduca),weight(tubwgt)
 
  duplicates drop occ_563,force 
 
  keep occ_563 avg_educ563
  
  save "./6.4_avg_educ563.dta",replace 
  
  restore
  
  preserve 
  
  *** avg educ for 22
  
  keep if prtage>=18 & prtage<=65 
  bysort occ_22: egen avg_educ22=wtmean(peeduca),weight(tubwgt)
 
  duplicates drop occ_22,force 
 
  keep occ_22 avg_educ22
  
  save "./6.4_avg_educ22.dta",replace 
  
  
  
  
  
  
  restore 
  
  clear 
  
  
  
