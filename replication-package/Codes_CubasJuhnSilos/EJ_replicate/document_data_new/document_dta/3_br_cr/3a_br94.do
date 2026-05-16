

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
/*browse if v!=24*/ 
drop yy y v

******************************************************************************
*for 94 OCCUPATIONS-householdcare
bysort occ_94: egen weightsum_94=sum(tufnwgtp)

*A*
sort tucaseid start_time stop_time
gen A1=householdcare if start_time>=0 & stop_time<=8
bysort tucaseid:egen A2=sum(A1)
replace A2=A2*tufnwgtp
bysort occ_94: egen A3=sum(A2)
by occ_94:gen A_hcare94=A3/weightsum_94

*B*

sort tucaseid start_time stop_time
gen B1=householdcare if start_time>=8 & stop_time<=17 
bysort tucaseid:egen B2=sum(B1)
replace B2=B2*tufnwgtp
bysort occ_94: egen B3=sum(B2)
by occ_94:gen B_hcare94=B3/weightsum_94

*C*
sort tucaseid start_time stop_time
gen C1=householdcare if start_time>=17 & stop_time<=24 
bysort tucaseid:egen C2=sum(C1)
replace C2=C2*tufnwgtp
bysort occ_94: egen C3=sum(C2)
by occ_94:gen C_hcare94=C3/weightsum_94

*bunching ratio based on time spent on householdcare , for 94 occ category*

by occ_94: gen bratio_hcare94=B_hcare94/(A_hcare94+B_hcare94+C_hcare94)


drop B1 B2 B3 A1 A2 A3 C1 C2 C3 

*for 94 OCCUPATIONS-work

*A*
sort tucaseid start_time stop_time
gen A1=work if start_time>=0 & stop_time<=8
bysort tucaseid:egen A2=sum(A1)
replace A2=A2*tufnwgtp
bysort occ_94: egen A3=sum(A2)
by occ_94:gen A_work94=A3/weightsum_94



*B*

sort tucaseid start_time stop_time
gen B1=work if start_time>=8 & stop_time<=17 
bysort tucaseid:egen B2=sum(B1)
replace B2=B2*tufnwgtp
bysort occ_94: egen B3=sum(B2)
by occ_94:gen B_work94=B3/weightsum_94

*C*
sort tucaseid start_time stop_time
gen C1=work if start_time>=17 & stop_time<=24 
bysort tucaseid:egen C2=sum(C1)
replace C2=C2*tufnwgtp
bysort occ_94: egen C3=sum(C2)
by occ_94:gen C_work94=C3/weightsum_94

*bunching ratio based on time spent on work , for 94 occ category*

by occ_94: gen bratio_work94=B_work94/(A_work94+B_work94+C_work94)



keep occ_94 occ_94 bratio_work94 bratio_hcare94
duplicates drop occ_94 ,force 


egen bratio_s_work94_8to5pm= std(bratio_work94)

egen bratio_s_hcare94_8to5pm= std(bratio_hcare94)


rename bratio_hcare94 bratio_hcare94_8to5pm

rename bratio_work94 bratio_work94_8to5pm

save "./3a_br94.dta",replace 
restore
preserve

merge m:1 occ_94 using "./3a_br94.dta"
 

drop _merge


save  "./3_data_#3.dta",replace 
restore 
clear

 
 

 

