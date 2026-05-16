use "2_matrix.dta"

format tucaseid %15.0f
nsplit tucaseid, digits (4 10) gen ( year y)

keep tucaseid year id

duplicates drop tucaseid,force 
save "6_year_tucaseid.dta",replace 
