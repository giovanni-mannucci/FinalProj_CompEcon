rm(list=ls())
library(doBy)
library(Hmisc)
library(data.table)

##########################################################


###########################################################


data_cps <- fread("../data/6_b_reg_april2019.csv", header=TRUE, sep = ',')

data_cps$newid <- paste0(as.character(data_cps$tucaseid),as.character(data_cps$tulineno))



summary(data_cps$prernwa)
data_cps<- data_cps[!is.na(data_cps$prernwa),]
data_cps<- data_cps[!is.na(data_cps$tubwgt),]
data_cps<- data_cps[data_cps$prernwa>0,]
data_cps$prernwa<-data_cps$prernwa/100
mean_earn_all<-weighted.mean(data_cps$prernwa,data_cps$tubwgt) # 


data_atus<-data_cps[!is.na(data_cps$work),]
myvars <- c("newid","occ_22","tubwgt","peeduca","prernwa","prtage"
,"pesex","year",
"prdtind1","pehrusl1","pemaritl","prnmchld","ptdtrace")
data_cps<-data_cps[ ,..myvars]

data_cps$prernwa_ph<-data_cps$prernwa/data_cps$pehrusl1

####filtering cps data to obtain the sample we need###################

##restrict the sample to prime age workers
data_cps<- data_cps[data_cps$prtage>17,]
data_cps<- data_cps[data_cps$prtage<66,]

###full time workers
data_cps<- data_cps[data_cps$pehrusl1>34,]

data_cps<- data_cps[!is.na(data_cps$occ_22),]
data_cps<- data_cps[!is.na(data_cps$tubwgt),]


###positive earnings
data_cps<- data_cps[!is.na(data_cps$prernwa),]
data_cps<- data_cps[data_cps$prernwa>0,]
data_cps<- data_cps[data_cps$prernwa_ph>0,]

##restrict the sample to married individuals
data_cps<- data_cps[data_cps$pemaritl==1|data_cps$pemaritl==2,]

###restrict the sample to married individuals with kids under 18
data_cps<- data_cps[data_cps$prnmchld>0,]


#############################################################
data_at <- fread("../data/2.4_data_#2_b.csv", header=TRUE, sep = ',')


data_at$newid <- paste0(as.character(data_at$tucaseid),as.character(data_at$tulineno))

data_at[1:2,]

tot_hh_ind<-summaryBy(householdcare ~ newid, data = data_at, FUN=sum)
tot_w_ind<-summaryBy(work ~ newid, data = data_at, FUN=sum)
weight_ind<-summaryBy(tufnwgtp ~ newid, data = data_at, FUN=mean)
age_ind<-summaryBy(teage ~ newid, data = data_at, FUN=mean)
hours_ind<-summaryBy(tehrusl1 ~ newid, data = data_at, FUN=mean)
marit_ind<-summaryBy(trsppres ~ newid, data = data_at, FUN=mean)
child_ind<-summaryBy(trchildnum ~ newid, data = data_at, FUN=mean)
occ_ind<-summaryBy(occ_22 ~ newid, data = data_at, FUN=mean)
sex_ind<-summaryBy(tesex ~ newid, data = data_at, FUN=mean)




data_at2<-merge(tot_hh_ind,tot_w_ind,by="newid")
rm(data_at)
data_at3<-merge(data_at2,weight_ind,by="newid")
rm(data_at2)
data_at4<-merge(data_at3,age_ind,by="newid")
rm(data_at3)
data_at5<-merge(data_at4,hours_ind,by="newid")
rm(data_at4)
data_at6<-merge(data_at5,marit_ind,by="newid")
rm(data_at5)
data_at7<-merge(data_at6,child_ind,by="newid")
rm(data_at6)
data_at8<-merge(data_at7,occ_ind,by="newid")
rm(data_at7)
data_at9<-merge(data_at8,sex_ind,by="newid")
rm(data_at8)



data_at4<-data_at9
colnames(data_at4) <- c("newid","hh_at","w_at","tufnwgtp","teage","tehrusl1",
"trsppres","trchildnum","occ_22","tesex")
rm(data_at9)
#fulltime workers
data_at4<- data_at4[data_at4$tehrusl1>34,]

