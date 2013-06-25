library(pbdMPI, quiet=TRUE)
init()

comm.set.seed(diff=TRUE)

n.spmd <- sample(1:10, size=1)

sm <- allreduce(n.spmd, op='sum')
comm.print(sm)

gt <- allgather(n.spmd)
comm.print(unlist(gt))

finalize()
