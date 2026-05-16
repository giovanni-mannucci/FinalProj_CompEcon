

 use "../2.4_data_#2.dta"

preserve

 * keep full time workers*
 
 keep if teage >=18 & teage<=65
 keep if tehrusl1>=35
 
 *1.first we create unique time bins for each respondent with no repeats ( 1-2,... 23-24)
 
sort tucaseid start_time stop_time
gen y=1 if stop_time[_n]==stop_time[_n-1]
drop if y==1
drop if stop_time==0
egen yy=group(tucaseid)
bysort yy:egen v=count(tucaseid)
/*br if v!=24*/ 
drop yy y v

******************************************************************************
*for 563 OCCUPATIONS-householdcare
bysort occ_563: egen weightsum_563=sum(tufnwgtp)

*A*
sort tucaseid start_time stop_time
gen A1=householdcare if start_time>=0 & stop_time<=8
bysort tucaseid:egen A2=sum(A1)
replace A2=A2*tufnwgtp
bysort occ_563: egen A3=sum(A2)
by occ_563:gen A_hcare563=A3/weightsum_563

*B*

sort tucaseid start_time stop_time
gen B1=householdcare if start_time>=8 & stop_time<=17 
bysort tucaseid:egen B2=sum(B1)
replace B2=B2*tufnwgtp
bysort occ_563: egen B3=sum(B2)
by occ_563:gen B_hcare563=B3/weightsum_563

*C*
sort tucaseid start_time stop_time
gen C1=householdcare if start_time>=17 & stop_time<=24 
bysort tucaseid:egen C2=sum(C1)
replace C2=C2*tufnwgtp
bysort occ_563: egen C3=sum(C2)
by occ_563:gen C_hcare563=C3/weightsum_563

*bunching ratio based on time spent on householdcare , for 563 occ category*

by occ_563: gen bratio_hcare563=B_hcare563/(A_hcare563+B_hcare563+C_hcare563)


drop B1 B2 B3 A1 A2 A3 C1 C2 C3 

*for 563 OCCUPATIONS-work

*A*
sort tucaseid start_time stop_time
gen A1=work if start_time>=0 & stop_time<=8
bysort tucaseid:egen A2=sum(A1)
replace A2=A2*tufnwgtp
bysort occ_563: egen A3=sum(A2)
by occ_563:gen A_work563=A3/weightsum_563



*B*

sort tucaseid start_time stop_time
gen B1=work if start_time>=8 & stop_time<=17 
bysort tucaseid:egen B2=sum(B1)
replace B2=B2*tufnwgtp
bysort occ_563: egen B3=sum(B2)
by occ_563:gen B_work563=B3/weightsum_563

*C*
sort tucaseid start_time stop_time
gen C1=work if start_time>=17 & stop_time<=24 
bysort tucaseid:egen C2=sum(C1)
replace C2=C2*tufnwgtp
bysort occ_563: egen C3=sum(C2)
by occ_563:gen C_work563=C3/weightsum_563

*bunching ratio based on time spent on work , for 563 occ category*

by occ_563: gen bratio_work563=B_work563/(A_work563+B_work563+C_work563)



keep occ_563 occ_563 bratio_work563 bratio_hcare563
duplicates drop occ_563 ,force 


egen bratio_s_work563_8to5pm= std(bratio_work563)

egen bratio_s_hcare563_8to5pm= std(bratio_hcare563)


rename bratio_hcare563 bratio_hcare563_8to5pm

rename bratio_work563 bratio_work563_8to5pm

save "./3b_br563.dta",replace
restore

clear

use "./3_data_#3.dta"
preserve 

 
merge m:1 occ_563 using "./3b_br563.dta"


save  "./3_data_#3.dta",replace
 
restore
clear
 
 
 
 
