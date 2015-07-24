### Random Forests Classification
library(randomForest, quiet=TRUE)
library(MASS, quiet=TRUE)
library(pbdMPI, quiet=TRUE)

init()

data(fgl) # Forensic Glass Data 214 x 10
comm.set.seed(seed=1234567, diff=TRUE)

## train random forest - parallel
nt <- floor(4000/comm.size())
rf <- randomForest(type ~ ., fgl, mtry=2, ntree=nt, norm.votes=FALSE)

## combine forests - communicate
rf.each <- allgather(rf)
rf.all <- do.call(combine, rf.each)

## classify "new data" - parallel
my.rows <- get.jid(nrow(fgl))
predict(rf.all, fgl[my.rows, ])

finalize()
