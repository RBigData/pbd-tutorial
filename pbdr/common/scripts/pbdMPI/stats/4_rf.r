suppressPackageStartupMessages(library(randomForest))
suppressPackageStartupMessages(library(mlbench))
data(LetterRecognition)

suppressPackageStartupMessages(library(pbdMPI))
init()
comm.set.seed(seed=123, diff=FALSE)
n <- nrow(LetterRecognition)
n_test <- floor(0.2*n)
i_test <- sample.int(n, n_test)
train <- LetterRecognition[-i_test, ]
test <- LetterRecognition[i_test, ][get.jid(n_test), ]

comm.set.seed(seed=1e6*runif(1), diff=TRUE)
my.rf <- randomForest(lettr ~ ., train, ntree=500 %/% comm.size(), norm.votes=FALSE)
rf.all <- do.call(combine, allgather(my.rf))

pred <- predict(rf.all, test)
correct <- reduce(sum(pred == test$lettr))
comm.cat("Proportion Correct:", correct/(n_test), "\n")
finalize()
