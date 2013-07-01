setwd("~/dev/dmatrix/fixing/tutorial/useR/pics/")


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

df <- data.frame(Cores=c(x,x), Scaling=c(x, z), group=c(rep("Theoretical", length(x)), rep("Application", length(x))))



g <- ggplot(df, aes(Cores, Scaling, group=group)) + 
  geom_point() + 
  geom_path(aes(colour=group)) +
  opts(title=expression("Strong Scalability"))

g
ggsave(filename="scale_strong.pdf", plot=g)




df <- data.frame(Cores=c(x,x), Scaling=c(x, log10(z)+1), group=c(rep("Theoretical", length(x)), rep("Application", length(x))))

h <- ggplot(df, aes(Cores, Scaling, group=group)) + 
  geom_point() + 
  geom_path(aes(colour=group)) +
  opts(title=expression("Weak Scalability"))

h
ggsave(filename="scale_weak.pdf", plot=h)



