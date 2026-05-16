rm(list=ls())
library(ggplot2)
library(latex2exp)

#FIGURE 5

data_for_figure_5 <- read.table('../Quantitative_Analysis/model_output/data_for_figure_5', header=F)
names(data_for_figure_5) <- c("alpha", "within")
data_for_figure_5$within <- data_for_figure_5$within*100 #put in percentage
p1 <- ggplot(data_for_figure_5, aes(x=alpha,y=within)) + geom_line(color="red", size=1.5) + scale_x_continuous(breaks=c(0.5,1,1.5,2,2.5,3,3.5,4,4.5,5),expand = c(0, 0), limits = c(0.5, 5), sec.axis=dup_axis(labels=NULL,name=NULL)) 

p1 <- p1 + scale_y_continuous(breaks=c(0,2,4,6,8,10,12,14),expand = c(0, 0), limits = c(0, 14),  sec.axis=dup_axis(labels=NULL,name=NULL)) + ylab("Gender Wage Gap-Within (%)") + xlab(TeX("$\\alpha$")) + theme_bw()+ theme(axis.ticks.length=unit(-0.12, "cm"), panel.grid.major = element_blank(),
panel.grid.minor = element_blank(), axis.line = element_line(colour = "black") )

ggsave('./figure5.pdf')


# FIGURE 6
data_for_figure_6 <- read.table('../Quantitative_Analysis/model_output/data_for_figure_6', header=F)
names(data_for_figure_6) <- c("distance", "low","medium","high")
data_for_figure_6$distance <- data_for_figure_6$distance[length(data_for_figure_6$distance)]-data_for_figure_6$distance

p2 <- ggplot(data_for_figure_6, aes(x=distance)) + geom_line(aes(y=low,color="low"),size=1.0) + geom_line(aes(y=medium,color="medium"),size=1.0) + geom_line(aes(y=high,color="high"), size=2.0)

p2 <- p2 +  scale_x_continuous(breaks=c(0,0.02,0.04,0.06,0.08 ,0.10,0.12),labels=c('0','0.02','0.04','0.06','0.08' ,'0.10','0.12'),expand = c(0, 0), limits = c(0, 0.137)) 
p2 <- p2 + scale_y_continuous(breaks=c(0,0.02,0.04,0.06,0.08 ,0.10,0.12,0.14),labels=c('0','0.02','0.04','0.06','0.08' ,'0.10','0.12','0.14'),expand = c(0, 0), limits = c(0, 0.14))
p2 <- p2 + ylab("Gender Wage Gap-Within (%)") + xlab(TeX("Distance Between $\\nu$ of Females and Males")) + theme_bw()+ theme(axis.ticks.length=unit(-0.12, "cm"), panel.grid.major=element_blank(), panel.grid.minor=element_blank(), panel.border=element_blank(),axis.line=element_line(),legend.position = c(0.15, 0.87),  legend.box.background = element_rect(colour = "black", size=0.8),legend.key.width = unit(3, "line"),legend.key.size = unit(0.05, 'cm'), legend.margin=margin(c(1,5,5,5)  ))
p2 <- p2 +  guides(colour = guide_legend(override.aes = list(size=1)))
p2 <- p2  + scale_color_manual(name = element_blank(), values=c('low'="black",'medium'="blue","high"="red"),labels = unname(TeX(c("$\\alpha$ = 0.6", "$\\alpha$ = 1.5", "$\\alpha$ = 12 "))) )
ggsave('./figure6.pdf',height=5,width=6)


