# compute the optimal allocation for a given
# occupation and one person
utility <- function(xvec,theta,xi,alpha,wage){
    l1 <- xvec[1]
    l2 <- xvec[2]
    h1 <- 0.5-l1
    h2 <- 0.5-l2
    lstar <- (l1+l2-(0.5-l1)^alpha)
    if (l1 <=0 || l2 <=0 || h1 <=0.0 || h2 <=0.0 || alpha<alpha_min || lstar<=0){
        utility <- -100000
    } else {

    care <- (h1^xi+h2^xi)^(1/xi)
    #care <- (h1^xi*h2^(1-xi)^(1/xi)
    #care <- h1^xi*h2^(1-xi)

    cons <- wage*lstar
    utility <- cons^(theta)*care^(1-theta)
    #rho <- 0.2
    #utility <- (theta*cons^(rho) + (1-theta)*care^(rho))^(1/rho)
    }
    return(-utility)
}

# computes and returns value functions, hours and
# bunching ratios
all_occ <- function(paramvec,wage_vec){
    set.seed(123456)
    alpha_vec <- paramvec[1:nocc]
    tfpvec <- paramvec[(2*nocc+1):(3*nocc)]
    #    print(c("Infun 2: ", paramvec))
    xi <- paramvec[(4*nocc+1)]

    theta_vec <- paramvec[(4*nocc+2):(length(paramvec))]
    #xi <- paramvec[length(paramvec)] 
    valfuns <- mat.or.vec(nocc,2) # stores value 
                           # functions for females and males for 
                           # each occupation
    hours_prime <- mat.or.vec(nocc,2) # stores hours worked
                           # prime for females and males for 
                           # each occupation
    hours_nonprime <- mat.or.vec(nocc,2) # stores hours worked
                           # nonprime for females and males for 
                           # each occupation
    brw <- mat.or.vec(nocc,2) # stores bunching ratios work
                           # for females and males for 
                           # each occupation
    brh <- mat.or.vec(nocc,2) # stores bunching ratios care 
                           # for females and males for 
                           # each occupation
    for (i in seq(1,nocc)){ # i for each occupation
        alpha <- alpha_vec[i]
        wage <- wage_vec[i]
        #print(c("wage: ",wage))
        for (j in seq(1,2)){ # 1 is male 2 is female
             theta <- theta_vec[j]
        xvec <- c(0.8*0.5,0.1)
        #print(c(alpha,theta,xvec,wage,xi))
        res <- optim(xvec,utility,gr=NULL,theta,xi,alpha,wage,method="Nelder-Mead")

        res <- optim(res$par,utility,gr=NULL,theta,xi,alpha,wage,method="BFGS")


         l1 <- res$par[1]
         l2 <- res$par[2]
         h1 <- 0.5-l1
         h2 <- 0.5-l2
         lstar <- l1+l2-(0.5-l1)^alpha
         valfuns[i,j] <- -res$value
         hours_prime[i,j] <- l1
         hours_nonprime[i,j] <- l2
         brw[i,j] <- l1/(l1+l2)
         brh[i,j] <- h1/(h1+h2)
        }
    }
    returnvec <- list(valfuns,hours_prime,hours_nonprime,brw,brh)
    return(returnvec)
}


# calculates model gender gap decomposition
gender_gap_decomp <- function(earnph_female,earnph_male,massvec,sf){

    all_male_earnph <- sum(earnph_male*massvec*(1-sf))/0.5 
    all_female_earnph <- sum(earnph_female*massvec*sf)/0.5
    aggregate_gender_gap <- log(all_male_earnph/all_female_earnph) 
    alpha_m <- (1-sf)*massvec/0.5
    alpha_f <- sf*massvec/0.5

    total <- sum(alpha_m*earnph_male)/sum(alpha_f*earnph_female)
    across <- sum(alpha_m*earnph_female)/sum(alpha_f*earnph_female)
    within <- sum(alpha_m*earnph_male)/sum(alpha_m*earnph_female)
    print(c("Decomposition of Gender Gap:  "))
    print(c("Total: ", log(total)))
    print(c("Across: ", log(across)))
    print(c("Within: ", log(within)))

 return(list(log(total),log(across),log(within)))

}




