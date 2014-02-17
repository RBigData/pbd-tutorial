library(pbdMPI, quiet = TRUE)
init()

comm.set.seed(seed=1234567, diff=TRUE)

n <- sample(1:10, size=1)

gt <- gather(n)
comm.print(unlist(gt))

sm <- allreduce(n, op='sum')
comm.print(sm, all.rank=T)

finalize()
