library(pbdMPI, quiet=TRUE)
init()

comm.set.seed(diff=T)

test <- function(timed)
{
  ltime <- system.time(timed)[3]
  
  mintime <- allreduce(ltime, op='min')
  maxtime <- allreduce(ltime, op='max')
  meantime <- allreduce(ltime, op='sum')/comm.size()

  return(data.frame(min=mintime, mean=meantime, max=maxtime))
}

times <- test(rnorm(1e6)) # ~7.6MiB of data
comm.print(times)

finalize()
