rm(list=ls())

pathtotables = "./"


# ------------------------------------------------------------------------
#  Table 4 
# ------------------------------------------------------------------------
unlink(paste0(pathtotables,"table4.tex"),recursive=F,force=F)
tabfile = paste0(pathtotables,"table4.tex")

table_4_numbers <- read.csv('./table_4_numbers.csv')
data <- table_4_numbers$V1

write(sprintf("\\def\\sep{0.5em}"),file=tabfile,append=T)
write(sprintf("\\begin{table}[!htbp]"),file=tabfile,append=T)
write(sprintf("\\centering {"),file=tabfile,append=T)
write(sprintf("\\caption{Correlations between Importance of Occupational Characteristics and Ratio8to5}\\label{table4}"),file=tabfile,append=T)
write(sprintf(" \\scalebox{0.8}{"),file=tabfile,append=T)
write(sprintf(""),file=tabfile,append=T)
write(sprintf("\\small\\begin{tabular}{clc}\\\\"),file=tabfile,append=T)
write(sprintf("\\hline"),file=tabfile,append=T)
write(sprintf("& &\\\\"),file=tabfile,append=T)
write(sprintf("$\\#$Cat.&Name: O*NET Characteristic& Corr. Coeff.\\\\[\\sep]"),file=tabfile,append=T)
write(sprintf("\\hline"),file=tabfile,append=T)
write(sprintf("1&Assisting and caring for others & %.4f\\sym{*}\\\\[\\sep]", data[1]),file=tabfile,append=T)
write(sprintf("2&Coaching and developing others &%.4f\\\\[\\sep]", data[2]),file=tabfile,append=T)
write(sprintf("3&Developing\\_and\\_Building\\_Teams &%.4f\\\\[\\sep]", data[3]),file=tabfile,append=T)
write(sprintf("4&Establishing\\_and\\_Maintaining\\_Interpersonal\\_Relationships &%.4f\\sym{*}\\\\[\\sep]", data[4]),file=tabfile,append=T)
write(sprintf("5&Face-to-Face\\_Discussions &%.4f\\sym{*}\\\\[\\sep]",data[5]),file=tabfile,append=T)
write(sprintf("7&Social orientation &%.4f\\\\[\\sep]",data[6]),file=tabfile,append=T)
write(sprintf("8&Training\\_and\\_Teaching\\_Others &%.4f\\\\[\\sep]",data[7]),file=tabfile,append=T)
write(sprintf("10&Guiding\\_Directing\\_and\\_Motivating\\_Subordinates &%.4f\\\\[\\sep]",data[8]),file=tabfile,append=T)
write(sprintf(""),file=tabfile,append=T)
write(sprintf("\\hline"),file=tabfile,append=T)
write(sprintf("& &\\\\"),file=tabfile,append=T)
write(sprintf("&Concentration Index                                 &%.4f\\sym{*}\\\\[\\sep]",data[9]),file=tabfile,append=T)
write(sprintf("&Male Overwork                                       &%.4f\\sym{*}\\\\",data[10]),file=tabfile,append=T)
write(sprintf("& &\\\\"),file=tabfile,append=T)
write(sprintf("\\hline"),file=tabfile,append=T)
write(sprintf("& &\\\\"),file=tabfile,append=T)
write(sprintf("$\\#$Cat.&Name: O*NET Skill Measures& Corr. Coeff.\\\\[\\sep]"),file=tabfile,append=T)
write(sprintf("\\hline"),file=tabfile,append=T)
write(sprintf("1&Social Skills &%.4f\\sym{*}\\\\[\\sep]",data[11]),file=tabfile,append=T)
write(sprintf("2&Abstract Skills &%.4f\\sym{*}\\\\[\\sep]",data[12]),file=tabfile,append=T)
write(sprintf("3&Manual Skills &%.4f\\sym{*}\\\\[\\sep]",data[13]),file=tabfile,append=T)
write(sprintf("4&Routine Skills &%.4f\\sym{*}\\\\[\\sep]",data[14]),file=tabfile,append=T)
write(sprintf("\\hline"),file=tabfile,append=T)
write(sprintf("\\multicolumn{3} {p{6in}} { {\\footnotesize{"),file=tabfile,append=T)
write(sprintf("Notes:"),file=tabfile,append=T)
write(sprintf("The"),file=tabfile,append=T)
write(sprintf("table shows correlations between our standardized Ratio8to5 and O*NET"),file=tabfile,append=T)
write(sprintf("occupational characteristics for 434 detailed Census 2002 occupations."),file=tabfile,append=T)
write(sprintf("Ratio8to5 is the ratio of total hours worked by all full-time workers"),file=tabfile,append=T)
write(sprintf("during the hours 8 a.m. to 5 p.m. relative to total hours worked in"),file=tabfile,append=T)
write(sprintf("each occupation category in the ATUS time diary data. See Appendix for"),file=tabfile,append=T)
write(sprintf("the detailed definitions of the O*NET"),file=tabfile,append=T)
write(sprintf("characteristics, as well as for details on the variables used and for"),file=tabfile,append=T)
write(sprintf("matching across O*NET Standard Occupation Codes (SOC) and 2002 Census"),file=tabfile,append=T)
write(sprintf("occupation codes. (*) denotes"),file=tabfile,append=T)
write(sprintf("significance at the 5\\%% level.  }}}"),file=tabfile,append=T)
write(sprintf("\\end{tabular}"),file=tabfile,append=T)
write(sprintf("}}"),file=tabfile,append=T)
write(sprintf("\\end{table}"),file=tabfile,append=T)


# This code populates the latex tables with model-related output.
# get data from model_output directory 
pathtofiles = "../Quantitative_Analysis/model_output"
pathtosect4 <- "../Sect_4_Simple_Case_code"

# ------------------------------------------------------------------------
#  Table 5
# ------------------------------------------------------------------------
unlink(paste0(pathtotables,"table5.tex"),recursive=F,force=F)
tabfile = paste0(pathtotables,"table5.tex")

simple_homog <- read.csv(paste0(pathtosect4,'/results_simple_case_no_gender.txt'))
simple_diff_nu <- read.csv(paste0(pathtosect4,'/results_simple_case_gender_diff_nu.txt'))
simple_tastes <- read.csv(paste0(pathtosect4,'/results_simple_case_tastes.txt'))
 
write(sprintf("\\begin{table}[ht]"),file=tabfile,append=T)
write(sprintf("\\centering"),file=tabfile,append=T)
write(sprintf("\\caption{A Simple Case with Gender Differences} \\label{table7}"),file=tabfile,append=T)
write(sprintf("\\scalebox{0.85}{"),file=tabfile,append=T)
write(sprintf("\\begin{tabular}{lccccccc}  \\hline"),file=tabfile,append=T)
write(sprintf("\\\\"),file=tabfile,append=T)
write(sprintf("\\footnotesize{"),file=tabfile,append=T)
write(sprintf("Occupation}          & \\footnotesize{$\\%%$ Workers}&\\footnotesize{Bunching Ratio}   &\\footnotesize{Earnings}   &\\footnotesize{$l_1+l_2$}&  \\footnotesize{$l$}   & \\footnotesize{$\\%%$ Females}& \\footnotesize{E. Gap}\\\\ \\\\"),file=tabfile,append=T)
write(sprintf("(1)                 & (2)         &       (3)       &  (4)   &(5)      &  (6)   & (7)&(8)\\\\"),file=tabfile,append=T)

