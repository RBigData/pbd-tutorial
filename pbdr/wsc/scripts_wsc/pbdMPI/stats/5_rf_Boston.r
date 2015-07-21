### Random Forest Regression Prediction
library(randomForest, quiet=TRUE)
library(MASS, quiet=TRUE)
library(pbdMPI, quiet=TRUE)

init()

data(Boston) # Boston Housing Data 506 x 14
Boston <- rbind(Boston, Boston, Boston, Boston)
comm.set.seed(seed=1234567, diff=TRUE)

## train random forest - parallel
my.n <- floor(4000/comm.size())
my.rf <- randomForest(medv ~ ., Boston, mtry=2, ntree=my.n, norm.votes=FALSE)

## combine forests - communicate
rf.each <- allgather(my.rf)
rf.all <- do.call(combine, rf.each)

## predict "new data" - parallel
my.rows <- get.jid(nrow(fgl))
predict(rf.all, Boston[my.rows, ])

finalize()
