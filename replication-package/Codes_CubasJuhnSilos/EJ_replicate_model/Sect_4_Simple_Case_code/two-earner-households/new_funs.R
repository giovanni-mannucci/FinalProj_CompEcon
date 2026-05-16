# occupation and one person
utility_household <- function(xvec,theta_f,theta_m,xi,alpha_f,alpha_m,wage_m,wage_f){
    l1f <- xvec[1]
    l2f <- xvec[2]
    l1m <- xvec[3]
    l2m <- xvec[4]
#    consf <- xvec[5]
    h1f <- t1-l1f
    h2f <- t1-l2f
    h1m <- t1-l1m
    h2m <- t1-l2m
lstar_f <- (l1f+l2f-(t1-l1f)^alpha_f)
    lstar_m <- (l1m+l2m-(t1-l1m)^alpha_m)
    if (l1f <=0 || l2f <=0 || h1f <=0.0 || h2f <=0.0 || alpha_f<alpha_min || lstar_f<=0 || l1f <=0 || l2f <=0 || h1m <=0.0 || h2m <=0.0 || alpha_m<alpha_min || lstar_m<=0){
        utility <- -100000
    } else {

    care_f <- (h1f^xi+h2f^xi)^(1/xi)
    care_m <- (h1m^xi+h2m^xi)^(1/xi)
    consm <- (wage_f*lstar_f + wage_m*lstar_m)*weight_m/(weight_m + weight_f)
    consf <- (wage_f*lstar_f + wage_m*lstar_m)*weight_f/(weight_m + weight_f)
#    consm <- (wage_f*lstar_f + wage_m*lstar_m)-consf
    util_f <- consf^(theta_f)*care_f^(1-theta_f)
    util_m <- consm^(theta_m)*care_m^(1-theta_m)


    utility <- weight_m * util_m + weight_f * util_f 
    

    }
    return(-utility)
}


# computes and returns value functions, hours and
# bunching ratios
all_occ <- function(paramvec,wage_vec){
    set.seed(123456)
    valfuns <- mat.or.vec(dim(nocc_combos)[1],1) # stores value 
                           # functions for females and males for 
                           # each occupation
    hours_prime <- mat.or.vec(dim(nocc_combos)[1],2) # stores hours worked
                           # prime for females and males for 
                           # each occupation
    hours_nonprime <- mat.or.vec(dim(nocc_combos)[1],2) # stores hours worked
                           # nonprime for females and males for 
                           # each occupation
lstar <- mat.or.vec(dim(nocc_combos)[1],2) # stores hours worked
                           # nonprime for females and males for 
                           # each occupation


    brw <- mat.or.vec(dim(nocc_combos)[1],2) # stores bunching ratios work
                           # for females and males for 
                           # each occupation
    brh <- mat.or.vec(dim(nocc_combos)[1],2) # stores bunching ratios care 
                           # for females and males for 
                           # each occupation
        #print(c("wage: ",wage))
        for (j in seq(1,dim(nocc_combos)[1])){ # 1 is male 2 is female
             theta_m <- theta_vec[1]
             theta_f <- theta_vec[2]
    xvec <- c(0.4,0.4,0.4,0.4)
    alpha_m <- alpha_vec[nocc_combos[j,1]] 
    alpha_f <- alpha_vec[nocc_combos[j,2]] 
    wage_m <-  wage_vec[nocc_combos[j,1]] 
    wage_f <- wage_vec[nocc_combos[j,2]] 
        #print(c(alpha,theta,xvec,wage,xi))
#    res <- nloptr(xvec,utility_household,opts=list("algorithm"="NLOPT_LN_SBPLX","xtol_rel"=1.0e-8,maxeval=15000),theta_f=theta_f,theta_m=theta_m,xi=xi,alpha_f=alpha_f,alpha_m=alpha_m, wage_m=wage_m, wage_f=wage_f)
    res <- optim(xvec,utility_household,gr=NULL,theta_f=theta_f,theta_m=theta_m,xi=xi,alpha_f=alpha_f,alpha_m=alpha_m, wage_m=wage_m, wage_f=wage_f,method="Nelder-Mead")
    xvec <- res$par
    res <- optim(xvec,utility_household,gr=NULL,theta_f=theta_f,theta_m=theta_m,xi=xi,alpha_f=alpha_f,alpha_m=alpha_m, wage_m=wage_m, wage_f=wage_f,method="BFGS")


    #print(c(res$par,res$minimum))
    l1f <- res$par[1]
    l2f <- res$par[2]
    l1m <- res$par[3]
    l2m <- res$par[4]
    h1f <- t1-l1f
    h2f <- t1-l2f
    h1m <- t1-l1m
    h2m <- t1-l2m

    lstar[j,] <- c(l1m+l2m-(t1-l1m)^alpha_m,l1f+l2f-(t1-l1f)^alpha_f)
    valfuns[j] <- -res$value
    hours_prime[j,] <- c(l1m,l1f)
    hours_nonprime[j,] <- c(l2m,l2f) 
    brw[j,] <- c(l1m/(l1m+l2m),l1f/(l1f+l2f))
    brh[j,] <- c(h1m/(h1m+h2m),h1f/(h1f+h2f))
    }
    returnvec <- list(valfuns,hours_prime,hours_nonprime,brw,brh,lstar)
    return(returnvec)
}