write(sprintf("\\hline\\\\\\\\"),file=tabfile,append=T)

               write(sprintf("       \\multicolumn{8}{l}{\\footnotesize Panel A: No Gender Differences}\\\\"),file=tabfile,append=T)
write(sprintf("\\hline\\\\"),file=tabfile,append=T)
write(sprintf("1              & %.2f      &  %.2f     &  %.2f      &   %.2f &  %.2f  &             & \\\\", simple_homog$V1[1], simple_homog$V1[2], simple_homog$V1[3], simple_homog$V1[4], simple_homog$V1[5] ),file=tabfile,append=T)
write(sprintf("2              & %.2f       &  %.2f      &  %.2f       &   %.2f &  %.2f  &           &\\\\",simple_homog$V2[1], simple_homog$V2[2], simple_homog$V2[3], simple_homog$V2[4], simple_homog$V2[5] ),file=tabfile,append=T)
write(sprintf(" \\hline \\\\"),file=tabfile,append=T)

write(sprintf("                      \\multicolumn{8}{l}{\\footnotesize Panel B: Gender-Specific"),file=tabfile,append=T)
write(sprintf("				  $\nu$}\\\\"),file=tabfile,append=T)
write(sprintf("\\hline\\\\"),file=tabfile,append=T)
write(sprintf("1              & %.2f       &  %.2f      &  %.2f       &   %.2f &  %.2f  & %.0f           &\\\\", simple_diff_nu$V1[3],simple_diff_nu$V1[4],simple_diff_nu$V1[5],simple_diff_nu$V1[6], simple_diff_nu$V1[7],simple_diff_nu$V1[8]*100),file=tabfile,append=T)
write(sprintf("2              & %.2f       &  %.2f      &  %.2f       &   %.2f &  %.2f &%.0f         & %.3f \\\\", simple_diff_nu$V2[3],simple_diff_nu$V2[4],simple_diff_nu$V2[5],simple_diff_nu$V2[6], simple_diff_nu$V2[7],simple_diff_nu$V2[8]*100, simple_diff_nu$V2[2]),file=tabfile,append=T)
write(sprintf("\\\\"),file=tabfile,append=T)
write(sprintf("Gender Earnings Gap  &\\multicolumn{7}{l}{%.3f}\\\\", simple_diff_nu$V1[1]),file=tabfile,append=T)
write(sprintf("\\hline \\\\\\\\"),file=tabfile,append=T)

write(sprintf("                      \\multicolumn{8}{l}{\\footnotesize Panel C: Gender-Specific"),file=tabfile,append=T)
write(sprintf("					  $\\nu$ and Tastes}\\\\"),file=tabfile,append=T)
write(sprintf("\\hline\\\\"),file=tabfile,append=T)
write(sprintf("1              & %.2f       &  %.2f      &  %.2f       &   %.2f  &  %.2f   & %.0f    & %.3f       \\\\", simple_tastes$V1[5], simple_tastes$V1[3], simple_tastes$V1[6],simple_tastes$V1[7],simple_tastes$V1[8],simple_tastes$V1[4]*100 , simple_tastes$V1[2] ),file=tabfile,append=T)
write(sprintf("2              & %.2f       &  %.2f      &  %.2f       &   %.2f  &  %.2f   & %.0f    &%.3f      \\\\", simple_tastes$V2[5], simple_tastes$V2[3], simple_tastes$V2[6],simple_tastes$V2[7],simple_tastes$V2[8],simple_tastes$V2[4]*100 , simple_tastes$V2[2] ),file=tabfile,append=T)
write(sprintf("\\\\"),file=tabfile,append=T)
write(sprintf("Gender Earnings Gap  &\\multicolumn{7}{l}{%.3f}",simple_tastes$V1[1]),file=tabfile,append=T)
write(sprintf("\\\\"),file=tabfile,append=T)
write(sprintf("\\hline"),file=tabfile,append=T)
write(sprintf("\\\\"),file=tabfile,append=T)
write(sprintf("\\multicolumn{8} {p{6.8in}} { {\\footnotesize{"),file=tabfile,append=T)

write(sprintf("}}}"),file=tabfile,append=T)
write(sprintf("\\end{tabular}"),file=tabfile,append=T)
write(sprintf("}"),file=tabfile,append=T)
write(sprintf("\\end{table}"),file=tabfile,append=T)

# ------------------------------------------------------------------------
#  Table 8 
# ------------------------------------------------------------------------

unlink(paste0(pathtotables,"table8.tex"),recursive=F,force=F)
tabfile = paste0(pathtotables,"table8.tex")

occ_labels <- readLines('../../Raw_Data/occ_labels_22')


lshvec <- scan('../Quantitative_Analysis/data/labor_shares_22occ_may.txt')
 # share of females
 share_fem <- scan('../Quantitative_Analysis/data/share_fem_occ_22occs_may.txt')
 # bunching ratios
 brw_data <- scan('../Quantitative_Analysis/data/br_w_22_may19.txt')
 brh_data <- scan('../Quantitative_Analysis/data/br_hh_22_may19.txt')
 #-------------------------------------------------
 aver_earn_data <- read.csv('../Quantitative_Analysis/data/mean_earn_ph_occ_all_22occs_may.txt')
 aver_earn_data <- aver_earn_data$mean_earn_ph_occ
 aver_earn_data <- aver_earn_data/aver_earn_data[1]
