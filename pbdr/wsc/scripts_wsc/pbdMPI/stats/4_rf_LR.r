### Random Forest Classification for Letter Recognition
suppressPackageStartupMessages(library(randomForest))
suppressPackageStartupMessages(library(mlbench))
suppressPackageStartupMessages(library(pbdMPI))
init()

## To use on your data, replace with parallel read of data!
data(LetterRecognition) # 26 Capital Letters Data 20,000 x 17
comm.set.seed(seed=123, diff=FALSE) # everyone gets same training data
n <- nrow(LetterRecognition)
## get same train data
n_train <- floor(0.8*n)
i_train <- sample.int(n, n_train) # Use 4/5 of the data to train
train <- LetterRecognition[i_train, ]
## get different test data
my.test_rows <- get.jid(n - n_train)
test <- LetterRecognition[-i_train, ][my.test_rows, ]

## Now generate different RNs on each process
comm.set.seed(seed=1e6*runif(1), diff=TRUE)

## train random forest - parallel
my.k <- floor(500/comm.size())
my.rf <- randomForest(lettr ~ ., train, ntree=my.k, norm.votes=FALSE)

## combine forests - communicate
rf.each <- allgather(my.rf)
rf.all <- do.call(combine, rf.each)

## predict test data - parallel
pred <- predict(rf.all, test)
correct <- allreduce(sum(pred == test$lettr))
comm.cat("Proportion Correct:", correct/(n - n_train), "\n")

finalize()