##restrict the sample to prime age workers
data_at4<- data_at4[data_at4$teage>17,]
data_at4<- data_at4[data_at4$teage<66,]

##restrict the sample to married individuals
data_at4<- data_at4[data_at4$trsppres==1|data_at4$trsppres==2,]

###restrict the sample to married individuals with kids under 18
data_at4<- data_at4[data_at4$trchildnum>0,]

data_at4<- data_at4[!is.na(data_at4$occ_22),]



#############################################################
##sample of individuals in atus and cps
data_atcps<-merge(data_at4,data_cps,by="newid")

##########################################################
##Labor Shares
###########################################
data_cps$aux_earn<-data_cps$tubwgt*data_cps$prernwa
earn_byocc <- summaryBy(aux_earn ~ occ_22, FUN=c(sum), data=data_cps)
earn_byocc$labor_share_w <- earn_byocc$aux_earn.sum/sum(data_cps$aux_earn)
 
labor_shares_occ<-earn_byocc$labor_share_w

write.table(labor_shares_occ,file = "../data/labor_shares_22occ_may.txt", sep=",", col.names=F, row.names=F)


#########################################################
##Earnings (total) moments by gender and occ
#########################################################
DT <- data.table(data_cps)
mean_earn_occ<-DT[,list(mean_earn_occ = weighted.mean(prernwa,tubwgt)),by=occ_22]
var_logearn_occ<-DT[,list(var_logearn_occ = wtd.var(log(prernwa),tubwgt)),by=occ_22]

write.table(mean_earn_occ,file = "../data/mean_earn_occ_all_22occs_may.txt", sep=",", col.names=FALSE)
write.table(var_logearn_occ,file = "../data/var_logearn_occ_all_22occs_may.txt", sep=",", col.names=FALSE)
rm(DT)

############################################################
data_cps_fem<-data_cps[data_cps$pesex==2,]
data_cps_mal<-data_cps[data_cps$pesex==1,]
###########################################################

mean_earn_all<-weighted.mean(data_cps$prernwa,data_cps$tubwgt)
mean_earn_mal<-weighted.mean(data_cps_mal$prernwa,data_cps_mal$tubwgt)
mean_earn_fem<-weighted.mean(data_cps_fem$prernwa,data_cps_fem$tubwgt)

mean_earn_gender <- cbind(mean_earn_all,mean_earn_mal,mean_earn_fem)


write.table(mean_earn_gender,file = "../data/mean_earn_gender_may.txt", sep=",")

DT_fem <- data.table(data_cps_fem)
mean_earn_occ_fem<-DT_fem[,list(mean_earn_occ_fem = weighted.mean(prernwa,tubwgt)),by=occ_22]
var_logearn_occ_fem<-DT_fem[,list(var_logearn_occ_fem = wtd.var(log(prernwa),tubwgt)),by=occ_22]

write.table(mean_earn_occ_fem,file = "../data/mean_earn_occ_all_22occs_fem_may.txt", sep=",")
write.table(var_logearn_occ_fem,file = "../data/var_logearn_occ_all_22occs_fem_may.txt", sep=",",col.names=F)


rm(DT_fem)

DT_mal <- data.table(data_cps_mal)
mean_earn_occ_mal<-DT_mal[,list(mean_earn_occ_mal = weighted.mean(prernwa,tubwgt)),by=occ_22]
var_logearn_occ_mal<-DT_mal[,list(var_logearn_occ_mal = wtd.var(log(prernwa),tubwgt)),by=occ_22]

write.table(mean_earn_occ_mal,file = "../data/mean_earn_occ_all_22occs_mal_may.txt", sep=",")
write.table(var_logearn_occ_mal,file = "../data/var_logearn_occ_all_22occs_mal_may.txt", sep=",", col.names=F)

rm(DT_mal)

#########################################################
##Earnings (per hour) moments by gender and occ
#########################################################

mean_earn_ph_all<-weighted.mean(data_cps$prernwa_ph,data_cps$tubwgt)
mean_earn_ph_mal<-weighted.mean(data_cps_mal$prernwa_ph,data_cps_mal$tubwgt)
mean_earn_ph_fem<-weighted.mean(data_cps_fem$prernwa_ph,data_cps_fem$tubwgt)

mean_earn_ph_gender <- cbind(mean_earn_ph_all,mean_earn_ph_mal,mean_earn_ph_fem)

