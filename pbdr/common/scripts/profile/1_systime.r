x <- matrix(rnorm(5000*750), nrow=5000, ncol=750)

system.time( t(x) %*% x )

system.time( crossprod(x) )

system.time( cov(x) )
