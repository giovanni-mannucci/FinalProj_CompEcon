rm(list=ls())
library(minpack.lm)
library(data.table)
library(nloptr)

# Calculates results for two-earner households. For details, see online appendix
# "Coordinated Wage Schedules and the Gender Wage Gap", by G. Cubas, C. Juhn and
# P. Silos

# functions
source('new_funs.R')
source('new_one.R')
t1 <- 0.5 # length of prime time
t2 <- 1-t1 # length of non prime time
lshvec <- c(0.5,0.5)
alpha_min <- 0.7
# combos of occs [order is male female]
nocc <- 2
nocc_combos <- expand.grid(seq(1,nocc),seq(1,nocc))
# combos of occs [order is male female]

nocc_combos <- expand.grid(seq(1,nocc),seq(1,nocc))
    weight_m <- 1
    weight_f <- 1

# do three cases:
# positive assort matching is correl = 0.4; negative is correl=-0.4;
# empirical correlation is 0.13, zero assortative matching is 0.0003
correl_vals <- c(0.4,-0.4,0.13)
filenames <- c("./results_two_earner_positive.txt","./results_two_earner_negative.txt","./results_two_earner.txt")

for (k in seq(1,3)){
lambda <- 0.85
# vector to keep equilibrium wages
tempwage <- rep(1.0,nocc)
share_fem <- c(0.5,0.5) 
alpha_vec <- c(0.8,2.8) 
theta_vec <- c(0.9,0.7)
xi <- 0.6
paramvec <- c(1,1,1,1)
    data_moments <- c(share_fem,correl_vals[k])
        nelder <- 1  
compute_moments(paramvec, data_moments)    
    estim_res <- nloptr(paramvec,compute_moments,opts=list("algorithm"="NLOPT_LN_SBPLX","xtol_rel"=1.0e-8,maxeval=15000),moments=data_moments)
        paramvec <- estim_res$solution
    gg <- get_final_model_data(paramvec,tempwage)
    print(gg)
   print(" RESULTS              ")
   print(paste0("Agg Gender Gap: ",format(gg[[1]],digits=5)))
   print(paste0("Gender Gap by Occ: ",format(gg[[2]],digits=5)))
   print(paste0("Size of Occ: ",format(gg[[5]],digits=5)))
   print(paste0("Share of females in each occ : ",format(gg[[4]],digits=5)))
   print(paste0("Bunching Ratio by occ : ",format(gg[[3]],digits=5)))
   print(paste0("Earnings by occ : ",format(gg[[6]],digits=5)))
   print(paste0("Hours by occ : ",format(gg[[7]],digits=5)))
   print(paste0("Effective Hours by occ : ",format(gg[[8]],digits=5)))


cnames <- c("Agg Gender Gap", "Gender Gap by Occ", "Ratio 8to5", "Share Females", "Percent Workers", "Earnings","Raw Labor", "Eff Labor")  
unlink('./results_simple_case_tastes.txt')  
write.table(as.data.frame(rbind(gg[[1]],gg[[2]],gg[[3]],gg[[4]],gg[[5]],gg[[6]],gg[[7]],gg[[8]])),filenames[k],sep=",", row.names=cnames)

}  


