library(pbdMPI, quiet = TRUE)
init()

comm.set.seed(diff=TRUE)
X.spmd <- matrix(rnorm(10*3), ncol=3)


N <- allreduce(nrow(X.spmd), op="sum")
mu <- allreduce(colSums(X.spmd) / N, op="sum")

X.spmd <- sweep(X.spmd, STATS=mu, MARGIN=2)
Cov.X <- allreduce(crossprod(X.spmd), op="sum") / (N-1)

comm.print(Cov.X, rank.print=1)

finalize()
