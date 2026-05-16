

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
*for 22 OCCUPATIONS-householdcare
bysort occ_22: egen weightsum_22=sum(tufnwgtp)

*A*
sort tucaseid start_time stop_time
gen A1=householdcare if start_time>=0 & stop_time<=8
bysort tucaseid:egen A2=sum(A1)
replace A2=A2*tufnwgtp
bysort occ_22: egen A3=sum(A2)
by occ_22:gen A_hcare22=A3/weightsum_22

*B*

sort tucaseid start_time stop_time
gen B1=householdcare if start_time>=8 & stop_time<=17 
bysort tucaseid:egen B2=sum(B1)
replace B2=B2*tufnwgtp
bysort occ_22: egen B3=sum(B2)
by occ_22:gen B_hcare22=B3/weightsum_22

*C*
sort tucaseid start_time stop_time
gen C1=householdcare if start_time>=17 & stop_time<=24 
bysort tucaseid:egen C2=sum(C1)
replace C2=C2*tufnwgtp
bysort occ_22: egen C3=sum(C2)
by occ_22:gen C_hcare22=C3/weightsum_22

*bunching ratio based on time spent on householdcare , for 22 occ category*

by occ_22: gen bratio_hcare22=B_hcare22/(A_hcare22+B_hcare22+C_hcare22)


drop B1 B2 B3 A1 A2 A3 C1 C2 C3 

*for 22 OCCUPATIONS-work

*A*
sort tucaseid start_time stop_time
gen A1=work if start_time>=0 & stop_time<=8
bysort tucaseid:egen A2=sum(A1)
replace A2=A2*tufnwgtp
bysort occ_22: egen A3=sum(A2)
by occ_22:gen A_work22=A3/weightsum_22



*B*

sort tucaseid start_time stop_time
gen B1=work if start_time>=8 & stop_time<=17 
bysort tucaseid:egen B2=sum(B1)
replace B2=B2*tufnwgtp
bysort occ_22: egen B3=sum(B2)
by occ_22:gen B_work22=B3/weightsum_22

*C*
sort tucaseid start_time stop_time
gen C1=work if start_time>=17 & stop_time<=24 
bysort tucaseid:egen C2=sum(C1)
replace C2=C2*tufnwgtp
bysort occ_22: egen C3=sum(C2)
by occ_22:gen C_work22=C3/weightsum_22

*bunching ratio based on time spent on work , for 22 occ category*

by occ_22: gen bratio_work22=B_work22/(A_work22+B_work22+C_work22)



keep occ_22 occ_22 bratio_work22 bratio_hcare22
duplicates drop occ_22 ,force 


egen bratio_s_work22_8to5pm= std(bratio_work22)

egen bratio_s_hcare22_8to5pm= std(bratio_hcare22)


rename bratio_hcare22 bratio_hcare22_8to5pm

rename bratio_work22 bratio_work22_8to5pm

save "./3i_br22.dta",replace
restore

clear

use "./3_data_#3.dta"
preserve 

merge m:1 occ_22 using "./3i_br22.dta"

drop _merge
save  "./3_data_#3.dta",replace

restore
clear
 
 
 
 
