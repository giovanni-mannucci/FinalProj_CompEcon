rm(list=ls())

# -------------------------
#----------------- TABLE 1
# -------------------------

table <- readLines('../../EJ_replicate/table1-2/table1.tex')

xx <- grepl("tabular", table, fixed = TRUE)
xy <- xx
for (i in seq(2,length(xy))){
    if (xx[i]==F){
        xy[i]==F
    } else {
    xy[i+1]=T 
    }
}

table <- table[xy==F]

beginning <- c("\\begin{table}[!htbp]" ,
"\\centering{",
"\\caption{Work among Full-time Workers, Married with Children}\\label{table1}",
"\\scalebox{0.8}{",
"\\small \\begin{tabular}{l*{7}{c}}","\\hline")
table2 <- table[-(1:3)]
table <- c(beginning,table2)
end <- c("\\multicolumn{8} {p{7.2in}} { {\\footnotesize{
Notes:
Data are from the 2003-2014 American Time Use Surveys (ATUS). The table is based on 18-65 year old ATUS respondents who report working full-time in the activity summary ﬁle.  We keep those who are married with spouse present and have at least one own child in the household. The dependent variable is total hours spent on ``work and work-related activities'' on the diary day. Each column reports the coefﬁcient on the ``female'' dummy. Column (5) controls for usual weekly hours worked reported in the activity summary ﬁle. Column (6) only includes workers who reported usual weekly hours of less than 50. Individual observations are weighted by ATUS weights for multi-year data files.
}}}
\\end{tabular}
}}
\\end{table}")

table <- c(table,end)
unlink("./table1_fixed.tex",recursive=F,force=F)
tabfile = "./table1_fixed.tex"


for (k in seq(1,length(table))){
write(table[k],file=tabfile,append=T)
}

# -------------------------
#----------------- TABLE 2  
# -------------------------
table <- readLines('../../EJ_replicate/table1-2/table2.tex')

xx <- grepl("tabular", table, fixed = TRUE)
xy <- xx
for (i in seq(2,length(xy))){
    if (xx[i]==F){
        xy[i]==F
    } else {
    xy[i+1]=T 
    }
}

table <- table[xy==F]

beginning <- c("\\begin{table}[!htbp]" ,
"\\centering{",
"\\caption{Work among Full-time Workers, Married with Children}\\label{table1}",
"\\scalebox{0.8}{",
"\\small \\begin{tabular}{l*{7}{c}}","\\hline")
table2 <- table[-(1:3)]
table <- c(beginning,table2)
end <- c("\\multicolumn{8} {p{7.2in}} { {\\footnotesize{
Notes:
Data are from the 2003-2014 American Time Use Surveys (ATUS). The table is based on 18-65 year old ATUS respondents who report working full-time in the activity summary ﬁle.  We keep those who are married with spouse present and have at least one own child in the household. The dependent variable is total hours spent on ``work and work-related activities'' on the diary day. Each column reports the coefﬁcient on the ``female'' dummy. Column (5) controls for usual weekly hours worked reported in the activity summary ﬁle. Column (6) only includes workers who reported usual weekly hours of less than 50. Individual observations are weighted by ATUS weights for multi-year data files.
}}}
\\end{tabular}
}}
\\end{table}")

table <- c(table,end)
unlink("./table2_fixed.tex",recursive=F,force=F)
tabfile = "./table2_fixed.tex"


for (k in seq(1,length(table))){
write(table[k],file=tabfile,append=T)
}

# -------------------------
#----------------- TABLE 3
# -------------------------
table <- readLines('../../EJ_replicate/table3/table3reg.tex')


beginning <- c("\\def\\sep{0.5em}",
"\\def\fns{\\footnotesize}",
"\\begin{table}[htbp]\\centering",
  "\\footnotesize",
"\\caption{Household Care Activities of Parents by Marital and Work Status (Hours)}\\label{table3}",
"\\scalebox{0.8}{",
"\\begin{tabular}{l  c c c c}")

table <- c(beginning, table)


