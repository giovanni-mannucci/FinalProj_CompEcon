* br if tucaseid==20030100014169



use "./f2.dta"

preserve

** first keep activities with reported time 

keep if tuactdur !=.


** make time in editable format

gen starttime=clock(tustarttim,"hms")
format starttim %tcHH:MM:SS

gen stoptime=clock(tustoptim,"hms")
format stoptim %tcHH:MM:SS
 

** split into hours and mints

gen start_hr=hh(starttime)
gen stop_hr=hh(stoptime)
gen start_mint=mm(starttime)
gen stop_mint=mm(stoptime)

gen hr_diff=stop_hr-start_hr

** fix time difference for cases where time goes from say 5 pm to 2 am 
gen neg_diff=(hr_diff<0)
replace stop_hr =stop_hr+24 if hr_diff<0
replace hr_diff=stop_hr-start_hr if hr_diff<0


* drop nonsensical cases

drop if (stop_hr==start_hr ) & tuactdur>60



 * keep if hr_diff==0 
keep if stop_hr==start_hr

clonevar start_hr_orig=start_hr

clonevar stop_hr_orig=stop_hr
* focus on time periods where time period moves on to diff bin

egen g=group(tucaseid start_hr)

bysort g: egen mints=sum(tuactdur)

duplicates drop g,force 

replace stop_hr=start_hr+1 


keep tucaseid start_hr stop_hr mints hactivity  starttime stoptime 
 
save f3_c,replace 




