###
### Function Definitions ###############################################
###
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
  my.local <- NULL
  for(i in 1:num)
    {
      ## serial collection of unique data to each rank
      local <- as.vector(x[, i])
      if(comm.rank() + 1 == i) my.local <- local
    }
  my.local
}
###
### End Function Definitions ###########################################
###

### Load pbdR and utilities.
library(pbdDMAT, quiet = TRUE)
init.grid()

## global subcube definition
g.dim <- c(64, 64, 1024)

## local dimension and start
my.dim <- g.dim / c(1, 1, comm.size())

save.file <- paste("xyz.RData", comm.rank(), sep="")
load(save.file)

## make a ddmatrix from local data
## note we use ICTXT=1 as we split columns among processors

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
## glue local pieces into a ddmatrix
X <- new("ddmatrix", Data=X, dim=gdim, ldim=ldim, bldim=ldim, ICTXT=1)
## transform to 2d block cyclic
X <- redistribute(X, bldim=c(8,8), ICTXT=0)

## Plot few columns in parallel
step <- 5
max.plots <- min(20, ncol(X) %/% step)
last.plot <- 1 - step
time <- comm.timer(
for(i in 1:max.plots)
    {
        now.plots <- last.plot + step*(1:comm.size())
        my.col <- gather.col(X[, now.plots])
        lab <- paste("col", lead0(now.plots[comm.rank() + 1]), sep="")
        png.slice(my.col, g.dim[1:2], lab)
        last.plot <- now.plots[length(now.plots)]
    }
)
comm.print(time)

finalize()