end <- c("\\hline \\multicolumn{5} {p{6.2in}}
            {{\\footnotesize{Note:
            Data are from the 2003-2014 American Time Use Surveys
(ATUS). The table shows the average hours allocated to household care
activities by parents. See main text for the definitions of the main
activities. See Appendix for
detailed activities that are included in each category. Married NW
refers to married women with spouse present who are not working,
Married FT refers to men and women who are married with spouse present
and working full-time, Single FT refers to single women who are
working full-time.   }}}
\\end{tabular}
}
\\end{table}")

table <- c(table,end)

unlink("./table3_fixed.tex",recursive=F,force=F)
tabfile = "./table3_fixed.tex"


for (k in seq(1,length(table))){
write(table[k],file=tabfile,append=T)
}

# -------------------------
#----------------- TABLE 6 
# -------------------------
table <- readLines('../../EJ_replicate/table6-7/table6.tex')
beginning <- c("\\begin{table}[htbp]\\centering",
  "\\footnotesize",
"\\caption{Household Care Activities of Parents by Marital and Work Status (Hours)}\\label{table3}")

table <- c(beginning, table)


end <-  c("\\end{table}")

table <- c(table,end)

unlink("./table6_fixed.tex",recursive=F,force=F)
tabfile = "./table6_fixed.tex"


for (k in seq(1,length(table))){
write(table[k],file=tabfile,append=T)
}

# -------------------------
#----------------- TABLE 7 
# -------------------------
table <- readLines('../../EJ_replicate/table6-7/table7.tex')


table[6] <- "&\\multicolumn{1}{c}{baseline }&\\multicolumn{1}
{c}{(1)+agg educ}&\\multicolumn{1}{c}{(2)+ overwrk}&\\multicolumn{1}{c}{(3)+ ONET}\\\\"

beginning <- c("\\begin{table}[htbp]\\centering",
  "\\footnotesize",
"\\caption{Log Weekly Earnings of Males by Working Status of Spouse and Coordination Measure Ratio8to5 -- Married with Children}\\label{table3}")

table <- c(beginning, table)


end <-  c("\\end{table}")

table <- c(table,end)

unlink("./table7_fixed.tex",recursive=F,force=F)
tabfile = "./table7_fixed.tex"


for (k in seq(1,length(table))){
write(table[k],file=tabfile,append=T)
}

# -------------------------
#----------------- TABLE A5
# -------------------------
table <- readLines('../../EJ_replicate/appendix/tableA5.tex')
xx <- grepl("tabular", table, fixed = TRUE)
xy <- xx
for (i in seq(2,length(xy))){
    if (xx[i]==F){
        xy[i]==F
    } else {
    xy[i+1]=T 
    }
}

table <- table[xy==F]

beginning <- c("\\begin{table}[!htbp]" ,
"\\centering{",
"\\caption{Work among Full-time Workers, Married with Children}\\label{table1}",
"\\scalebox{0.8}{",
"\\small \\begin{tabular}{l*{7}{c}}","\\hline")
table2 <- table[-(1:3)]
table <- c(beginning,table2)
end <- c("\\multicolumn{8} {p{7.2in}} { {\\footnotesize{
Notes:
Data are from the 2003-2014 American Time Use Surveys (ATUS). The table is based on 18-65 year old ATUS respondents who report working full-time in the activity summary ﬁle.  We keep those who are married with spouse present and have at least one own child in the household. The dependent variable is total hours spent on ``work and work-related activities'' on the diary day. Each column reports the coefﬁcient on the ``female'' dummy. Column (5) controls for usual weekly hours worked reported in the activity summary ﬁle. Column (6) only includes workers who reported usual weekly hours of less than 50. Individual observations are weighted by ATUS weights for multi-year data files.
}}}
\\end{tabular}
}}
\\end{table}")

table <- c(table,end)
xx <- grepl("Total", table, fixed = TRUE)
table <- table[xx==F]


unlink("./tableA5_fixed.tex",recursive=F,force=F)
tabfile = "./tableA5_fixed.tex"


for (k in seq(1,length(table))){
write(table[k],file=tabfile,append=T)
}

