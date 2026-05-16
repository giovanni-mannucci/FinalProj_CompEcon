* merges spouse data with data  3 * 
* this is basically the data set with information on spouse, bunching ratios as well as householdcare and work *



use "./3_br_cr/3_data_#3.dta"

preserve

sort tucaseid tulineno

merge m:m tucaseid tulineno using "./4_spouses.dta"

save "./5_data_#5.dta", replace
