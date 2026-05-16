* NOTE: You need to set the Stata working directory to the path
* where the data file is located.

set more off

clear
quietly infix               ///
  long    year       1-5    ///
  double  caseid     6-19   ///
  byte    pernum     20-21  ///
  int     lineno     22-24  ///
  double  wt06       25-41  ///
  int     age        42-44  ///
  long    occ        45-49  ///
  int     uhrswork1  50-52  ///
  using `"atus_00005.dat"'


format caseid    %14.0f
format wt06      %17.0g

label var year      `"Survey year"'
label var caseid    `"ATUS Case ID"'
label var pernum    `"Person number (general)"'
label var lineno    `"Person line number"'
label var wt06      `"Person weight, 2006 methodology"'
label var age       `"Age"'
label var occ       `"Detailed occupation category, main job"'
label var uhrswork1 `"Hours usually worked per week at main job"'

label define pernum_lbl 01 `"1"'
label define pernum_lbl 02 `"2"', add
label define pernum_lbl 03 `"3"', add
label define pernum_lbl 04 `"4"', add
label define pernum_lbl 05 `"5"', add
label define pernum_lbl 06 `"6"', add
label define pernum_lbl 07 `"7"', add
label define pernum_lbl 08 `"8"', add
label define pernum_lbl 09 `"9"', add
label define pernum_lbl 10 `"10"', add
label define pernum_lbl 11 `"11"', add
label define pernum_lbl 12 `"12"', add
label define pernum_lbl 13 `"13"', add
label define pernum_lbl 14 `"14"', add
label define pernum_lbl 15 `"15"', add
label define pernum_lbl 16 `"16"', add
label values pernum pernum_lbl

label define lineno_lbl 001 `"1"'
label define lineno_lbl 002 `"2"', add
label define lineno_lbl 003 `"3"', add
label define lineno_lbl 004 `"4"', add
label define lineno_lbl 005 `"5"', add
label define lineno_lbl 006 `"6"', add
label define lineno_lbl 007 `"7"', add
label define lineno_lbl 008 `"8"', add
label define lineno_lbl 009 `"9"', add
label define lineno_lbl 010 `"10"', add
label define lineno_lbl 011 `"11"', add
label define lineno_lbl 012 `"12"', add
label define lineno_lbl 013 `"13"', add
label define lineno_lbl 014 `"14"', add
label define lineno_lbl 015 `"15"', add
label define lineno_lbl 016 `"16"', add
label define lineno_lbl 017 `"17"', add
label define lineno_lbl 018 `"18"', add
label define lineno_lbl 019 `"19"', add
label define lineno_lbl 999 `"NIU (Not in universe)"', add
label values lineno lineno_lbl


rename caseid tucaseid
rename lineno tulineno

save "../../Stata_Raw_Data/weight_atus.dta", replace
