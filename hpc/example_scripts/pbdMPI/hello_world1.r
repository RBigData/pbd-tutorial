library(pbdMPI, quiet=TRUE)
init()

my.rank <- comm.rank()

if (my.rank == 0){
  print( "Hello, world.")
}

finalize()
