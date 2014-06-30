library(pbdMPI, quiet=TRUE)
init()
##
## comm.rank <- function(comm=0) 0
## rank 0 writes a bunch of integers into a binary file
if(comm.rank() == 0)
{
    ## write a vector of doubles to a binary file
    length <- 32
    x <- seq(0.5, length, 1)
    writeBin(x, "binary.vector.file")
}

if(comm.rank() == 1)
{
    ncol <- 8
    nrow <- 4

    x <- matrix(seq(0.5, nrow*ncol, 1), nrow=nrow)
    writeBin(as.vector(x), "binary.matrix.file")
}

finalize()
