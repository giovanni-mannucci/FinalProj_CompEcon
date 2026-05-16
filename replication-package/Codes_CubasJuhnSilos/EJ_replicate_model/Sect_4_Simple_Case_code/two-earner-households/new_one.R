
# calculates equilibrium wages and occupation masses (size and
# efficiency units 

wages_iterate <- function(paramvec,wage_vec){
    clear_diff <- 10
    tempwage <<- wage_vec  
    newwages <- tempwage
    taste_param <- paramvec
    cleariter <- 1
    while (clear_diff> 0.005){
    model_data <- all_occ(paramvec,tempwage)
    valfuns <- model_data[[1]]
    hours_prime <- model_data[[2]]
    hours_nonprime <- model_data[[3]]
    lstar <- model_data[[6]]
    
    # now we have all parameters
share_households <- (taste_param*valfuns)/(sum(taste_param*valfuns))
share_females <- c(sum(share_households[1:2]),sum(share_households[3:4]))
share_males <- c(share_households[1]+share_households[3],share_households[2]+share_households[4])
lstar_female <- c(sum((share_households*lstar[,2])[1:2])/share_females[1],sum((share_households*lstar[,2])[3:4])/share_females[2])
lstar_male <- c(((share_households*lstar[,1])[1] + (share_households*lstar[,1])[3])/share_males[1],((share_households*lstar[,1])[2] + (share_households*lstar[,1])[4])/share_males[2])
    lstar_female <- ifelse(lstar_female<1e-7,1e-7,lstar_female)
    lstar_male <- ifelse(lstar_male<1e-7,1e-7,lstar_male)
 


# compute mean efficiency and masses by occ
massvec <- share_females*0.5 + share_males*0.5 
eff_by_occ <- lstar_female*share_females + lstar_male*share_males 

laborInputs <- massvec*eff_by_occ
if (length(which(laborInputs<=0))>0){
print(c('infun: ', lstar_male,lstar_female,massvec))
    }
## update wages
# efficient labor raised to labor share
    N2alpha <- laborInputs ^ lshvec  
    # update wages 
    for (j in seq(1, nocc)){
        newwages[j] <- lshvec[j] * (laborInputs[j]) ^ (lshvec[j] - 1) * prod(N2alpha[-c(j)])
    }
    
    clear_diff <-  sum(abs(newwages-tempwage)/tempwage)
    tempwage <<- (1-lambda)*newwages + lambda*tempwage
    cleariter <- cleariter+1
    #print(clear_diff)
    if (cleariter>100){clear_diff <- 0}
    }
return(tempwage)
}


# objective function: given parameters compute model moments and
# calculate deviations from datal
compute_moments <- function(paramvec,moments){
	print(c("Params: ", paramvec))
    #print(c("Tempwage: ", tempwage))
    yvec <- numeric(length(moments))

    taste_param <- c(paramvec)
    
    if ( xi <1e-6 || xi>0.9999||min(theta_vec)<=0 || max(theta_vec)>=0.9999 || max(alpha_vec)>300.0 || min(alpha_vec)< alpha_min|| min(taste_param)<=0 || xi>=1.0){
        for (k in seq(1,length(yvec))){
        yvec[k] <- 100000
        }
        } else {
           tempwage <<- wages_iterate(taste_param,tempwage)
           get_model_moments <- all_occ(taste_param,tempwage)
    #print(get_model_moments)
           valfuns <- get_model_moments[[1]]
    hours_prime <-get_model_moments[[2]]
    hours_nonprime <-get_model_moments[[3]]
    brw <- get_model_moments[[4]]
    brh <- get_model_moments[[5]]
    hours_male <- mean(hours_prime[,1] + hours_nonprime[,1])
    hours_female <- mean(hours_prime[,2] + hours_nonprime[,2])
    share_households <- (taste_param*valfuns)/(sum(taste_param*valfuns))
share_females <- c(sum(share_households[1:2]),sum(share_households[3:4]))
share_males <- c(share_households[1]+share_households[3],share_households[2]+share_households[4])
massvec <- share_females*0.5 + share_males*0.5 
    share_females <- 0.5*share_females/massvec
    share_males <- 0.5*share_males/massvec
    #ratio <- sum(massvec*brw_occ)/sum(massvec*brh_occ)
    pvec <- share_households 
    #brw_occ <- brw_occ - mean(brw_occ)
    xy <- nocc_combos[,1]*nocc_combos[,2]
    exy <- sum(pvec*xy)
    ex <- sum(pvec*nocc_combos[,1])
    ey <- sum(pvec*nocc_combos[,2])
    covar <- exy - ex*ey
    ex2 <- sum(pvec*nocc_combos[,1]^2)
    ey2 <- sum(pvec*nocc_combos[,2]^2)
    varx <- ex2-ex^2
    vary <- ey2-ey^2
    corrcoef <- covar/(sqrt(varx)*sqrt(vary))
    
    # sizes of each occupation    
	data_model <- c(share_females,corrcoef) 
    yvec <- (data_model-moments)/moments
    weights <- c(rep(1,nocc+1)) 
    print(c("Funval: ", sum(yvec^2)))
    print(c("Moments: ", data_model))

    }

    if (nelder==1){
        return(sum(yvec^2))
    } else {
        return(yvec)
    }

}

