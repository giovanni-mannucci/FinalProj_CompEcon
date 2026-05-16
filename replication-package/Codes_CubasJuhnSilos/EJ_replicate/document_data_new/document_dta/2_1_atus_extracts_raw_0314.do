* this file creates extracts the ATUS files using the data dictionary and then merges them together. *
* I merge all the relevant atus files since the frequently used variables we want to keep are those from the respondent , cps and roster and activity files.


use "../../../Stata_Raw_Data/atusrost_raw_0314.dta"

preserve
merge 1:1 tucaseid tulineno using "../../../Stata_Raw_Data/atusresp_raw_0314.dta"

drop _merge 
merge 1:m tucaseid  using "../../../Stata_Raw_Data/1_atusact_raw_0314.dta"

drop _merge 
merge m:m tucaseid tulineno using "../../../Stata_Raw_Data/atuscps_raw_0314.dta"

drop _merge

save 2.1_atusact_extracts_raw_0314.dta,replace

