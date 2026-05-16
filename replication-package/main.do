/*==========================================================
Giovanni Mannucci
14.05.26
Computation Economics
CCA

Replicating
"Coordinated Work Schedules and the Gender Wage Gap"
by G. Cubas, C. Juhn and P. Silos

main do file, substituting .zh file
==========================================================*/

cd "/Users/Gio/Desktop/CompEcon/FinalProj_CompEcon/replication-package/Codes_CubasJuhnSilos"

cap mkdir ./Stata_Raw_Data
cd "./Raw_Data/Get_Atus_Raw_Data"

clear
include "./atusact_raw_0314.do"
di "Done getting raw ATUS data"
clear
include "./atusresp_raw_0314.do"
di "Done getting raw ATUS data"
clear
include "./atusrost_raw_0314.do"
di "Done getting raw ATUS data"
clear
include "./atuscps_raw_0314.do"
di "Done getting raw ATUS data"
clear
include "./atus_weights.do"
di "Done getting raw ATUS data"
clear
include "./get_weights.do"
di "Done getting raw ATUS data"



cd "../Get_ACS_Raw_Data"
clear
include "./get_acs.do"
di "Done getting ACS data"


cd "../occ_labels"
clear
include "./import_occs_to_stata.do"
 
cd "../ONET/additional Onet characteristics"
clear
include "./do_additional_onet.do"

cd "../8_onet_characteristics"
clear
include "./do_10.do"


cd "../nonroutine_and_routine_onet"
include  "./dofile_rout.do"

cd "../Basic_5"
include  "./basic_five_merge.do"

cd "../../../"



********************************************
cd "./EJ_replicate_atus"
di "Getting activity by time bins by individual - this takes hours"
include "1_matrix.do"

// inclde "3_matrix.do"
// inclde "5_matrix.do"
// inclde "6_matrix.do"
//
// rm "./id1*"
// rm "./id2*"
// rm "./id3*"
// rm "./id4*"
// rm "./id5*"
// rm "./id*"
//
// cd ".."
//
// cd "./EJ_replicate/document_data_new/document_dta/"
// include "./2_1_atus_extracts_raw_0314.do"
// include "./2_2_atus_data_1_merge.do"
// include "./2_3_atus_data_1_occs.do"
// include "./2_4_data_2.do"




















