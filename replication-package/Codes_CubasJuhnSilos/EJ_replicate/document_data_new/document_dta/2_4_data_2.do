* **just keeps frequently used variables 

use "./2.3_atus_data#1_occs.dta"

keep trcodep teage prtage ttwk pespouse trtier1p trtier2p year tucaseid tulineno pulineno tesex peeduca  ptdtrace pehspnon prdthsp terrp trhhchild trchildnum trnhhchild trohhchild tryhhchild telfs trernwa trernhly teernhry temjot trdpftpt tehruslt tehrusl1 tehrusl2 teio1ocd trdtocc1 trmjocc1 trmjocgr teio1cow peio2ocd peio1ocd peio2cow teio1icd trdtind1 trimind1 trmjind1 hufaminc hefaminc  trcode trtier2 trcodep trtier1p trtier2p tewhere tuactdur24 tustarttim tustoptime tuelder tuecytd trtec trtec_ln trthh trthh_ln teschenr teschlvl teschft peeduca trsppres pemaritl tespempnot trspftpt tespuhrs tratusr tremodr trwbmodr trlvmodr tudiaryday tumonth tuyear tudiarydate trholiday hryear4   hrmonth tufnwgtp tubwgt gestfips gemetsta gtmetsta gereg householdcare work id timebin  start_time stop_time  occ_563 occ_94 occ_22 soc soc_2002 occ_563_orig trtcc 

label variable householdcare " time spent on hcare in each 1 hr bin"
label variable work " time spent on work in each 1 hr bin"
label variable start_time " starting time of bin"
label variable stop_time " stopping time of bin"

save "./2.4_data_#2.dta",replace

