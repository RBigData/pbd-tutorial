library(rbenchmark)

x <- matrix( rnorm(1000 * 50), nrow=1000, ncol=50)

f <- function(x) t(x) %*% x
g <- function(x) crossprod(x)

library( rbenchmark )
benchmark(f(x), g(x))
