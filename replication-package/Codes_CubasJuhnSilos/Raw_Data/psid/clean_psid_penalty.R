rm(list=ls())
library(doBy)
library(data.table)

# load cnef-psid data
data_psid <- read.csv("./datpsid.csv", header=TRUE, sep = ',')

##########filters###################33

hours_low <- 1820   # lower bound on hours (annual)
hours_high <- 5110 # upper bound on hours (annual)
earnings_low <- 1.00 # lower bounds on earnings per hour
earnings_high <- 300 # upper bounds on earnings per hour
min_nper <- 3   # minimum number of consecutive years in samplkeep(c(hours_low,hours_high,earnings_low,earnings_high,min_nper, growth_low, growth_high), sure=TRUE)


datest<-subset(data_psid, select=c("x11101ll","x11102",
                                   "w11101","w11102","w11103","w11104","d11101","d11102ll",
                                   "d11104","d11105","d11106","d11107","d11109","d11112ll",
                                   "e11101","e11102","e11103","e11104","e11105","e11106",
                                   #"e11107",
                                   "h11101","h11102",
                                   "h11103","h11104","h11105","h11106","h11107","h11108","h11109",
                                   "h11110","h11112",
                                   #"i11101","i11102","i11103","i11104","i11105","i11106","i11107","i11108","i11109",
                                   #"i11112","i11113","i11114","i11115","i11116","i11117","i11118",
                                   "i11110","i11111","year"))
rm(data_psid)
summary(datest$e11105)


# Eliminate missing obs for occupation classif.
#datest2<-datest[!is.na(datest$e11105),]
#datest2<-datest2[as.numeric(datest2$e11105)!=-1,]
#datest2<-datest2[as.numeric(datest2$e11105)!=-2,]
#datest2<-datest2[as.numeric(datest2$e11105)!=0,]
#datest2<-datest2[as.numeric(datest2$e11105)!=-3,]
datest2<-datest

##count individuals in each sample
nrper<-datest$x11101ll
nrper<-unique(nrper)
length(nrper)

##################################################################
#compute the frequency of individuals
freqindiv<-as.data.frame(table(datest2$x11101ll))
names(freqindiv)[1] <- "x11101ll"

datest3<-merge(freqindiv,datest2,by=c("x11101ll"))
rm(datest2)
print(datest3[1:10,])
datest4<-datest3[datest3$Freq>=1,]
print(datest4[1:10,])
rm(datest3)

#order the data by individual and by year
datest5<-orderBy(~x11101ll+year, data=datest4)
print(datest5[1:23,])
rm(datest4)

summary(datest5)

##############################################3
# Select prime-age workers
datest6<-datest5[datest5$d11101>18,]
datest7<-datest6[datest6$d11101<65,]

rm(datest6)

datest8<-datest7


#datest8_aux<- datest8[datest8$x11101ll==6006,]

# Eliminate people not employed following the criterion in e11104
# e11102 is problematic (it eliminates a bunch of people for no reason)
#datest9<-datest8[as.numeric(datest8$e11104)!=-1,]
#datest9<-datest9[as.numeric(datest9$e11104)!=-2,]
#datest9<-datest9[as.numeric(datest9$e11104)!=-3,]
#datest9<-datest9[as.numeric(datest9$e11104)!=2,]
#datest9<-datest9[as.numeric(datest9$e11104)!=0,]
#rm(datest8)

datest9<-datest8

#########################################
# Merge cpi index to main dataset
cpius <- read.csv("./cpius.csv", header=TRUE, sep = ',')


datest10<-merge(cpius,datest9,by=c("year"))
rm(datest9)

#re-order the data by individual and by year
datest11<-orderBy(~x11101ll+year, data=datest10)
print(datest11[1:23,])

rm(datest10)

datest12<-datest11

##########################################################
#rename industry variable (one digit industry code e11106)
datest12$indus<-datest12$e11106
#rename the occupation variable
datest12$occ<-datest12$e11105


freq_occ<-as.data.frame(table(datest12$occ))
names(freq_occ)[1] <- "occ"
print(freq_occ)

#######################################################


########################################################
#############################################################
##EARNINGS
######################################################################

datest11<-datest12

# Eliminate people with no earnings
datest12<-datest11[!is.na(datest11$i11110),]
datest12<-datest12[datest12$i11110>0,]
rm(datest11)

print(datest12[1:10,])
nrper12<-datest12$x11101ll
nrper12<-unique(nrper12)
length(nrper12)


# Eliminate people with 0 hours of work
#datest13<-datest12[datest12$e11101>0,]
#rm(datest12)
datest13<-datest12

datest13<-datest13[!is.na(datest13$e11101),]

