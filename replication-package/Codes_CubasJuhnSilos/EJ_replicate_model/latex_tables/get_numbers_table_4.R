rm(list=ls())

suppressWarnings(x <- readLines('../../EJ_replicate/table4/table4_corr_vals.smcl'))

temp_vector <- c()

# get data 
# 1st block  (onet characteristics)
y <- x[14:21]
for (k in seq(14:21)){
i <- unlist(gregexpr('\\{res\\}', y[k]))
print(as.numeric(substr(y[k], 31,37)))
temp_vector <- rbind(temp_vector, (as.numeric(substr(y[k], 31,37))))
}

# 2nd block (conc. ratio and male overwork)
y1 <- x[34]
i <- unlist(gregexpr('\\{res\\}', y1))
print(as.numeric(substr(y1, 31,37)))       
temp_vector <- rbind(temp_vector, (as.numeric(substr(y1, 31,37))))
y2 <- x[35]
i <- unlist(gregexpr('\\{res\\}', y2))
print(as.numeric(substr(y2, 31,37)))
temp_vector <- rbind(temp_vector, (as.numeric(substr(y2, 31,37))))
# 3rd block (onet skills)
y <- x[43:46]
for (k in seq(43:46)){
i <- unlist(gregexpr('\\{res\\}', y[k]))
print(as.numeric(substr(y[k], 31,37)))
temp_vector <- rbind(temp_vector, (as.numeric(substr(y[k], 31,37))))

}

table_4_numbers <- temp_vector
write.csv(table_4_numbers, file="./table_4_numbers.csv")
