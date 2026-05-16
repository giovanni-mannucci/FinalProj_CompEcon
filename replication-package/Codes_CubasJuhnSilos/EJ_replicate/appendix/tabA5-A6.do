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

*keep men only and also define work status of spouse

keep if trsppres==1  /*spouse present in the ATUS survey */
gen spouse_work=1 if trspftpt==-1 /*NW*/
replace spouse_work=2 if trspftpt==2 /*PT*/
replace spouse_work=3 if trspftpt==1 | trspftpt==3 /*FT*/

gen female=(tesex==2)
gen male=(tesex==1)
keep if male==1

gen hhcare_dum=(tothhcare>0)
gen lesswork_dum=(totwork<7)

save junk, replace

***table for work
eststo:xi: reg totwork i.spouse_work [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 
eststo:xi: reg totwork i.spouse_work [aw=tufnwgtp] if married==1 & child==1 & tudiaryday==1 | tudiaryday==7 
eststo:xi: reg totwork i.tudiaryday i.year i.spouse_work [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 
eststo:xi: reg totwork i.tudiaryday i.year i.spouse_work teage teage2 teage3 teage4 i.peeduca i.ptdtrace [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 
eststo:xi: reg totwork i.tudiaryday i.year i.spouse_work teage teage2 teage3 teage4 i.peeduca i.ptdtrace tehruslt [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 
eststo:xi: reg totwork i.tudiaryday i.year i.spouse_work teage teage2 teage3 teage4 i.peeduca i.ptdtrace tehruslt [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 & tehruslt<50

label variable _Ispouse_wo_2 "Male Hours Gap PT Spouse Relative to NW Spouse"
label variable _Ispouse_wo_3 "Male Hours Gap FT Spouse Relative to NW Spouse"

esttab est1 est2 est3 est4 est5 est6 using tableA5.tex,replace label se star(* .10  **  .05 *** .001) keep(_Ispouse_wo_2 _Ispouse_wo_3)  mtitles("Weekday"  "Weekend" "Weekday") nonotes
_eststo clear


estpost tabstat totwork [aw=tufnwgtp] if weekday==1, by(spouse_work)
eststo tab1, t(Weekday)
estpost tabstat totwork [aw=tufnwgtp] if weekday==0, by(spouse_work)
eststo tab2, t(Weekend)
esttab * using tableA5.tex, append main(mean) nostar unstack nonotes label fragment mtitles nonumber
_eststo clear 




***table for household care
eststo:xi: reg tothhcare i.spouse_work [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 
eststo:xi: reg tothhcare i.spouse_work [aw=tufnwgtp] if married==1 & child==1 & tudiaryday==1 | tudiaryday==7 
eststo:xi: reg tothhcare i.tudiaryday i.year i.spouse_work [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 
eststo:xi: reg tothhcare i.tudiaryday i.year i.spouse_work teage teage2 teage3 teage4 i.peeduca i.ptdtrace [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 
eststo:xi: reg tothhcare i.tudiaryday i.year i.spouse_work teage teage2 teage3 teage4 i.peeduca i.ptdtrace tehruslt [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 
eststo:xi: reg tothhcare i.tudiaryday i.year i.spouse_work teage teage2 teage3 teage4 i.peeduca i.ptdtrace tehruslt [aw=tufnwgtp] if married==1 & child==1 & tudiaryday~=1 & tudiaryday~=7 & tehruslt<50

label variable _Ispouse_wo_2 "Male Hours Gap PT Spouse Relative to NW Spouse"
label variable _Ispouse_wo_3 "Male Hours Gap FT Spouse Relative to NW Spouse"
esttab est1 est2 est3 est4 est5 est6 using tableA6.tex, replace label se star(* .10  **  .05 *** .001) keep(_Ispouse_wo_2 _Ispouse_wo_3)  mtitles("Weekday"  "Weekend" "Weekday") nonotes
_eststo clear

estpost tabstat tothhcare [aw=tufnwgtp] if weekday==1, by(spouse_work)
eststo tab1, t(Weekday)
estpost tabstat tothhcare [aw=tufnwgtp] if weekday==0, by(spouse_work)
eststo tab2, t(Weekend)
esttab * using tableA6.tex, append main(mean) nostar unstack nonotes label fragment mtitles nonumber
_eststo clear


