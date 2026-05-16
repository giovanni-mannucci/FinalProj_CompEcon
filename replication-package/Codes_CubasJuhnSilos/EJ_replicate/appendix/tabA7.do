 
use "../document_data_new/document_dta/5_data_#5.dta", clear

preserve

egen z=group(tucaseid tulineno)


keep if telfs<=2 & telfs >0
keep if teage>=18 & teage<=65

bysort tucaseid: egen worktot=sum(work)

duplicates drop z ,force

gen worker=1
gen female=tesex==2
gen coll=(peeduca>=43)
gen fulltime_worker=(trdpftpt==1)
gen coll_ft=(peeduca>=43 & trdpftpt==1)
gen work_diary=(trdpftpt==1 & worktot>0)

bysort occ_563: egen ft_wrker=sum(fulltime_worker)
bysort occ_563: egen occ_wt=sum(tufnwgtp)
bysort occ_563: egen pos_wrkdiary=sum(work_diary)


collapse (last) bratio_work563_8to5pm bratio_s_work563_8to5pm ft_wrker occ_wt pos_wrkdiary (mean) female coll [aw=tufnwgtp] , by(occ_563)
format bratio_work563_8to5pm bratio_s_work563_8to5pm %9.3f

drop if bratio_work563_8to5pm == .

export delimited "./data_for_tableA7.csv"

