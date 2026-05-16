

use "./f5_matrix.dta"

preserve

rename mint_final mints_per_tbin

label variable mints_per_tbin "total time spent in mints on each household activity in each time bin "

gen hrs_per_tbin=mints_per_tbin /60

label variable hrs_per_tbin "total time spent in hrs on each household activity in each time bin "

label variable mints " mints_per_tbin but missing values for missing activities" 


// label detailed household activity.

#delimit ;

label define hactivitylabel
1"routine care 1"
2"routine care 2"
3"routine care 3"
4"enrich care 1"
5"enrich care 2"
6"other care"
;

label values hactivity hactivitylabel;


save f6_hcaredetail_matrix_0314.dta,replace;  
