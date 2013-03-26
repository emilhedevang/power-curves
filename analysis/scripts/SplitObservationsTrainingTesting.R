# Script SplitObservationsTrainingTesting.R

# randomly sample the entire input observations data set and divide into
# training and test data. 
# The training data are 50% of the entire observations dataset.
sub <- sample(nrow(Obs), floor(nrow(Obs) * 0.5))
Obs.train <- Obs[sub, ]
Obs.test <- Obs[-sub, ]

# tidy up, leaving only the things we actually want
rm(sub)