library(pbdDMAT, quietly=TRUE)
init.grid()

.ICTXT <- 1

x <- ddmatrix(1:100, 10, 10)

comm.print(x@Data, all.rank=TRUE)

finalize()
