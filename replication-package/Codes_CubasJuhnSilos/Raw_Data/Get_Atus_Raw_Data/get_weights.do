/*09/11/2022
Get weight of each occ by using ATUS 2011-2014 18-65 full-time workers
*/
clear

use "../../Stata_Raw_Data/weight_atus.dta"

 

*age
keep if age>=18 & age<=65

*full time workers work>=35
keep if uhrswork1>=35 & uhrswork1<=100

*2011-2014
keep if year >= 2011 & year<=2014

collapse (sum) wt06, by(occ)

rename occ occ_563

save "../../Stata_Raw_Data/wt_ATUS_2011_2014_new", replace
 
