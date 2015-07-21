library(raster, quiet-TRUE)
library(ggplot2, quiet=TRUE)
library(sp, quiet=TRUE)
library(rlecuyer, quiet=TRUE)
library(pbdMPI, quiet=TRUE)
library(pbdSLAP, quiet=TRUE)
library(pbdBASE, quiet=TRUE)
library(pbdDMAT, quiet=TRUE)
init.grid()

x <- ddmatrix(comm.rank(), nrow=10, ncol=20)
comm.print(x@Data, all.rank=TRUE)
y <- ddmatrix(1:200, nrow=10, ncol=20)
comm.print(y@Data, all.rank=TRUE)
z <- as.ddmatrix(matrix(1:200, nrow=10, ncol=20))
comm.print(z@Data, all.rank=TRUE)

comm.print("next bunch:")
comm.print(x)
xx <- as.matrix(x)
comm.print(xx)
yy <- as.matrix(y)
comm.print(yy)
zz <- as.matrix(z)
comm.print(zz)

comm.print(class(x))
x <- pbdDMAT::as.matrix(x)

if(comm.rank() == 0)
{
    png("data_layoutR.png")
    image(x, useRaster=TRUE)
    dev.off()
    nr <- nrow(x)
    nc <- ncol(x)
    x <- data.frame(rasterToPoints(raster(x, xmn=0, xmx=nr - 1, ymn=0,
                                          ymx=nc - 1)))
    pw <- 480
    ph <- 480
    px_per_c <- pw/nc
    px_per_r <- ph/nr
    px_per <- min(px_per_c, px_per_r)

    names(x) <- c("row", "col", "rank")
    x$rank <- as.factor(x$rank)
    png("data_layout.png", width = nc * px_per, height = nr * px_per)
    print(
      ggplot(x, aes(col, row, fill=rank)) + geom_raster() +
       scale_fill_discrete()
         )
    dev.off()
}

finalize()
