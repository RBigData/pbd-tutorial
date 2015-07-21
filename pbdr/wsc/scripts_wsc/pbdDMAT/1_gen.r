library(pbdDMAT, quiet=TRUE)
init.grid()

# Common global on all processors --> distributed
x <- matrix(1:100, nrow=10, ncol=10)
x.dmat <- as.ddmatrix(x)

x.dmat

# Global on processor 0 --> distributed
if (comm.rank()==0){
  y <- matrix(1:100, nrow=10, ncol=10)
} else {
  y <- NULL
}
y.dmat <- as.ddmatrix(y)

y.dmat

finalize()
