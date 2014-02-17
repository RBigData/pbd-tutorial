lead0 <- function(num, lead=3)
  {
      formatC(num, flag="0", width=lead)
  }
png.slice <- function(x, g.dim, lab="slice", title=lab, work.dir="",
                      zero.center=TRUE, most.positive=TRUE)
{
  ## create a png image file of x as a matrix
  ##
  ## lab - used as filename
  ## x - vector that is folded into a g.dim dimensional array
  ## zero.center - centers colors on zero

  ## make an array from x
  X <- array(as.vector(x), dim=g.dim)

  ## prepare zero centered topo.colors
  if(zero.center)
    {
      if(is.numeric(zero.center))
        {
          abs.max <- zero.center
        }
      else
        {
          maxX <- max(X)
          minX <- min(X)
          abs.max <- max(maxX, abs(minX))
        }
      zlim <- c(-abs.max, abs.max)
    }
  else
    {
      zlim <- range(X)
    }

  ## set majority to be positive (useful when unique up to sign)
  if(most.positive)
    {
      positives <- sum(X > 0)
      zeros <- sum(X == 0)
      all <- length(X)
      if(positives + 0.5*zeros < 0.5*all) X <- X*(-1)
    }
  
  ## make png file
  file <- paste(work.dir, lab, "-r", comm.rank(), ".png", sep="")
  png(file)
  image(x=1:g.dim[1], y=1:g.dim[2], z=X,
        col=topo.colors(40), useRaster=TRUE, asp=1,
        xlim=c(1, g.dim[1] + 1), ylim=c(1, g.dim[2] + 1), zlim=zlim)
  title(title)
  ret <- dev.off()
  invisible(ret)
}

gather.col <- function(x, num=min(ncol(x), comm.size()))
{
  ## gather complete columns of a global array to different ranks
  x.num <- x[, 1:num]
  x.num <- as.colblock(x.num)

  ## ScaLAPACK fix (a future release will automate)
  if(ownany(x.num))
    ret <- as.vector(submatrix(x.num))
  else
    ret <- NULL
  ret
}


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
    png.slice(my.col, g.dim[1:2], lab)
  }

finalize()
