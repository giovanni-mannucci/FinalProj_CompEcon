* for each individual , create 6 activities. 



use "./f1.dta"

preserve

keep tucaseid 

duplicates drop tucaseid, force 

expand 6

egen hactivity= seq(),  f(1) t(6)

merge m:m tucaseid hactivity using f1.dta


keep tucaseid hactivity tustarttim tustoptime tuactdur24 trcodep trtier1p trtier2p 


save f2, replace 


restore

clear


**
