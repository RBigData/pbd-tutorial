library(pbdDMAT, quiet=TRUE)
init.grid()

x.dmat <- ddmatrix(1:30, nrow=10)
y.dmat <- x.dmat[c(1, 3, 5, 7, 9), -3]

comm.print(y.dmat)
y <- as.matrix(y.dmat)
comm.print(y)

finalize()
