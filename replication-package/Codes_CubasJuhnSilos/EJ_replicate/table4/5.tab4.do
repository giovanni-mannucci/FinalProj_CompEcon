************************************************************************************************************************
*** Merge in Jeonghyeok's data set with ONET measures by 2002 occ codes                                              *** 
*** merge with Saumya's original cr and cr ratios because in 6_b_reg.dta, she only kept the 144 occupations with     ***
*** at least 100 obs in the ATUS time use survey                                                                     ***
*** results using the 144 occs only makes the results stronger                                                       ***
*** merge with "C:\Users\cjuhn\Dropbox (UH-ECON)\document_data_new\document_dta\6_regression data\6_b_reg.dta" data  ***
*** to get the weights-- for this program 18-65 year old full-time workers                                           ***
*** correlations are weighted and *s indicate significance at the 95%                                                ***
*** all correlations are for the more detailed occ_563 categories                                                    ***
*** original 499 detailed occs are matched to 430 ONET, 493 non-missing BR, 322 CR                                   *** 
************************************************************************************************************************
set more off
clear
capture log close _all
 

use "../document_data_new/document_dta/5_data_#5.dta" , clear


use "./main_result_to_2002.dta", clear
rename occ_563_2002 occ_563

rename mean_measure_1 social
rename mean_measure_2 abstract
rename mean_measure_3 manual
rename mean_measure_4 routine
sort occ_563
save ONET_563b, replace

use "../document_data_new/document_dta/3_br_cr/3b_br563.dta", clear
rename bratio_s_work563_8to5pm bratio_563
sort occ_563
keep occ_563 bratio_563
save bratio_563all, replace

use "../document_data_new/document_dta/3_br_cr/3d_cr563.dta", clear
rename cr_563_wt_std cratio_563
sort occ_563
keep occ_563 cratio_563
save cratio_563all, replace

*** construct occ_94 to occ_563 cross-walk to merge into the DOT measures ****;
use "../document_data_new/document_dta/6_regression data/6_b_reg.dta" , clear
* age between 18 and 65*
 keep if prtage >= 18 & prtage <= 65
 
 * (full time) usual hours of work more than 35*
 keep if prhrusl >=3 & prhrusl <=6
 * make sure weekly earnings are greater than 0 *
 *keep if prernwa>0

egen weight=total(tubwgt), by(occ_563)

duplicates drop occ_563, force
keep occ_563 bratio_s_work563_8to5pm cr_563_wt_std male_overwork563 weight
sort occ_563



merge 1:1 occ_563 using ONET_563b
tab _merge
*keep if _merge==3 
drop _merge

sort occ_563
merge 1:1 occ_563 using bratio_563all
tab _merge
*keep if _merge==3 
drop _merge

sort occ_563
merge m:1 occ_563 using cratio_563all
tab _merge
*keep if _merge==3 
drop _merge
log using table4_corr_vals, replace
 
pwcorr bratio_563 onet_ch_27 onet_ch_28 onet_ch_29 onet_ch_30 onet_ch_31 onet_ch_32 onet_ch_33 onet_ch_34 [aw=weight], star(.05)

pwcorr bratio_563 cratio_563 male_overwork563 [aw=weight], star(.05)

pwcorr bratio_563 social abstract manual routine [aw=weight], star(.05)
** format into tex file as table 8b 
 

log close
