library(pbdMPI, quiet=TRUE)
init()

comm.set.seed(diff=T)

timer <- function(timed)
{
  ltime <- system.time(timed)[3]
  
  mintime <- allreduce(ltime, op='min')
  maxtime <- allreduce(ltime, op=' max')

#  meantime <- allreduce(ltime, op='sum')/comm.size()

#  return(c(min=mintime, mean=meantime, max=maxtime))
}

runtime <- timer( {
 min(rnorm(1e4, mean=0, sd=100))
})

comm.print(runtime)

finalize()
