**Jeonghyeok Kim 3/16/2020
**this code is slightly different version of main code.  
**In this version, I didn't modify code to be compatible with CPS march data, and did crosswalk to 2002 ATUS code.
**From the crosswalk 2010 to 2002, I used ATUS 2011-2014 data(18-65,full-time) as a weight. 
**Edit
**4/ 9/2020 I added nonroutine and routine onet characteristics
 
clear

set more off

*log using main_log, replace

**1.onet characteristics merging
/*

forvalues i=3/5{
import excel "./onet_data/`i'.xls", sheet("Sheet1") cellrange(B4:C970) firstrow clear
destring soc,replace
destring onet_ch_`i',replace 
tempfile char_`i'
save `char_`i'', replace
}

foreach i of numlist 2 1 {
import excel "./onet_data/`i'.xls", sheet("Sheet1") cellrange(B4:C971) firstrow clear
destring soc,replace
destring onet_ch_`i',replace
tempfile char_`i'
save `char_`i'', replace
}

forvalues i=2/5{
merge 1:1 soc using `char_`i'' 
drop _merge
}
*/

use  "../../Stata_Raw_Data/basic_five_merged.dta"


**1.5 additional characteristics merging
merge 1:1 soc using "../../Stata_Raw_Data/onet_merged_char_additional.dta"
drop _merge

*generating straigt mean measures
egen mean_measure_1=rowmean(onet_ch_6 onet_ch_7 onet_ch_8 onet_ch_9)
egen mean_measure_2=rowmean(onet_ch_10 onet_ch_11 onet_ch_12)
egen mean_measure_3=rowmean(onet_ch_13 onet_ch_14 onet_ch_15 onet_ch_16)
egen mean_measure_4=rowmean(onet_ch_17 onet_ch_18 onet_ch_19 onet_ch_20 onet_ch_21)

**1.6 nonroutine and routine characteristics merging
merge 1:1 soc using "../../Stata_Raw_Data/merged_char_rout.dta"
drop _merge

*generating straigt mean measures
egen mean_measure_5=rowmean(onet_ch_22 onet_ch_23 onet_ch_24)
egen mean_measure_6=rowmean(onet_ch_25 onet_ch_26)

**1.7 8Onet characterisitcs(paper with German Table8) merging
merge 1:1 soc using "../../Stata_Raw_Data/onet_merged_char_10.dta"
drop _merge

**2.generalizing soc code
merge 1:1 soc using "./generalizing_soc.dta"
replace soc=gen_soc if gen_soc!=.
keep if _merge==3
drop _merge gen_soc

**3.decimal soc code into integer soc code
replace soc=int(soc)
collapse (mean) onet_ch_* mean_measure_* , by(soc) //# of occs: 572soc

tempfile onet
save `onet', replace
/*

**4.2018 occupation code and 2010 occupation code crosswalk
import excel "../../Raw_Data/ONET/10_18_crosswalk.xls", sheet("for 1018 crosswalk") cellrange(B5:E1042)  clear
drop C 
rename B occ_563 //2010 census occupation code
rename D soc     //2018 soc occupation code
rename E occ_563_2018
destring occ_563 occ_563_2018,replace
replace soc=subinstr(soc, "-", "",.) 
replace soc=subinstr(soc, "X", "0",.)
destring soc,replace
drop if soc==.   //# of occ: 529occ_563, 613soc
 */

 clear 
import delimited "../../Raw_Data/ONET/for_1018_crosswalk.txt", delimiters(tab) 
drop v2
rename v1 occ_563 // 2010 census occ code
rename v3 soc // 2018 soc occ code
rename v4 occ_563_2018
destring occ_563 occ_563_2018,replace
replace soc=subinstr(soc, "-", "",.) 
replace soc=subinstr(soc, "X", "0",.)
destring soc,replace
drop if soc==.   //# of occ: 529occ_563, 613soc

**5.merging onet characteristics with crosswalk
merge m:1 soc using `onet' //# of occ:508occ_563, 557soc
keep if _merge==3
drop _merge

