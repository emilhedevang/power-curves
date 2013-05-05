# Script SplitObservationsTrainingTesting.R

# randomly sample the entire input observations data set and divide into
# training and test data. 
# The training data are 50% of the entire observations dataset.
sub <- sample(nrow(observations.all), 
              floor(nrow(observations.all) * 0.5))
observations.train <- observations.all[sub, ]
observations.test <- observations.all[-sub, ]

# tidy up, leaving only the things we actually want
rm(sub)