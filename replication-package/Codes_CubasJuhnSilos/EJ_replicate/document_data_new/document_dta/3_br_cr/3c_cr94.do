 use "../2.4_data_#2.dta"

preserve

keep if teage >=18 & teage<=65
 keep if tehrusl1>=35
 
 
 // multiply time spent in each time bin by the indivbidual with the assigned wt of that individual 
 
 sort tucaseid timebin work 
 
 gen work_wt= work*tufnwgtp
 
 // create time spent in each bin , each day and each occ.
collapse (sum)  work_mints_wt=work_wt ,by ( occ_94 tudiaryday timebin)

// drop occs which have responses that dont cover all 7 days//

egen tag= tag(occ_94 tudiaryday)
bysort occ_94: egen y=sum(tag)
drop if y<7
drop y tag

//create total time spent across all bins and all days in each occupation.

bysort occ_94: egen total_mints_wt=sum(work_mints_wt)

//create shares that is time spent in each time bin on each day dividded by total time spent across all bins and all days in each occ : sij/total_o
bysort occ_94: gen share_mints_wt=work_mints_wt/total_mints_wt 
 
 // square the shares
 gen sij_wt_sq=share_mints_wt^2
 
 // add teh shares for each occ to create final cr.
 
 bysort occ_94:egen cr_94_wt=sum(sij_wt_sq)


 duplicates drop occ_94 ,force
 keep occ_94 cr_94_wt
 egen cr_94_wt_std =std(cr_94_wt)
 
 save "./3c_cr94.dta",replace
 
 restore
 clear
 
 * merge with data 3
use  "./3_data_#3.dta"
drop _merge

merge m:1 occ_94 using "./3c_cr94.dta"
 
 drop _merge
 save,replace 
 
 //same code for 94 occ, replace 94 by 94 and vice versa
