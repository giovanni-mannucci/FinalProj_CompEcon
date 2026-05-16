
use "../../../Stata_Raw_Data/1_atusact_raw_0314.dta"

*30186 includes 30106 and 30107  
*180381 includes- 170310;180301;180302;180303 that is travel related to caring and helping hh children. 

preserve

forval i=1/3{

local A`i' "trcodep==03010`i'|trcodep==03020`i'|trcodep==030`i'99 "


}

forval i=1/2{

local B`i' "trcodep==03030`i'|trtier1p==130`i' "
}

local C "trtier2p==1201|trcodep==30186|trcodep==180381|trcodep==030204|trcodep==030105 "

keep if `A1'|`A2'|`A2'|`B1'|`B2'|`C'


* create new household activities

gen hactivity= 1 if trcodep==(30101)
replace hactivity=2 if trcodep== (30109)
replace hactivity=3 if trcodep==(30301)


replace hactivity=4  if (trcodep==30102|trcodep==30103|trcodep==30104|trcodep==30105|trcodep==30106|trcodep==30186|trcodep==30201|trcodep==30203)
replace hactivity=5  if (trtier2p==1201|trcodep==120307|trcodep==120309|trcodep==120310|trcodep==120311|trcodep==120401|trcodep==120402|trcodep==120403|trtier2p==1301|trtier2p==1302)
replace hactivity=6 if (trcodep==30108|trcodep==30110|trcodep==30111|trcodep==30112|trcodep==30199|trcodep==30202|trcodep==30204|trcodep==30299|trcodep==30302|trcodep==30303|trcodep==30399|trcodep==180381)

format tucaseid %20.0f 


#delimit ;

label define hactivitylabel
1"routine care 1"
2"routine care 2"
3"routine care 3"
4"enrich care 1"
5"enrich care 2"
6"other care"
;

label values hactivity hactivitylabel;


save f1.dta,replace;  


