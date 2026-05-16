# calculates equilibrium wages
wages_iterate <- function(paramvec,wage_vec){
    clear_diff <- 10
    tempwage <<- wage_vec  
    newwages <- tempwage
    taste_param <- paramvec[(nocc+1):(2*nocc)]
    tfpvec <- paramvec[(2*nocc+1):(3*nocc)]
    taste_males <- paramvec[(3*nocc+1):(4*nocc)]
    alpha_vec <- paramvec[1:nocc]
    cleariter <- 1
    while (clear_diff> 0.00005){
        model_data <- all_occ(paramvec,tempwage)
        valfuns <- model_data[[1]]
        hours_prime <- model_data[[2]]
        hours_nonprime <- model_data[[3]]
        lstar_male <- max(hours_prime[,1] + hours_nonprime[,1]-(0.5-hours_prime[,1])^alpha_vec,1e-7)
        lstar_female <- max(hours_prime[,2] + hours_nonprime[,2]-(0.5-hours_prime[,2])^alpha_vec,1e-7)
    
        # now we have all parameters
        share_females <- (taste_param*valfuns[,2])/(sum(taste_param*valfuns[,2]))
        share_males <- (taste_males*valfuns[,1])/(sum(taste_males*valfuns[,1]))
        # compute mean efficiency and masses by occ
        massvec <- share_females*0.5 + share_males*0.5 
        eff_by_occ <- lstar_female*share_females*0.5 + lstar_male*share_males*0.5 
        laborInputs <- tfpvec*massvec*eff_by_occ
        if (length(which(laborInputs<=0))>0){
            print(c('infun: ', lstar_male,lstar_female,massvec))
        }
        ## update wages
        N2alpha <- lshvec * (laborInputs ^ peos)  
        BigSum <- sum(N2alpha)
        # update wages 
        for (j in seq(1, nocc)){
             newwages[j] <- BigSum^(1/peos-1)*lshvec[j]*laborInputs[j]^(peos-1)*tfpvec[j] 
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
# calculates momoments from model and compares them to data, computing the main
# objective function
compute_moments <- function(paramvec,moments){
	print(c("Params: ", paramvec))
    #print(c("Tempwage: ", tempwage))
    yvec <- numeric(length(moments))

    alpha_vec <- paramvec[1:nocc]
    taste_param <- paramvec[(nocc+1):(2*nocc)]
    tfpvec <- paramvec[(2*nocc+1):(3*nocc)]
    taste_males <- paramvec[(3*nocc+1):(4*nocc)]

    xi <- paramvec[(4*nocc+1)]
    theta_vec <- paramvec[(4*nocc+2):(length(paramvec))]

    if ( xi <=-10 || xi>-1e-2 & xi <0 || xi == 0 ||xi <1e-2 & xi>0 || xi>0.9999||min(theta_vec)<=0 || max(theta_vec)>=0.9999 || max(alpha_vec)>300.0 || min(alpha_vec)< alpha_min|| min(taste_param)<=0 || min(taste_males)<=0 || xi>=1.0 || min(tfpvec)<=0.0 ) {
		for (k in seq(1,length(yvec))){
			yvec[k] <- 100000
		}
	} else {
		if (estimation_ind==1){
			tempwage <<- wages_iterate(paramvec,tempwage)
		} 
		get_model_moments <- all_occ(paramvec,tempwage)
        valfuns <- get_model_moments[[1]]
        hours_prime <-get_model_moments[[2]]
        hours_nonprime <-get_model_moments[[3]]
        brw <- get_model_moments[[4]]
        brh <- get_model_moments[[5]]
        hours_male <- mean(hours_prime[,1] + hours_nonprime[,1])
        hours_female <- mean(hours_prime[,2] + hours_nonprime[,2])
        share_females <- (taste_param*valfuns[,2])/sum(taste_param*valfuns[,2]) 
        share_males <- (taste_males*valfuns[,1])/sum(taste_males*valfuns[,1]) 
        massvec <- share_females*0.5 + share_males*0.5 
        share_females <- 0.5*share_females/massvec
        share_males <- 0.5*share_males/massvec
        brw_occ <- share_females*brw[,2] + share_males*brw[,1]
        brh_occ <- share_females*brh[,2] + share_males*brh[,1]
        ratio <- mean(brw_occ)/mean(brh_occ)
        #ratio <- sum(massvec*brw_occ)/sum(massvec*brh_occ)
         
        brw_occ <- brw_occ - mean(brw_occ)

        gg_infun <- get_final_model_data(paramvec,tempwage) 
        aver_earn_model <- gg_infun[[8]]/gg_infun[[8]][1]
         
        # sizes of each occupation    
        data_model <- c(brw_occ,share_females, aver_earn_model, massvec, hours_male,hours_female,ratio) 
        yvec <- (data_model-moments)/moments
        # weighting matrix for moments (identity) 
		weights <- c(rep(10,nocc),rep(1,nocc),rep(10,nocc),rep(1,nocc), rep(10,2),1) 
        yvec <- weights*yvec
        print(c("Funval: ", sum(yvec^2)))
        print(c("Moments: ", data_model))
        write(data_model,file="../model_output/moments",ncolumns = 180,append=T)
        print(c("BRH: ", mean(brh)))
        }
	# write moments and obj function value to files
    write(sum(yvec^2),file="../model_output/funvals",ncolumns = 9,append=T)
    write(paramvec,file="../model_output/params",ncolumns = 180,append=T)


    if (nelder==1){
        return(sum(yvec^2))
    } else {
        return(yvec)
    }

}

get_share_females <- function(paramvec,tempwage){
    taste_param <- paramvec[(nocc+1):(2*nocc)]
    tfpvec <- paramvec[(2*nocc+1):(3*nocc)]
    taste_males <- paramvec[(3*nocc+1):(4*nocc)]

    get_model_moments <- all_occ(paramvec,tempwage)
    valfuns <- get_model_moments[[1]]
    share_females <- (taste_param*valfuns[,2])/sum(taste_param*valfuns[,2]) 
    share_males <- (taste_males*valfuns[,1])/sum(taste_males*valfuns[,1]) 

    #share_males <-  valfuns[,1]/sum(valfuns[,1])
    
    # sizes of each occupation    
    massvec <- share_females*0.5 + share_males*0.5 
    share_females <- 0.5*share_females/massvec

retvec <- list(share_females,massvec)
return(retvec)
}


# get some final output from model
get_final_model_data <- function(paramvec,tempwage){ 
    #tempwage <- wages_iterate(paramvec,tempwage)
    print(tempwage) 
    sfm <- get_share_females(paramvec,tempwage)
    sf <- sfm[[1]]
    massvec <- sfm[[2]]
    
    alpha_vec <- paramvec[1:nocc]
   get_model_moments <- all_occ(paramvec,tempwage)
    hours_prime <-get_model_moments[[2]]
    hours_nonprime <-get_model_moments[[3]]
    brw <- get_model_moments[[4]]
    brh <- get_model_moments[[5]]
    lstar_male <- hours_prime[,1] + hours_nonprime[,1] -(0.5-hours_prime[,1])^alpha_vec
    lstar_female <- hours_prime[,2] + hours_nonprime[,2] - (0.5-hours_prime[,2])^alpha_vec
    hours_male_occ<- hours_prime[,1] + hours_nonprime[,1]
    hours_female_occ<- hours_prime[,2] + hours_nonprime[,2]
    hours_male <- mean(hours_prime[,1] + hours_nonprime[,1])
    hours_female <- mean(hours_prime[,2] + hours_nonprime[,2])
    earn_male <- lstar_male*tempwage
    earn_female <- lstar_female*tempwage

    earnph_male <- earn_male/hours_male_occ
    earnph_female <- (earn_female/hours_female_occ)
    gender_gap_occ <- earnph_male/earnph_female
    tot_gender_gap_occ <- earn_male/earn_female
    earnph_occ <- sf*earnph_female +(1-sf)*earnph_male

    brw_occ <- sf*brw[,2] + (1-sf)*brw[,1]
    brh_occ <- sf*brh[,2] + (1-sf)*brh[,1]
    brw_occ <- (brw_occ - mean(brw_occ))/sd(brw_occ)

 	earn_reg <- c(earn_male,earn_female)
 	earnph_reg <- c(earnph_male,earnph_female)
    female_reg <- c(rep(0,nocc),rep(1,nocc))
    brw_reg <- c(brw_occ,brw_occ)
	hours_reg <- c(hours_male_occ,hours_female_occ)
    mainreg <- lm(log(earn_reg) ~brw_reg +female_reg*brw_reg+hours_reg)
    mainreg_ph <- lm(log(earnph_reg)~brw_reg + female_reg*brw_reg)
    male_mainreg <- lm(log(earn_male) ~ brw_occ + hours_male_occ)
    male_mainreg_ph <- lm(log(earnph_male) ~ brw_occ)
    female_mainreg <- lm(log(earn_female) ~ brw_occ + hours_female_occ)
    female_mainreg_ph <- lm(log(earnph_female) ~ brw_occ)

    #aggregate_gender_gap <- sum(massvec*gender_gap_occ)
 
    all_male_earn <- sum(earn_male*massvec*(1-sf))/ sum(massvec*(1-sf))
    all_female_earn <- sum(earn_female*massvec*sf)/sum(massvec*sf)
    all_male_earnph <- sum(earnph_male*massvec*(1-sf))/0.5 
    all_female_earnph <- sum(earnph_female*massvec*sf)/0.5
    aggregate_gender_gap <- all_male_earnph/all_female_earnph 
    total_gender_gap <- all_male_earn/all_female_earn 
    print(aggregate_gender_gap)
# retvec is a vector (list) that includes all the relevant moment
    # outcomes:
    # 1.- regression with total earnings
    # 2.- regression with earnings per hour
    # 3.- total gender gap
    # 4.- vector of occupation-level gender gaps
    # 5.- vector of occupation-level bunching ratios of work
    # 6.- vector of occupation-level share of females
    # 7.- vector of occupation sizes (masses)
    # 8.- vector of earnings per hour by occ
    # 9.- regression with female earnings per hour
    # 10.- regression with male earnings per hour
    # 11.- an alternative aggregate gender gap
    # 12.- male earnings
    # 13.- female earnings
    # 14.- male earnings per hour
    # 15.- female earnings per hour
    # 16.- earnings per hour males by occ
    # 17.- earnings per hour females by occ
    # 18.- lstar of males by occ
    # 19.- lstar of females by occ
    # 20.- hours of males by occ
    # 21.- hours of females by occ
    # 22.- bunching ratios work (female and male) by occ
    # 23.- bunching ratior childcare (female and male) by occ

    retvec <- list(mainreg,mainreg_ph,aggregate_gender_gap,gender_gap_occ,brw_occ,sf,massvec,earnph_occ,female_mainreg_ph, male_mainreg_ph,total_gender_gap,all_male_earn,all_female_earn,all_male_earnph,all_female_earnph,earnph_male,earnph_female,lstar_male,lstar_female, hours_male_occ,hours_female_occ,brw,brh)

    return(retvec)
}

printout_fun <- function(gg,paramvec,filename){

   unlink(paste0('../model_output/',filename))
   filename = paste0('../model_output/',filename);
   write(sprintf("Regression per hour:, %f ", gg[[2]]$coeff),file=filename,append=T)
   write(sprintf("Aggregate Gender Gap (in percent): , %f  ", (gg[[3]]-1)*100),file=filename,append=T)
   write(sprintf("Corr gender gap brw: , %f ", cor(gg[[4]],gg[[5]])),file=filename,append=T)
   write(sprintf("Corr occ size brw: , %f ", cor(gg[[7]],gg[[5]])),file=filename,append=T)
   write(sprintf("Corr data brw model brw: , %f  ", cor(gg[[5]],brw_data)),file=filename,append=T)
   write(sprintf("Corr occ size gender gap: , %f ", cor(gg[[7]],gg[[4]])),file=filename,append=T)
   write(sprintf("Corr occ size data and model: , %f ", cor(gg[[7]], data_mass  )) ,file=filename,append=T)
   write(sprintf("Corr aver earn data and model: , %f ", cor(gg[[8]], aver_earn_data  )),file=filename,append=T)
   write(sprintf("Corr data brw model brw:, %f  ", cor(gg[[5]],brw_data)),file=filename,append=T)
   write(sprintf("Corr female share model brw:, %f  ", cor(gg[[6]],gg[[5]])),file=filename,append=T)
   write(sprintf("Corr data female share model female share:, %f   ", cor(gg[[6]],share_fem)),file=filename,append=T)
   write(sprintf("Corr brw and alpha: , %f ", cor(gg[[5]],alpha_vec)),file=filename,append=T)
   write(sprintf("Total Gender Gap (in percent not per hour):, %f  ",(gg[[11]]-1)*100),file=filename,append=T)
   write(sprintf("Corr female share and alpha:, %f  ", cor(gg[[6]],paramvec[1:nocc])),file=filename,append=T)
   write(sprintf("Corr mass and alpha:, %f  ", cor(gg[[7]],paramvec[1:nocc])),file=filename,append=T)
   write(sprintf("All Male Earn:, %f ", gg[[12]]),file=filename,append=T)
   write(sprintf("All Female Earn:, %f ", gg[[13]]),file=filename,append=T)
   write(sprintf("All Male Earn Per Hour:, %f ", gg[[14]]),file=filename,append=T)
   write(sprintf("All Female Earn Per Hour:, %f ", gg[[15]]),file=filename,append=T)
   # now do some validation
   # load male and female hours by occupation
   hours_by_occ <- read.csv('../data/mean_work_hours_gender_occ_22occs_may.txt',header=T)
   # gg[[20]] is male hours, gg[[21]] is female hours
   male_hours <- gg[[20]]
   female_hours <- gg[[21]]
   model_ratio <- gg[[20]]/gg[[21]]
	data_ratio <- hours_by_occ$V2/hours_by_occ$V3
    # some model fit paramaters
	write(sprintf("Correlation between ratio of male to female hours by occ between model and data:, %f ",  cor(data_ratio,model_ratio)),file=filename,append=T)
	write(sprintf("Ratio of Men Work BR to Women Work BR:, %f ", sum(gg[[22]][,1]*(1-sf)*massvec/0.5)/sum(gg[[22]][,2]*sf*massvec/0.5)),file=filename,append=T)
   	write(sprintf("Men Work BR:, %f  ", sum(gg[[22]][,1]*(1-sf)*massvec/0.5)), file=filename, append=T)
    write(sprintf("Women Work BR:, %f  ", sum(gg[[22]][,2]*(sf)*massvec/0.5)),file=filename,append=T)
   	write(sprintf("Overall Work BR:, %f  ",mean(gg[[22]][,1]*(1-sf) + gg[[22]][,2]*sf)), file=filename, append=T)
  	write(sprintf("Overall HH BR:, %f  ", mean(gg[[23]][,1]*(1-sf) + gg[[23]][,2]*sf)), file=filename, append=T)
   	write(sprintf("Ratio Work BR to HH BR:, %f  ",mean(gg[[22]][,1]*(1-sf) + gg[[22]][,2]*sf)/mean(gg[[23]][,1]*(1-sf) + gg[[23]][,2]*sf)), file=filename, append=T)
  

    write(sum(gg[[22]][,1]*(1-sf)*massvec/0.5)/sum(gg[[22]][,2]*sf*massvec/0.5),file=paste0(model_output_folder,'validation'),append=T)
    write(sprintf("Ratio of Men housecare BR to Women housecare BR:, %f ", sum(gg[[23]][,1]*(1-sf)*massvec/0.5)/sum(gg[[23]][,2]*sf*massvec/0.5)), file=filename, append=T)
 	write(sprintf("Ratio of Hours worked Male to Female:, %f ", mean(gg[[20]])/mean(gg[[21]])),file=filename,append=T)
   	



}




