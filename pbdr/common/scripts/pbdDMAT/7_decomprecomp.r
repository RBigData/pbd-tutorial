brary(pbdDMAT)
init.grid()


decomp_recomp <- function(x, exclude, center=TRUE, scale=FALSE)
{
  if (center || scale)
    x <- scale(x, center=center, scale=scale)
  
  svd <- La.svd(x)
  
  u <- svd$u
  d <- svd$d
  vt <- svd$vt
  
  sweep(u[, -exclude], MARGIN=2, FUN="*", STAT=d[-exclude]) %*% vt[-exclude, ]
}


dx <- ddmatrix("rnorm", 100, 10, bldim=c(2,2))
x <- as.matrix(dx)

dr_dx <- as.matrix(decomp_recomp(dx, 1))
dr_x <- decomp_recomp(x, 1)

comm.print(all.equal(dr_dx, dr_x))

finalize()
