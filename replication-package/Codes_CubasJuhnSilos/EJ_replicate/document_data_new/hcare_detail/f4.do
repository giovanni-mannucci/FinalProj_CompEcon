

use "./f3_a.dta"

preserve 

append using "./f3_b.dta"

append using "./f3_c.dta"


gen timebin=stop_hr

egen g=group( tucaseid hactivity timebin)

bysort g: egen mint_final=sum (mints)

duplicates drop g,force 

drop g

save f4,replace 



