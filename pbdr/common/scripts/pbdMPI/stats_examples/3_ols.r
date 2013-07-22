library(pbdMPI, quiet = TRUE)
init()

comm.set.seed(diff=TRUE)

# 10 rows and 3 columns of data per process
X.spmd <- matrix(rnorm(10*3), ncol=3)
y.spmd <- matrix(rnorm(10*1), ncol=1)

tX.spmd <- t(X.spmd)
A <- allreduce(tX.spmd %*% X.spmd, op = "sum")
B <- allreduce(tX.spmd %*% y.spmd, op = "sum")

ols <- solve(A) %*% B

comm.print(ols)

finalize()
