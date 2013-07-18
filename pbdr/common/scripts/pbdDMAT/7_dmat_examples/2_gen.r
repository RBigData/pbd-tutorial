library(pbdDMAT, quiet=TRUE)
init.grid()

zero.dmat <- ddmatrix(0, nrow=100, ncol=100)
zero.dmat

id.dmat <- diag(1, nrow=100, ncol=100, type="ddmatrix")
id.dmat

comm.set.seed(diff=T)
rand.dmat <- ddmatrix("rnorm", nrow=100, ncol=100, mean=10, sd=100)
rand.dmat

finalize()
