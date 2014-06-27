setwd("../pbdr/common/pics/")


library(ggplot2)

e <- .1

x <- 1:8
y <- numeric(length(x))

y[1] <- 1
for (i in 2:length(x)){
  y[i] <- 1/(1-e)
}

z <- x/y
z

df <- data.frame(Cores=c(x,x), Speedup=c(x, z), group=c(rep("Optimal", length(x)), rep("Application", length(x))))



g <- ggplot(df, aes(Cores, Speedup, group=group)) + 
  geom_point() + 
  geom_path(aes(colour=group))

g
ggsave(filename="scale_good.pdf", plot=g)




df <- data.frame(Cores=c(x,x), Speedup=c(x, log10(z)+1), group=c(rep("Optimal", length(x)), rep("Application", length(x))))

h <- ggplot(df, aes(Cores, Speedup, group=group)) + 
  geom_point() + 
  geom_path(aes(colour=group))

h
ggsave(filename="scale_bad.pdf", plot=h)



