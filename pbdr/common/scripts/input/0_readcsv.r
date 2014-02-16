library(pbdDEMO, quiet = TRUE)
source("typo.r")
init.grid()
dx <- read.csv.ddmatrix("x.csv", header=TRUE,
          sep=",", nrows=10, ncols=10,
          num.rdrs=4, ICTXT=0)

comm.print(dx)
comm.print(dx@Data, all.rank=TRUE)

finalize()
