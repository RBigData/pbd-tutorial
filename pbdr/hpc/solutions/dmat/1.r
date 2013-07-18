library(pbdDMAT, quiet=T)
init.grid()

x.dmat <- ddmatrix(1:30, 10, 3)


y.dmat <- x.dmat[x.dmat[, 2] > 13, ]
y.dmat
y <- as.matrix(y.dmat)
comm.print(y)

y.dmat <- x.dmat[x.dmat[, 2] > x.dmat[, 3], ]
y.dmat
y <- as.matrix(y.dmat)
comm.print(y)

y.dmat <- x.dmat[, x.dmat[2,] > x.dmat[3, ]]
y.dmat
y <- as.matrix(y.dmat)
comm.print(y)

y.dmat <- x.dmat[c(1, 3, 5), x.dmat[, 2] > x.dmat[, 3]]
y.dmat
y <- as.matrix(y.dmat)
comm.print(y)

finalize()