# get some model statistics
get_final_model_data <- function(paramvec,tempwage){ 
    taste_param <- c(paramvec)
    tempwage <<- wages_iterate(taste_param,tempwage)

    get_model_moments <- all_occ(taste_param,tempwage)
    valfuns <- get_model_moments[[1]]
    share_households <- (taste_param*valfuns)/(sum(taste_param*valfuns))
    share_females <- c(sum(share_households[1:2]),sum(share_households[3:4]))
    share_males <- c(share_households[1]+share_households[3],share_households[2]+share_households[4])
    massvec <- share_females*0.5 + share_males*0.5 

    hours_prime <- get_model_moments[[2]]
    hours_nonprime <- get_model_moments[[3]]
    brw <- get_model_moments[[4]]
    brh <- get_model_moments[[5]]

    hours_male_occ <- c( sum(share_households*(nocc_combos[,1]==1)*(hours_prime[,1]+hours_nonprime[,1]) )/sum(share_households*(nocc_combos[,1]==1)), sum(share_households*(nocc_combos[,1]==2)*(hours_prime[,1]+hours_nonprime[,1]) )/sum(share_households*(nocc_combos[,1]==2)))
    hours_female_occ <- c( sum(share_households*(nocc_combos[,2]==1)*(hours_prime[,2]+hours_nonprime[,2]) )/sum(share_households*(nocc_combos[,2]==1)), sum(share_households*(nocc_combos[,2]==2)*(hours_prime[,2]+hours_nonprime[,2]) )/sum(share_households*(nocc_combos[,2]==2)))

lstar <- get_model_moments[[6]]
    
    # effective hours 
    lstar_female <- c(sum((share_households*lstar[,2])[1:2])/share_females[1],sum((share_households*lstar[,2])[3:4])/share_females[2])
    lstar_male <- c(((share_households*lstar[,1])[1] + (share_households*lstar[,1])[3])/share_males[1],((share_households*lstar[,1])[2] + (share_households*lstar[,1])[4])/share_males[2])
    lstar_female <- ifelse(lstar_female<1e-7,1e-7,lstar_female)
    lstar_male <- ifelse(lstar_male<1e-7,1e-7,lstar_male)
    earn_male <- lstar_male * tempwage
    earn_female <- lstar_female * tempwage
    
    earnph_male <- earn_male/hours_male_occ
    earnph_female <- (earn_female/hours_female_occ)
    gender_gap_occ <- earnph_male/earnph_female
    
    # aver earnph women by occupation
    earn_female_occ_1 <- sum(share_households*(nocc_combos[,2]==1)*earnph_female)/sum(share_households*(nocc_combos[,2]==1))
    earn_female_occ_2 <- sum(share_households*(nocc_combos[,2]==2)*earnph_female)/sum(share_households*(nocc_combos[,2]==2))
    # aver earnph men by occupation
    earn_male_occ_1 <- sum(share_households*(nocc_combos[,1]==1)*earnph_male)/sum(share_households*(nocc_combos[,1]==1))
    earn_male_occ_2 <- sum(share_households*(nocc_combos[,1]==2)*earnph_male)/sum(share_households*(nocc_combos[,1]==2))
    # aver brw women by occupation
    brw_occ_female_occ1 <- sum(share_households*(nocc_combos[,2]==1)*brw[,2])/sum(share_households*(nocc_combos[,2]==1))
    brw_occ_female_occ2 <- sum(share_households*(nocc_combos[,2]==2)*brw[,2])/sum(share_households*(nocc_combos[,2]==2))
    # aver brw men by occupation
    brw_occ_male_occ1 <- sum(share_households*(nocc_combos[,1]==1)*brw[,1])/sum(share_households*(nocc_combos[,1]==1))
    brw_occ_male_occ2 <- sum(share_households*(nocc_combos[,1]==2)*brw[,1])/sum(share_households*(nocc_combos[,1]==2))


    brw_occ_gender <- mat.or.vec(2,2)
    brw_occ_gender[1,1] <- brw_occ_male_occ1
    brw_occ_gender[1,2] <- brw_occ_female_occ1
    brw_occ_gender[2,1] <- brw_occ_male_occ2
    brw_occ_gender[2,2] <- brw_occ_female_occ2


    aggregate_gender_gap <- sum(massvec*gender_gap_occ)
sf <- 0.5*share_females/massvec
   earn_occ <- sf*earn_female +(1-sf)*earn_male  
earnph_occ <- sf*earnph_female +(1-sf)*earnph_male  

    hours_occ<-sf*hours_female_occ +(1-sf)*hours_male_occ
    lstar_occ<-sf*lstar_female +(1-sf)*lstar_male
## NOTE: share_females is the share of females that goes to each
    ## occupation. sf is the share of females in each occupation.
    brw_occ <- c(sf*brw_occ_gender[,2]+(1-sf)*brw_occ_gender[,1]) 
#    retvec <- list(aggregate_gender_gap,gender_gap_occ,brw_occ,sf,massvec,earn_occ,hours_occ,lstar_occ,lstar_male/lstar_female)
    retvec <- list(aggregate_gender_gap,gender_gap_occ,brw_occ,sf,massvec,earn_occ,hours_occ,lstar_occ,share_females,earnph_occ )
    return(retvec)
}


