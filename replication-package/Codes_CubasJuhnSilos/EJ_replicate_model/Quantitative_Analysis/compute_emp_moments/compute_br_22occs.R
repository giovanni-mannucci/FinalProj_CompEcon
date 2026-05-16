rm(list=ls())
 
library(data.table)

data_at <- fread("../data/2.4_data_#2_b.csv", header=TRUE, sep = ',')

data_at[1:2,]

##create individual id
data_at$newid <- paste0(as.character(data_at$tucaseid),as.character(data_at$tulineno))

data6<-data_at[!is.na(data_at$occ_22),]
rm(data_at)

data6$sum_w<-data6$work*data6$tufnwgtp
data6$sum_hh<-data6$householdcare*data6$tufnwgtp
data6$sum_tot<-data6$tufnwgtp


###########data cps###########
##############################

data_cps <- fread("../data/6_b_reg_april2019.csv", header=TRUE, sep = ',')

data_cps$newid <- paste0(as.character(data_cps$tucaseid),as.character(data_cps$tulineno))


##########################clean data#####################
##############################################################
## we apply the filters
##############################################################


##restrict the sample to prime age workers
data_cps3<- data_cps[data_cps$prtage>17,]
data_cps4<- data_cps3[data_cps3$prtage<66,]

#hours cps
data_cps5<-data_cps4[!is.na(data_cps4$pehrusl1),]
data_cps5<-data_cps5[data_cps5$pehrusl1>34,]
rm(data_cps3)
rm(data_cps4)

data_filter<-merge(data_cps5,data6,by="newid")

# harmmonizes the samples for the ind according to the different hours filters
data7<-data6[data6$newid %in% data_filter$newid,]
rm(data6)

data6<-data7

##incorporates to the atus data the cps variables that allows us to further filter the 
##sample to married with kids

data_cps5<-data_cps
myvars <- c("newid","tubwgt","pemaritl","prnmchld","prernwa","pesex")
data_cps6<-data_cps5[,..myvars]

data8<-merge(data6,data_cps6,by="newid")
rm(data6)

data6<-data8

##restrict the sample to married individuals
data6<- data6[data6$pemaritl.x==1|data6$pemaritl.x==2,]

#eliminate NAs in weights
data6$prernwa<-data6$prernwa/100
data6<- data6[data6$prernwa>0,]

###restrict the sample to married individuals with kids under 18
data6<- data6[data6$prnmchld>0,]


##########################################################
##calculate br for the overall sample by gender
##########################################################
#filter by sex (2 is female)
#data6b<-data6

for (sex_index in seq(1,2)){
if (sex_index == 1) { 
    filename_br = "../data/br_6_m.csv"
} else {
    filename_br = "../data/br_6_f.csv"
}

data6b<-data6[data6$tesex==sex_index,]


data_sum_all<-data6b

DT_sum_all <- data.table(data_sum_all)
sumbin_work_all<-DT_sum_all[, sum(sum_w),by=timebin]
sumbin_hhcare_all<-DT_sum_all[, sum(sum_hh),by=timebin]
sumbin_tot_all<-DT_sum_all[, sum(sum_tot),by=timebin]

sumbin_work_all<-data.matrix(sumbin_work_all[order(sumbin_work_all$timebin),])
sumbin_hhcare_all<-data.matrix(sumbin_hhcare_all[order(sumbin_hhcare_all$timebin),])
sumbin_tot_all<-data.matrix(sumbin_tot_all[order(sumbin_tot_all$timebin),])
store_sumbin_work_all<-sumbin_work_all[,2]
store_sumbin_hhcare_all<-sumbin_hhcare_all[,2]
store_sumbin_tot_all<-sumbin_tot_all[,2]

br8to5_work_all<-sum(store_sumbin_work_all[9:17])/sum(store_sumbin_work_all)
br8to5_hhcare_all<-sum(store_sumbin_hhcare_all[9:17])/sum(store_sumbin_hhcare_all)

br8to5_all<-cbind(br8to5_work_all,br8to5_hhcare_all)

br8to5_all
write.csv(br8to5_all,file=filename_br)
}
##################################################################
## calculate br by occ
##################################################################

occcodes <- levels(factor(data6$occ_22))
occ_codes <- occcodes[!is.na(table(data6$occ_22)[occcodes])]
nocc <- length(occ_codes)
store_sumbin_work_occ<-matrix(data=NA, nrow=24, ncol=nocc)
store_sumbin_hhcare_occ<-matrix(data=NA, nrow=24, ncol=nocc)

k <- 1
for (j in occ_codes){
data_sum<-data6[data6$occ_22==j,]

DT <- data.table(data_sum)
sumbin_work_occ<-DT[, sum(sum_w),by=timebin]
sumbin_hhcare_occ<-DT[, sum(sum_hh),by=timebin]
sumbin_work_occ<-data.matrix(sumbin_work_occ[order(sumbin_work_occ$timebin),])
sumbin_hhcare_occ<-data.matrix(sumbin_hhcare_occ[order(sumbin_hhcare_occ$timebin),])
store_sumbin_work_occ[,k]<-sumbin_work_occ[,2]
store_sumbin_hhcare_occ[,k]<-sumbin_hhcare_occ[,2]
k <- k+1
}

#calculate bunching ratio
br8to5_work_occ<-matrix(data=NA, nrow=nocc, ncol=1)
br8to5_hhcare_occ<-matrix(data=NA, nrow=nocc, ncol=1)
for (j in 1:nocc){
br8to5_work_occ[j]<-sum(store_sumbin_work_occ[9:17,j])/sum(store_sumbin_work_occ[,j])
br8to5_hhcare_occ[j]<-sum(store_sumbin_hhcare_occ[9:17,j])/sum(store_sumbin_hhcare_occ[,j])
}
# write output
write.table(br8to5_work_occ,file = "../data/br_w_22_may19.txt", sep=",", col.names=F, row.names=F)
write.table(br8to5_hhcare_occ,file = "../data/br_hh_22_may19.txt", sep=",", col.names=F, row.names=F)



