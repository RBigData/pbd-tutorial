library(pbdMPI, quiet = TRUE)
init()

.SPMD.CT$msg.barrier <- TRUE
.SPMD.CT$print.quiet <- TRUE

for (rank in 1:comm.size() - 1){
  if (comm.rank() == rank){
    cat(paste("HelloA", rank+1, "of", comm.size(), "\n"))
  }
  barrier()
}

comm.cat("newline\n")

comm.cat(paste("HelloB", comm.rank()+1, "of", comm.size(), "\n"), all.rank=TRUE)

finalize()
