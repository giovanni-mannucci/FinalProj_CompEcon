
# function that gives utility for a set of parameters/variables
value_fun <- function(x, params){
    wage <- params[1]
    alpha <- params[2] 
    nu <- params[3]
    weight <- params[4]
     
    l1 = x[1];
    l2 = x[2];
    #home = 0.5-l1 + (0.5-l2)*nu
    home = ((0.5-l1)^nu + (0.5-l2)^nu)^(1/nu)
    if (l1<0 |l2 <0|0.5-l1<0 | 0.5-l2<0 | home<0){
        util <- 10000
    }else{
       c <- wage*(l1+l2-(0.5-l1)^alpha)
       util <- - (c^weight * home^(1-weight))  
    }
    return(util);
}

 
# main function that solves for equilibrium for a set of parameters/variables
one_gender <- function(x, alldata, print){
	alphavec <- alldata[[1]]
	param <- alldata[[2]]
    labor_shares <- alldata[[3]]
    fvec <- numeric(3) 
    shares <- rep(0,nocc)
    wagevec <- rep(0,nocc)

    shares[1] <- x[1]
    shares[2] <- 1.0-shares[1]
    wagevec[1] <- x[2]
    wagevec[2] <- x[3]
    print(x)
    nu <- param[1]
    weight <- param[2]
    val <- rep(0,nocc)
    efflabor <- rep(0,nocc)
    brw_by_occ <- rep(0,nocc)
    earnings_by_occ <- rep(0,nocc)
    raw_labor_by_occ <- rep(0,nocc)
    brw_by_occ <- rep(0,nocc)

    if (min(x)<0.0){
		fvec = 10000;
	} else {
		for (i in seq(nocc)){
        wage <- wagevec[i]
        #print(c('wage: ' , wage))
        alpha <- alphavec[i]
        # paramaters to pass to utility
        params <- c(wage, alpha, nu, weight)
        # initial guess
        x_init <- c(0.2,0.2)
        z <- optim(x_init, value_fun,gr=null, params)
        x <- z$par
        #print(c(z$value))
        home = ((0.5-x[1])^nu +  (0.5-x[2])^(nu))^(1/nu) 
        c <- wage*(x[1]+x[2]-(0.5-x[1])^alpha)
        efflabor[i] <- (x[1]+x[2]-(0.5-x[1])^alpha)
	    earnings_by_occ[i] <- efflabor[i]*wage  
	    raw_labor_by_occ[i] <- x[1] + x[2]
        brw_by_occ[i] <- x[1]/(x[1]+x[2])

        print(c('occ: ', i,' cons:' , c, ' wage: ', wage, ' efflabor: ' ,efflabor[i], ' earnings: ', efflabor[i]*wage,' l1 + l2: ', x[1]+x[2], '  br: ', x[1]/(x[1]+x[2])) )
           val[i] = c^weight*home^(1.0-weight)
   
   }
		# the equilibrium conditions are wages equal to marginal
		# product in each occupation, and agents indifferent between the
		# two occupations (because of homogeneity).        
		fvec[1] <- wagevec[1] - labor_shares[1]*(shares[1]*efflabor[1])^(labor_shares[1]-1)*(shares[2]*efflabor[2])^labor_shares[2]
        fvec[2] <- wagevec[2] - labor_shares[2]*(shares[1]*efflabor[1])^(labor_shares[1])*(shares[2]*efflabor[2])^(labor_shares[2]-1.0)
        fvec[3] <- val[1] - val[2]
        print(c("Shares: ",shares))
	}
	if (print==0){ # return system
		return(fvec)
	} else { # print results
		cnames <- c("Share of Workers","Ratio 8to5","Earnings","Rawlabor by occ", "Eff Labor by Occ")  
		unlink('./results_simple_case_no_gender.txt')  
		write.table(as.data.frame(rbind(shares,brw_by_occ,earnings_by_occ,raw_labor_by_occ,efflabor)),'./results_simple_case_no_gender.txt',sep=",", row.names=cnames)
	}           
}


  #-----------------------------------------
  # function to solve the  model with two genders.
  #-----------------------------------------

