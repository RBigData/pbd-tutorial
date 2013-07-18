library(pbdMPI, quiet = TRUE)
init()
comm.set.seed(diff=TRUE)

N.spmd <- 50000 / comm.size()
X.spmd <- matrix(runif(N.spmd * 2), ncol = 2)
r.spmd <- sum(rowSums(X.spmd^2) <= 1)
r <- allreduce(r.spmd)
PI <- 4*r/(N.spmd * comm.size())
comm.print(PI)

finalize()