#----------------- TABLE A6
# -------------------------
table <- readLines('../../EJ_replicate/appendix/tableA6.tex')
xx <- grepl("tabular", table, fixed = TRUE)
xy <- xx
for (i in seq(2,length(xy))){
    if (xx[i]==F){
        xy[i]==F
    } else {
    xy[i+1]=T 
    }
}

table <- table[xy==F]

beginning <- c("\\begin{table}[!htbp]" ,
"\\centering{",
"\\caption{Household Care among Full-time Workers, Married with Children}\\label{table1}",
"\\scalebox{0.8}{",
"\\small \\begin{tabular}{l*{7}{c}}","\\hline")
table2 <- table[-(1:3)]
table <- c(beginning,table2)
end <- c("\\multicolumn{8} {p{7.2in}} { {\\footnotesize{
Notes:
Data are from the 2003-2014 American Time Use Surveys (ATUS). The table is based on 18-65 year old ATUS respondents who report working full-time in the activity summary ﬁle.  We keep those who are married with spouse present and have at least one own child in the household. The dependent variable is total hours spent on ``work and work-related activities'' on the diary day. Each column reports the coefﬁcient on the ``female'' dummy. Column (5) controls for usual weekly hours worked reported in the activity summary ﬁle. Column (6) only includes workers who reported usual weekly hours of less than 50. Individual observations are weighted by ATUS weights for multi-year data files.
}}}
\\end{tabular}
}}
\\end{table}")

table <- c(table,end)
xx <- grepl("Total", table, fixed = TRUE)
table <- table[xx==F]


unlink("./tableA6_fixed.tex",recursive=F,force=F)
tabfile = "./tableA6_fixed.tex"


for (k in seq(1,length(table))){
write(table[k],file=tabfile,append=T)
}

# -------------------------
#----------------- TABLE A8
# -------------------------
table <- readLines('../../EJ_replicate/appendix/tableA8.tex')

table[6] <- "&\\multicolumn{1}{c}{baseline }&\\multicolumn{1}
{c}{(1)+agg educ}&\\multicolumn{1}{c}{(2)+ overwrk}&\\multicolumn{1}{c}{(3)+ ONET}\\\\"

beginning <- c("\\begin{table}[htbp]\\centering",
  "\\footnotesize",
"\\caption{Gender Gap in Log Weekly Earnings of Males: Controlling for the Effect of Shiftwork}\\label{table3}")

table <- c(beginning, table)


end <-  c("\\end{table}")

table <- c(table,end)

unlink("./tableA8_fixed.tex",recursive=F,force=F)
tabfile = "./tableA8_fixed.tex"


for (k in seq(1,length(table))){
write(table[k],file=tabfile,append=T)
}

# -------------------------
#----------------- TABLE A9
# -------------------------
table <- readLines('../../EJ_replicate/appendix/tableA9.tex')

table[6] <- "&\\multicolumn{1}{c}{baseline }&\\multicolumn{1}
{c}{(1)+agg educ}&\\multicolumn{1}{c}{(2)+ overwrk}&\\multicolumn{1}{c}{(3)+ ONET}\\\\"

beginning <- c("\\begin{table}[htbp]\\centering",
  "\\footnotesize",
"\\caption{Gender Gap in Log Weekly Earnings of Males by Concentration Index}\\label{table3}")

table <- c(beginning, table)


end <-  c("\\end{table}")

table <- c(table,end)
table[53] <- "&\\multicolumn{1}{c}{baseline }&\\multicolumn{1}
{c}{(1)+agg educ}&\\multicolumn{1}{c}{(2)+ overwrk}&\\multicolumn{1}{c}{(3)+ ONET}\\\\"
table[31] <- "&\\multicolumn{1}{c}{baseline }&\\multicolumn{1}
{c}{(1)+agg educ}&\\multicolumn{1}{c}{(2)+ overwrk}&\\multicolumn{1}{c}{(3)+ ONET}\\\\"



unlink("./tableA9_fixed.tex",recursive=F,force=F)
tabfile = "./tableA9_fixed.tex"


for (k in seq(1,length(table))){
write(table[k],file=tabfile,append=T)
}