write.table(mean_earn_ph_gender,file = "../data/mean_earn_ph_gender_may.txt", sep=",")


DT <- data.table(data_cps)
mean_earn_ph_occ<-DT[,list(mean_earn_ph_occ = weighted.mean(prernwa_ph,tubwgt)),by=occ_22]
var_logearn_ph_occ<-DT[,list(var_logearn_ph_occ = wtd.var(log(prernwa_ph),tubwgt)),by=occ_22]

write.table(mean_earn_ph_occ,file = "../data/mean_earn_ph_occ_all_22occs_may.txt", sep=",")
write.table(var_logearn_ph_occ,file = "../data/var_logearn_ph_occ_all_22occs_may.txt", sep=",", col.names=F)
rm(DT)


DT_fem <- data.table(data_cps_fem)
mean_earn_ph_occ_fem<-DT_fem[,list(mean_earn_ph_occ_fem = weighted.mean(prernwa_ph,tubwgt)),by=occ_22]
var_logearn_ph_occ_fem<-DT_fem[,list(var_logearn_ph_occ_fem = wtd.var(log(prernwa_ph),tubwgt)),by=occ_22]

write.table(mean_earn_ph_occ_fem,file = "../data/mean_earn_ph_occ_all_22occs_fem_may.txt", sep=",")
write.table(var_logearn_ph_occ_fem,file = "../data/var_logearn_ph_occ_all_22occs_fem_may.txt", sep=",", col.names=F)


rm(DT_fem)

DT_mal <- data.table(data_cps_mal)
mean_earn_ph_occ_mal<-DT_mal[,list(mean_earn_ph_occ_mal = weighted.mean(prernwa_ph,tubwgt)),by=occ_22]
var_logearn_ph_occ_mal<-DT_mal[,list(var_logearn_ph_occ_mal = wtd.var(log(prernwa_ph),tubwgt)),by=occ_22]

write.table(mean_earn_ph_occ_mal,file = "../data/mean_earn_ph_occ_all_22occs_mal_may.txt", sep=",")
write.table(var_logearn_ph_occ_mal,file = "../data/var_logearn_ph_occ_all_22occs_mal_may.txt", sep=",", col.names=F)

rm(DT_mal)



############################################################
###occupation shares
#############################################################

sum_ind_occ <- summaryBy(tubwgt ~ occ_22, FUN=c(sum), data=data_cps)
occ_shares_all<-sum_ind_occ$tubwgt.sum/sum(sum_ind_occ$tubwgt.sum)
sum(occ_shares_all)

ind_occ_fem <- summaryBy(tubwgt ~ occ_22, FUN=c(sum), data=data_cps_fem)
ind_occ_mal <- summaryBy(tubwgt ~ occ_22, FUN=c(sum), data=data_cps_mal)

share_fem_occ<-ind_occ_fem$tubwgt.sum/sum_ind_occ$tubwgt.sum
share_mal_occ<-ind_occ_mal$tubwgt.sum/sum_ind_occ$tubwgt.sum


sum_ind_occ_mal <- summaryBy(tubwgt ~ occ_22, FUN=c(sum), data=data_cps_mal)
sum_ind_occ_fem <- summaryBy(tubwgt ~ occ_22, FUN=c(sum), data=data_cps_fem)

share_fem_occ2<-ind_occ_fem$tubwgt.sum/sum(sum_ind_occ_fem)
share_mal_occ2<-ind_occ_mal$tubwgt.sum/sum(sum_ind_occ_mal)

write.table(occ_shares_all,file = "../data/occ_shares_all_22occs_may.txt", sep=",", col.names=F,row.names=F)
write.table(share_fem_occ,file = "../data/share_fem_occ_22occs_may.txt", sep=",",col.names=F,row.names=F)



###########################################################
##hours worked and hosuehold care hours ATUS
############################################################

##count ind by occ 
freq_occ<-as.data.frame(table(data_at4$occ_22))
names(freq_occ)[1] <- "occ_22"
print(freq_occ)

##use the sample of matched cps and atus
data_at4_mal<-data_at4[data_at4$tesex==1,]
data_at4_fem<-data_at4[data_at4$tesex==2,]

###aggregate moments by gender weighted by atus weights