two_gender <- function(x, alldata,print){
	alphavec <- alldata[[1]]
    param <- alldata[[2]]
    labor_shares <- alldata[[3]]
   
    nu_f <- param[1]
    nu_m <- param[2]
    weight_f <- param[3]
    weight_m <- param[4]
    val_f <- rep(0,nocc)
    val_m <- rep(0,nocc)
    shares <<- rep(0,nocc)
    shares[1] <<- x[1]
    shares[2] <<- 1.0-x[1]
    wagevec <<- c(x[2],x[3])
    efflabor_m <<- rep(0,nocc)
    efflabor_f <<- rep(0,nocc)
    l1_f <<- rep(0,nocc)
    l2_f <<- rep(0,nocc)
    l1_m <<- rep(0,nocc)
    l2_m <<- rep(0,nocc)
    brw_vec <<- c(0,0,0,0)
    fvec <- numeric(3)
    count <- 1
	for (female in seq(0,1)){
		for (i in seq(nocc)){
			wage <- wagevec[i]
			alpha <- alphavec[i]
			if (female == 1){
				weight = weight_f
				nu <- nu_f
			} else { 
				weight = weight_m
				nu <- nu_m 
			}
			params <- c(wage, alpha, nu, weight)
			x_init <- c(0.2,0.2)
			z <- optim(x_init, value_fun,gr=null, params)
			x <- z$par
			home = ((0.5-x[1])^nu +  (0.5-x[2])^(nu))^(1/nu)
			c <- wage*(x[1]+x[2]-(0.5-x[1])^alpha)
            efflabor <- (x[1]+x[2]-(0.5-x[1])^alpha)
            print(c('occ: ', i,' cons:' , c, ' wage: ', wage, ' efflabor: ' ,efflabor, ' earnings: ', efflabor*wage,' l1 + l2: ', x[1]+x[2], '  br: ', x[1]/(x[1]+x[2])) )
			brw_vec[count] <<- x[1]/(x[1]+x[2])
									 if (female == 1){
										 val_f[i] = c^weight*home^(1.0-weight)
										 print(val_f[i])
										 efflabor_f[i] <<- efflabor
										 l1_f[i] <<- x[1]
										 l2_f[i] <<- x[2]
									 } else {
										 val_m[i] = c^weight*home^(1.0-weight)
										 efflabor_m[i] <<- efflabor
										 l1_m[i] <<- x[1]
										 l2_m[i] <<- x[2]
									 }
									 count <- count + 1
		}
	}
    print(val_f)
    #print(val_m)
    share_f <<- rep(0,nocc)
	share_m <<- rep(0,nocc)
    share_m[1] <<-min(shares[1],0.5)
    share_m[2] <<- 0.5 - share_m[1] 
    share_f[1] <<- shares[1] - share_m[1] 
    share_f[2] <<- shares[2] - share_m[2] 
    fvec[1] <- wagevec[1] - labor_shares[1]*(share_f[1]*efflabor_f[1]+share_m[1]*efflabor_m[1])^(labor_shares[1]-1)*(share_f[2]*efflabor_f[2]+share_m[2]*efflabor_m[2])^labor_shares[2]
    fvec[2] <- wagevec[2] - labor_shares[2]*(share_f[1]*efflabor_f[1]+share_m[1]*efflabor_m[1])^(labor_shares[1])*(share_f[2]*efflabor_f[2]+share_m[2]*efflabor_m[2])^(labor_shares[2]-1.0)
	fvec[3] <- val_m[1] - val_m[2]
	if (print==0){
		return(fvec)  
	} else {
		earn_m <- sum(efflabor_m*wagevec*(1-share_f))
        earn_f <- sum(efflabor_f*wagevec*(share_f))
        gender_gap <- sum((efflabor_m*wagevec/(l1_m+l2_m))*share_m)/sum((efflabor_f*wagevec/(l1_f+l2_f))*share_f)
		brw_by_occ <- c((share_m[1]*brw_vec[1]+share_f[1]*brw_vec[3])/shares[1], (share_m[2]*brw_vec[2]+share_f[2]*brw_vec[4])/shares[2])
	    # given that no female sort into occupation 1, there is no point in
	    # calculating  a gender gap in that occupation.
        gender_gap_occ_2 <- (efflabor_m[2]*wagevec[2]/(l1_m[2]+l2_m[2]))/(efflabor_f[2]*wagevec[2]/(l1_f[2]+l2_f[2])) 
	    earn_m <- sum(efflabor_m*wagevec*(1-share_f))
        earn_f <- sum(efflabor_f*wagevec*(share_f))
        gender_gap <- sum((efflabor_m*wagevec/(l1_m+l2_m))*share_m)/sum((efflabor_f*wagevec/(l1_f+l2_f))*share_f)
 
        brw_by_occ <- c((share_m[1]*brw_vec[1]+share_f[1]*brw_vec[3])/shares[1], (share_m[2]*brw_vec[2]+share_f[2]*brw_vec[4])/shares[2])
        efflabor_by_occ <- (efflabor_m*share_m + efflabor_f*share_f)/shares
	    rawlabor_m <- c(l1_m[1] + l2_m[1],l1_m[2] + l2_m[2])
        rawlabor_f <- c(l1_f[1] + l2_f[1],l1_f[2] + l2_f[2])
        rawlabor_by_occ <- (rawlabor_m*share_m + rawlabor_f*share_f)/shares
	   

        cnames <- c("Gender Gap","Gender Gap Occ2","Share of Workers","Ratio 8to5","Earnings","Rawlabor by occ", "Eff Labor by Occ","Share females")  
        unlink('./results_simple_case_gender_diff_nu.txt')  
        write.table(as.data.frame(rbind(gender_gap,gender_gap_occ_2,share_f+share_m,brw_by_occ,efflabor_by_occ*wagevec,rawlabor_by_occ,efflabor_by_occ,share_f/(share_f+share_m))),'./results_simple_case_gender_diff_nu.txt',sep=",", row.names=cnames)
	}
}

