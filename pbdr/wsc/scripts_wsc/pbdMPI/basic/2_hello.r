library(pbdMPI, quiet=TRUE)
init()

print("Hello, world")

comm.print("Hello, world too")

comm.print("Hello again", all.rank=TRUE, quiet=TRUE)

finalize()
