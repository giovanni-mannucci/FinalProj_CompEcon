***********************************************************************
*** uses Saumya's ATUS data supplemented with activity file data*** ***
*** subsets the data and makes simple graphs                        ***
*** fig1 - work for all workers                                     ***
*** fig2a - work for married with children                          ***
*** fig2b - work for single without children                        ***
*** fig3a - work for married with children                          ***
*** fig3b - work for single without children                        ***
*** uses 5_data_#5.dta which has CPS with respondents and           ***
*** non-respondents                                                 ***
*** respondents have 24 observations each corresponding to timebins ***
*** id==. gets rid of nonrespondents                                ***    
***********************************************************************
set more off
clear


log using fig1_3.log, replace

use "../document_data_new/document_dta/5_data_#5.dta" , clear
drop if id==.

***first count number of obs
***drop nonrespondents who have id==. and also multiple obs per respondent

collapse (sum) work householdcare (mean) teage trdpftpt, by(tucaseid)
count
count if teage>=18 & teage<=65
count if teage>=18 & teage<=65 & trdpftpt==1
count if teage>=18 & teage<=65 & trdpftpt==1 & work>0
count if teage>=18 & teage<=65 & trdpftpt==1 & householdcare>0

use "../document_data_new/document_dta/5_data_#5.dta" , clear
***just keep ATUS respondents
drop if id==.

***in minutes
replace work=work*60
replace householdcare=householdcare*60

***marital and child status
gen married=(pemaritl==1)
gen child=(trohhchild==1)
gen childlt6=(child==1 & tryhhchild<6)

*** age
keep if teage >= 18 & teage <= 65

***fulltime workers work>=35
gen fulltime=(trdpftpt ==1)
gen weekday=(tudiaryday~=1 & tudiaryday~=7)

keep if fulltime
*keep if weekday==1

save plotdata, replace

***1. work for all FT workers***

collapse (mean) work householdcare[aw=tufnwgtp], by(timebin)
export excel timebin work householdcare using fig1, replace

label var timebin "Hour of Day"

graph twoway line work timebin,title("") ytitle("Minutes") xlabel(0(3)25) saving(fig1.gph, replace) ///
	    xline(8) xline(17) ylabel(0(10)40)
graph export fig1.eps, replace	

use plotdata, clear
gen grp=1 if married==1 & child==1
replace grp=2 if married==0 & child==0
drop if grp==.		

collapse (mean) work householdcare[aw=tufnwgtp], by(timebin grp tesex)
reshape wide work householdcare, i(timebin grp) j(tesex)
sort grp timebin
export excel grp timebin work1 work2 householdcare1 householdcare2 using fig2_3, replace
label var timebin "Hour of Day"

***2a. work for all FT married with children***
graph twoway line work1 work2 timebin if grp==1  ///
        ,title("Work among FT Married w/ Children") ytitle("Minutes") xlabel(0(3)25) saving(fig2_a.gph, replace) ///
	     legend( order(1 "Men" 2 "Women")) xline(8) xline(17) ylabel(0(10)40)

***2b. work for all FT single without children***
graph twoway line work1 work2 timebin if grp==2 ///
        ,title("Work among FT Singles w/o Children") ytitle("Minutes") xlabel(0(3)25) saving(fig2_b.gph, replace) ///
		 legend( order(1 "Men" 2 "Women")) xline(8) xline(17) ylabel(0(10)40)  

***3a. hhcare for all FT married with children***		 
graph twoway line householdcare1 householdcare2 timebin if grp==1 ///
        ,title("Care among FT Married w/ Children") ytitle("Minutes") xlabel(0(3)25) saving(fig3_a.gph, replace) ///
	     legend( order(1 "Men" 2 "Women")) xline(8) xline(17) ylabel(0(2)10)

***3b. hhcare for all FT married with children***
graph twoway line householdcare1 householdcare2 timebin if grp==2 ///
        ,title("Care among FT Singles w/o Children") ytitle("Minutes") xlabel(0(3)25) saving(fig3_b.gph, replace) ///
	     legend( order(1 "Men" 2 "Women")) xline(8) xline(17) ylabel(0(2)10)

graph combine fig2_a.gph fig2_b.gph, col(1) xcommon saving(fig2.gph, replace) ysize(5) xsize(3)
graph export fig2.eps, replace

graph combine fig3_a.gph fig3_b.gph, col(1) xcommon saving(fig3.gph, replace) ysize(5) xsize(3) 
graph export fig3.eps, replace

log close