# ------------------------------------------
# The following functions are for the case of tastes
# which increases the complerhoty of the problem's solution
#-----------------------------------------------------


# compute the optimal allocation for a given
# occupation and one person
utility <- function(xvec,nu,rho,alpha,wage){
    l1 <- xvec[1]
    l2 <- xvec[2]
    h1 <- t1-l1
    h2 <- t1-l2
    lstar <- (l1+l2-(t1-l1)^alpha)
    if (l1 <=0 || l2 <=0 || h1 <=0.0 || h2 <=0.0 || alpha<alpha_min || lstar<=0){
        utility <- -100000
    } else {
        care <- (h1^rho+h2^rho)^(1/rho)
        #care <- (h1^rho*h2^(1-rho)^(1/rho)
        #care <- h1^rho*h2^(1-rho)
    
        cons <- wage*lstar
        utility <- cons^(nu)*care^(1-nu)
        #rho <- 0.2
        #utility <- (nu*cons^(rho) + (1-nu)*care^(rho))^(1/rho)
    }
    return(-utility)
}

# computes and returns value functions, hours and
# bunching ratios by occupation
all_occ <- function(paramvec,wage_vec){
    set.seed(123456)
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
             nu <- nu_vec[j]
        xvec <- c(0.8*t1,0.1)
        #print(c(alpha,nu,xvec,wage,rho))
        res <- optim(xvec,utility,gr=NULL,nu,rho,alpha,wage,method="Nelder-Mead")

        res <- optim(res$par,utility,gr=NULL,nu,rho,alpha,wage,method="BFGS")


    #print(c(res$par,res$minimum))
    l1 <- res$par[1]
    l2 <- res$par[2]
    h1 <- t1-l1
    h2 <- t2-l2
    lstar <- l1+l2-(t1-l1)^alpha
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

# function to calculate equilibrium wages
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
        lstar_male <- hours_prime[,1] + hours_nonprime[,1]-(t1-hours_prime[,1])^alpha_vec
        lstar_female <- hours_prime[,2] + hours_nonprime[,2]-(t1-hours_prime[,2])^alpha_vec
        lstar_female <- ifelse(lstar_female<1e-7,1e-7,lstar_female)
        lstar_male <- ifelse(lstar_male<1e-7,1e-7,lstar_male)
       
    
        # now we have all parameters
        share_females <- (taste_param*valfuns[,2])/(sum(taste_param*valfuns[,2]))
        share_males <-  valfuns[,1]/sum(valfuns[,1])
        
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
    	if (cleariter>100){
            clear_diff <- 0
        }
	}
	return(tempwage)
}

