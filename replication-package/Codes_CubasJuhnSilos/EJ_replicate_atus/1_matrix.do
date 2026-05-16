clear
use "../Stata_Raw_Data/1_atusact_raw_0314.dta", clear



scalar N=_N
sort tucaseid trtier1p
by tucaseid:gen gap=trtier1p-trtier1p[_n-1]
expand gap if gap>1

replace trtier1p=17 if trtier1p==18
drop if trtier1p==50

gen original=_n<=scalar(N)
sort tucaseid trtier1p original
replace trtier1p=trtier1p[_n-1]+1 if original==0
 
* storing time in usable tc format*
 
gen starttim=clock(tustarttim,"hms")
format starttim %tcHH:MM:SS

gen stoptim=clock(tustoptim,"hms")
format stoptim %tcHH:MM:SS
 
 *replacing time values with 0 for activities that were not originally in the data *
 
replace tuactdur24=0 if original==0



 
 * analysing households who report for all the 24 hours
by tucaseid: egen time=total(tuactdur24)
gen hours=time/60
keep if hours==24
 
* create unique household identifier*
egen id=group(tucaseid)

replace starttim=tc(00:00:00) if original==0
replace stoptim=tc(00:00:00) if original==0

sort id starttim stoptim
replace stoptim=tc(04:00:00) if starttim[_n+1]==tc(04:00:00) & tuactdur24!=0
replace stoptim=24 if starttim[_n+1]==tc(04:00:00) & stoptim[_n-1]==24

replace stoptim=tc(04:00:00) if tuactdur!=tuactdur24 & tuactdur24 !=0 




preserve