tempfile onet
save `onet', replace

**6.merging ACS2018
use "../../Stata_Raw_Data/ACS2018.dta", clear
gen n=(empstat==1)
collapse (sum) n, by(occ)
*recode ACS2018 occ variable compatible with census occ(giving half observation if two occ in census are in one occ in ACS)
expand 2 if occ==1340 | occ==1520 | occ==1935 | occ==2100 | occ==3258 | occ==3840 | occ==5350 | occ==6220 | occ==6800 | occ==9300, gen(x)
replace n=0.5*n if occ==1340 | occ==1520 | occ==1935 | occ==2100 | occ==3258 | occ==3840 | occ==5350 | occ==6220 | occ==6800 | occ==9300
replace occ=1330 if occ==1340 & x==1
replace occ=1500 if occ==1520 & x==1
replace occ=1940 if occ==1935 & x==1
replace occ=2110 if occ==2100 & x==1
replace occ=3257 if occ==3258 & x==1
replace occ=3830 if occ==3840 & x==1
replace occ=5210 if occ==5350 & x==1
replace occ=6500 if occ==6220 & x==1
replace occ=6920 if occ==6800 & x==1
replace occ=9330 if occ==9300 & x==1
replace occ=8060 if occ==8100 

rename occ occ_563_2018

merge 1:m occ_563_2018 using `onet' //# of occ: 474occ_563, 521soc
keep if _merge==3  
drop _merge  

**7.getting weighted average of onet char by 2010census
bys occ_563:egen wt=sum(n)
*adapting weight since the 2010obs with multiple 2018obs are overidentified
replace n=0.5*n if occ_563==3870 | occ_563==4055 | occ_563==4330 | occ_563==6115 | occ_563==6410 | occ_563==6850 | occ_563==8335 | occ_563==8465 | occ_563==8865 | occ_563==8990 ///
 | occ_563==9265 | occ_563==9430
replace n=0.33*n if occ_563==6305 | occ_563==6305 | occ_563==7925 | occ_563==8025 | occ_563==9570
replace n=0.25*n if occ_563==8365
replace n=0.20*n if occ_563==8225

collapse (mean)onet_ch_* mean_measure_* wt [aw=n], by(occ_563) 

**crosswalking from 2010census to 2002census
{
gen occ_563_new=occ_563 
replace occ_563_new=130 if (occ_563==135|occ_563==136|occ_563==137)

replace occ_563_new=200 if occ_563==205
//
replace occ_563_new=320 if occ_563==325
//
replace occ_563_new=560 if occ_563==565
//
replace occ_563_new=620 if (occ_563==630|occ_563==640|occ_563==650)
//
replace occ_563_new=720 if (occ_563==725|occ_563==726)
//
replace occ_563_new=730 if (occ_563==735|occ_563==740)
//
replace occ_563_new=1000 if (occ_563==1005|occ_563==1006|occ_563==1107)
//
replace occ_563_new=1040 if occ_563==1050
//
replace occ_563_new=1100 if occ_563==1105
//
replace occ_563_new=1110 if (occ_563==1007|occ_563==1030|occ_563==1106)
//
replace occ_563_new=1810 if occ_563==1815
//
replace occ_563_new=1960 if (occ_563==1950|occ_563==1965)
//
replace occ_563_new=2010 if (occ_563==2015|occ_563==2016)
//
replace occ_563_new=2020 if occ_563==2025
//
replace occ_563_new=2140 if occ_563==2145
//
replace occ_563_new=2150 if occ_563==2160
//
replace occ_563_new=2820 if occ_563==2825
//
replace occ_563_new=3240 if occ_563==3245
//
replace occ_563_new=3130 if (occ_563==3255|occ_563==3256|occ_563==3257|occ_563==3258)
//
replace occ_563_new=3410 if occ_563==3420
//
replace occ_563_new=3530 if occ_563==3535
//
replace occ_563_new=3650 if (occ_563==3645|occ_563==3646|occ_563==3647|occ_563==3648|occ_563==3649|occ_563==3655)
//
replace occ_563_new=3920 if occ_563==3930
//
replace occ_563_new=3940 if occ_563==3945
//
replace occ_563_new=3950 if occ_563==3955
//
replace occ_563_new=4460 if occ_563==4465
//
replace occ_563_new=4960 if occ_563==4965
//
replace occ_563_new=5930 if occ_563==5940
//
replace occ_563_new=6000 if occ_563==6005
//
replace occ_563_new=6350 if occ_563==6355
//
replace occ_563_new=6510 if occ_563==6515
//
replace occ_563_new=6760 if occ_563==6765
//
replace occ_563_new=7310 if occ_563==7315
//
replace occ_563_new=7430 if occ_563==7440
//
replace occ_563_new=7620 if occ_563==7630
//
replace occ_563_new=7850 if occ_563==7855
//
replace occ_563_new=8260 if (occ_563==8255|occ_563==8256)
//
replace occ_563_new=8960 if occ_563==8965
//
replace occ_563_new=9040 if occ_563==9050
//
replace occ_563_new=9410 if occ_563==9415
//
replace occ_563_new=420 if occ_563==425
//
replace occ_563_new=2100 if occ_563==2105
//
replace occ_563_new=3230 if occ_563==3235
//
replace occ_563_new=5160 if occ_563==5165
//
replace occ_563_new=6530 if occ_563==6540

rename occ_563_new occ_563_2002 
}

