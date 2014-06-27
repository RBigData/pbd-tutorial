#setwd("../pbdr/common/pics/")


library(ggplot2)



df <- data.frame(Cores=c(1, 2, 4, 8, 16, 32, 64), Speedup=c(1, 1.7, 3.24, 6.9, 14.1, 26.2, 50.7))

g <- ggplot(df, aes(Cores, Speedup)) + 
  geom_point() +
  geom_line() +
  geom_abline(intercept=0, slope=1, linetype="dashed")

g
ggsave("scaling_strong.pdf")



df <- data.frame(Cores=c(1, 2, 4, 8, 16)*1024, Time=c(3014, 3017, 3020, 3026, 3033))

h <- ggplot(df, aes(Cores, Time)) +
  geom_point() +
  geom_line() +
  geom_hline(yintercept=df[1,2], linetype="dashed") + 
  ylim(df[1,2]-100, df[1,2]+100) 

h
ggsave("scaling_weak.pdf")


