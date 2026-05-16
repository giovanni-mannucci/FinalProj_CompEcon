 rm(list=ls())
 library(minpack.lm)
 library(data.table)
 library(batch)
 parseCommandArgs()
 # functions
 #setwd(working_directory) 
 source('./new_funs.R')
 source('./new_one.R')
 unlink('../model_output/funvals')
 unlink('../model_output/moments')
 unlink('../model_output/params')
 unlink('../model_output/validation')
 options(digits=8,scipen=999)
 alpha_min <- 0.6
 #peos <- 2/3 # peos = (sigma-1)/sigma. We use sigma (the elast of subs among occs) from klenow et al and set it to 3.
 estimation_ind = 0 # set to 1 if you want to estimate, to 0 to load previously estimated parameters
 # if estimation equals zero then you can run
 # different counterfactuals
 
 #experiment = 0 # 0: baseline
                # 1: alpha of health support 
                # 2: Reduce differences in nu
                # 3: get data for figure 5 (within gender gap by value
 # of alpha and 6 (within gender gap by value of alpha and diff in nu)
                # 4: change elast of substitution between home care in
 # prime time vs. rest of the day 
                # 5: equal taste distributions for males and females
 # Data on labor shares, female shares, and
 # bunching ratios
 # labor shares
 lshvec <- scan('../data/labor_shares_22occ_may.txt')
 # share of females
 share_fem <- scan('../data/share_fem_occ_22occs_may.txt')
 # bunching ratios
 brw_data <- scan('../data/br_w_22_may19.txt')
 brh_data <- scan('../data/br_hh_22_may19.txt')
 # find average brw to average brh
 mean_brw_brh <- mean(brw_data)/mean(brh_data)
 # de-mean bunching ratios work for estimation
 brw_data <- brw_data - mean(brw_data)
 # mean daily hours of work and household care for females and males
 mean_hours_hh <- read.csv('../data/mean_hhcare_hours_gender_22occs_may.txt')
 mean_hours_work <- read.csv('../data/mean_work_hours_gender_22occs_may.txt')
 mean_work_female <- mean_hours_work$mean_work_hours_fem/(mean_hours_work$mean_work_hours_fem+mean_hours_hh$mean_hhcare_hours_fem)
 mean_work_male <- mean_hours_work$mean_work_hours_mal/(mean_hours_work$mean_work_hours_mal+mean_hours_hh$mean_hhcare_hours_mal)
 
 #-------------------------------------------------
 # occ sizes
 data_mass <- scan('../data/occ_shares_all_22occs_may.txt')
 aver_earn_data <- read.csv('../data/mean_earn_ph_occ_all_22occs_may.txt')
 aver_earn_data <- aver_earn_data$mean_earn_ph_occ
 aver_earn_data <- aver_earn_data/aver_earn_data[1]
 nocc <- 22
 lambda <- 0.85
 # vector to keep equilibrium wages
 tempwage <- rep(1.0,nocc)
 # initial parameter guess    
 alpha_vec <- 1./(brw_data+1)
 #alpha_vec <- rep(1,nocc)
 nu_vec <- c(0.88,0.71) 
 paramvec <- c(alpha_vec,rep(1,nocc)*10*share_fem, rep(1,nocc), rep(1,nocc), 0.05,nu_vec)
 
 #-----------------------------------------------------------------
 # data moments has nocc bunching ratios work and
 # average hours worked for males and females 
 data_moments <- c(brw_data,share_fem,aver_earn_data,data_mass,mean_work_male,mean_work_female,mean_brw_brh)
 
 #####
 ######
 if (estimation_ind==1){
     paramvec<- scan('./ces_param')
     nelder <- 0 
     # compute_moments(paramvec,data_moments)
     #estim_res <- nloptr(paramvec,compute_moments,opts=list("algorithm"="NLOPT_LN_SBPLX","xtol_rel"=1.0e-8,maxeval=145000),moments=data_moments)
     estim_res <- nls.lm(paramvec,lower=NULL, upper=NULL, compute_moments, jac=NULL, moments=data_moments)
     paramvec <- estim_res$par
     write(paramvec,file='./ces_param')
 } else {
     nelder <- 1
     # load previously estimated parameter values.
     paramvec <- scan('ces_param')
     alpha_vec <- paramvec[1:nocc]
     taste_param <- paramvec[(nocc+1):(2*nocc)]
     
     tfpvec <- paramvec[(2*nocc+1):(3*nocc)]
     taste_males <- paramvec[(3*nocc+1):(4*nocc)]
 
     rho <- paramvec[(4*nocc+1)]
     nu_vec <- paramvec[(4*nocc+2):(length(paramvec))]
     #compute_moments(paramvec,data_moments)
     if (experiment==0){ # baseline case
         experiment_label <- "BASELINE"
 	     taste_param <- paramvec[(nocc+1):(2*nocc)]
 	     tfpvec <- paramvec[(2*nocc+1):(3*nocc)]
 	     taste_males <- paramvec[(3*nocc+1):(4*nocc)]
 	     tempwage <<- wages_iterate(paramvec,tempwage)
 	     compute_moments(paramvec,data_moments)
 	     gg <- get_final_model_data(paramvec,tempwage)
 	     # save several files for counterfactuals
 	     write(gg[[16]],file=paste0(model_output_folder,'baseline_male_earningsph',model_extension))
         write(gg[[17]],file=paste0(model_output_folder,'baseline_female_earningsph',model_extension))
 	     write(tempwage,file=paste0(model_output_folder,'baseline_wages',model_extension))
         write(gg[[7]],file=paste0(model_output_folder,'baseline_occ_masses',model_extension))
         write(gg[[6]],file=paste0(model_output_folder,'baseline_share_females',model_extension))
	 } else if (experiment==1) {
         experiment_label <- "Same_alpha_(healthcare_support)" 
		 tempwage <<- wages_iterate(paramvec,tempwage)
		 paramvec[1:nocc] <- paramvec[11] # put healthcare alpha
         tempwage <<- wages_iterate(paramvec,tempwage)
         gg_counter <- get_final_model_data(paramvec,tempwage) 
         gg <- gg_counter
     } else if (experiment==2){
         tempwage <<- wages_iterate(paramvec,tempwage)
         nu_vec <-paramvec[(4*nocc+2):(length(paramvec))]  
         diff <- (nu_vec[1]-nu_vec[2])/4
         nu_vec[1] <- nu_vec[1]-diff
         nu_vec[2] <- nu_vec[2]+diff
         paramvec[(4*nocc+2):(length(paramvec))] <- nu_vec
         experiment_label <- "Smaller_differences_preferences"
		 tempwage <<- wages_iterate(paramvec,tempwage)
         gg <- get_final_model_data(paramvec,tempwage)
	 } else if (experiment==3) { # this experiment just outputs data for figures
		 #---- DATA FOR FIGURE 5
		 fig_alpha_vec <- seq(0.60,5,by=0.1)
 	     within_gg_vec <- mat.or.vec(length(fig_alpha_vec),1)
 	     for (j in seq(1,length(fig_alpha_vec))){
			 paramvec[1:nocc] <- fig_alpha_vec[j]  
             tempwage <<- wages_iterate(paramvec,tempwage)
             gg_counter <- get_final_model_data(paramvec,tempwage) 
             gg <- gg_counter
             earnph_male <- gg[[16]]
     	     earnph_female <- gg[[17]]
     	     massvec <- gg[[7]]
     	     sf <- gg[[6]]
     	      
            decomp <- gender_gap_decomp(earnph_female, earnph_male, massvec,sf)
      	    within_gg_vec[j] <- decomp[[3]] 
		 }
 	     data_for_figure_5 <- cbind(fig_alpha_vec, within_gg_vec)
         write.table(round(data_for_figure_5,digits=4),file=paste0(model_output_folder,'data_for_figure_5',model_extension),row.names=F,col.names=F)
		 #---- DATA FOR FIGURE 6
		 nu_vec_estim <-paramvec[(4*nocc+2):(length(paramvec))]  
		 diff <- (nu_vec_estim[1]-nu_vec_estim[2])
        Npoints <- 50
        diff_vec <- seq(0,diff,by=(diff-0)/Npoints)
        within_gg_nu_vec <- mat.or.vec(length(diff_vec),3) #store within for 3 values of alpha and values of diff
		alpha_fig6_vec <- c(0.6,1.5,12)
		for (k in seq(1,length(alpha_fig6_vec),1)){
			paramvec[1:nocc] <- alpha_fig6_vec[k] 
            nu_vec <- nu_vec_estim
			for (j in seq(1, length(diff_vec))){ 
				nu_vec[1] <- nu_vec_estim[1]-diff_vec[j]/2
                nu_vec[2] <- nu_vec_estim[2]+diff_vec[j]/2
                print(nu_vec)
                paramvec[(4*nocc+2):(length(paramvec))] <- nu_vec
                tempwage <<- wages_iterate(paramvec,tempwage)
                gg_counter <- get_final_model_data(paramvec,tempwage)
                gg <- gg_counter
                earnph_male <- gg[[16]]
                earnph_female <- gg[[17]]
	            massvec <- gg[[7]]
     	        sf <- gg[[6]] 
               decomp <- gender_gap_decomp(earnph_female, earnph_male, massvec,sf)
			   within_gg_nu_vec[j,k] <- decomp[[3]] 
			}
		}
		data_for_figure_6 <- cbind(diff_vec,within_gg_nu_vec)
		write.table(round(data_for_figure_6,digits=4),file=paste0(model_output_folder,'data_for_figure_6',model_extension),row.names=F,col.names=F)
	 } else if (experiment==4) { #experiment #4
		 rho <- 0.65
		 paramvec[(4*nocc+1)] <- rho
         experiment_label <- "Alternative_eos_home_care"
 	     tempwage <<- wages_iterate(paramvec,tempwage)
 	     gg_counter <- get_final_model_data(paramvec,tempwage) 
 	     gg <- gg_counter
 
     } else { #experiment #5
		experiment_label <- "Equal_taste_distrib_males_and_females"
 	    paramvec[(nocc+1):(2*nocc)] <- 1
 	    paramvec[(3*nocc+1):(4*nocc)] <- 1
 	    tempwage <<- wages_iterate(paramvec,tempwage)
        gg <- get_final_model_data(paramvec,tempwage)
	 }
 }

 if (experiment != 3 & estimation_ind == 0){
	     # save gender gap decomposition 
	     earnph_male <- gg[[16]]
	     earnph_female <- gg[[17]]
	     massvec <- gg[[7]]
	     sf <- gg[[6]]   
	     result_decomp <- gender_gap_decomp(earnph_female,earnph_male, massvec,sf) 
	     write(unlist(result_decomp),file=paste0(model_output_folder,'decomp_gender_gap_',experiment_label,model_extension))
         # decomposition due to sorting 
		 earnph_male <- scan(paste0(model_output_folder,'baseline_male_earningsph',model_extension))
		 earnph_female <- scan(paste0(model_output_folder,'baseline_female_earningsph',model_extension)) 
		 massvec <- scan(paste0(model_output_folder,'baseline_occ_masses',model_extension))
		 wage_vec <- scan(paste0(model_output_folder,'baseline_wages',model_extension))
		 gg <- get_final_model_data(paramvec,tempwage)
		 sf <- gg[[6]]
         result_decomp <- gender_gap_decomp(earnph_female,earnph_male, massvec,sf) 
	     write(unlist(result_decomp),file=paste0(model_output_folder,'decomp_gender_gap_sorting_',experiment_label,model_extension))
		 # save model regression
	     write(gg[[2]]$coeff,file=paste0(model_output_folder,'earnph_regression_',experiment_label,model_extension))
 }
# get some extra results for the baseline case. 
if (experiment==0){
	data_model <- scan(paste0(model_output_folder,'moments'))
    fit <- sum(abs(((data_model-data_moments)/data_model))*100)/length(data_model)
    print(paste("Average Percentage Deviations of Model from Data: ", fit, "%"))
    write(fit,file = paste0(model_output_folder, 'model_fit_measure',model_extension)) 
    printout_fun(gg,paramvec,"additional_model_output.txt")
}

print(experiment)