write(sprintf("\\def\\sep{0.5em}"),file=tabfile,append=T)
write(sprintf("\\def\\fns{\\footnotesize}"),file=tabfile,append=T)
write(sprintf("\\begin{table}[htbp]\\centering"),file=tabfile,append=T)
write(sprintf(" \\caption{Moments} \\label{table8}"),file=tabfile,append=T)
write(sprintf(" \\scalebox{0.65}{"),file=tabfile,append=T)
write(sprintf("\\begin{tabular}{c l c c c c}"),file=tabfile,append=T)
write(sprintf("\\hline"),file=tabfile,append=T)
write(sprintf("&       &    &        &\\\\"), file=tabfile, append=T)
write(sprintf(" Occupation no. & Occupation &Labor Share& $8to5ratio$ & Av.Earn.
			  Per Hour& $\\%%$ Fem.\\\\"), file=tabfile, append=T) 
write(sprintf("& &    &        &\\\\"),file=tabfile,append=T)

write(sprintf("\\hline & &    &        &\\\\"),file=tabfile,append=T)
for (k in seq(1,22)){
	write(sprintf(" %d & %s & %.3f & %.3f & %.2f & %.2f \\\\[\\sep]", k, occ_labels[k],lshvec[k],brw_data[k],aver_earn_data[k],share_fem[k]),file=tabfile, append=T)

}
write(sprintf("\\bottomrule \\multicolumn{6} {p{9in}} {{\\footnotesize{Note: The table presents the occupational level moments we use in our calibration. Labor shares are calculated by dividing the total earnings of workers in each occupation by the total mass of earnings in the sample. The $8to5ratio$ is our measure of coordination using time use data obtained as we explain in the text. We also report the average earnings per hour of workers in each of the occupations ($Av. Earn. Per Hour$) and the share of females in the total number of workers in each occupation ($\\%% Fem.$).}}}
\\end{tabular}"), file=tabfile, append=T)
write(sprintf("}"),file=tabfile, append=T)

write(sprintf("\\end{table}"),file=tabfile, append=T)


# ------------------------------------------------------------------------
#  Table 9 
# ------------------------------------------------------------------------

unlink(paste0(pathtotables,"table9.tex"),recursive=F,force=F)
tabfile = paste0(pathtotables,"table9.tex")

# load additional moments from model
zdata <- read.csv(paste0(pathtofiles,'/additional_model_output.txt'), header=F)
model_fit_measure <- scan('../Quantitative_Analysis/model_output/model_fit_measure')
# data moments hours worked
hours_worked <- read.csv('../Quantitative_Analysis/data/mean_work_hours_gender_22occs_may.txt',
						 header=T)
# empirical bunching ratios work and care
brw_data <- scan('../Quantitative_Analysis/data/br_w_22_may19.txt')
brh_data <- scan('../Quantitative_Analysis/data/br_hh_22_may19.txt')
# find average brw to average brh in data
mean_brw_brh <- mean(brw_data)/mean(brh_data)
brw_f <- read.csv('../Quantitative_Analysis/data/br_6_f.csv')
brw_m <- read.csv('../Quantitative_Analysis/data/br_6_m.csv')

brw_f <- brw_f$br8to5_work_all
brw_m <- brw_m$br8to5_work_all


write(sprintf("\\def\\sep{0.5em}"),file=tabfile, append=T)
write(sprintf("\\def\\fns{\\footnotesize}"),file=tabfile, append=T)
write(sprintf("\\begin{table}[htbp]\\centering"),file=tabfile, append=T)
write(sprintf("\\caption{Model Fit}"),file=tabfile, append=T)
write(sprintf("\\label{table9}"),file=tabfile, append=T)
write(sprintf("\\scalebox{0.81}{"),file=tabfile, append=T)
write(sprintf("\\begin{tabular}{l  c c}"),file=tabfile, append=T)
write(sprintf("\\hline"),file=tabfile, append=T)

write(sprintf("                 &                   &\\\\[\\sep]"),file=tabfile, append=T)


write(sprintf("\\multicolumn{3} {l} {Panel A: Occupational-level Moments}\\\\[\\sep]"),file=tabfile, append=T)
write(sprintf("\\hline"),file=tabfile, append=T)
 write(sprintf("               &                   &\\\\"),file=tabfile, append=T)

write(sprintf("\\multicolumn{2} {l} {Moment}     &Correlation Coeff. Model-Data\\\\"),file=tabfile, append=T)
write(sprintf("\\hline"),file=tabfile, append=T)
write(sprintf("\\multicolumn{2} {l} {$8to5ratio$}                & %.2f   \\tabularnewline [\\sep]",  round(zdata$V2[8],digits=2)),file=tabfile, append=T)
write(sprintf("\\multicolumn{2} {l} {Average Earnings Per Hour}  &  %.2f\\tabularnewline [\\sep]", round(zdata$V2[11],digits=2)),file=tabfile, append=T)
write(sprintf("\\multicolumn{2} {l} {$\\%%$ Females}  & %.2f \\tabularnewline [\\sep]",round(zdata$V2[14],digits=2)  ),file=tabfile, append=T)
write(sprintf("\\multicolumn{2} {l} {Occupational Shares} &  %.2f \\tabularnewline
			  [\\sep]", round(zdata$V2[10],digits=2)),file=tabfile, append=T)

write(sprintf("\\hline"),file=tabfile, append=T)
write(sprintf("                  &                   &\\\\[\\sep]"),file=tabfile, append=T)
write(sprintf("\\multicolumn{3} {l} {Panel B: Economy-wide Moments}\\\\[\\sep]"),file=tabfile, append=T)
write(sprintf("\\hline"),file=tabfile, append=T)
write(sprintf("               &                   &\\\\"),file=tabfile, append=T)
write(sprintf(" Moment                                      & Data    & Model \\tabularnewline"),file=tabfile, append=T)
write(sprintf(" \\hline"),file=tabfile, append=T)

write(sprintf(" Ratio Hours Worked Male-Female        & %.2f & %.2f \\tabularnewline
			  [\\sep]",
			  round(hours_worked$mean_work_hours_mal[1]/hours_worked$mean_work_hours_fem[1],digits=1), round(zdata$V2[31],digits=2)  ),file=tabfile, append=T)
write(sprintf(" $ratio8to5$ Work/$ratio8to5$ Household Care & %.2f  &  %.2f
			  \\tabularnewline [\\sep]", round(mean_brw_brh,digits=2), round(zdata$V2[29],digits=2)),file=tabfile, append=T)
write(sprintf(" \\hline"),file=tabfile, append=T)
write(sprintf("                   &                   &\\\\[\\sep]"),file=tabfile, append=T)

write(sprintf(" \\multicolumn{3} {l} {Panel C: Overall Measure of Fit}\\\\[\\sep]"),file=tabfile, append=T)
write(sprintf(" \\hline"),file=tabfile, append=T)
write(sprintf("                &                   &\\\\"),file=tabfile, append=T)

write(sprintf(" Average Absolute \\%% Deviation (Model-Data)
			  & %.2f \\%%  &  \\tabularnewline [\\sep]",
			  round(model_fit_measure,digits=1)),file=tabfile, append=T)

write(sprintf("    \\multicolumn{3} {l} {Panel D: Non-Targeted Moments}\\\\[\\sep]"),file=tabfile, append=T)
write(sprintf(" \\hline"),file=tabfile, append=T)
write(sprintf("                 &                   &\\\\"),file=tabfile, append=T)
write(sprintf(" Moment                                      & Data    & Model \\tabularnewline"),file=tabfile, append=T)
write(sprintf(" \\hline"),file=tabfile, append=T)
write(sprintf(" $ratio8to5$ Males  & %.2f & %.2f
			  \\tabularnewline[\\sep]",round(brw_m,digits=2), round(zdata$V2[25],digits=2)),file=tabfile, append=T)
write(sprintf(" $ratio8to5$ Females  & %.2f & %.2f
			  \\tabularnewline[\\sep]",round(brw_f,digits=2),
			  round(zdata$V2[26],digits=2)),file=tabfile, append=T)


write(sprintf(" \\hline \\multicolumn{3} {p{6.2in}}"),file=tabfile, append=T)
write(sprintf("             {{\\footnotesize{Note: The table shows the model fit by"),file=tabfile, append=T)
write(sprintf(" 				    comparing the value of the"),file=tabfile, append=T)
write(sprintf(" 				    targeted moments in the data and"),file=tabfile, append=T)
write(sprintf(" 				    in the model. In addition, Panel D shows the"),file=tabfile, append=T)
write(sprintf("                     values of non-targeted moments. For the"),file=tabfile, append=T)
write(sprintf(" 				    occupational-level moments"),file=tabfile, append=T)
write(sprintf("             we show their values in the data and in the model (Panel"),file=tabfile, append=T)
write(sprintf(" 	    A). For the economy-wide targeted moments we show in Panel"),file=tabfile, append=T)
write(sprintf(" 	    B, for each targeted moment, the correlation across"),file=tabfile, append=T)
	write(sprintf("     occupations between the value of the moments in the data"),file=tabfile, append=T)
	write(sprintf("     and in the model. The last line of the table gives an"),file=tabfile, append=T)
	write(sprintf("     overall measure of fit (average absolute percentage"),file=tabfile, append=T)
	write(sprintf("     deviation between model and data).}}}"),file=tabfile, append=T)
write(sprintf(" \\end{tabular}"),file=tabfile, append=T)
write(sprintf(" }"),file=tabfile, append=T)
write(sprintf(" \\end{table}"),file=tabfile, append=T)


# ------------------------------------------------------------------------
#  Table 10 
# ------------------------------------------------------------------------
unlink(paste0(pathtotables,"table10.tex"),recursive=F,force=F)
tabfile = paste0(pathtotables,"table10.tex")


paramvec <- scan('../Quantitative_Analysis/model_files/ces_param')
nocc <- 22
alpha_vec <- paramvec[1:nocc]
     taste_param <- paramvec[(nocc+1):(2*nocc)]
     
     tfpvec <- paramvec[(2*nocc+1):(3*nocc)]
     taste_males <- paramvec[(3*nocc+1):(4*nocc)]
 
     xi <- paramvec[(4*nocc+1)]
     theta_vec <- paramvec[(4*nocc+2):(length(paramvec))]

#	 for (k in seq(1,22)){
#	write(sprintf(" %d & %s & %f & %f & %f & %f \\\\[\\sep]", k, occ_labels[k],lshvec[k],brw_data[k],aver_earn_data[k],share_fem[k]),file=tabfile, append=T)
#
#}
#
#
write(sprintf("\\def\\sep{0.5em}"),file=tabfile, append=T)
write(sprintf("\\def\\fns{\\footnotesize}"),file=tabfile, append=T)
write(sprintf("\\begin{table}[htbp]\\centering"),file=tabfile, append=T)
 write(sprintf("\\caption{Parameter Values} \\label{table10}"),file=tabfile, append=T)
 write(sprintf("\\scalebox{0.78}{"),file=tabfile, append=T)
write(sprintf("\\begin{tabular}{c l c c c c c}"),file=tabfile, append=T)
write(sprintf("\\hline"),file=tabfile, append=T)
write(sprintf("        &                                         &           &            &      &        &\\\\[\\sep]"),file=tabfile, append=T)
write(sprintf("\\multicolumn{6} {l} {Panel A: Occupational-specific Parameters}\\\\[\\sep]"),file=tabfile, append=T)

write(sprintf("\\hline"),file=tabfile, append=T)
write(sprintf("               &                                  &           &         &     &        &       \\\\"),file=tabfile, append=T)
write(sprintf("Occupation no. & Occupation                       & $\\kappa$  & $\\alpha$& $A$ & $T_{f}$& $T_{m}$\\\\"),file=tabfile, append=T)
write(sprintf("\\hline"),file=tabfile, append=T)
write(sprintf("               &                                  &           &         &     &        &       \\\\[\\sep]"),file=tabfile, append=T)
	 for (k in seq(1,22)){
	write(sprintf(" %d & %s & %.3f & %.2f  &%.2f  &%.2f  & %.2f   \\\\[\\sep]", k, occ_labels[k],lshvec[k],alpha_vec[k],tfpvec[k],taste_param[k], taste_males[k]),file=tabfile, append=T)

}

write(sprintf("\\hline"),file=tabfile, append=T)
write(sprintf("        &                                         &           &        &      &      &    \\\\[\\sep]"),file=tabfile, append=T)
write(sprintf("\\multicolumn{7} {l} {Panel B: Rest of Parameters}\\\\[\\sep]"),file=tabfile, append=T)
write(sprintf("\\hline"),file=tabfile, append=T)
write(sprintf("        &                                         &           &            &     &&\\\\[\\sep]"),file=tabfile, append=T)
write(sprintf("\\multicolumn{2} {l} {$\\rho$}                      %.2f     &            &     &&\\\\[\\sep]", xi),file=tabfile, append=T)
write(sprintf("\\multicolumn{2} {l} {$\\nu_f$}                     %.2f    &            &    &&\\\\[\\sep]", theta_vec[2]),file=tabfile, append=T)
write(sprintf("\\multicolumn{2} {l} {$\\nu_m$}                     %.2f      &            &     &&\\\\[\\sep]", theta_vec[1]),file=tabfile, append=T)

write(sprintf("\\bottomrule \\multicolumn{7} {p{7.8in}} {{\\footnotesize{Note: Panel A shows the values of the parameters that are specific to the different occupations and Panel B the values obtained for the utility function, $\\nu_m$  and $\\nu_f$, for males and females, respectively. In addition, Panel B presents the value obtained for the parameter that governs the elasticity of substitution of the technology for household care, $\\rho$.}}}"),file=tabfile, append=T)
write(sprintf("\\end{tabular}"),file=tabfile, append=T)
write(sprintf("}"),file=tabfile, append=T)
write(sprintf("\\end{table}"),file=tabfile, append=T)

# ------------------------------------------------------------------------
#  Table 11
# ------------------------------------------------------------------------
unlink(paste0(pathtotables,"table11.tex"),recursive=F,force=F)
tabfile = paste0(pathtotables,"table11.tex")


reg_data_coeff <- read.csv('../Quantitative_Analysis/data/data_reg_table_coeffs.txt')
reg_data_se <- read.csv('../Quantitative_Analysis/data/data_reg_table_se.txt')


write(sprintf("\\begin{table}[!htbp]"),file=tabfile, append=T)
write(sprintf("\\centering {"),file=tabfile, append=T)
write(sprintf("\\caption{Regressions: Model vs. Data} \\label{table11}"),file=tabfile, append=T)
write(sprintf("\\scalebox{0.85}{"),file=tabfile, append=T)
write(sprintf("\\def\\sym#1{\\ifmmode^{#1}\\else\\(^{#1}\\)\\fi}"),file=tabfile, append=T)
write(sprintf("\\begin{tabular}{l*{2}{c}}"),file=tabfile, append=T)
write(sprintf("\\hline"),file=tabfile, append=T)
write(sprintf("                   & Data               & Model\\\\"),file=tabfile, append=T)
write(sprintf("\\hline\\"),file=tabfile, append=T)
write(sprintf("female              &     %.3f\\sym{***}  &      %.2f\\\\",reg_data_coeff$x[1],zdata$V2[3]),file=tabfile, append=T)
write(sprintf("                    &    (%.3f)         &",reg_data_se$x[1]),file=tabfile, append=T)
write(sprintf("         \\\\"),file=tabfile, append=T)
write(sprintf("[1em]"),file=tabfile, append=T)
write(sprintf("ratio8to5           &       %.3f\\sym{***} &      %.2f        \\\\",reg_data_coeff$x[2],zdata$V2[2]),file=tabfile, append=T)
write(sprintf("                    &    (%.3f)         &",reg_data_se$x[2]),file=tabfile, append=T)
write(sprintf("         \\\\"),file=tabfile, append=T)
write(sprintf("[1em]"),file=tabfile, append=T)
write(sprintf("femaleXratio8to5    &     %.3f\\sym{***}  &     %.2f\\\\",reg_data_coeff$x[3],zdata$V2[4]),file=tabfile, append=T)
write(sprintf("                    &    (%.3f)         &",reg_data_se$x[3]),file=tabfile, append=T)
write(sprintf("         \\\\"),file=tabfile, append=T)
write(sprintf("\\hline"),file=tabfile, append=T)
write(sprintf("\\multicolumn{3} {p{4.4in}} { {\\footnotesize{"),file=tabfile, append=T)
write(sprintf(" Standard errors in parentheses. \\sym{*} \\(p<.10\\), \\sym{**} \\(p<.05\\), \\sym{***} \\(p<.01\\). Note: This table shows the estimates of the regression using individual data for married workers with children (column Data) for 22 occupations and the estimates of the same regression using data generated by the model in its baseline calibration (column Model). The dependent variable is earnings per hour."),file=tabfile, append=T)
write(sprintf("}}}"),file=tabfile, append=T)

write(sprintf("\\end{tabular}"),file=tabfile, append=T)
write(sprintf("}}"),file=tabfile, append=T)
write(sprintf("\\end{table}"),file=tabfile, append=T)



# ------------------------------------------------------------------------
#  Table 12
# ------------------------------------------------------------------------
unlink(paste0(pathtotables,"table12.tex"),recursive=F,force=F)
tabfile = paste0(pathtotables,"table12.tex")

data_decomp <- scan('../Quantitative_Analysis/data/empirical_decomp_gender_gap')*100
baseline_decomp <- scan('../Quantitative_Analysis/model_output/decomp_gender_gap_BASELINE')*100
baseline_decomp_sorting <- scan('../Quantitative_Analysis/model_output/decomp_gender_gap_sorting_BASELINE')*100
equal_alpha_decomp <-  scan('../Quantitative_Analysis/model_output/decomp_gender_gap_Same_alpha_(healthcare_support)')*100
equal_alpha_decomp_sorting <-  scan('../Quantitative_Analysis/model_output/decomp_gender_gap_sorting_Same_alpha_(healthcare_support)')*100
similar_pref_decomp <- scan('../Quantitative_Analysis/model_output/decomp_gender_gap_Smaller_differences_preferences')*100
similar_pref_decomp_sorting <- scan('../Quantitative_Analysis/model_output/decomp_gender_gap_sorting_Smaller_differences_preferences')*100
increase_rho_decomp <- scan('../Quantitative_Analysis/model_output/decomp_gender_gap_Alternative_eos_home_care')*100
increase_rho_decomp_sorting <- scan('../Quantitative_Analysis/model_output/decomp_gender_gap_sorting_Alternative_eos_home_care')*100


write(sprintf("\\def\\sep{0.5em}"),file=tabfile, append=T)
write(sprintf("\\def\\fns{\\footnotesize}"),file=tabfile, append=T)
write(sprintf("\\begin{table}[htbp]\\centering"),file=tabfile, append=T)
write(sprintf("\\caption{Gender Earnings Gap (\\%%)}"),file=tabfile, append=T)
write(sprintf("\\label{table12}"),file=tabfile, append=T)
write(sprintf("\\scalebox{0.99}{"),file=tabfile, append=T)
write(sprintf("\\begin{tabular}{l  c c c c}"),file=tabfile, append=T)
write(sprintf("\\toprule"),file=tabfile, append=T)
              write(sprintf("		      & Overall & Between & Between & Within \\\\[\\sep]"),file=tabfile, append=T)
			 write(sprintf("     &         &        & (Sorting)&"),file=tabfile, append=T)
	write(sprintf("		      \\\\[\\sep]"),file=tabfile, append=T)
 write(sprintf("                \\hline"),file=tabfile, append=T)
write(sprintf("\\midrule"),file=tabfile, append=T)


write(sprintf("Data                          &  %.1f  &  %.1f& - &  %.1f \\\\[\\sep]", data_decomp[1], data_decomp[2], data_decomp[3]),file=tabfile, append=T)
write(sprintf("Baseline                      &  %.1f  &  %.1f& - &  %.1f   \\\\[\\sep]",baseline_decomp[1],baseline_decomp[2], baseline_decomp[3] ),file=tabfile, append=T)
write(sprintf("Equal $\\alpha$ ($\\alpha$ $=$ 2.72)  &  %.1f  &  %.1f& %.1f &  %.1f  \\\\[\\sep]", equal_alpha_decomp[1],equal_alpha_decomp[2],equal_alpha_decomp_sorting[2],equal_alpha_decomp[3]),file=tabfile, append=T)
write(sprintf("50\\%% Drop in $\\nu_m-\\nu_f$     &  %.1f  &  %.1f& %.1f &  %.1f  \\\\[\\sep]", similar_pref_decomp[1], similar_pref_decomp[2],similar_pref_decomp_sorting[2], similar_pref_decomp[3]),file=tabfile, append=T)
write(sprintf("Increase in $\\rho$            &  %.1f  &  %.1f& %.1f &  %.1f   \\\\[\\sep]", increase_rho_decomp[1], increase_rho_decomp[2], increase_rho_decomp_sorting[2], increase_rho_decomp[3]),file=tabfile, append=T)

write(sprintf("\\bottomrule "),file=tabfile, append=T)
write(sprintf("\\end{tabular}"),file=tabfile, append=T)
write(sprintf("}"),file=tabfile, append=T)
write(sprintf("\\end{table}"),file=tabfile, append=T)

# -------------------------------------------------------------------------------------
# Table A10
# -------------------------------------------------------------------------------------

unlink(paste0(pathtotables,"tableA10.tex"),recursive=F,force=F)
tabfile = paste0(pathtotables,"tableA10.tex")

# load additional moments from model
zdata <- scan(paste0(pathtofiles,'/earnph_regression_Equal_taste_distrib_males_and_females'))

reg_data_coeff <- read.csv('../Quantitative_Analysis/data/data_reg_table_coeffs.txt')
reg_data_se <- read.csv('../Quantitative_Analysis/data/data_reg_table_se.txt')


write(sprintf("\\begin{table}[!htbp]"),file=tabfile, append=T)
write(sprintf("\\centering {"),file=tabfile, append=T)
write(sprintf("\\caption{Regressions: Model vs. Data} \\label{table11}"),file=tabfile, append=T)
write(sprintf("\\scalebox{0.85}{"),file=tabfile, append=T)
write(sprintf("\\def\\sym#1{\\ifmmode^{#1}\\else\\(^{#1}\\)\\fi}"),file=tabfile, append=T)
write(sprintf("\\begin{tabular}{l*{2}{c}}"),file=tabfile, append=T)
write(sprintf("\\hline"),file=tabfile, append=T)
write(sprintf("                   & Data               & Model\\\\"),file=tabfile, append=T)
write(sprintf("\\hline\\"),file=tabfile, append=T)
write(sprintf("female              &     %.3f\\sym{***}
			  &      %.2f\\\\",reg_data_coeff$x[1],zdata[3]),file=tabfile, append=T)
write(sprintf("                    &    (%.3f)         &",reg_data_se$x[1]),file=tabfile, append=T)
write(sprintf("         \\\\"),file=tabfile, append=T)
write(sprintf("[1em]"),file=tabfile, append=T)
write(sprintf("ratio8to5           &       %.3f\\sym{***} &      %.2f
			  \\\\",reg_data_coeff$x[2],zdata[2]),file=tabfile, append=T)
write(sprintf("                    &    (%.3f)         &",reg_data_se$x[2]),file=tabfile, append=T)
write(sprintf("         \\\\"),file=tabfile, append=T)
write(sprintf("[1em]"),file=tabfile, append=T)
write(sprintf("femaleXratio8to5    &     %.3f\\sym{***}  &     %.2f\\\\",reg_data_coeff$x[3],zdata[4]),file=tabfile, append=T)
write(sprintf("                    &    (%.3f)         &",reg_data_se$x[3]),file=tabfile, append=T)
write(sprintf("         \\\\"),file=tabfile, append=T)
write(sprintf("\\hline"),file=tabfile, append=T)
write(sprintf("\\multicolumn{3} {p{4.4in}} { {\\footnotesize{"),file=tabfile, append=T)
write(sprintf(" Standard errors in parentheses. \\sym{*} \\(p<.10\\), \\sym{**} \\(p<.05\\), \\sym{***} \\(p<.01\\). Note: This table shows the estimates
 of the regression using individual data for married workers with children
 (column Data) and 22 occupations and the estimates of the same regression using data
 generated by the model when the taste distributions of males and
 females are equal (column Model). The dependent variable is earnings per hour.
"),file=tabfile, append=T)
write(sprintf("}}}"),file=tabfile, append=T)

write(sprintf("\\end{tabular}"),file=tabfile, append=T)
write(sprintf("}}"),file=tabfile, append=T)
write(sprintf("\\end{table}"),file=tabfile, append=T)

# -------------------------------------------------------------------------------------
# Table A11
# -------------------------------------------------------------------------------------

unlink(paste0(pathtotables,"tableA11.tex"),recursive=F,force=F)
tabfile = paste0(pathtotables,"tableA11.tex")

data_decomp <- scan('../Quantitative_Analysis/data/empirical_decomp_gender_gap')*100
equal_taste_decomp <- scan('../Quantitative_Analysis/model_output/decomp_gender_gap_Equal_taste_distrib_males_and_females')*100
equal_taste_decomp_sorting <- scan('../Quantitative_Analysis/model_output/decomp_gender_gap_sorting_Equal_taste_distrib_males_and_females')*100

write(sprintf("\\def\\sep{0.5em}"),file=tabfile, append=T)
write(sprintf("\\def\\fns{\\footnotesize}"),file=tabfile, append=T)
write(sprintf("\\begin{table}[htbp]\\centering"),file=tabfile, append=T)
write(sprintf("\\caption{Gender Earnings Gap (\\%%)}"),file=tabfile, append=T)
write(sprintf("\\label{table12}"),file=tabfile, append=T)
write(sprintf("\\scalebox{0.99}{"),file=tabfile, append=T)
write(sprintf("\\begin{tabular}{l  c c c c}"),file=tabfile, append=T)
write(sprintf("\\toprule"),file=tabfile, append=T)
              write(sprintf("		      & Overall & Between & Between & Within \\\\[\\sep]"),file=tabfile, append=T)
			 write(sprintf("     &         &        & (Sorting)&"),file=tabfile, append=T)
	write(sprintf("		      \\\\[\\sep]"),file=tabfile, append=T)
 write(sprintf("                \\hline"),file=tabfile, append=T)
write(sprintf("\\midrule"),file=tabfile, append=T)


write(sprintf("Data                          &  %.1f  &  %.1f& - &  %.1f \\\\[\\sep]", data_decomp[1], data_decomp[2], data_decomp[3]),file=tabfile, append=T)
write(sprintf("Baseline                      &  %.1f  &  %.1f& - &  %.1f   \\\\[\\sep]",baseline_decomp[1],baseline_decomp[2], baseline_decomp[3] ),file=tabfile, append=T)
write(sprintf("Equal Taste Distrib.            &  %.1f  &  %.1f& %.1f &  %.1f
			  \\\\[\\sep]", equal_taste_decomp[1], equal_taste_decomp[2], equal_taste_decomp_sorting[2], equal_taste_decomp[3]),file=tabfile, append=T)

write(sprintf("\\bottomrule "),file=tabfile, append=T)
write(sprintf("\\end{tabular}"),file=tabfile, append=T)
write(sprintf("}"),file=tabfile, append=T)
write(sprintf("\\end{table}"),file=tabfile, append=T)


# -------------------------------------------------------------------------------------
# Table A12
# -------------------------------------------------------------------------------------

unlink(paste0(pathtotables,"tableA12.tex"),recursive=F,force=F)
tabfile = paste0(pathtotables,"tableA12.tex")
pathtofiles = "../Quantitative_Analysis/sensitivity_cobb_douglas"

# load additional moments from model
zdata <- scan(paste0(pathtofiles,'/earnph_regression_BASELINE_cobb_douglas'))

reg_data_coeff <- read.csv('../Quantitative_Analysis/data/data_reg_table_coeffs.txt')
reg_data_se <- read.csv('../Quantitative_Analysis/data/data_reg_table_se.txt')


write(sprintf("\\begin{table}[!htbp]"),file=tabfile, append=T)
write(sprintf("\\centering {"),file=tabfile, append=T)
write(sprintf("\\caption{Regressions: Model vs. Data} \\label{table11}"),file=tabfile, append=T)
write(sprintf("\\scalebox{0.85}{"),file=tabfile, append=T)
write(sprintf("\\def\\sym#1{\\ifmmode^{#1}\\else\\(^{#1}\\)\\fi}"),file=tabfile, append=T)
write(sprintf("\\begin{tabular}{l*{2}{c}}"),file=tabfile, append=T)
write(sprintf("\\hline"),file=tabfile, append=T)
write(sprintf("                   & Data               & Model\\\\"),file=tabfile, append=T)
write(sprintf("\\hline\\"),file=tabfile, append=T)
write(sprintf("female              &     %.3f\\sym{***}
			  &      %.2f\\\\",reg_data_coeff$x[1],zdata[3]),file=tabfile, append=T)
write(sprintf("                    &    (%.3f)         &",reg_data_se$x[1]),file=tabfile, append=T)
write(sprintf("         \\\\"),file=tabfile, append=T)
write(sprintf("[1em]"),file=tabfile, append=T)
write(sprintf("ratio8to5           &       %.3f\\sym{***} &      %.2f
			  \\\\",reg_data_coeff$x[2],zdata[2]),file=tabfile, append=T)
write(sprintf("                    &    (%.3f)         &",reg_data_se$x[2]),file=tabfile, append=T)
write(sprintf("         \\\\"),file=tabfile, append=T)
write(sprintf("[1em]"),file=tabfile, append=T)
write(sprintf("femaleXratio8to5    &     %.3f\\sym{***}  &     %.2f\\\\",reg_data_coeff$x[3],zdata[4]),file=tabfile, append=T)
write(sprintf("                    &    (%.3f)         &",reg_data_se$x[3]),file=tabfile, append=T)
write(sprintf("         \\\\"),file=tabfile, append=T)
write(sprintf("\\hline"),file=tabfile, append=T)
write(sprintf("\\multicolumn{3} {p{4.4in}} { {\\footnotesize{"),file=tabfile, append=T)
write(sprintf(" Standard errors in parentheses. \\sym{*} \\(p<.10\\), \\sym{**} \\(p<.05\\), \\sym{***} \\(p<.01\\). Note: This table shows the estimates
 of the regression using the data for married workers with children
 (column Data) and 22 occupations, and the estimates of the same regression using data
 generated by the model in its baseline calibration but assuming a
 Cobb-Douglas aggregate technology (column Model). The dependent variable is earnings per hour.
"),file=tabfile, append=T)
write(sprintf("}}}"),file=tabfile, append=T)

write(sprintf("\\end{tabular}"),file=tabfile, append=T)
write(sprintf("}}"),file=tabfile, append=T)
write(sprintf("\\end{table}"),file=tabfile, append=T)


# ------------------------------------------------------------------------
#  Table A13
# ------------------------------------------------------------------------
unlink(paste0(pathtotables,"tableA13.tex"),recursive=F,force=F)
tabfile = paste0(pathtotables,"tableA13.tex")

data_decomp <- scan('../Quantitative_Analysis/data/empirical_decomp_gender_gap')*100
baseline_decomp <- scan('../Quantitative_Analysis/sensitivity_cobb_douglas/decomp_gender_gap_BASELINE_cobb_douglas')*100
baseline_decomp_sorting <- scan('../Quantitative_Analysis/sensitivity_cobb_douglas/decomp_gender_gap_sorting_BASELINE_cobb_douglas')*100
equal_alpha_decomp <-  scan('../Quantitative_Analysis/sensitivity_cobb_douglas/decomp_gender_gap_Same_alpha_(healthcare_support)_cobb_douglas')*100
equal_alpha_decomp_sorting <-  scan('../Quantitative_Analysis/sensitivity_cobb_douglas/decomp_gender_gap_sorting_Same_alpha_(healthcare_support)_cobb_douglas')*100
similar_pref_decomp <- scan('../Quantitative_Analysis/sensitivity_cobb_douglas/decomp_gender_gap_Smaller_differences_preferences_cobb_douglas')*100
similar_pref_decomp_sorting <- scan('../Quantitative_Analysis/sensitivity_cobb_douglas/decomp_gender_gap_sorting_Smaller_differences_preferences_cobb_douglas')*100
increase_rho_decomp <- scan('../Quantitative_Analysis/sensitivity_cobb_douglas/decomp_gender_gap_Alternative_eos_home_care_cobb_douglas')*100
increase_rho_decomp_sorting <- scan('../Quantitative_Analysis/sensitivity_cobb_douglas/decomp_gender_gap_sorting_Alternative_eos_home_care_cobb_douglas')*100


write(sprintf("\\def\\sep{0.5em}"),file=tabfile, append=T)
write(sprintf("\\def\\fns{\\footnotesize}"),file=tabfile, append=T)
write(sprintf("\\begin{table}[htbp]\\centering"),file=tabfile, append=T)
write(sprintf("\\caption{Gender Earnings Gap (\\%%)}"),file=tabfile, append=T)
write(sprintf("\\label{table12}"),file=tabfile, append=T)
write(sprintf("\\scalebox{0.99}{"),file=tabfile, append=T)
write(sprintf("\\begin{tabular}{l  c c c c}"),file=tabfile, append=T)
write(sprintf("\\toprule"),file=tabfile, append=T)
              write(sprintf("		      & Overall & Between & Between & Within \\\\[\\sep]"),file=tabfile, append=T)
			 write(sprintf("     &         &        & (Sorting)&"),file=tabfile, append=T)
	write(sprintf("		      \\\\[\\sep]"),file=tabfile, append=T)
 write(sprintf("                \\hline"),file=tabfile, append=T)
write(sprintf("\\midrule"),file=tabfile, append=T)


write(sprintf("Data                          &  %.1f  &  %.1f& - &  %.1f \\\\[\\sep]", data_decomp[1], data_decomp[2], data_decomp[3]),file=tabfile, append=T)
write(sprintf("Baseline                      &  %.1f  &  %.1f& - &  %.1f   \\\\[\\sep]",baseline_decomp[1],baseline_decomp[2], baseline_decomp[3] ),file=tabfile, append=T)
write(sprintf("Equal $\\alpha$ ($\\alpha$ $=$ 2.72)  &  %.1f  &  %.1f& %.1f &  %.1f  \\\\[\\sep]", equal_alpha_decomp[1],equal_alpha_decomp[2],equal_alpha_decomp_sorting[2],equal_alpha_decomp[3]),file=tabfile, append=T)
write(sprintf("50\\%% Drop in $\\nu_m-\\nu_f$     &  %.1f  &  %.1f& %.1f &  %.1f  \\\\[\\sep]", similar_pref_decomp[1], similar_pref_decomp[2],similar_pref_decomp_sorting[2], similar_pref_decomp[3]),file=tabfile, append=T)
write(sprintf("Increase in $\\rho$            &  %.1f  &  %.1f& %.1f &  %.1f   \\\\[\\sep]", increase_rho_decomp[1], increase_rho_decomp[2], increase_rho_decomp_sorting[2], increase_rho_decomp[3]),file=tabfile, append=T)

write(sprintf("\\bottomrule "),file=tabfile, append=T)
write(sprintf("\\end{tabular}"),file=tabfile, append=T)
write(sprintf("}"),file=tabfile, append=T)
write(sprintf("\\end{table}"),file=tabfile, append=T)

# ------------------------------------------------------------------------
#  Table A1
# ------------------------------------------------------------------------
unlink(paste0(pathtotables,"tableA1.tex"),recursive=F,force=F)
tabfile = paste0(pathtotables,"tableA1.tex")

two_earner_positive <- read.csv(paste0(pathtosect4,'/two-earner-households/results_two_earner_positive.txt'))
two_earner_negative <- read.csv(paste0(pathtosect4,'/two-earner-households/results_two_earner_negative.txt'))
two_earner <- read.csv(paste0(pathtosect4,'/two-earner-households/results_two_earner.txt'))
 
write(sprintf("\\begin{table}[ht]"),file=tabfile,append=T)
write(sprintf("\\centering"),file=tabfile,append=T)
write(sprintf("\\caption{A Simple Case with Two-Earner Households
} \\label{table7}"),file=tabfile,append=T)
write(sprintf("\\scalebox{0.85}{"),file=tabfile,append=T)
write(sprintf("\\begin{tabular}{lccccccc}  \\hline"),file=tabfile,append=T)
write(sprintf("\\\\"),file=tabfile,append=T)
write(sprintf("\\footnotesize{"),file=tabfile,append=T)
write(sprintf("Occupation}          & \\footnotesize{$\\%%$ Workers}&\\footnotesize{Bunching Ratio}   &\\footnotesize{Earnings}   &\\footnotesize{$l_1+l_2$}&  \\footnotesize{$l$}   & \\footnotesize{$\\%%$ Females}& \\footnotesize{E. Gap}\\\\ \\\\"),file=tabfile,append=T)
write(sprintf("(1)                 & (2)         &       (3)       &  (4)   &(5)      &  (6)   & (7)&(8)\\\\"),file=tabfile,append=T)

write(sprintf("\\hline\\\\\\\\"),file=tabfile,append=T)

               write(sprintf("       \\multicolumn{8}{l}{\\footnotesize Panel A: Positive Assortative Matching}\\\\"),file=tabfile,append=T)
write(sprintf("\\hline\\\\"),file=tabfile,append=T)
write(sprintf("1              & %.f      &  %.2f     &  %.2f      &   %.2f &  %.2f  & %.f             & %.3f \\\\", round(two_earner_positive$V1[5]*100), two_earner_positive$V1[3], two_earner_positive$V1[6], two_earner_positive$V1[7], two_earner_positive$V1[8], two_earner_positive$V1[4]*100, two_earner_positive$V1[2] ),file=tabfile,append=T)
write(sprintf("2              & %.f       &  %.2f      &  %.2f       &   %.2f &  %.2f  & %.f          & %.3f\\\\",two_earner_positive$V2[5]*100, two_earner_positive$V2[3], two_earner_positive$V2[6], two_earner_positive$V2[7], two_earner_positive$V2[8], two_earner_positive$V2[4]*100, two_earner_positive$V2[2] ),file=tabfile,append=T)
write(sprintf(" \\hline \\\\"),file=tabfile,append=T)
write(sprintf("\\\\"),file=tabfile,append=T)
write(sprintf("Gender Earnings Gap  &\\multicolumn{7}{l}{%.3f}\\\\", two_earner_positive$V1[1]),file=tabfile,append=T)
write(sprintf("\\hline \\\\\\\\"),file=tabfile,append=T)


write(sprintf("                      \\multicolumn{8}{l}{\\footnotesize Panel B: Negative Assortative Matching}\\\\"),file=tabfile,append=T)
write(sprintf("\\hline\\\\"),file=tabfile,append=T)
write(sprintf("1              & %.f      &  %.2f     &  %.2f      &   %.2f &  %.2f  & %.f             & %.3f \\\\", round(two_earner_negative$V1[5]*100), two_earner_negative$V1[3], two_earner_negative$V1[6], two_earner_negative$V1[7], two_earner_negative$V1[8], two_earner_negative$V1[4]*100, two_earner_negative$V1[2] ),file=tabfile,append=T)
write(sprintf("2              & %.f       &  %.2f      &  %.2f       &   %.2f &  %.2f  & %.f          & %.3f\\\\",two_earner_negative$V2[5]*100, two_earner_negative$V2[3], two_earner_negative$V2[6], two_earner_negative$V2[7], two_earner_negative$V2[8], two_earner_negative$V2[4]*100, two_earner_negative$V2[2] ),file=tabfile,append=T)
write(sprintf(" \\hline \\\\"),file=tabfile,append=T)
write(sprintf("\\\\"),file=tabfile,append=T)
write(sprintf("Gender Earnings Gap  &\\multicolumn{7}{l}{%.3f}\\\\", two_earner_negative$V1[1]),file=tabfile,append=T)
write(sprintf("\\hline \\\\\\\\"),file=tabfile,append=T)


write(sprintf("                      \\multicolumn{8}{l}{\\footnotesize Panel C: Observed Assortative Matching}\\\\"),file=tabfile,append=T)
write(sprintf("\\hline\\\\"),file=tabfile,append=T)
write(sprintf("1              & %.f      &  %.2f     &  %.2f      &   %.2f &  %.2f  & %.f             & %.3f \\\\", round(two_earner$V1[5]*100), two_earner$V1[3], two_earner$V1[6], two_earner$V1[7], two_earner$V1[8], two_earner$V1[4]*100, two_earner$V1[2] ),file=tabfile,append=T)
write(sprintf("2              & %.f       &  %.2f      &  %.2f       &   %.2f &  %.2f  & %.f          & %.3f\\\\",two_earner$V2[5]*100, two_earner$V2[3], two_earner$V2[6], two_earner$V2[7], two_earner$V2[8], two_earner$V2[4]*100, two_earner$V2[2] ),file=tabfile,append=T)
write(sprintf("\\\\"),file=tabfile,append=T)
write(sprintf("Gender Earnings Gap  &\\multicolumn{7}{l}{%.3f}\\\\", two_earner$V1[1]),file=tabfile,append=T)
write(sprintf("\\hline"),file=tabfile,append=T)
write(sprintf("\\\\"),file=tabfile,append=T)
write(sprintf("\\multicolumn{8} {p{6.8in}} { {\\footnotesize{"),file=tabfile,append=T)

write(sprintf("}}}"),file=tabfile,append=T)
write(sprintf("\\end{tabular}"),file=tabfile,append=T)
write(sprintf("}"),file=tabfile,append=T)
write(sprintf("\\end{table}"),file=tabfile,append=T)

# ---------------------------------------------------
# ---------- TABLE A7
# ---------------------------------------------------


z1 <- read.csv("../../EJ_replicate/appendix/data_for_tableA7.csv",header=T)
z2 <- read.csv("../../Raw_Data/occ_labels/occs_labels.txt",sep="\t", header=T)
names(z2)[1:3] <- c("X", "occ_563","Label")

bigd <- merge(z1,z2,by="occ_563")
bigd <- bigd[order(bigd$bratio_work563_8to5pm, -bigd$ft_wrker),]


unlink("./tableA7_fixed.tex",recursive=F,force=F)
tabfile = "./tableA7_fixed.tex"


write(sprintf("{"),file=tabfile,append=T)
write(sprintf("\\tiny"),file=tabfile,append=T)
write(sprintf("\\begin{longtable}{llcccc}"),file=tabfile,append=T)
write(sprintf(""),file=tabfile,append=T)
write(sprintf("\\caption{Ratio8to5 by Occupation}\\label{tableA4}"),file=tabfile,append=T)
write(sprintf(""),file=tabfile,append=T)
write(sprintf("\\tabularnewline"),file=tabfile,append=T)
write(sprintf(" & {\\tiny{}Occupations}  & {\\tiny{}\\# FT Workers} & {\\tiny{}ratio8to5} & {\\tiny{}ratio8to5\\_Std}& {\\tiny{}\\%% Females} \\tabularnewline"),file=tabfile,append=T)
write(sprintf("\\hline"),file=tabfile,append=T)
write(sprintf(""),file=tabfile,append=T)
write(sprintf("\\endfirsthead"),file=tabfile,append=T)
write(sprintf(""),file=tabfile,append=T)
write(sprintf(" & {\\tiny{}Occupations}  & {\\tiny{}\\# FT Workers}
& {\\tiny{}ratio8to5} & {\\tiny{}ratio8to5\\_Std}& {\\tiny{}\\%% Females} \\tabularnewline"),file=tabfile,append=T)
write(sprintf(""),file=tabfile,append=T)
write(sprintf("\\hline"),file=tabfile,append=T)

write(sprintf("\\endhead"),file=tabfile,append=T)
write(sprintf(""),file=tabfile,append=T)
write(sprintf("\\hline"),file=tabfile,append=T)
write(sprintf("\\multicolumn{6}{c}{{Continued on next page}}"),file=tabfile,append=T)
write(sprintf(""),file=tabfile,append=T)
write(sprintf("\\endfoot"),file=tabfile,append=T)
write(sprintf("\\endlastfoot"),file=tabfile,append=T)
for (k in seq(1,(dim(bigd)[1]))){
	write(sprintf(" %i & %s & %i & %.3f & %.3f & %.3f \\\\", k,
				  bigd$Label[k],bigd$ft_wrker[k],
				  bigd$bratio_work563_8to5pm[k], bigd$bratio_s_work563_8to5pm[k],
				  bigd$female[k]),file=tabfile,append=T)
}

write(sprintf("\\hline"),file=tabfile,append=T)
write(sprintf("\\multicolumn{6} {p{6.6in}} { {\\tiny{"),file=tabfile,append=T)
write(sprintf("Notes:"),file=tabfile,append=T)
write(sprintf("Data are from the 2003-2014 American Time Use Surveys (ATUS). The sample is all"),file=tabfile,append=T)
write(sprintf("18-65 years old ATUS respondents who report to be full-time workers in the"),file=tabfile,append=T)
write(sprintf("activity summary file. Respondents are linked to detailed 2002 Census occupation"),file=tabfile,append=T)
write(sprintf("codes of their main job. \\# FT Workers is the number of
			  full-time workers by occupation. \\%% Females is the percentage of females in each occupation. ratio8to5 is the ratio of total hours spent on ``work and work-related activities'' during the hours 8 a.m. to 5 p.m. relative to total hours spent on ``work and work-related activities'' on the diary day.  Both weekdays and weekends are included. In calculating Ratio8to5, individual observations are weighted by ATUS weights for multi-year data files. ``ratio8to5\\_std'' reports standardized values with mean zero and standard deviation equal to 1."),file=tabfile,append=T)
write(sprintf("}}}"),file=tabfile,append=T)
write(sprintf("\\end{longtable}"),file=tabfile,append=T)
write(sprintf("}"),file=tabfile,append=T)



