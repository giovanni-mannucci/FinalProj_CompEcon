************************************************************************************************************************
*** Merge in Jeonghyeok's data set with ONET measures by 2002 occ codes                                              *** 
*** merge with Saumya's original cr and cr ratios because in 6_b_reg.dta, she only kept the 144 occupations with     ***
*** at least 100 obs in the ATUS time use survey                                                                     ***
*** results using the 144 occs only makes the results stronger                                                       ***
*** merge with "C:\Users\cjuhn\Dropbox (UH-ECON)\document_data_new\document_dta\6_regression data\6_b_reg.dta" data  ***
*** original 499 detailed occs are matched to 430 ONET, 493 non-missing BR, 322 CR                                   *** 
************************************************************************************************************************

set more off
clear


 
*** construct occ_94 to occ_563 cross-walk to merge into the DOT measures ****;

use "../document_data_new/document_dta/6_regression data/6_b_reg.dta", clear
 
sort occ_563
merge m:1 occ_563 using ONET_563b
tab _merge
*keep if _merge==3 

drop _merge

sort occ_563
merge m:1 occ_563 using bratio_563all
tab _merge
*keep if _merge==3 

drop _merge
* create standardized measures of ONET skill measures

egen social_563 = std(social)
egen abstract_563 = std(abstract)
egen manual_563 = std(manual)
egen routine_563 = std(routine)
egen onet_ch_1_563 = std(onet_ch_1)
egen onet_ch_2_563 = std(onet_ch_2)
egen onet_ch_3_563 = std(onet_ch_3)
egen onet_ch_4_563 = std(onet_ch_4)
egen onet_ch_5_563 = std(onet_ch_5)

egen onet_ch_27_563 = std(onet_ch_27) 
egen onet_ch_28_563 = std(onet_ch_28) 
egen onet_ch_29_563 = std(onet_ch_29) 
egen onet_ch_30_563 = std(onet_ch_30) 
egen onet_ch_31_563 = std(onet_ch_31) 
egen onet_ch_32_563 = std(onet_ch_32) 
egen onet_ch_33_563 = std(onet_ch_33)
egen onet_ch_34_563 = std(onet_ch_34) 

count
count if prtage>=18 & prtage<=65
count if prtage>=18 & prtage<=65 & prhrusl >=3 & prhrusl <=6
count if prtage>=18 & prtage<=65 & (prhrusl >=3 & prhrusl <=6 & prernwa>0)
* age between 18 and 65*
 keep if prtage >= 18 & prtage <= 65
 
 * (full time) usual hours of work more than 35*
 keep if prhrusl >=3 & prhrusl <=6
 * make sure weekly earnings are greater than 0 *
  keep if prernwa>0
  
******creating variables************
  
* log of weekly earnings 
gen lprernwa=log(prernwa)

* log of hourly earnings
gen lprernhly=log(prernhly)

* log of hours worked
gen lpehrusl1=log(pehrusl1)

*age variable (prtage)
gen prtage2=prtage*prtage
gen prtage3=prtage2*prtage
gen prtage4=prtage3*prtage
*gender dummy
gen female=(pesex==2)
gen male=(pesex==1)

sum lprernwa female bratio_563 prtage prtage2 prtage3 prtage4 lpehrusl1 peeduca ptdtrace year tubwgt occ_563

  * all baseline     (1) 
  eststo:xi: reg lprernwa i.female*bratio_563  prtage prtage2 prtage3 prtage4 lpehrusl1 i.peeduca i.ptdtrace i.year [aw=tubwgt], robust cluster(occ_563)

  * all baseline  + agg educ  (2)
 eststo:xi: reg lprernwa i.female*bratio_563  prtage prtage2 prtage3 prtage4 lpehrusl1 i.peeduca i.ptdtrace i.year avg_educ563 [aw=tubwgt], robust cluster(occ_563)
 
  * all baseline   + agg educ +  male overwork   (3)
 eststo:xi: reg lprernwa i.female*bratio_563  prtage prtage2 prtage3 prtage4 lpehrusl1 i.peeduca i.ptdtrace i.year avg_educ563 male_overwork563 [aw=tubwgt], robust cluster(occ_563)

 * all baseline   + agg educ + male overwork + ONET   (4)
 eststo:xi: reg lprernwa i.female*bratio_563  prtage prtage2 prtage3 prtage4 lpehrusl1 i.peeduca i.ptdtrace i.year avg_educ563 male_overwork563 social_563 abstract_563 manual_563 routine_563 [aw=tubwgt], robust cluster(occ_563)
  