**************************************************************************************************************************************************************




 forval j =  1/134772{
 * forval j = 1/30{
keep if id==`j' 
 scalar N=_N
 gen hr =tuactdur24/60
 gen hstop=hh(stoptim)
 gen string_hstop=string(hstop)
  gen clock_hstop=clock(string_hstop,"h")
   format clock_hstop %tcHH:MM:SS
   replace clock_hstop=tc(00:00:00) if hstop==24 & clock_hstop==.
   replace hr=2 if hr<=1 & hh(stoptim)!=hh(starttim) & stoptim>clock_hstop
 gen exp1=.
 forval i=1/23{
 replace exp1=round(hr)+1 if hr<`i'+.5 & hr>`i'
 replace exp1=round(hr) if hr>=`i'+.5 & hr<=`i'+1
 }
 
 expand exp1 if exp1 !=0, gen(orig)
  sort starttim stoptim orig
 by starttim: gen a=sum(orig)
 gen b =mm(stoptim)
 replace orig=2 if hr <=1
 replace orig =3 if a==exp1-1 & b>0 
 * this is to indicate the last stoptim of a subset of expanded observations*
 drop a b
 
 gen a =hh(starttim) if orig==0
 gen b =a+1
  gen string_b=string(b)
  gen clock_b=clock(string_b,"h")
   format clock_b %tcHH:MM:SS
   replace clock_b=tc(00:00:00) if b==24 & clock_b==.
    replace stoptim=clock_b if orig==0
	drop a b  string_b clock_b
	replace starttim=stoptim[_n-1] if orig[_n-1]==0
	replace starttim=tc(00:00:00) if starttim==.
	gen a =hh(starttim) if orig[_n-1]==0
	gen b =a+1
 gen string_b=string(b)
  gen clock_b=clock(string_b,"h")
   format clock_b %tcHH:MM:SS
   replace clock_b=tc(00:00:00) if b==24 & clock_b==.
   replace stoptim=clock_b if clock_b !=. & orig!=3
   
	gen hh=hh(stoptim)
	replace hh=24 if hh(stoptim)==0 & hh(starttim)==23 
	replace hh=0 if starttim==stoptim
	replace hh=1 if hh(starttim)==0 & hh(stoptim)==0 & starttim !=stoptim

   replace hh=hh[_n-1]+1 if orig==1 & orig[_n-1]==0 
   replace hh=hh[_n-1]+1 if orig==1 & orig[_n-1]==1
   gen dif=hh-24
   
  replace dif=. if dif<0
  replace hh =dif if dif !=. & dif>0
  

  
  
    drop a b   string_b clock_b
   gen b =string(hh)
   gen c= clock(b,"h")
   format c %tcHH:MM:SS
   replace c=tc(00:00:00) if hh==24 & c==.
   replace c=c[_n-1]+1 if c==. 
   replace stoptim=c if orig==1 & orig[_n-1]==1
   replace starttim=stoptim[_n-1] if orig==1 & orig[_n-1]==1
   replace starttim=stoptim[_n-1] if orig==3 & orig[_n-1]==1
   replace hh=24 if hh(stoptim)==0 & hh(starttim)==23 
	replace hh=0 if starttim==stoptim
	replace hh=1 if hh(starttim)==0 & hh(stoptim)==0 & starttim !=stoptim
   sort hh, stable
   sort stoptim starttim
   sort hh,stable
   *****************************************************************************************************
  replace starttim=stoptim[_n-1] if starttim !=stoptim[_n-1] & stoptim[_n-1]!=starttim[_n-1]
 
   
   
    gen a =stoptim-starttim
 format a %tcHH:MM:SS
 gen a_h=hh(a)
 gen a_hm=a_h*60
 gen a_m=mm(a)
 gen mint=a_m+a_hm
 
 gen gap2=(mint/60) if mint>60
 gen exp=.
 forval x=1/23{
 replace exp=round(gap2)+1 if gap2<`x'+.5 & gap2>`x'
 replace exp=round(gap2) if gap2>=`x'+.5 & gap2<=`x'+1
 }
 
 expand exp if exp!=., gen (abc)
 
  sort starttim stoptim abc 

 ************************************************************
 gen aa =hh(starttim) if abc==0 & abc[_n+1]==1
 gen bb =aa+1
 replace bb=bb[_n-1]+1 if abc==1 & abc[_n+1]==1
 gen string_bb=string(bb)
 gen clock_bb=clock(string_bb,"h")
 format clock_bb %tcHH:MM:SS
 replace clock_bb=tc(00:00:00) if bb==24 & clock_bb==.
 replace stoptim=clock_bb if abc==0 & abc[_n+1]==1|abc==1 & abc[_n+1]==1
 replace starttim=stoptim[_n-1] if abc==1 & abc[_n-1]==0|abc==1 & abc[_n-1]==1
 sort starttim,stable
 ***
 **
 ***
drop a a_m a_h a_hm mint 
 gen a =stoptim-starttim
 format a %tcHH:MM:SS
 gen a_h=hh(a)
 gen a_hm=a_h*60
 gen a_m=mm(a)
 gen mint=a_m+a_hm
 

 gen obsn=_n
 
 replace starttim=stoptim[_n-1] if starttim !=stoptim[_n-1] & mint!=0 & mint[_n-1]!=0 & obsn !=1
 

 sort hh, stable
 ******************************************************
  
 gen bin1=hh(starttim)
 gen bin2=hh(stoptim)
 *replace bin1=24 if starttim==tc(00:00:00) & stoptim==tc(01:00:00)
  replace bin2=bin1 +1 if bin1==bin2 & mint!=0
  *replace bin2=bin1+1 if starttim==tc(00:00:00) & stoptim==tc(01:00:00)
  replace bin2=24 if bin1==23 & bin2==0
 
 
 
 
 sort bin1 ,stable
 
 ****************************************************************************************
 by bin1:gen count1=_n
 by bin1:gen count2=_N
 egen saum=group(bin1 trtier1p)
 bysort saum:egen mint1=total(mint)

sort hh,stable

sort stoptim starttim

sort hh,stable
save "id`j'.dta", replace

*save id`j'

restore,preserve

}

clear

 
* once all the files are created, open id 1 and append using loop from 2 onwards.
use "id1.dta"
forval num= 2/134772{
* forval num = 2/30{
append using "id`num'.dta"
}

save "2_matrix.dta", replace



******************************************************************************************








