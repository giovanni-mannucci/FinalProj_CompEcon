rm(list=ls())
library(pracma)
library(nloptr)


# In this file we keep all the functions needed. The ones that solve
# for the economy's allocation and functions to print out results
source('./simple_cases_funs.R')

#-------------------------
# No gender case
#-------------------------

# Parameters (see paper for description)
alphavec <- c(0.8, 2.8) 
nocc <- 2 
nu <- 0.6
weight <- 0.8 
labor_shares <- rep(1.0/nocc,nocc)
alldata <- list()
alldata[[1]] <- alphavec
alldata[[2]] <- c(nu, weight)
alldata[[3]] <- labor_shares

# initial guess
x_init = c(0.2, 1.5,1.5)
# solve model
bigprob <- fsolve(one_gender , x_init,J=NULL,maxiter=100,tol=1e-10, alldata, print = 0)
# print results
one_gender(bigprob$x,alldata,print=1)

#-------------------------
# Gender differences in nu 
#-------------------------

# Parameters (see paper for description)
 
alphavec <- c(0.8, 2.8)
nocc <- 2 
nu_f <- 0.6
nu_m <- 0.6
weight_m <- 0.9 
weight_f <- 0.7
labor_shares <- rep(1.0/nocc,nocc)
alldata <- list()
alldata[[1]] <- alphavec
alldata[[2]] <- c(nu_f, nu_m, weight_f, weight_m)
alldata[[3]] <- labor_shares

# initial guess
x_init = c(0.2,0.5,0.5)
# solve economy
bigprob <- fsolve(two_gender , x_init,J=NULL,maxiter=100,tol=1e-10, alldata, print=0)
# print results
two_gender(bigprob$x,alldata,print=1)

#--------------------------------------
# Gender differences in nu and tastes
#--------------------------------------

# Parameters (see paper for description)

t1 <- 0.5 # length of prime time
t2 <- 1-t1 # length of non prime time
lshvec <- c(0.5,0.5)
alpha_min <- 0.7
# fixed parameters
# number of occupations
nocc <- 2
lambda <- 0.85
# vector to keep equilibrium wages
tempwage <- rep(1.0,nocc)
# target share of females
share_fem <- c(0.5,0.5) 
# penalty parameters
alpha_vec <- c(0.8,2.8)
# preference parameters
nu_vec <- c(0.9,0.7)
rho <- 0.6
paramvec <- c(rep(1,nocc)*10*share_fem)

data_moments <- c(share_fem)
nelder <- 1
# solve for calibrated parameters 
estim_res <- nloptr(paramvec,compute_moments,opts=list("algorithm"="NLOPT_LN_SBPLX","xtol_rel"=1.0e-8,maxeval=15000),moments=data_moments)
paramvec <- estim_res$solution
# get model output
gg <- get_final_model_data(paramvec,tempwage)
# save results  
cnames <- c("Agg Gender Gap", "Gender Gap by Occ", "Ratio 8to5", "Share Females", "Percent Workers", "Earnings","Raw Labor", "Eff Labor")  
unlink('./results_simple_case_tastes.txt')  
write.table(as.data.frame(rbind(gg[[1]],gg[[2]],gg[[3]],gg[[4]],gg[[5]],gg[[6]],gg[[7]],gg[[8]])),'./results_simple_case_tastes.txt',sep=",", row.names=cnames)





