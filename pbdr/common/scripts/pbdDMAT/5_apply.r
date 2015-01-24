library(pbdDMAT, quiet = TRUE)
init.grid()

x.dmat <- ddmatrix(1:30, nrow = 10)
comm.print(x.dmat)

colsd <- apply(X = x.dmat, FUN = sd, MARGIN = 2)
colsd.loc <- as.matrix(colsd)
tc.c <- as.matrix(t(colsd) %*% colsd)
c.tc <- as.matrix(colsd %*% t(colsd))

comm.print(colsd)
comm.print(colsd.loc)
comm.print(tc.c)
comm.print(c.tc)

finalize ()
