library(pbdMPI, quiet = TRUE)
init()

.SPMD.CT$msg.barrier <- TRUE
.SPMD.CT$print.quiet <- TRUE

for (rank in 1:comm.size()-1){
  if (comm.rank() == rank){
    cat(paste("Hello", rank+1, "of", comm.size(), "\n"))
  }
  barrier()
}

comm.cat("\n")

comm.cat(paste("Hello", comm.rank()+1, "of", comm.size(), "\n"), all.rank=TRUE)

finalize()
