# script based on examples at http://www.statmethods.net/advstats/cart.html
# and http://stat-www.berkeley.edu/users/breiman/RandomForests/

# note that we installed the randomForest package in LoadPackages.R

# create the model from the data
# set a random seed so that we have repeatable results
set.seed(1)
# train the random forest model using the training data set 
TurbineModel.CART <- randomForest(x = data.frame('WS_Eq' = Obs.train$WS_Eq,
                                                 'Ti_HH' = Obs.train$Ti_HH,
                                                 'Shear' = Obs.train$Shear,
                                                 'TurbineOpRegion' = Obs.train$TurbineOpRegion),
                                  y = Obs.train$Power_mean,
                                  replace = TRUE,
                                  type = "regression",
                                  mtry = 2,
                                  ntree=100,
                                  importance=TRUE)
# The key to a successful model is to increase mtry to at least 2.
# the maximum value is the number of variables in the data set.
# otherwise only 1 variable is tried at each node (Duh). 
# The only problem with mtry = NROW(x) is that the model may be over-fitted.

print(TurbineModel.CART) # view results 
importance(TurbineModel.CART) # importance of each predictor

# look at how the model improves with number of trees
plot(TurbineModel.CART)
varImpPlot(TurbineModel.CART)