# main function that computes moments and the difference from the data moments 
compute_moments <- function(paramvec,moments){
	yvec <- numeric(length(moments))
    taste_param <- paramvec
    if ( rho <1e-6 || rho>0.9999||min(nu_vec)<=0 || max(nu_vec)>=0.9999 || max(alpha_vec)>300.0 || min(alpha_vec)< alpha_min|| min(taste_param)<=0 || rho>=1.0){
        for (k in seq(1,length(yvec))){
			yvec[k] <- 100000
		}
	} else {
		tempwage <<- wages_iterate(paramvec,tempwage)
		get_model_moments <- all_occ(paramvec,tempwage)
		#print(get_model_moments)
        valfuns <- get_model_moments[[1]]
        hours_prime <-get_model_moments[[2]]
        hours_nonprime <-get_model_moments[[3]]
        brw <- get_model_moments[[4]]
        brh <- get_model_moments[[5]]
        hours_male <- mean(hours_prime[,1] + hours_nonprime[,1])
        hours_female <- mean(hours_prime[,2] + hours_nonprime[,2])
        share_females <- (taste_param*valfuns[,2])/sum(taste_param*valfuns[,2]) 
        share_males <-  valfuns[,1]/sum(valfuns[,1])
        massvec <- share_females*0.5 + share_males*0.5 
        share_females <- 0.5*share_females/massvec
        share_males <- 0.5*share_males/massvec
        brw_occ <- share_females*brw[,2] + share_males*brw[,1]
        brh_occ <- share_females*brh[,2] + share_males*brh[,1]
        ratio <- mean(brw_occ)/mean(brh_occ)
        #ratio <- sum(massvec*brw_occ)/sum(massvec*brh_occ)
         
        #brw_occ <- brw_occ - mean(brw_occ)

        
        # sizes of each occupation    
        data_model <- c(share_females) 
        yvec <- (data_model-moments)/moments
        weights <- c(rep(1,nocc)) 
        yvec <- weights*yvec

        }
	if (nelder==1){
        return(sum(yvec^2))
    } else {
        return(yvec)
    }

}

# calculate share of females
get_share_females <- function(paramvec,tempwage){
    taste_param <- paramvec

    get_model_moments <- all_occ(paramvec,tempwage)
    valfuns <- get_model_moments[[1]]
    share_females <- (taste_param*valfuns[,2])/sum(taste_param*valfuns[,2]) 
    share_males <-  valfuns[,1]/sum(valfuns[,1])
    
    # sizes of each occupation    
    massvec <- share_females*0.5 + share_males*0.5 
    share_females <- 0.5*share_females/massvec

retvec <- list(share_females,massvec)
return(retvec)
}

# get statistics of interest from the model for tables, checking, etc
get_final_model_data <- function(paramvec,tempwage){ 
    tempwage <<- wages_iterate(paramvec,tempwage)
    sfm <- get_share_females(paramvec,tempwage)
    sf <- sfm[[1]]
    massvec <- sfm[[2]]

    get_model_moments <- all_occ(paramvec,tempwage)
    hours_prime <-get_model_moments[[2]]
    hours_nonprime <-get_model_moments[[3]]
    brw <- get_model_moments[[4]]
    brh <- get_model_moments[[5]]
    lstar_male <- hours_prime[,1] + hours_nonprime[,1] -(t1-hours_prime[,1])^alpha_vec
    lstar_female <- hours_prime[,2] + hours_nonprime[,2] - (t1-hours_prime[,2])^alpha_vec
    hours_male_occ<- hours_prime[,1] + hours_nonprime[,1]
    hours_female_occ<- hours_prime[,2] + hours_nonprime[,2]
    hours_male <- mean(hours_prime[,1] + hours_nonprime[,1])
    hours_female <- mean(hours_prime[,2] + hours_nonprime[,2])
    earn_male <- lstar_male*tempwage
    earn_female <- lstar_female*tempwage

    earnph_male <- earn_male/hours_male_occ
    earnph_female <- (earn_female/hours_female_occ)
    gender_gap_occ <- earnph_male/earnph_female

    brw_occ <- sf*brw[,2] + (1-sf)*brw[,1]
    brh_occ <- sf*brh[,2] + (1-sf)*brh[,1]

 	earn_reg <- c(earn_male,earn_female)
 	earnph_reg <- c(earnph_male,earnph_female)
    female_reg <- c(rep(0,nocc),rep(1,nocc))
    brw_reg <- c(brw_occ,brw_occ)
	hours_reg <- c(hours_male_occ,hours_female_occ)

    aggregate_gender_gap <- sum(massvec*gender_gap_occ)
    earnph_occ <- sf*earnph_female +(1-sf)*earnph_male
    earn_occ <- sf*earn_female +(1-sf)*earn_male
    hours_occ<-sf*hours_female +(1-sf)*hours_male
    lstar_occ<-sf*lstar_female +(1-sf)*lstar_male

    retvec <- list(aggregate_gender_gap,gender_gap_occ,brw_occ,sf,massvec,earn_occ,hours_occ,lstar_occ,lstar_male/lstar_female,earnph_male,earnph_female,tempwage,lstar_male,lstar_female,hours_male_occ, hours_female_occ)
    return(retvec)
}


