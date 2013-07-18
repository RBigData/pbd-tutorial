library(pbdDMAT, quiet=TRUE)
init.grid()

x.dmat <- ddmatrix(1:30, nrow=10)

y.dmat <- x.dmat + 1:7

z.dmat <- scale(x.dmat, center=TRUE, scale=TRUE)

y <- as.matrix(y.dmat)
z <- as.matrix(z.dmat)

comm.print(y)
comm.print(z)

finalize()
