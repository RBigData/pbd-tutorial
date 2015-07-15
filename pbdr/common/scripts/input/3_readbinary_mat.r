## Binary reading of a matrix
library(pbdMPI, quiet=TRUE)
library(pbdDMAT, quiet=TRUE)
init.grid()

## set up start and length for reading a matrix of
##        doubles split on columns
nrow <- 4
ncol <- 8
size <- 8 # bytes

my_ids <- get.jid(ncol, method="block")
my_start_col <- my_ids[1]
my_ncol <- length(my_ids) # contiguous ids
my_start <- (my_start_col - 1)*nrow*size
my_length <- my_ncol*nrow
comm.cat("my_start", my_start, "my_length", my_length, "\n",
         all.rank=TRUE)

con <- file("binary.matrix.file", "rb")
seekval <- seek(con, where=my_start, rw="read")
x <- readBin(con, what="double", n=my_length, size=size)
comm.print(x, all.rank=TRUE)

gdim <- c(nrow, ncol)
ldim <- c(nrow, my_ncol)
bldim <- c(nrow, allreduce(my_ncol, op="max"))
X <- new("ddmatrix", Data=matrix(x, nrow, my_ncol),
         dim=gdim, ldim=ldim, bldim=bldim, ICTXT=1)
comm.print(X@Data, all.rank=TRUE)

X <- redistribute(X, bldim=c(2, 2), ICTXT=0) # ScaLAPACK-powered!
comm.print(X@Data, all.rank=TRUE)

Xprc <- prcomp(X) # ScaLAPACK-powered!
comm.print(Xprc)

finalize()
