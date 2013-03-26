# script based on examples at http://www.statmethods.net/advstats/cart.html
# and http://stat-www.berkeley.edu/users/breiman/RandomForests/

# note that we installed the randomForest package in LoadPackages.R

# create the model from the data
# set a random seed so that we have repeatable results
set.seed(1)
# train the random forest model using the training data set
TurbineModel.CART <- randomForest(Power_mean ~ WS_Eq + Ti_HH + Shear + TurbineOpRegion,
                                  data = Obs.train,
                                  replace = TRUE,
                                  ntree=100,
                                  importance=TRUE)
print(TurbineModel.CART) # view results 
importance(TurbineModel.CART) # importance of each predictor

# look at how the model improves with number of trees
plot(TurbineModel.CART)
varImpPlot(TurbineModel.CART)