**8.getting weighted average of onet char 2002 by using ATUS 2011-2014
merge 1:1 occ_563 using "../../Stata_Raw_Data/wt_ATUS_2011_2014_new.dta" //# of occ: 456 occ_563, 430occ_563_2002

keep if _merge==3
collapse (mean)onet_ch_* mean_measure_* [aw=wt06], by(occ_563_2002) 

label variable onet_ch_1 "contact with others" 
label variable onet_ch_2 "establishing and maintaining interpersonal relationship" 
label variable onet_ch_3 "freedom to make decision"
label variable onet_ch_4 "structured versus unstructured work"
label variable onet_ch_5 "time pressure"
label variable onet_ch_6 "Coordination"
label variable onet_ch_7 "Negotiation"
label variable onet_ch_8 "Persuation"
label variable onet_ch_9 "Social Perceptness"
label variable onet_ch_10 "Interpreting the Meaning of Information for Others"
label variable onet_ch_11 "Think Creatively"
label variable onet_ch_12 "Analyzing Data or Information"
label variable onet_ch_13 "Spend Time Using Your Hands to Handle, Control, or Feel Objects, Tools, or Controls"
label variable onet_ch_14 "Manual Dexterity"
label variable onet_ch_15 "Operating Vehicle, Machanized Devices, or Equipment"
label variable onet_ch_16 "Spatial Orientation"
label variable onet_ch_17 "Controlling Machines and Processes"
label variable onet_ch_18 "Spend Time Making Repetitive Motions"
label variable onet_ch_19 "Pace Determined by speed of Equipment"
label variable onet_ch_20 "Importance of Being Exact or Accurate"
label variable onet_ch_21 "Importance of Repeating Same Tasks"
label variable occ_563 "2010 census occ code"
label variable occ_563_2002 "2002 census occ code"
label variable onet_ch_22 "Mathematical Reasoning Ability"
label variable onet_ch_23 "Mathematics Knowledge"
label variable onet_ch_24 "Mathematics Skill"
label variable onet_ch_25 "Degree of Automation"
label variable onet_ch_26 "Importance of Repeating Same Tasks"
label variable onet_ch_27 "Assisting and Caring for Others"
label variable onet_ch_28 "Coaching and Developing Others"
label variable onet_ch_29 "Developing and Building Teams"
label variable onet_ch_30 "Establishing and Maintaining Interpersonal Relationships"
label variable onet_ch_31 "Face-to-Face Discussions"
label variable onet_ch_32 "Social Orientation"
label variable onet_ch_33 "Training and Teaching Others"
label variable onet_ch_34 "Guiding, Directing, and Motivating Subordinates"

*drop onet_ch_*

label variabl mean_measure_1 "Social"
label variabl mean_measure_2 "Abstract"
label variabl mean_measure_3 "Manual"
label variabl mean_measure_4 "Routine"
label variabl mean_measure_5 "Deming Nonroutine Analytical"
label variabl mean_measure_6 "Deming Routine"

save "main_result_to_2002", replace
*log close
exit

**additional work
merge 1:1 occ_563 using "../../../document_data_new/document_dta/3_br_cr/3b_br563.dta" //this merge is problematic due to the time inconstistency
keep if _merge ==3
drop _merge
correlate bratio_s_work563_8to5pm onet_ch_1 onet_ch_2 onet_ch_3 onet_ch_4 onet_ch_5
spearman bratio_s_work563_8to5pm onet_ch_1 onet_ch_2 onet_ch_3 onet_ch_4 onet_ch_5 
