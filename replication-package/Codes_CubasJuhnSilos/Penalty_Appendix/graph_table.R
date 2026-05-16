rm(list=ls())
library(ggplot2)
library(data.table)

# FEMALE GRAPH (HBR VS LBR OCCS)
coeffs <- load('./coeffs_data') 
std_error <- load('./std_error_data')

df <- as.data.frame(cbind(coeffs_data$coeffs_lbr,coeffs_data$coeffs_hbr,std_error_data$std_error_lbr,std_error_data$std_error_hbr))
names(df) <- c("coeff_lbr", "coeff_hbr","se_lbr", "se_hbr")
df2 <- reshape2::melt(df, measure.vars=c("coeff_lbr","coeff_hbr"))
df2$se <- ifelse(df2$variable=="coeff_lbr",df2$se_lbr,df2$se_hbr)
df2$se_lbr <- NULL
df2$se_hbr <- NULL

df2$dose <- rep(seq(0,4),2)
p1 <- ggplot(df2, aes(dose, value)) + geom_line(aes(color = variable, group = variable,linetype=variable),position=position_dodge(0.3))
p1 <- p1 + geom_errorbar(aes(ymin = value-1.95*se, ymax = value+1.95*se,color=variable),position = position_dodge(0.3), width = 0.2)

p1 <- p1 + geom_point(aes(shape=variable,color=variable),size=2, position = position_dodge(0.3)) + scale_color_manual('Occ. Bunching Ratio',labels=c("Low","High"),values = c("#00AFBB", "#E7B800")) + scale_linetype_manual('Occ. Bunching Ratio',values=c("dashed","solid"),labels=c("Low","High"))

p1 <- p1 +   scale_shape_manual('Occ. Bunching Ratio',values=c(21,15),labels=c("Low", "High"))
p1 <- p1 +  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),legend.position=c(0.4,0.9), legend.background = element_rect(fill = "white", color = "black"))

p1 <- p1 +  geom_hline(yintercept=0, linetype="solid", color = "black", size=0.4) + xlab('Period') + ylab('Coefficient')
ggsave("../EJ_replicate_model/latex_tables/psid_penalty.pdf")



unlink(paste0("../EJ_replicate_model/latex_tables/tableA3.tex"),recursive=F,force=F)
tabfile = paste0("../EJ_replicate_model/latex_tables/tableA3.tex")
coeffs <- load('./coeffs_all') 
std_error <- load('./std_error_all')



write(sprintf("{"), file=tabfile, append=T)
write(sprintf("\\def\\sep{0.6em}"), file=tabfile, append=T)
write(sprintf("\\def\\fns{\\footnotesize}"), file=tabfile, append=T)
write(sprintf("\\begin{table}[htbp]\\centering"), file=tabfile, append=T)
write(sprintf("\\footnotesize"), file=tabfile, append=T)
write(sprintf("\\caption{Regression Child Penalty \\label{event_reg}}"), file=tabfile, append=T)
write(sprintf("\\begin{tabular}{l c c c c }"), file=tabfile, append=T)
write(sprintf("\\toprule"), file=tabfile, append=T)
write(sprintf("                          && All Occs   &  Low $ratio8to5$     & High"), file=tabfile, append=T)
write(sprintf("                          $ratio8to5$      \\tabularnewline[\\sep]"), file=tabfile, append=T)
write(sprintf("$\\alpha_[-2,1]$              && %.3f    & %.3f      & %.3f    \\tabularnewline", coeffs_all[1],coeffs_data$coeffs_lbr[1], coeffs_data$coeffs_hbr[1]), file=tabfile, append=T)
write(sprintf("                          &&\\fns{(%.2f)}&\\fns{(%.2f)} & \\fns{(%.2f)} \\tabularnewline[\\sep]", std_error_all[1], std_error_data$std_error_lbr[1], std_error_data$std_error_hbr[1]), file=tabfile, append=T)
write(sprintf("$\\alpha_[2,3]$               && %.3f    & %.3f      & %.3f    \\tabularnewline", coeffs_all[2],coeffs_data$coeffs_lbr[2], coeffs_data$coeffs_hbr[2]), file=tabfile, append=T)
write(sprintf("                          &&\\fns{(%.2f)}&\\fns{(%.2f)} & \\fns{(%.2f)} \\tabularnewline[\\sep]", std_error_all[2], std_error_data$std_error_lbr[2], std_error_data$std_error_hbr[1]), file=tabfile, append=T)
write(sprintf("$\\alpha_[4,5]$               && %.3f    & %.3f      & %.3f    \\tabularnewline", coeffs_all[3],coeffs_data$coeffs_lbr[3], coeffs_data$coeffs_hbr[3]), file=tabfile, append=T)
write(sprintf("                          &&\\fns{(%.2f)}&\\fns{(%.2f)} & \\fns{(%.2f)} \\tabularnewline[\\sep]", std_error_all[3], std_error_data$std_error_lbr[3], std_error_data$std_error_hbr[3]), file=tabfile, append=T)
write(sprintf("$\\alpha_[6,7]$               && %.3f    & %.3f      & %.3f    \\tabularnewline", coeffs_all[4],coeffs_data$coeffs_lbr[4], coeffs_data$coeffs_hbr[4]), file=tabfile, append=T)
write(sprintf("                          &&\\fns{(%.2f)}&\\fns{(%.2f)} & \\fns{(%.2f)} \\tabularnewline[\\sep]", std_error_all[4], std_error_data$std_error_lbr[4], std_error_data$std_error_hbr[4]), file=tabfile, append=T)
write(sprintf("$\\alpha_[8,10]$              && %.3f    & %.3f      & %.3f    \\tabularnewline", coeffs_all[5],coeffs_data$coeffs_lbr[5], coeffs_data$coeffs_hbr[5]), file=tabfile, append=T)
write(sprintf("                          &&\\fns{(%.2f)}&\\fns{(%.2f)} & \\fns{(%.2f)} \\tabularnewline[\\sep]", std_error_all[5], std_error_data$std_error_lbr[5], std_error_data$std_error_hbr[5]), file=tabfile, append=T)

write(sprintf("		  \\bottomrule \\tabularnewline"), file=tabfile, append=T)
write(sprintf("		  \\multicolumn{5}{p{4in}}{\\setstretch{1.9}\\scriptsize{	\\emph{Note}: Standard errors in parentheses"), file=tabfile, append=T)
write(sprintf("}}"), file=tabfile, append=T)
write(sprintf("\\end{tabular}"), file=tabfile, append=T)
write(sprintf("\\end{table}"), file=tabfile, append=T)
write(sprintf("}"), file=tabfile, append=T)

