library(pbdDMAT, quiet = TRUE)
init.grid()

## load local data (file assumes 4 processors!)
g.dim <- c(64, 64, 1024)
my.dim <- g.dim / c(1, 1, comm.size())
save.file <- paste("xyz.RData", comm.rank(), sep="") # assumes 4 processors!
load(save.file)

## reshape 3d array into a matrix for PCA (EOF) computation
## first two dimensions become rows and third becomes columns
## local reshape dimensions
my.nrow <- prod(my.dim[1:2])
my.ncol <- my.dim[3]
ldim <- c(my.nrow, my.ncol)

## global reshape dimensions
g.nrow <- prod(g.dim[1:2])
g.ncol <- g.dim[3]
gdim <- c(g.nrow, g.ncol)

## now reshape local
X <- matrix(vx, nrow=my.nrow, ncol=my.ncol, byrow=FALSE)
Y <- matrix(vy, nrow=my.nrow, ncol=my.ncol, byrow=FALSE)
Z <- matrix(vz, nrow=my.nrow, ncol=my.ncol, byrow=FALSE)

## glue local pieces into a ddmatrix
X <- new("ddmatrix", Data=X, dim=gdim, ldim=ldim, bldim=ldim, ICTXT=1)
Y <- new("ddmatrix", Data=Y, dim=gdim, ldim=ldim, bldim=ldim, ICTXT=1)
Z <- new("ddmatrix", Data=Z, dim=gdim, ldim=ldim, bldim=ldim, ICTXT=1)

## transform to 2d block cyclic
X <- redistribute(X, bldim=c(8,8), ICTXT=0)
Y <- redistribute(Y, bldim=c(8,8), ICTXT=0)
Z <- redistribute(Z, bldim=c(8,8), ICTXT=0)

## now we can relax and do "serial"
E <- sqrt(X^2 + Y^2 + Z^2)

E.pca <- prcomp(x=E, retx=TRUE, scale=FALSE)

## Use ranks 1 to n.pca to plot individual components in parallel
n.pca <- min(comm.size(), g.nrow)
my.col <- gather.col(E.pca$x, num=n.pca)

if(!is.null(my.col))
  {
    ## component plots on rank 1 to n.pca
    lab <- paste("pc", comm.rank(), sep="")
    title <- paste(lab, "sigma^2 =", variance[comm.rank() + 1])
    png.slice(my.col, g.dim[1:2], lab, title=title, work.dir=work.dir)
  }
