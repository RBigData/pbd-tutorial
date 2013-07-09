library(pbdDMAT, quiet=T)
init.grid()

n <- 1e4
p <- 250

comm.set.seed(diff=T)
x.dmat <- ddmatrix("rnorm", nrow=n, ncol=p, mean=100, sd=25)

pca <- prcomp(x=x.dmat, retx=TRUE, scale=TRUE)
prop_var <- cumsum(pca$sdev)/sum(pca$sdev)
i <- max(min(which(prop_var > 0.9)) - 1, 1)

y.dmat <- pca$x[, 1:i]

comm.cat("\nNumber of columns retained: ", i, "\n", quiet=T)
comm.cat("% of columns retained:     ", i/dim(x.dmat)[2], "\n\n", quiet=T)

finalize()
