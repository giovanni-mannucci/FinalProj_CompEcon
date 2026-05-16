clear
use 2_matrix.dta
drop if obsn==.

 ** covert into minutes and keep relevant variables
 sort tucaseid
 format tucaseid %20.0f 
 gen x = mint1
 gen mints =x/60
 egen z=group(id)
 sort z bin1 bin2
 keep tucaseid z trtier1p bin1 bin2 mints  
 egen dups=group(tucaseid trtier1p bin2 )
 duplicates drop dups,force

 drop dups

 save 3a_matrix.dta,replace
 **  create 24 bins for each individual and each activity.
 keep tucaseid
 duplicates drop tucaseid,force
 expand 17
 sort tucaseid
 expand 24
 sort tucaseid
 egen trtier1p= seq(),  f(1) t(17) b(24)
 egen bin2= seq(),  f(1) t(24) 

 gen mints2=.

 ** keep householdcare and work
 keep if trtier1p==3|trtier1p==5
 sort tucaseid trtier1p bin2


  save 3b_matrix.dta,replace 
 
  clear
 
  use 3a_matrix.dta
  ** keep householdcare and work
  keep if trtier1p==3|trtier1p==5
  drop if bin2==0
  save 3a_matrix.dta,replace
  clear
 
  use 3b_matrix
 
  ** merge with 3a_matrix to get actual time spent.
 
  merge m:m tucaseid trtier1p bin2 using 3a_matrix.dta
 
  drop _merge
 
  save 3_matrix_merged.dta,replace
  clear
 
  use 3_matrix_merged.dta
 
  ** the next few lines of code simply reshape the data. 
  replace mints=0 if mints==.
    drop mints2
  keep if trtier1p==3
  rename mints mints_hcare
  drop trtier1p
 
  save hcare19 ,replace
  clear
  use 3_matrix_merged.dta
 
 
  replace mints=0 if mints==.
  drop mints2
  keep if trtier1p==5
  drop trtier1p
  rename mints mints_work
  save work19,replace
 
  merge m:m tucaseid bin2 using hcare19
 gen n=_n
 seq id , f(1) t(134772) b(24)
 

  rename bin2 timebin 
  rename mints_work work
  rename mints_hcare householdcare
  gen tulineno=1
  gen start_time=timebin-1
  gen stop_time=start_time+1
  drop _merge bin1 z
  save 5_wrk_hcare_id.dta,replace
 
  * clear
 
 
  ** can compare final_wrk_hcare2019 with the original data: 7_final_wrk_hcare.dta created in matlab. values match. 

