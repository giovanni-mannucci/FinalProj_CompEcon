rm(list=ls())
library(doBy)
library(Hmisc) 
library(data.table)

############################################
##replicate regressions
############################################


############################Bunchign Ratios Saumya#################


data_br <- fread("../data/br_w_22_may19.txt", header=F, sep = ',')

colnames(data_br) <- "br_w"
data_br$occ_22 <- seq(1,22)
data_br$br_w_s<- (data_br$br_w-mean(data_br$br_w))/sd(data_br$br_w)


##########################################

data_cps <- fread("../data/6_b_reg_april2019.csv", header=TRUE, sep = ',')


data_cps$newid <- paste0(as.character(data_cps$tucaseid),as.character(data_cps$tulineno))



myvars <- c("newid","occ_22","tubwgt","peeduca","prernwa","prtage"
,"pesex","year",
"prdtind1","pehrusl1","pemaritl","prnmchld","ptdtrace")
data_cps<-data_cps[,..myvars]
data_cps<-data_cps[!is.na(data_cps$occ_22),]


data_cps$prernwa_ph<-data_cps$prernwa/data_cps$pehrusl1

data9<-merge(data_cps,data_br,by="occ_22")

#eliminate NA's
data9<-data9[!is.na(data9$pesex),]
##########################


###positive earnings
data9<- data9[data9$prernwa>0,]

###full time workers
data9<- data9[data9$pehrusl1>34,]

##restrict the sample to prime age workers
data9<- data9[data9$prtage>17,]
data9<- data9[data9$prtage<66,]

##restrict the sample to married individuals
data9<- data9[data9$pemaritl==1|data9$pemaritl==2,]

###restrict the sample to married individuals with kids under 18
data9<- data9[data9$prnmchld>0,]



########################################################
##regressions
########################################################
#standarized BR
reg_bench <- lm(log(prernwa) ~ factor(pesex)+ br_w_s+
factor(pesex)*br_w_s+factor(peeduca)+factor(ptdtrace)+log(pehrusl1)+
prtage+prtage*prtage+prtage*prtage*prtage+prtage*prtage*prtage*prtage+factor(year), data=data9,
weights=tubwgt)
summary(reg_bench) # show results 
# extract relevant coefficients
data_reg_table_coeffs <- c(reg_bench$coeff[2],reg_bench$coeff[3],reg_bench$coeff[length(reg_bench$coeff)])
# and standard error
sterr <- coef(summary(reg_bench))[, "Std. Error"]
data_reg_table_se <- c(sterr[2],sterr[3],sterr[length(reg_bench$coeff)])

write.table(data_reg_table_coeffs,file = "../data/data_reg_table_coeffs.txt", sep=",")
write.table(data_reg_table_se,file = "../data/data_reg_table_se.txt", sep=",")