mean_hhcare_hours_all<-weighted.mean(data_at4$hh_at,data_at4$tufnwgtp)
mean_hhcare_hours_mal<-weighted.mean(data_at4_mal$hh_at,data_at4_mal$tufnwgtp)
mean_hhcare_hours_fem<-weighted.mean(data_at4_fem$hh_at,data_at4_fem$tufnwgtp)

mean_work_hours_all<-weighted.mean(data_at4$w_at,data_at4$tufnwgtp)
mean_work_hours_mal<-weighted.mean(data_at4_mal$w_at,data_at4_mal$tufnwgtp)
mean_work_hours_fem<-weighted.mean(data_at4_fem$w_at,data_at4_fem$tufnwgtp)

###moments by occ and by gender weighted by atus weights

DT_atus <- data.table(data_at4)
mean_hhcare_hours_occ_all<-DT_atus[,weighted.mean(hh_at,tufnwgtp),by=occ_22]
mean_hhcare_hours_occ_all<-mean_hhcare_hours_occ_all[order(mean_hhcare_hours_occ_all$occ_22),]
rm(DT_atus)

DT_atus_mal <- data.table(data_at4_mal)
mean_hhcare_hours_occ_mal<-DT_atus_mal[,weighted.mean(hh_at,tufnwgtp),by=occ_22]
mean_hhcare_hours_occ_mal<-mean_hhcare_hours_occ_mal[order(mean_hhcare_hours_occ_mal$occ_22),]
rm(DT_atus_mal)

DT_atus_fem <- data.table(data_at4_fem)
mean_hhcare_hours_occ_fem<-DT_atus_fem[,weighted.mean(hh_at,tufnwgtp),by=occ_22]
mean_hhcare_hours_occ_fem<-mean_hhcare_hours_occ_fem[order(mean_hhcare_hours_occ_fem$occ_22),]
rm(DT_atus_fem)

DT_atus <- data.table(data_at4)
mean_work_hours_occ_all<-DT_atus[,weighted.mean(w_at,tufnwgtp),by=occ_22]
mean_work_hours_occ_all<-mean_work_hours_occ_all[order(mean_work_hours_occ_all$occ_22),]
rm(DT_atus)

DT_atus_mal <- data.table(data_at4_mal)
mean_work_hours_occ_mal<-DT_atus_mal[,weighted.mean(w_at,tufnwgtp),by=occ_22]
mean_work_hours_occ_mal<-mean_work_hours_occ_mal[order(mean_work_hours_occ_mal$occ_22),]
rm(DT_atus_mal)

DT_atus_fem <- data.table(data_at4_fem)
mean_work_hours_occ_fem<-DT_atus_fem[,weighted.mean(w_at,tufnwgtp),by=occ_22]
mean_work_hours_occ_fem<-mean_work_hours_occ_fem[order(mean_work_hours_occ_fem$occ_22),]
#names(mean_work_hours_occ_fem)[2]<-"mean_work_hours_occ_fem"
rm(DT_atus_fem)


mean_hhcare_hours_occ_gender<-cbind(mean_hhcare_hours_occ_all,mean_hhcare_hours_occ_mal$V1,mean_hhcare_hours_occ_fem$V1)
mean_work_hours_occ_gender<-cbind(mean_work_hours_occ_all,mean_work_hours_occ_mal$V1,mean_work_hours_occ_fem$V1)

mean_hhcare_hours<-cbind(mean_hhcare_hours_all,mean_hhcare_hours_mal,mean_hhcare_hours_fem)
mean_work_hours <- cbind(mean_work_hours_all,mean_work_hours_mal,mean_work_hours_fem)

write.table(mean_hhcare_hours,file = "../data/mean_hhcare_hours_gender_22occs_may.txt", sep=",")
write.table(mean_work_hours,file = "../data/mean_work_hours_gender_22occs_may.txt", sep=",")

write.table(mean_hhcare_hours_occ_gender,file = "../data/mean_hhcare_hours_occ_gender_22occs_may.txt", sep=",")
write.table(mean_work_hours_occ_gender,file = "../data/mean_work_hours_gender_occ_22occs_may.txt", sep=",")


###########################################################
##hours work cps sample
############################################################

