
use "../../../Stata_Raw_Data/atuscps_raw_0314.dta", clear
preserve

destring tucaseid, replace
format tucaseid %20.0f
nsplit tucaseid, digits ( 4 10)
rename tucaseid1 year
drop tucaseid2  

* raw cps from 2003-2016 with year variable. 

sort tucaseid tulineno pulineno
save "./file1.dta",replace
restore
clear

use "./file1.dta",replace
preserve

keep tucaseid pespouse tulineno pulineno prtage pesex ptdtrace pehspnon pemlr prernwa prernhly peernhry ptwk pehruslt peio1ocd  prdtocc1 peio1cow peschenr peschlvl peschft peeduca

keep if pespouse>0
rename pulineno pulineno_orig
rename pespouse pulineno
rename prtage s_prtage
rename pesex s_pesex
rename ptdtrace s_ptdtrace
rename pehspnon s_pehspnon
rename pemlr s_pemlr
rename prernwa s_prernwa
rename prernhly s_prernhly
rename peernhry s_peernhry
rename ptwk s_ptwk
rename pehruslt s_pehruslt
rename peio1ocd s_peio1ocd
rename prdtocc1 s_prdtocc1
rename peio1cow s_peio1cow
rename peschenr s_peschenr 
rename peschlvl s_peschlvl
rename peschft  s_peschft
rename peeduca  s_peeduca

sort tucaseid  pulineno
save "./file2.dta", replace
restore
clear
use "./file1.dta"
merge m:m tucaseid pulineno using "./file2.dta"
sort tucaseid tulineno pulineno
drop _merge
save "./4_spouses.dta",replace


* check if correcty matched (* 20030100013109*)
*br tucaseid tulineno pulineno pulineno_orig peio1ocd s_peio1ocd if tucaseid==20030100013109

