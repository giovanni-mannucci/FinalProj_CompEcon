***********************************************************************
*** uses 5_data_#5                                              *** ***
*** merges with f6_hcaredetail-matrix_0314.dta                      ***
*** categories are based on Stewart (2010) Appendix                 ***
***                                                                 *** 
***Routine childcare
***030101 Physical care of household children
***030109 Looking after children as a primary activity
***030301 Providing medical care to household children
***
***Enriching childcare (children of all ages)
***030102 Reading to/with household children
***030103 Playing with household children, not sports
***030104 Arts and crafts with household children
***030105 Playing sports with household children
***030106 Talking with/listening to household children
***030107 Helping/teaching household children (not related to education)
***030201 Homework (household children)
***030203 Homeschooling of household children
***
***Enriching childcare (children ages 2+, note: while child is present)
***1201 Socializing and communicating
***120307 Playing games
***120309 Arts and crafts as a hobby
***120310 Collecting as a hobby
***120311 Hobbies, except arts & crafts and collecting
***120401 Attending performances
***120402 Attending museums
***120403 Attending movies/films
***1301 Participating in sports
***1302 Attending sporting event
***
***Other childcare
***030108 Organization and planning for household children
***030110 Attending household children’s events
***030111 Waiting for/with household children
***030112 Picking up/dropping off household children
***030199 Caring for and helping household children, not elsewhere classified
***030202 Meetings and school conferences (household children)
***030204 Waiting associated with household children’s education
***030299 Activities related to household children’s education, not elsewhere classified
***030302 Obtaining medical care for household children
***030303 Waiting associated with household children’s health
***030399 Activities related to household children’s health, not elsewhere classified
***170301 Travel related to caring for and helping household children
***180301 Travel related to caring for and helping household children
***180302 Travel related to household children’s education
***180303 Travel related to household children’s health
***********************************************************************
set more off
clear



use "../document_data_new/hcare_detail/f6_hcaredetail_matrix_0314.dta", clear

gen routine=hrs_per_tbin if hactivity==1 | hactivity==2 | hactivity==3
gen enrich=hrs_per_tbin if hactivity==4 | hactivity==5
gen other=hrs_per_tbin if hactivity==6

collapse (sum) routine enrich other, by(tucaseid timebin)
sort tucaseid timebin
save plotdata, replace

use "../document_data_new/document_dta/5_data_#5.dta" , clear


***just keep ATUS respondents
drop if id==.
drop _merge

***keep track of those with positive hhcare on diary day
sort tucaseid
quietly by tucaseid: egen tothhcare=sum(householdcare)
quietly by tucaseid: replace tothhcare=tothhcare[_N]

sort tucaseid timebin
merge 1:1 tucaseid timebin using plotdata
tab _merge

keep if _merge==1 | _merge==3
*keep if _merge==3

***keep those with positive hhcare on diary day
*keep if tothhcare>0

replace routine=0 if routine==.
replace enrich=0 if enrich==.
replace other=0 if other==.

***marital and child status
gen married=(pemaritl==1)
gen child=(trohhchild==1)
gen childlt6=(child==1 & tryhhchild<6)

***employment status and fulltime workers work>=35
gen employed=(telfs==1 | telfs==2)
gen fulltime=(trdpftpt ==1)

*** age
keep if teage >= 18 & teage <= 65

***keep parents only
keep if child==1

*** weekday vs. weekend
gen weekday=(tudiaryday~=1 & tudiaryday~=7)

*** generate counts 
gen num=1

collapse (sum) work householdcare routine enrich other num (mean) tesex married employed fulltime tufnwgtp childlt6 weekday, by(tucaseid)

***groups: 1= non-employed married mothers 2=FT married mothers 3=FT single mothers 4=FT married fathers***

*getting dummies
gen Married_NW= tesex==2 & married==1 & employed==0
gen Married_FT=  tesex==2 & married==1 & employed==1 & fulltime==1
gen Single_FT=  tesex==2 & married==0 & employed==1 & fulltime==1
gen Male_Married_FT=  tesex==1 & married==1 & employed==1 & fulltime==1

global grp "Married_NW Married_FT Single_FT Male_Married_FT"

_eststo clear
*regression
eststo:xi: reg routine $grp [aw=tufnwgtp] if childlt6==1 & weekday==1, nocons
eststo:xi: reg enrich $grp [aw=tufnwgtp] if childlt6==1 & weekday==1, nocons
eststo:xi: reg other $grp [aw=tufnwgtp] if childlt6==1 & weekday==1, nocons

*transposing
esttab, se nostar 
matrix C = r(coefs)
eststo clear

local rnames : rownames C
local models : coleq C

