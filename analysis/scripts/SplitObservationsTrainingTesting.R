# Script SplitObservationsTrainingTesting.R

# randomly sample the entire input observations data set and divide into
# training and test data. 
# The training data are 80% of the entire observations dataset.
sub <- sample(nrow(Obs), floor(nrow(Obs) * 0.8))
Obs.train <- Obs[sub, ]
Obs.test <- Obs[-sub, ]