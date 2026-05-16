
use "./2.1_atusact_extracts_raw_0314.dta"

keep if tulineno==1
duplicates drop tucaseid, force

*drop _merge
merge 1:m tucaseid tulineno using "../../../EJ_replicate_atus/1.2_data_#1.dta"

keep if _merge==3

save "./2.2_atus_data#1_merge.dta",replace