local models : list uniq models

local i 0

foreach name of local rnames {
 local ++i //+1
 local j 0
 capture matrix drop b
 capture matrix drop se
 foreach model of local models {
 local ++j
 matrix tmp = C[`i', 2*`j'-1]
 if tmp[1,1]<. {
 matrix colnames tmp = `model'
 matrix b = nullmat(b), tmp
 matrix tmp[1,1] = C[`i', 2*`j']
 matrix se = nullmat(se), tmp
 }
 }
 ereturn post b
 quietly estadd matrix se
 eststo `name'
 }
*tabulating
esttab using table3reg.tex, replace f ///
 mtitle noobs  cells(b(fmt(1) nostar) se(fmt(2) par)) ///
 rename(est1 Routine est2 Enrichment est3 Other)

 _eststo clear
*regression
eststo:xi: reg routine $grp [aw=tufnwgtp] if childlt6==0 & weekday==1, nocons
eststo:xi: reg enrich $grp [aw=tufnwgtp] if childlt6==0 & weekday==1, nocons
eststo:xi: reg other $grp [aw=tufnwgtp] if childlt6==0 & weekday==1, nocons

*transposing
esttab, se nostar 
matrix C = r(coefs)
eststo clear

local rnames : rownames C
local models : coleq C

local models : list uniq models

local i 0

foreach name of local rnames {
 local ++i //+1
 local j 0
 capture matrix drop b
 capture matrix drop se
 foreach model of local models {
 local ++j
 matrix tmp = C[`i', 2*`j'-1]
 if tmp[1,1]<. {
 matrix colnames tmp = `model'
 matrix b = nullmat(b), tmp
 matrix tmp[1,1] = C[`i', 2*`j']
 matrix se = nullmat(se), tmp
 }
 }
 ereturn post b
 quietly estadd matrix se
 eststo `name'
 }
*tabulating
esttab using table3reg.tex, append f ///
 mtitle noobs  cells(b(fmt(1) nostar) se(fmt(2) par)) ///
 rename(est1 Routine est2 Enrichment est3 Other)

 _eststo clear
*regression
eststo:xi: reg routine $grp [aw=tufnwgtp] if childlt6==1 & weekday==0, nocons
eststo:xi: reg enrich $grp [aw=tufnwgtp] if childlt6==1 & weekday==0, nocons
eststo:xi: reg other $grp [aw=tufnwgtp] if childlt6==1 & weekday==0, nocons

*transposing
esttab, se nostar 
matrix C = r(coefs)
eststo clear

local rnames : rownames C
local models : coleq C

local models : list uniq models

local i 0

foreach name of local rnames {
 local ++i //+1
 local j 0
 capture matrix drop b
 capture matrix drop se
 foreach model of local models {
 local ++j
 matrix tmp = C[`i', 2*`j'-1]
 if tmp[1,1]<. {
 matrix colnames tmp = `model'
 matrix b = nullmat(b), tmp
 matrix tmp[1,1] = C[`i', 2*`j']
 matrix se = nullmat(se), tmp
 }
 }
 ereturn post b
 quietly estadd matrix se
 eststo `name'
 }
*tabulating
esttab using table3reg.tex, append f ///
 mtitle noobs  cells(b(fmt(1) nostar) se(fmt(2) par)) ///
 rename(est1 Routine est2 Enrichment est3 Other)

 
 _eststo clear
*regression
eststo:xi: reg routine $grp [aw=tufnwgtp] if childlt6==0 & weekday==0, nocons
eststo:xi: reg enrich $grp [aw=tufnwgtp] if childlt6==0 & weekday==0, nocons
eststo:xi: reg other $grp [aw=tufnwgtp] if childlt6==0 & weekday==0, nocons

*transposing
esttab, se nostar 
matrix C = r(coefs)
eststo clear

local rnames : rownames C
local models : coleq C

local models : list uniq models

local i 0

foreach name of local rnames {
 local ++i //+1
 local j 0
 capture matrix drop b
 capture matrix drop se
 foreach model of local models {
 local ++j
 matrix tmp = C[`i', 2*`j'-1]
 if tmp[1,1]<. {
 matrix colnames tmp = `model'
 matrix b = nullmat(b), tmp
 matrix tmp[1,1] = C[`i', 2*`j']
 matrix se = nullmat(se), tmp
 }
 }
 ereturn post b
 quietly estadd matrix se
 eststo `name'
 }
*tabulating
esttab using table3reg.tex, append f ///
 mtitle noobs  cells(b(fmt(1) nostar) se(fmt(2) par)) ///
 rename(est1 Routine est2 Enrichment est3 Other)