nrper13<-datest13$x11101ll
nrper13<-unique(nrper13)
length(nrper13)

freq_hs<-as.data.frame(table(datest13$e11101))
names(freq_hs)[1] <- "e11101"
freq_hs<-orderBy(~e11101, data=freq_hs)
print(freq_hs[1:10,])


print(datest13[1:10,])

# Calculate earnings in real terms
datest13$earnr<-(datest13$i11110*100)/datest13$cpi
# Apply hours filters



datest13 <- as.data.table(datest13)

datest13[, hours_shifted := shift(e11101, type="lead"), by=x11101ll]
datest13[, earn_shifted := shift(earnr, type="lead"), by=x11101ll]
datest13 <- as.data.frame(datest13)
datest13$earnh<-datest13$earn_shifted/datest13$hours_shifted


nrper13<-datest13$x11101ll
nrper13<-unique(nrper13)
length(nrper13)

# relabel some variables
datest13$sex <- datest13$d11102ll - 1
datest13$educ <- datest13$d11109
datest13$marital <- datest13$d11104
datest13$age <- datest13$d11101

datest14<-datest13



##############################################################
# eliminate individuals whose longest span is less than min_nper consecutive
# years. 
testcons2 <- function(vecyear) {
  # This function retrieves (for a given individual) the year
  # indices for the beginning and end of the longest span of
  # consecutive observations. 
  year_diff <- vecyear[-1] - vecyear[-length(vecyear)] 
  store <- array(0, dim=c((length(vecyear)-1),4))
  k <- 1
  kmin <- 1
  kmax <- 1
  j <- 2
  if (dim(as.matrix(vecyear))[1]==1) {
    return(c(0,0))
  } else {
    for (i in seq(1, length(year_diff))){
      if (vecyear[j]<=1997) { 
        if (year_diff[i]==1) {
          k <- k+1
          kmax <- i+1
        } else {
          k<-1
          kmin <- i + 1
          kmax <- i + 1
        }
      } else {
        if (year_diff[i]==2) {
          k <- k+1
          kmax <- i+1
        } else {
          k<-1
          kmin <- i + 1
          kmax <- i + 1
        }
      }
      j <- j + 1
      store[i,] <- c(i,kmin,kmax,kmax-kmin+1)
    }
    ind_max <- which.max(store[,4])
    return(c(store[ind_max, 2],store[ind_max, 3]))   
  }
}


# order data frame
datest14$x11101ll <- factor(datest14$x11101ll)
datest14 <- datest14[order(datest14$x11101ll, datest14$year),]

# obtain indices for the beginning and ending of longest consecutive
# span of years. 
tempvector2 <- summaryBy(year ~ x11101ll, data = datest14, FUN =testcons2)
names(tempvector2) <- c("x11101ll","kmin","kmax")
tempvector2$maxobs <- tempvector2$kmax-tempvector2$kmin + 1

datest14 <- merge(tempvector2,datest14)
datest14 <- datest14[datest14$maxobs >= min_nper,]   
datest14 <- datest14[order(datest14$x11101ll,datest14$year),]

datest14$nobbyid <- ave(as.numeric(datest14$x11101ll), datest14$x11101ll, FUN=seq_along)
datest14 <- datest14[datest14$kmin<=datest14$nobbyid & datest14$kmax>=datest14$nobbyid,]


datest14_aux<- datest14[datest14$x11101ll==6006,]


datest14$h11103<- ifelse(datest14$h11103>1,1,datest14$h11103)

##################################################################

datest14$kid_age1<- datest14$h11103*.5
datest14$kid_age2<- datest14$h11104*3
datest14$kid_age3<- datest14$h11105*6
datest14$kid_age4<- datest14$h11106*9
datest14$kid_age5<- datest14$h11107*11.5
datest14$kid_age6<- datest14$h11108*14
datest14$kid_age7<- datest14$h11109*17


datest14$nhhkids2<- (datest14$h11103+datest14$h11104+datest14$h11105+datest14$h11106+
                         datest14$h11107+datest14$h11108+datest14$h11109)


datest14$kids_avage<- (datest14$kid_age1+datest14$kid_age2+datest14$kid_age3+datest14$kid_age4+
datest14$kid_age5+datest14$kid_age6+datest14$kid_age7)/datest14$nhhkids2



#select hh that ever had at least one kid in the house
datest14_aux1 <- summaryBy(nhhkids2 ~ x11101ll, data = datest14, FUN =max)
datest14b<-merge(datest14,datest14_aux1) 
rm(datest14)
datest14<-datest14b
datest14$nhhkids2_var<- ifelse(datest14$nhhkids2.max>0,1,0)
datest14<-datest14[datest14$nhhkids2_var==1,]

