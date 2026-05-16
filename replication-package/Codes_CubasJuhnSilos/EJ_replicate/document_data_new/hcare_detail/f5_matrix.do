

use "./f4.dta"

preserve 

keep tucaseid 

duplicates drop tucaseid,force 

expand 6 
sort tucaseid
sequence hactivity, f(1) t(6)

save acttemp,replace

sort tucaseid hactivity
expand 24
sort tucaseid hactivity

sequence timebin, f(1) t(24)
 

save actbin,replace 



restore

preserve


keep tucaseid hactivity timebin mints mint_final 

sort tucaseid hactivity timebin

merge m:m tucaseid hactivity timebin using actbin

drop _merge 


** check 

egen x=group(tucaseid )

gen c=71666* 24*6

dis c 

* should match total observations *if it does then-

replace mint_final=0 if mint_final==.

drop x c 

save f5_matrix,replace 



restore

clear


