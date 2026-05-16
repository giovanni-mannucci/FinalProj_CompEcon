***********************************************************************
*** uses Saumya's ATUS data supplemented with activity file data*** ***
*** subsets the data and makes simple graphs                        ***
*** fig4 - hours worked in selected occ_563                          ***
*** uses 5_data_#5.dta which has CPS with respondents and           ***
*** non-respondents                                                 ***
*** respondents have 24 observations each corresponding to timebins ***
*** id==. gets rid of nonrespondents                                ***  

***********************************************************************
set more off
clear


use "../document_data_new/document_dta/5_data_#5.dta" , clear

***dropping nonrespondents
drop if id==.

*** age
keep if teage >= 18 & teage <= 65

***in minutes
replace work=work*60
replace householdcare=householdcare*60

***fulltime workers work>=35
gen fulltime=(trdpftpt ==1)
keep if fulltime==1

sort occ_563
keep work timebin occ_563 occ_563 bratio_s_work94_8to5pm bratio_s_work563_8to5pm tufnwgtp

merge m:1 occ_563 using "../table6-7/bratio_563all"
tab _merge
*keep if _merge==3 

drop _merge


sort bratio_563

keep if occ_563==2100 | occ_563==840 | occ_563==2850 | occ_563==3060 | occ_563==5700 | occ_563==4720 | occ_563==3600 | occ_563==5800 | occ_563==4700

***lawyers
twoway lpolyci work timebin [aw=tufnwgtp] if occ_563==2100, title("Lawyers", size(small)) ytitle("Minutes", size(small)) xtitle("Hour of Day", size(small)) ///
	     xline(8,lcolor(gs2)) xline(17,lcolor(gs2)) xlabel(0(3)25, labsize(small)) ylabel(0(10)40, labsize(small)) leg(off) plotregion(fcolor(white)) graphregion(fcolor(white)) saving(fig4_a.gph, replace) 

***financial analysts
twoway lpolyci work timebin [aw=tufnwgtp] if occ_563==840, title("Financial analysts", size(small)) ytitle("Minutes", size(small)) xtitle("Hour of Day", size(small)) ///
	     xline(8,lcolor(gs2)) xline(17,lcolor(gs2)) xlabel(0(3)25, labsize(small)) ylabel(0(10)40, labsize(small)) leg(off) plotregion(fcolor(white)) graphregion(fcolor(white)) saving(fig4_b.gph, replace) 

***writer and Authors, news media
twoway lpolyci work timebin [aw=tufnwgtp] if occ_563==2850, title("Writers and authors", size(small)) ytitle("Minutes", size(small)) xtitle("Hour of Day", size(small)) ///
	     xline(8,lcolor(gs2)) xline(17,lcolor(gs2)) xlabel(0(3)25, labsize(small)) ylabel(0(10)40, labsize(small)) leg(off) plotregion(fcolor(white)) graphregion(fcolor(white)) saving(fig4_c.gph, replace) 

***physicians, nurses, home health aides
twoway lpolyci work timebin [aw=tufnwgtp] if occ_563==3060, title("Physicians and surgeons", size(small)) ytitle("Minutes", size(small)) xtitle("Hour of Day", size(small)) ///
	     xline(8,lcolor(gs2)) xline(17,lcolor(gs2)) xlabel(0(3)25, labsize(small)) ylabel(0(10)40, labsize(small)) leg(off) plotregion(fcolor(white)) graphregion(fcolor(white)) saving(fig4_d.gph, replace) 

***secretaries and administrative assistants
twoway lpolyci work timebin [aw=tufnwgtp] if occ_563==5700, title("Secretaries and administrative assistants", size(small)) ytitle("Minutes", size(small)) xtitle("Hour of Day", size(small)) ///
	     xline(8,lcolor(gs2)) xline(17,lcolor(gs2)) xlabel(0(3)25, labsize(small)) ylabel(0(10)40, labsize(small)) leg(off) plotregion(fcolor(white)) graphregion(fcolor(white)) saving(fig4_e.gph, replace) 

***cashiers, clerks, retail person
twoway lpolyci work timebin [aw=tufnwgtp] if occ_563==4720, title("Cashiers", size(small)) ytitle("Minutes", size(small)) xtitle("Hour of Day", size(small)) ///
	     xline(8,lcolor(gs2)) xline(17,lcolor(gs2)) xlabel(0(3)25, labsize(small)) ylabel(0(10)40, labsize(small)) leg(off) plotregion(fcolor(white)) graphregion(fcolor(white)) saving(fig4_f.gph, replace) 

***Nursing, psychiatric, home health aides
twoway lpolyci work timebin [aw=tufnwgtp] if occ_563==3600, title("Nursing, psychiatric, home health aides", size(small)) ytitle("Minutes", size(small)) xtitle("Hour of Day", size(small)) ///
	     xline(8,lcolor(gs2)) xline(17,lcolor(gs2)) xlabel(0(3)25, labsize(small)) ylabel(0(10)40, labsize(small)) leg(off) plotregion(fcolor(white)) graphregion(fcolor(white)) saving(fig4_g.gph, replace) 		 		 

***Computer Operators
twoway lpolyci work timebin [aw=tufnwgtp] if occ_563==5800, title("Computer operators", size(small)) ytitle("Minutes", size(small)) xtitle("Hour of Day", size(small)) ///
	     xline(8,lcolor(gs2)) xline(17,lcolor(gs2)) xlabel(0(3)25, labsize(small)) ylabel(0(10)40, labsize(small)) leg(off) plotregion(fcolor(white)) graphregion(fcolor(white)) saving(fig4_h.gph, replace) 	

***First-Line Supervisors of Retail, non-retail Sales Workers
twoway lpolyci work timebin [aw=tufnwgtp] if occ_563==4700, title("First-Line supervisors retail, non-retail sales", size(small)) ytitle("Minutes", size(small)) xtitle("Hour of Day", size(small)) ///
	     xline(8,lcolor(gs2)) xline(17,lcolor(gs2)) xlabel(0(3)25, labsize(small)) ylabel(0(10)40, labsize(small)) leg(off) plotregion(fcolor(white)) graphregion(fcolor(white)) saving(fig4_i.gph, replace) 
		 
graph combine fig4_a.gph fig4_b.gph fig4_c.gph fig4_d.gph fig4_e.gph  ///
     fig4_f.gph fig4_g.gph fig4_h.gph fig4_i.gph, title("") graphregion(fcolor(white)) ///
	 saving(fig4.gph, replace) 
graph export fig4.eps, replace		


