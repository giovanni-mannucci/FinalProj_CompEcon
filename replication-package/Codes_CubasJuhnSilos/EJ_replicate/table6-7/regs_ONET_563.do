************************************************************************************************************************
*** Merge in Jeonghyeok's data set with ONET measures by 2002 occ codes                                              *** 
*** merge with Saumya's original cr and cr ratios because in 6_b_reg.dta, she only kept the 144 occupations with     ***
*** at least 100 obs in the ATUS time use survey                                                                     ***
*** results using the 144 occs only makes the results stronger                                                       ***
************************************************************************************************************************
set more off
clear


use ../table4/main_result_to_2002.dta, clear
rename occ_563_2002 occ_563

rename mean_measure_1 social
rename mean_measure_2 abstract
rename mean_measure_3 manual
rename mean_measure_4 routine
sort occ_563
save ONET_563b, replace

use ../document_data_new/document_dta/3_br_cr/3b_br563.dta, clear
rename bratio_s_work563_8to5pm bratio_563
sort occ_563
keep occ_563 bratio_563
save bratio_563all, replace