label variable _Ifemale_1 "female"
label variable   _IfemXbrati_1"femaleXratio8to5"
label variable bratio_563  "ratio8to5" 

 esttab est1 est2 est3 est4 using table6.tex,replace label se star(* .10  **  .05 *** .001) keep ( _Ifemale_1 _IfemXbrati_1 bratio_563 )  mtitles("baseline "  "baseline+agg educ"  "baseline+agg educ+ overwrk")
_eststo clear
************************************************************************
 * single, no children baseline     (1)
 eststo:xi: reg lprernwa  i.female*bratio_563  prtage prtage2 prtage3 prtage4 lpehrusl1 i.peeduca i.ptdtrace i.year  [aw=tubwgt], robust cluster(occ_563), if pemaritl~=1 & pemaritl~=2 & prnmchld<1
  
  * single, no children baseline   + agg educ  (2)
 eststo:xi: reg lprernwa  i.female*bratio_563  prtage prtage2 prtage3 prtage4 lpehrusl1 i.peeduca i.ptdtrace i.year avg_educ563  [aw=tubwgt], robust cluster(occ_563), if pemaritl~=1 & pemaritl~=2 & prnmchld<1
  
   * single, no children baseline   + agg educ + male overwork   (3)
 eststo:xi: reg lprernwa  i.female*bratio_563 prtage prtage2 prtage3 prtage4 lpehrusl1 i.peeduca i.ptdtrace i.year avg_educ563 male_overwork563 [aw=tubwgt], robust cluster(occ_563), if pemaritl~=1 & pemaritl~=2 & prnmchld<1 

 * single, no children baseline   + agg educ + male overwork + ONET   (4)
 eststo:xi: reg lprernwa  i.female*bratio_563  prtage prtage2 prtage3 prtage4 lpehrusl1 i.peeduca i.ptdtrace i.year avg_educ563 male_overwork563 social_563 abstract_563 manual_563 routine_563 [aw=tubwgt], robust cluster(occ_563), if pemaritl~=1 & pemaritl~=2 & prnmchld<1 

label variable _Ifemale_1 "female"
label variable   _IfemXbrati_1"femaleXratio8to5"
label variable bratio_563  "ratio8to5" 

 esttab est1 est2 est3 est4 using table6.tex,append label se star(* .10  **  .05 *** .001) keep ( _Ifemale_1 _IfemXbrati_1 bratio_563)  mtitles("baseline "  "baseline+agg educ"  "baseline+agg educ+ overwrk")
_eststo clear
  ************************************************************************
    
* married w/ children baseline     (1)
 eststo:xi: reg lprernwa  i.female*bratio_563  prtage prtage2 prtage3 prtage4 lpehrusl1 i.peeduca i.ptdtrace i.year  [aw=tubwgt], robust cluster(occ_563), if (pemaritl==1 | pemaritl==2) & prnmchld>0
  
* married w/ children baseline   + agg educ  (2)
eststo:xi: reg lprernwa  i.female*bratio_563  prtage prtage2 prtage3 prtage4 lpehrusl1 i.peeduca i.ptdtrace i.year avg_educ563 [aw=tubwgt], robust cluster(occ_563), if (pemaritl==1 | pemaritl==2) & prnmchld>0

* married w/ children baseline   + agg educ + male overwork   (3)
 eststo:xi: reg lprernwa  i.female*bratio_563  prtage prtage2 prtage3 prtage4 lpehrusl1 i.peeduca i.ptdtrace i.year avg_educ563 male_overwork563 [aw=tubwgt], robust cluster(occ_563), if (pemaritl==1 | pemaritl==2) & prnmchld>0 

* married w/ children baseline   + agg educ + male overwork + ONET   (4)
 eststo:xi: reg lprernwa  i.female*bratio_563  prtage prtage2 prtage3 prtage4 lpehrusl1 i.peeduca i.ptdtrace i.year avg_educ563 male_overwork563 social_563 abstract_563 manual_563 routine_563 [aw=tubwgt], robust cluster(occ_563), if (pemaritl==1 | pemaritl==2) & prnmchld>0 

label variable _Ifemale_1 "female"
label variable   _IfemXbrati_1"femaleXratio8to5"
label variable bratio_563  "ratio8to5"  

 esttab est1 est2 est3 est4 using table6.tex,append label se star(* .10  **  .05 *** .001) keep ( _Ifemale_1 _IfemXbrati_1 bratio_563)  mtitles("baseline "  "baseline+agg educ"  "baseline+agg educ+ overwrk")
_eststo clear
 
