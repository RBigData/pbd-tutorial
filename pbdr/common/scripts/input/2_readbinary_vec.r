## Binary reading in parallel example

library(pbdMPI, quiet=TRUE)
init()

## set up start and length for reading a vector of doubles
size <- 8 # bytes
n <- 32

my_ids <- get.jid(n, method="block")
comm.print(my_ids, "\n", all.rank=TRUE)

my_start <- (my_ids[1] - 1)*size
my_length <- length(my_ids) # contiguous ids
comm.cat("my_start", my_start, "my_length", my_length, "\n",
         all.rank=TRUE)

con <- file("binary.vector.file", "rb")
seekval <- seek(con, where=my_start, rw="read")
x <- readBin(con, what="double", n=my_length, size=size)
comm.print(x, all.rank=TRUE)

finalize()
