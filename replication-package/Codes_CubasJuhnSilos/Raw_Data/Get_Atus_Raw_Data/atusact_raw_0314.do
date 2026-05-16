
	#delimit ;
 
* Edit the insheet statement to reference the data file on your computer.;

insheet
tucaseid
tuactivity_n
tuactdur24
tucc5
tucc5b
trtcctot_ln
trtcc_ln
trtcoc_ln
tustarttim
tustoptime
trcodep
trtier1p
trtier2p
tucc8
tucumdur
tucumdur24
tuactdur
tr_03cc57
trto_ln
trtonhh_ln
trtohh_ln
trthh_ln
trtnohh_ln
tewhere
tucc7
trwbelig
trtec_ln
tuec24
tudurstop

using "./atusact_0314.dat";

label variable tucaseid "ATUS Case ID (14-digit identifier)";
label variable tuactivity_n "Activity line number";
label variable tuactdur24 "Duration of activity in minutes (last activity truncated at 4:00 a.m.)";
label variable tucc5 "Was at least one of your own household children < 13 in your care during this activity?";
label variable tucc5b "Was at least one of your non-own household children < 13 in your care during this activity?";
label variable trtcctot_ln "Total time spent during activity providing secondary childcare for all children < 13 (in minutes)";
label variable trtcc_ln "Total time spent during activity providing secondary child care for household and own nonhousehold children < 13 (in minutes)";
label variable trtcoc_ln "Total time spent during activity providing secondary child care for nonown, nonhousehold children <13 (in minutes)";
label variable tustarttim "Activity start time";
label variable tustoptime "Activity stop time";
label variable trcodep "Pooled six-digit activity code";
label variable trtier1p "Pooled lexicon tier 1: 1st and 2nd digits of 6-digit activity code";
label variable trtier2p "Pooled lexicon tiers 1 and 2: 1st four digits of 6-digit activity code";
label variable tucc8 "Other than household or own non-household children < 13, was there a child 0-12 in your care during this activity?";
label variable tucumdur "Cumulative duration of activity lengths in minutes; last activity not truncated at 4:00am or 1440 minutes (cumulative total of TUACTDUR for each TUCASEID)";
label variable tucumdur24 "Cumulative duration of activity lengths in minutes; last activity truncated at 4:00am or 1440 minutes (cumulative total of TUACTDUR24 for each TUCASEID)";
label variable tuactdur "Duration of activity in minutes (last activity not truncated at 4:00 a.m.)";
label variable tr_03cc57 "Was a household or own non-household child < 13 in your care during this activity?";
label variable trto_ln "Total time spent during activity providing secondary childcare for own children < 13 (in minutes)";
label variable trtonhh_ln "Total time spent during activity providing secondary childcare for own nonhousehold children < 13 (in minutes)";
label variable trtohh_ln "Total time spent during activity providing secondary childcare for own household children < 13 (in minutes)";
label variable trthh_ln "Total time spent during activity providing secondary childcare for household children < 13 (in minutes)";
label variable trtnohh_ln "Total time spent during activity providing secondary childcare for nonown household children < 13 (in minutes)";
label variable tewhere "Edited: where were you during the activity?";
label variable tucc7 "Was at least one of your own non-household children < 13 in your care during this activity?";
label variable trwbelig "Flag identifying activities eligible for the Well-Being Module";
label variable trtec_ln "Time (in minutes) spent providing eldercare by activity";
label variable tuec24 "At which times or during which activities did you provide that care or assistance yesterday?";
label variable tudurstop "Method for reporting activity duration";
 
label define labeltewhere
-1 "Blank"
-2 "Don't Know"
-3 "Refused"
1 "Respondent's home or yard"
2 "Respondent's workplace"
3 "Someone else's home"
4 "Restaurant or bar"
5 "Place of worship"
6 "Grocery store"
7 "Other store/mall"
8 "School"
9 "Outdoors away from home"
10 "Library"
11 "Other place"
12 "Car, truck, or motorcycle (driver)"
13 "Car, truck, or motorcycle (passenger)"
14 "Walking"
15 "Bus"
16 "Subway/train"
17 "Bicycle"
18 "Boat/ferry"
19 "Taxi/limousine service"
20 "Airplane"
21 "Other mode of transportation"
30 "Bank"
31 "Gym/health club"
32 "Post Office"
89 "Unspecified place"
99 "Unspecified mode of transportation"
;
label define labeltucc5
-1 "Blank"
-2 "Don't Know"
-3 "Refused"
0 "No"
1 "Yes"
97 "No additional activities involved childcare"
;
label define labeltucc5b
-1 "Blank"
-2 "Don't Know"
-3 "Refused"
0 "No"
1 "Yes"
97 "No additional activities involved childcare"
;
label define labeltucc7
-1 "Blank"
-2 "Don't Know"
-3 "Refused"
0 "No"
1 "Yes"
97 "No additional activities involved childcare"
;
label define labeltucc8
-1 "Blank"
-2 "Don't Know"
-3 "Refused"
0 "No"
1 "Yes"
97 "No additional activities involved childcare"
;
label define labeltr_03cc57
-1 "Blank"
-2 "Don't Know"
-3 "Refused"
1 "At least one child < 13 was in respondent's care during activity"
;
label define labeltrwbelig
-1 "Blank"
-2 "Don't Know"
-3 "Refused"
0 "Activity not eligible for selection in the Well-Being Module"
1 "Activity eligible for selection in the Well-Being Module"
;
label define labeltuec24
-1 "Blank"
-2 "Don't Know"
-3 "Refused"
1 "Activity identified as eldercare"
96 "All day"
97 "No more activities"
;
label define labeltudurstop
-1 "Blank"
-2 "Don't Know"
-3 "Refused"
1 "Activity duration was entered"
2 "Activity stop time was entered"
;

label values tewhere   labeltewhere;
label values tucc5     labeltucc5;
label values tucc5b    labeltucc5b;
label values tucc7     labeltucc7;
label values tucc8     labeltucc8;
label values tr_03cc57 labeltr_03cc57;
label values trwbelig  labeltrwbelig;
label values tuec24    labeltuec24;
label values tudurstop labeltudurstop;



save "../../Stata_Raw_Data/1_atusact_raw_0314.dta";