summary(datest14$kid_age1)


#discard hh that already had kids when appear on the PSID
datest14_aux2 <- summaryBy(h11103 ~ x11101ll, data = datest14, FUN =max)
datest14c<-merge(datest14,datest14_aux2) 
rm(datest14)
datest14<-datest14c

datest14<-datest14[datest14$h11103.max!=0,]

#datest14$kid_age1_var<- ifelse(datest14$h11103.max>0,1,0)
#datest14<-datest14[datest14$kid_age1_var==1,]


datest14_aux<- datest14[datest14$x11101ll==6006,]

summary(datest14$h11103)

###############################################################################
##################################################################

datest14$newkid_01<- ifelse(datest14$h11103==1,1,0)

datest14$newkid_01_b<-datest14$newkid_01*datest14$age

datest14$age_parent_newkid<-ifelse(datest14$newkid_01_b==0,1000,datest14$newkid_01_b)

datest14_aux <- summaryBy(age_parent_newkid ~ x11101ll, data = datest14, FUN =min)

datest15<-merge(datest14,datest14_aux) 

datest15$det_age_newkid<- -(datest15$age_parent_newkid.min-datest15$age)

datest15$age_parent_newkid<-NULL
datest15$age_parent_newkid<-datest15$age_parent_newkid.min
datest15$age_parent_newkid.min<-NULL

  
datest15_aux<- datest15[datest15$x11101ll==4175,]
datest15_aux<- datest15[datest15$x11101ll==6006,]

##############

datest15$newkid_01_f<- ifelse(datest15$det_age_newkid==0,1,0)

datest15$occ_1stkid<- ifelse(datest15$newkid_01_f==1,datest15$occ,0)

datest15$year_1stkid<- ifelse(datest15$newkid_01_f==1,datest15$year,0)

datest15_aux <- summaryBy(occ_1stkid ~ x11101ll, data = datest15, FUN =max)

datest16<-merge(datest15,datest15_aux) 

rm(datest15)

datest16$occ_1stkid<-datest16$occ_1stkid.max
datest16$occ_1stkid.max<-NULL

datest15_aux2 <- summaryBy(year_1stkid ~ x11101ll, data = datest16, FUN =max)

datest16b<-merge(datest16,datest15_aux2) 
rm(datest16)

datest16<-datest16b

datest16$year_1stkid<-NULL
datest16$year_1stkid<-datest16$year_1stkid.max
datest16$year_1stkid.max<-NULL

#################################################
#fix workers who report occ1stkid=0 and assign it the previous year occ

datest16$newkid_01_g<- ifelse(datest16$det_age_newkid==-1,1,0)

datest16$occ_1stkid_b<- ifelse(datest16$newkid_01_g==1,datest16$occ,-10)
datest16_aux <- summaryBy(occ_1stkid_b ~ x11101ll, data = datest16, FUN =max)

datest16_b<-merge(datest16,datest16_aux) 
rm(datest16)
datest16<-datest16_b

#datest16$occ_1stkid_b<-datest16$occ_1stkid_b.max
#datest16$occ_1stkid_b.max<-NULL

datest16$occ_1stkid_c<- ifelse(datest16$occ_1stkid==0,datest16$occ_1stkid_b.max,datest16$occ_1stkid)

datest16$occ_1stkid<-NULL
datest16$occ_1stkid<-datest16$occ_1stkid_c
datest16$occ_1stkid_c<-NULL


####################################################
datest16$newkid_01<-NULL
datest16$newkid_01_b<-NULL
datest16$newkid_01_c<-NULL
datest16$newkid_01_d<-NULL
datest16$newkid_01_f<-NULL


datest16_aux<- datest16[datest16$x11101ll==16003,]

datest16_aux<- datest16[datest16$x11101ll==6867192,]


######################################################
##################Kleuven Regression##################
######################################################

# un check aqui para ver
z <- summaryBy( year + year_1stkid~ x11101ll, datest16,FUN=max)
summary(z$year.max-z$year_1stkid.max)


datest16_aux<- datest16[datest16$x11101ll==134003 ,]


z2 <- z[z$year_1stkid.max==0,]


###################################################
datest17<-datest16
rm(datest16)
datest17$yeardiff<- datest17$year-datest17$year_1stkid
 
#select two years before and after of the year when the kids is born
 