##use the sample of matched cps and atus
data_cps_mal<-data_cps[data_cps$pesex==1,]
data_cps_fem<-data_cps[data_cps$pesex==2,]

###aggregate moments by gender weighted by atus weights

mean_work_hours_all_cps<-weighted.mean(data_cps$pehrusl1,data_cps$tubwgt)
mean_work_hours_mal_cps<-weighted.mean(data_cps_mal$pehrusl1,data_cps_mal$tubwgt)
mean_work_hours_fem_cps<-weighted.mean(data_cps_fem$pehrusl1,data_cps_fem$tubwgt)

###moments by occ and by gender weighted by atus weights

DT <- data.table(data_cps)
mean_work_hours_occ_all_cps<-DT[,weighted.mean(pehrusl1,tubwgt),by=occ_22]
mean_work_hours_occ_all_cps<-mean_work_hours_occ_all_cps[order(mean_work_hours_occ_all_cps$occ_22),]
rm(DT)
DT_mal <- data.table(data_cps_mal)
mean_work_hours_occ_mal_cps<-DT_mal[,weighted.mean(pehrusl1,tubwgt),by=occ_22]
mean_work_hours_occ_mal_cps<-mean_work_hours_occ_mal_cps[order(mean_work_hours_occ_mal_cps$occ_22),]
rm(DT_mal)
DT_fem <- data.table(data_cps_fem)
mean_work_hours_occ_fem_cps<-DT_fem[,weighted.mean(pehrusl1,tubwgt),by=occ_22]
mean_work_hours_occ_fem_cps<-mean_work_hours_occ_fem_cps[order(mean_work_hours_occ_fem_cps$occ_22),]
rm(DT_fem)




mean_work_hours_occ_gender_cps<-cbind(mean_work_hours_occ_all_cps,mean_work_hours_occ_mal_cps$V1,mean_work_hours_occ_fem_cps$V1)
mean_work_hours_cps <- cbind(mean_work_hours_all_cps,mean_work_hours_mal_cps,mean_work_hours_fem_cps)


###########################################################
##weekly hours work atus sample
############################################################

###aggregate moments by gender weighted by atus weights

mean_work_hours_all_at4<-weighted.mean(data_at4$tehrusl1,data_at4$tufnwgtp)
mean_work_hours_mal_at4<-weighted.mean(data_at4_mal$tehrusl1,data_at4_mal$tufnwgtp)
mean_work_hours_fem_at4<-weighted.mean(data_at4_fem$tehrusl1,data_at4_fem$tufnwgtp)

###moments by occ and by gender weighted by atus weights

DT <- data.table(data_at4)
mean_work_hours_occ_all_at4<-DT[,weighted.mean(tehrusl1,tufnwgtp),by=occ_22]
mean_work_hours_occ_all_at4<-mean_work_hours_occ_all_at4[order(mean_work_hours_occ_all_at4$occ_22),]
rm(DT)
DT_mal <- data.table(data_at4_mal)
mean_work_hours_occ_mal_at4<-DT_mal[,weighted.mean(tehrusl1,tufnwgtp),by=occ_22]
mean_work_hours_occ_mal_at4<-mean_work_hours_occ_mal_at4[order(mean_work_hours_occ_mal_at4$occ_22),]
rm(DT_mal)
DT_fem <- data.table(data_at4_fem)
mean_work_hours_occ_fem_at4<-DT_fem[,weighted.mean(tehrusl1,tufnwgtp),by=occ_22]
mean_work_hours_occ_fem_at4<-mean_work_hours_occ_fem_at4[order(mean_work_hours_occ_fem_at4$occ_22),]
rm(DT_fem)


mean_work_hours_occ_gender_at4<-cbind(mean_work_hours_occ_all_at4,mean_work_hours_occ_mal_at4$V1,mean_work_hours_occ_fem_at4$V1)
mean_work_hours_at4 <- cbind(mean_work_hours_all_at4,mean_work_hours_mal_at4,mean_work_hours_fem_at4)

write.table(mean_work_hours_cps,file = "../data/mean_work_hours_gender_22occs_cps_may.txt", sep=",", col.names=F)
write.table(mean_work_hours_occ_gender_cps,file = "../data/mean_work_hours_gender_occ_22occs_cps_may.txt", sep=",", col.names=F)


