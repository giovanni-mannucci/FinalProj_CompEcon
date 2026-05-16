use "../6_a.dta"

preserve


 
 * ******  male overwork 94
 
 * total college educated males in each occ
 gen b= (prtage >= 18 & prtage <= 65 & prhrusl >=3 & prhrusl <=6 & pesex==1 & peeduca >39)
 
 * total college educated males in each occ who work more than 50 hours. 
 gen a= (prtage >= 18 & prtage <= 65 & prhrusl >=3 & prhrusl ==6 & pesex==1 & peeduca >39)

 *male overwork94
 
 bysort occ_94: egen bb=sum(b)
 bysort occ_94: egen aa=sum(a)
 
 gen male_overwork94=aa/bb
 
duplicates drop occ_94,force 
 
 keep  occ_94  male_overwork94  
 
 save "./6.5_male_overwork94.dta",replace
 
 restore
 preserve 
 
 **** male overwork 563
 
 * total college educated males in each occ
 gen b= (prtage >= 18 & prtage <= 65 & prhrusl >=3 & prhrusl <=6 & pesex==1 & peeduca >39)
 
 * total college educated males in each occ who work more than 50 hours. 
 gen a= (prtage >= 18 & prtage <= 65 & prhrusl >=3 & prhrusl ==6 & pesex==1 & peeduca >39)

 
 
 bysort occ_563: egen bb1=sum(b)
 bysort occ_563: egen aa1=sum(a)
 
 gen male_overwork563=aa1/bb1
 
 
 duplicates drop occ_563,force 
 
 keep  occ_563   male_overwork563 
 
 save "./6.5_male_overwork563.dta",replace 
 
 
 restore
 preserve 
 
 
 **** male overwork 22
 
 * total college educated males in each occ
 gen b= (prtage >= 18 & prtage <= 65 & prhrusl >=3 & prhrusl <=6 & pesex==1 & peeduca >39)
 
 * total college educated males in each occ who work more than 50 hours. 
 gen a= (prtage >= 18 & prtage <= 65 & prhrusl >=3 & prhrusl ==6 & pesex==1 & peeduca >39)

 
 
 bysort occ_22: egen bb1=sum(b)
 bysort occ_22: egen aa1=sum(a)
 
 gen male_overwork22=aa1/bb1
 
 
 duplicates drop occ_22,force 
 
 keep  occ_22   male_overwork22 
 
 save "./6.5_male_overwork22.dta",replace 
 
 
 
 
 
 restore
 
 clear
 
 