datest17<- datest17[datest17$yeardiff>-6,]
datest17<- datest17[datest17$yeardiff<11,]
datest17<- datest17[datest17$det_age_newkid>-6,]
datest17<- datest17[datest17$det_age_newkid<11,]
datest17$year1_5minuskid<- ifelse(datest17$det_age_newkid==-5,1,0)
datest17$year1_4minuskid<- ifelse(datest17$det_age_newkid==-4,1,0)
datest17$year1_3minuskid<- ifelse(datest17$det_age_newkid==-3,1,0)
datest17$year1_2minuskid<- ifelse(datest17$det_age_newkid==-2,1,0)
datest17$year1_1minuskid<- ifelse(datest17$det_age_newkid==-1,1,0)
datest17$year1_0kid<- ifelse(datest17$det_age_newkid==0,1,0)
datest17$year1_1pluskid<- ifelse(datest17$det_age_newkid==1,1,0)
datest17$year1_2pluskid<- ifelse(datest17$det_age_newkid==2,1,0)
datest17$year1_3pluskid<- ifelse(datest17$det_age_newkid==3,1,0)
datest17$year1_4pluskid<- ifelse(datest17$det_age_newkid==4,1,0)
datest17$year1_5pluskid<- ifelse(datest17$det_age_newkid==5,1,0)
datest17$year1_6pluskid<- ifelse(datest17$det_age_newkid==6,1,0)
datest17$year1_7pluskid<- ifelse(datest17$det_age_newkid==7,1,0)
datest17$year1_8pluskid<- ifelse(datest17$det_age_newkid==8,1,0)
datest17$year1_9pluskid<- ifelse(datest17$det_age_newkid==9,1,0)
datest17$year1_10pluskid<- ifelse(datest17$det_age_newkid==10,1,0)


datest16<-datest17
rm(datest17)


datest16$id <- datest16$x11101ll
datest16$age2 <- datest16$age*datest16$age
datest16$age3 <- datest16$age2*datest16$age

datest16$idweight <- datest16$w11101
datest16$hhweight <- datest16$w11102
datest16$idlweight<- datest16$w11103
datest16$idpopfact<- datest16$w11104
datest16$relhead<- datest16$d11105
datest16$nhhmembers<- datest16$d11106
datest16$nhhkids<- datest16$d11107
datest16$race<- datest16$d11112ll
datest16$hoursyear<- datest16$e11101
datest16$empstatus<- datest16$e11102
datest16$emplevel<- datest16$e11103
datest16$empactive<- datest16$e11104


datest17<-subset(datest16, select=c("id","hhweight",
                                    "idweight","hhweight","idlweight","idpopfact",
                                    "relhead","nhhmembers","nhhkids2","race",
                                    "hoursyear","empstatus","emplevel","empactive",
                                    "sex","educ","marital","hours_shifted","earn_shifted",
                                    "kids_avage","age","age2","age3","occ","indus",
                                    "earnr","earnh","occ_1stkid","year","year_1stkid",
                                    "year1_5minuskid","year1_4minuskid","year1_3minuskid",
                                    "year1_2minuskid","year1_1minuskid","year1_0kid",
                                    "year1_1pluskid","year1_2pluskid","year1_3pluskid",
                                    "year1_4pluskid","year1_5pluskid",
                                    "year1_6pluskid","year1_7pluskid","year1_8pluskid",
                                    "year1_9pluskid","year1_10pluskid","yeardiff"))



datest17<-orderBy(~id+year, data=datest17)
datest17$id <- droplevels(datest17$id)

datest17$period <- 0
datest17$period <- ifelse(datest17$yeardiff < -2,1,datest17$period)
datest17$period <- ifelse(datest17$yeardiff > -3 & datest17$yeardiff < 2,2,datest17$period)
datest17$period <- ifelse(datest17$yeardiff > 1 & datest17$yeardiff < 4,3,datest17$period)
datest17$period <- ifelse(datest17$yeardiff > 3 & datest17$yeardiff < 6,4,datest17$period)
datest17$period <- ifelse(datest17$yeardiff > 5 & datest17$yeardiff < 8,5,datest17$period)
datest17$period <- ifelse(datest17$yeardiff > 7 & datest17$yeardiff < 11,6,datest17$period)



#for ( i in cases){

#datest18 <- datest17[datest17$sex==1,]
datest18 <- datest17
datest18 <- datest18[datest18$earnh > earnings_low,]
datest18 <- datest18[datest18$earnh < earnings_high,]

datest18 <- datest18[datest18$hours_shifted > hours_low,]
datest18 <- datest18[datest18$hours_shifted < hours_high,]

datest18 <- datest18[!is.na(datest18$occ_1stkid), ] 
count_datest18<-length(unique(datest18$id))
count_datest18
datest18 <- datest18[datest18$marital==1,]  

#eliminate unkonown occs
datest19 <- datest18[datest18$occ_1stkid>0, ] 
count_datest19<-length(unique(datest19$id))
count_datest19
write.csv(datest19, file="./clean_psid_data.csv")
