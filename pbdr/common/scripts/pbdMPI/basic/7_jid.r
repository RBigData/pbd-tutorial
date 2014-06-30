library(pbdMPI, quiet=TRUE)
init()
k <- get.jid(10)
my.rank <- comm.rank()
comm.cat(my.rank, ":", k, "\n", all.rank=TRUE)

finalize()
