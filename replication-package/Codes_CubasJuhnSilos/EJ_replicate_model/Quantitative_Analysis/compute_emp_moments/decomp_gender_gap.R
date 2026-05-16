rm(list=ls())

data_share_fem <- scan('../data/share_fem_occ_22occs_may.txt')
data_occ_shares <- scan('../data/occ_shares_all_22occs_may.txt')
data_mean_earn_male <- read.csv('../data/mean_earn_ph_occ_all_22occs_mal_may.txt')
data_mean_earn_female <- read.csv('../data/mean_earn_ph_occ_all_22occs_fem_may.txt')
alpha_m <- (1-data_share_fem)*data_occ_shares
alpha_f <- data_share_fem*data_occ_shares
mass_m <- sum(alpha_m)
mass_f <- sum(alpha_f)
earnph_male <- data_mean_earn_male$mean_earn_ph_occ_mal
earnph_female <- data_mean_earn_female$mean_earn_ph_occ_fem 
total <- sum(alpha_m/mass_m*earnph_male)/sum(alpha_f/mass_f*earnph_female)
    across <- sum(alpha_m/mass_m*earnph_female)/sum(alpha_f/mass_f*earnph_female)
    within <- sum(alpha_m/mass_m*earnph_male)/sum(alpha_m/mass_m*earnph_female)
    print(c("Decomposition of Gender Gap:  "))
    print(c("Total: ", log(total)))
    print(c("Across: ",  log(across)))
    print(c("Within: ", log(within)))

write(c(log(total),log(across),log(within)),file='../data/empirical_decomp_gender_gap')
