### Random Forest Classification for Letter Recognition - serial
suppressPackageStartupMessages(library(randomForest))
suppressPackageStartupMessages(library(mlbench))

## To use on your data, replace with parallel read of data!
data(LetterRecognition) # 26 Capital Letters Data 20,000 x 17
set.seed(seed=1234567)
n <- nrow(LetterRecognition)
## get same train data
n_train <- floor(0.8*n)
i_train <- sample.int(n, n_train) # Use 1/4 of the data to train
train <- LetterRecognition[i_train, ]
test <- LetterRecognition[-i_train, ]

## train random forest - parallel
my.k <- 500
rf.all <- randomForest(lettr ~ ., train, ntree=my.k, norm.votes=FALSE)

## predict test data - parallel
pred <- predict(rf.all, test)
correct <- sum(pred == test$lettr)
cat("Proportion Correct:", correct/(n - n_train), "\n")
