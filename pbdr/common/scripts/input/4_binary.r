block3d.read <- function(file, data.dim, my.start, my.dim, size=4) {
    ## read a 3d block of data from a possibly bigger 3d block binary file
    ## Data is stored in i,j,k first moves fastest order
    con.x <- file(file, "rb", blocking=TRUE)
    if(isSeekable(con.x)) {
        ## get linear position of my.start
        start <- sum((my.start - 1) * c(1, cumprod(data.dim)[-length(data.dim)]))
        ## allocate space for 3d block
        x <- rep(NA, prod(my.dim))
        
        ## set up fastest index block
        block <- 1:my.dim[1]
        
        ## loop over non-contiguous dimensions
        for(j in 1:my.dim[3]) {
            sofar <- 0
            for(i in 1:my.dim[2]) {
                seek(con.x, where=start, rw="read", origin="start")
                x[block] <- readBin(con=con.x, what="numeric",
                                    n=my.dim[1], size=size)
                block <- block + my.dim[1]
                ## stride for next chunk
                start <- start + data.dim[1]*size
                sofar <- sofar + data.dim[1]*size
            }
            start <- start - sofar + data.dim[1]*data.dim[2]*size
        }
    }
  else {
      x <- NULL
      comm.print(paste("Sorry ...", file, "not seakable!"))
  }
    close(con.x)
    x
}

### Load pbdR and utilities.
library(pbdDMAT, quiet = TRUE)
library(pbdDEMO, quiet = TRUE)
init.grid()

### set work.dir (all output goes here)
work.dir <- "/lustre/atlas/scratch/ost/stf006/inv_cascade_example/"

## Raw data dimensions in file
data.dim <- c(2048, 2048, 2048)

## assume that space is distributed, one file per timestep
## global subcube definition
g.start <- c(1, 1, 513)
## glength <- c(N_CUBE, N_CUBE, N_CUBE)
g.dim <- c(64, 64, 1024)

my.dim <- g.dim/c(1,1,comm.size())
my.start <- g.start + c(0, 0, comm.rank()*my.dim[3])

## Read data from original binary files
size <- 4 # file is single precision floats
filex <- "/lustre/atlas/proj-shared/stf006/d7r/inv_cascade/rot_abc_2048_kf50/outs/vx.061.out"
    
vx <- block3d.read(filex, data.dim, my.start, my.dim, size)

save.file <- paste("xyz.RData", comm.rank(), sep="")
save(vx, file=save.file)

## make a ddmatrix from local data
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

finalize()
        
        
