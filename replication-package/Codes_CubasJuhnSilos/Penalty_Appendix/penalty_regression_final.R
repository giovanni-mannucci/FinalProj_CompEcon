rm(list=ls())
datest19 <- read.csv('../Raw_Data/psid/clean_psid_data.csv')
datest21 <- datest19[datest19$occ_1stkid==13 |
					 datest19$occ_1stkid==12 |
					 datest19$occ_1stkid==40 |
					  datest19$occ_1stkid==41|
					  datest19$occ_1stkid==43|
	                 datest19$occ_1stkid==2|
		             datest19$occ_1stkid==3|		
datest19$occ_1stkid==45|		
datest19$occ_1stkid==49|		
 datest19$occ_1stkid==39|		
 datest19$occ_1stkid==33|
 datest19$occ_1stkid==14|
 datest19$occ_1stkid==18|		
 datest19$occ_1stkid==15|
 datest19$occ_1stkid==81|
 datest19$occ_1stkid==87|
 datest19$occ_1stkid==89|
 datest19$occ_1stkid==93|
 datest19$occ_1stkid==95|
					 datest19$occ_1stkid==5 , ]
###
#
##
datest21 <- datest21[datest21$sex==1,]
				 reg_hours_hbr <- lm(earnh ~ factor(year) + factor(age) + factor(period)-1,datest21,weights=idweight)
dimcoeff_hbr <- length(reg_hours_hbr$coeff)

coeffs_hbr <- reg_hours_hbr$coeff[(dimcoeff_hbr-4):dimcoeff_hbr]

dd <- datest21[datest21$period==1, ]
m <- mean(dd$earnh,na.rm=T)

coeffs_hbr <- coeffs_hbr/m
std_error_hbr <- (1/m)*coef(summary(reg_hours_hbr))[(dimcoeff_hbr-4):dimcoeff_hbr,2]
print(coeffs_hbr)
print(dim(datest21))

## low bunching ratio occupations Nov 2021
datest21 <- datest19[datest19$occ_1stkid==98 | 
					 datest19$occ_1stkid==61 |
					 datest19$occ_1stkid==62 |
					   datest19$occ_1stkid==64| 
					   datest19$occ_1stkid==70| 
					   datest19$occ_1stkid==71| 
					   datest19$occ_1stkid==74| 
					   datest19$occ_1stkid==80| 
					   datest19$occ_1stkid==83| 
					   datest19$occ_1stkid==86| 
					   					   datest19$occ_1stkid==88| 
					   					  datest19$occ_1stkid==52 |
				  datest19$occ_1stkid==58 |
				  datest19$occ_1stkid==55 |
				  datest19$occ_1stkid==53 |
				  datest19$occ_1stkid==56 |
				  datest19$occ_1stkid==59 |
datest19$occ_1stkid==17|
				  datest19$occ_1stkid==34 |
 datest19$occ_1stkid==7|
	 				  datest19$occ_1stkid==54 , ]
##34, #7

datest21 <- datest21[datest21$sex==1,]
reg_hours_lbr <- lm(earnh ~ factor(year) + factor(age) + factor(period)-1,datest21,weights=idweight)
dimcoeff_lbr <- length(reg_hours_lbr$coeff)

coeffs_lbr <- reg_hours_lbr$coeff[(dimcoeff_lbr-4):dimcoeff_lbr]

dd <- datest21[datest21$period==1, ]
m <- mean(dd$earnh,na.rm=T)

coeffs_lbr <- coeffs_lbr/m
std_error_lbr <- (1/m)*coef(summary(reg_hours_lbr))[(dimcoeff_lbr-4):dimcoeff_lbr,2]
print(coeffs_lbr)
coeffs_data <- as.data.frame(cbind(coeffs_lbr,coeffs_hbr))
std_error_data <- as.data.frame(cbind(std_error_lbr,std_error_hbr))
print(dim(datest21))

save(coeffs_data, file='coeffs_data')
save(std_error_data, file='std_error_data')


datest21 <- datest19[datest19$sex==1,]
reg_hours_all <- lm(earnh ~ factor(year) + factor(age) + factor(period)-1,datest21,weights=idweight)
dimcoeff_all <- length(reg_hours_all$coeff)

coeffs_all <- reg_hours_all$coeff[(dimcoeff_all-4):dimcoeff_all]

dd <- datest21[datest21$period==1, ]
m <- mean(dd$earnh,na.rm=T)

coeffs_all <- coeffs_all/m
std_error_all <- (1/m)*coef(summary(reg_hours_all))[(dimcoeff_all-4):dimcoeff_all,2]
print(coeffs_all)
save(coeffs_all, file='coeffs_all')
save(std_error_all, file='std_error_all')








