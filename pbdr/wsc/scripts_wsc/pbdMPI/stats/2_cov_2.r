### Compute covariance matrix the easy way
library(pbdDMAT, quiet = TRUE, warn.conflicts=FALSE)
init.grid()

comm.set.seed(seed=1234567, diff=TRUE)

## Generate 10 rows and 3 columns of data per process
X <- ddmatrix(data="rnorm", nrow=comm.size()*10, ncol=3)

## Compute covariance
Cov.X <- cov(X)

comm.print(Cov.X)

## Bring to local context for printing
Cov.X <- as.matrix(Cov.X)
comm.print(Cov.X)

finalize()
