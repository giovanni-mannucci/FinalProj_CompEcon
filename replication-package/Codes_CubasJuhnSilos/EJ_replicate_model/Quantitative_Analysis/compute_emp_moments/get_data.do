
use "../../../EJ_replicate/document_data_new/document_dta/2.4_data_#2.dta"

preserve 


keep tucaseid tulineno teage tehrusl1 tufnwgtp householdcare work timebin start_time stop_time occ_22 occ_94 occ_563 tesex trsppres pemaritl trhhchild trchildnum trnhhchild tryhhchild peeduca  tudiaryday tudiarydate

export delimited using "../data/2.4_data_#2_b", nolabel replace

clear

use "../../../EJ_replicate/document_data_new/document_dta/6_regression data/6_b_reg.dta"

export delimited using "../data/6_b_reg_april2019", nolabel replace

