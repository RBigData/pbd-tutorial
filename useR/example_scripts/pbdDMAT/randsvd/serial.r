
randSVD <- function(A, k, q=3)
  {
    ## Stage A
    Omega <- matrix(rnorm(n*2*k), nrow=n, ncol=2*k)
    Y <- A %*% Omega
    Q <- qr.Q(qr(Y))
    At <- t(A)
    for(i in 1:q)
      {
        Y <- At %*% Q
        Q <- qr.Q(qr(Y))
        Y <- A %*% Q
        Q <- qr.Q(qr(Y))
      }
    
    ## Stage B
    B <- t(Q) %*% A
    U <- La.svd(B)$u
    U <- Q %*% U
    U[, 1:k]
  }

set.seed(seed=1234567)

m <- 100000
n <- 1000
k <- 20

A <- matrix(rnorm(m*n), nrow=m, ncol=n)
A <- A %*% diag(exp(seq(10, -10, length.out=n)))

Ux <- La.svd(A, nu=k, nv=0)$u
U <- randSVD(A, k, q=6)

print(all.equal(abs(U), abs(Ux)))

