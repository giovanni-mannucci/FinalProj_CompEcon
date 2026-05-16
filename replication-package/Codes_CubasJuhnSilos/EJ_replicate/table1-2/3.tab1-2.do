***********************************************************************
*** uses Saumya's ATUS data supplemented with activity file data*** ***
*** calculates work and hhcare diffs by group                       ***
*** table 1, table 2 - married men and women with children          ***
*** table 1b - married men who make more or less than wives         *** 
*** uses 5_data_#5.dta which has CPS with respondents and           ***
*** non-respondents                                                 ***
*** respondents have 24 observations each corresponding to timebins ***
*** id==. gets rid of nonrespondents                                ***  
*** this does not get rid tehruslt= -4 which is hours varies        ***
*** if we keep tehruslt>0 it makes a small difference               *** 
***********************************************************************
set more off
clear

use "../document_data_new/document_dta/5_data_#5.dta", clear
***drop nonrespondents
drop if id==.

***marital and child status
gen married=(pemaritl==1)
gen child=(trohhchild==1)
gen childlt6=(child==1 & tryhhchild<6)

*** age
keep if teage >= 18 & teage <= 65

***fulltime workers work>=35
gen fulltime=(trdpftpt ==1)

keep if fulltime==1
keep if married==1 & child==1

sort year id
quietly by year id: egen totwork=sum(work)
quietly by year id: egen tothhcare=sum(householdcare)
quietly by year id: keep if _n==_N

gen weekday=(tudiaryday>1 & tudiaryday<7)

******creating variables************
  
* log of weekly earnings 
gen ltrernwa=log(trernwa)

* log of hourly earnings
gen ltrernhly=log(trernhly)

* log of hours worked
gen ltehruslt=log(tehruslt)
*age variable (prtage)
gen teage2=teage*teage
gen teage3=teage2*teage
gen teage4=teage3*teage

*gender dummy
gen female=(tesex==2)
gen male=(tesex==1)

gen hhcare_dum=(tothhcare>0)
gen lesswork_dum=(totwork<7)

save junk, replace

***table for work
eststo:xi: reg totwork i.female [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 
eststo:xi: reg totwork i.female [aw=tufnwgtp] if married==1 & child==1 & tudiaryday==1 | tudiaryday==7 
eststo:xi: reg totwork i.tudiaryday i.year i.female [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 
eststo:xi: reg totwork i.tudiaryday i.year i.female teage teage2 teage3 teage4 i.peeduca i.ptdtrace [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 
eststo:xi: reg totwork i.tudiaryday i.year i.female teage teage2 teage3 teage4 i.peeduca i.ptdtrace tehruslt [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 
eststo:xi: reg totwork i.tudiaryday i.year i.female teage teage2 teage3 teage4 i.peeduca i.ptdtrace tehruslt [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 & tehruslt<50

label variable _Ifemale_1 "Female Gap in Work Hours"
esttab est1 est2 est3 est4 est5 est6 using table1.tex,replace label se star(* .10  **  .05 *** .001) keep(_Ifemale_1)  mtitles("Weekday"  "Weekend" "Weekday") nonotes
_eststo clear

estpost tabstat totwork [aw=tufnwgtp] if weekday==1, by(tesex)
eststo tab1, t(Weekday)
estpost tabstat totwork [aw=tufnwgtp] if weekday==0, by(tesex)
eststo tab2, t(Weekend)
esttab * using table1.tex, append main(mean) nostar unstack nonotes label fragment mtitles nonumber
_eststo clear 



***table for household care
eststo:xi: reg tothhcare i.female [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 
eststo:xi: reg tothhcare i.female [aw=tufnwgtp] if married==1 & child==1 & tudiaryday==1 | tudiaryday==7 
eststo:xi: reg tothhcare i.tudiaryday i.year i.female [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 
eststo:xi: reg tothhcare i.tudiaryday i.year i.female teage teage2 teage3 teage4 i.peeduca i.ptdtrace [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 
eststo:xi: reg tothhcare i.tudiaryday i.year i.female teage teage2 teage3 teage4 i.peeduca i.ptdtrace tehruslt [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 
eststo:xi: reg tothhcare i.tudiaryday i.year i.female teage teage2 teage3 teage4 i.peeduca i.ptdtrace tehruslt [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 & tehruslt<50

label variable _Ifemale_1 "Female Gap in Household Hours"
esttab est1 est2 est3 est4 est5 est6 using table2.tex,replace label se star(* .10  **  .05 *** .001) keep(_Ifemale_1)  mtitles("Weekday"  "Weekend" "Weekday") nonotes
_eststo clear

estpost tabstat tothhcare [aw=tufnwgtp] if weekday==1, by(tesex)
eststo tab1, t(Weekday)
estpost tabstat tothhcare [aw=tufnwgtp] if weekday==0, by(tesex)
eststo tab2, t(Weekend)
esttab * using table2.tex, append main(mean) nostar unstack nonotes label fragment mtitles nonumber
_eststo clear


