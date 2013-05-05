# script based on examples at http://www.statmethods.net/advstats/cart.html
# and http://stat-www.berkeley.edu/users/breiman/RandomForests/

# note that we installed the randomForest package in LoadPackages.R

# create the model from the data
# set a random seed so that we have repeatable results
set.seed(1)
# train the random forest model using the training data set 
model.CART <- randomForest(x = data.frame('ws' = observations.train$ws.eq,
                                          'ti' = observations.train$ti.hh,
                                          'shear' = observations.train$shear,
                                          'turbine.operating.region' = 
                                            observations.train$turbine.operating.region),
                           y = observations.train$power.mean.observed,
                           replace = TRUE,
                           type = "regression",
                           mtry = 2,
                           ntree=100,
                           importance=TRUE)
# The key to a successful model is to increase mtry to at least 2.
# the maximum value is the number of variables in the data set.
# otherwise only 1 variable is tried at each node (Duh). 
# The only problem with mtry = NROW(x) is that the model may be over-fitted.
# set a switch to say we did it
projectdata.switches$TrainedCART <- TRUE

# look at how the model improves with number of trees
d <- ggplot(data = data.frame('trees' = seq(1, 100, by = 1),
                              'mse' = model.CART$mse),
            aes(x = trees,
                y = mse)) +
  geom_line() +
  labs(x = "trees") +
  labs(y = "Mean Square Error") + 
  labs(title = "Accuracy versus number of trees")
print(d)  
ggsave(filename = file.path(projectfiles.locations$FigureDir,
                            'CART_accuracy.png'),
       width = 6, height = 4, units = c("in"), dpi = 300 )

# find out how important each variable is
ImpData=data.frame(importance(model.CART))
ImpData$ID <- row.names(ImpData)
# plot a varImpPlot(model.CART)
d <- ggplot(data=ImpData,
            aes(x = ID,
                y = X.IncMSE)) + 
  geom_bar(position="dodge",stat="identity") + 
  labs(x = "Data") +
  labs(y = "Importance") + 
  labs(title = "Contribution of data to CART model")
print(d)  
ggsave(filename = file.path( projectfiles.locations$FigureDir,
                             'CART_contribution.png'),
       width = 6, height = 4, units = c("in"), dpi = 300 )

# tidy up
rm(ImpData, d)
