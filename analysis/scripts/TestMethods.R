# test the prediction of power using various methods

# get our testing data
tmp.test <- observations.test
# and create lists to dump colours into
tmp.datasets <- list()
tmp.colors <- list()

# predict power output with different methods ----
## 1. IEC method of binning
if (projectdata.switches$TrainedBinnedPowerCurve){
  # Get the results for all observations
  prediction.IECbinning <- cbind(tmp.test, 
                               predict.IECBinning(model.IECbinning,
                                                  'xout'=tmp.test$ws.eq))
  
  # save some information about this data
  tmp.datasets <- c(tmp.datasets, "Method of Binning" = "prediction.IECbinning")
  tmp.colors <- c(tmp.colors, "Method of Binning" = "black")
}

# 2. Random Forest method
if (projectdata.switches$TrainedCART){
  # Get the results for all trees so we can estimate the dispersion for each set 
  # of inputs  
  newdata = data.frame('ws' = observations.test$ws.eq,
                       'ti' = observations.test$ti.hh,
                       'shear' = observations.test$shear,
                       'turbine.operating.region' = 
                         observations.test$turbine.operating.region)
  rf <- predict(model.CART,
                newdata=newdata,
                type = "response",
                predict.all = TRUE)
  # get the data
  prediction.CART <- tmp.test
  prediction.CART$power.mean.predicted <-apply(rf$individual, 1, mean)
  prediction.CART$power.sdev.predicted <- apply(rf$individual, 1, sd)
  
  # save some information about this data
  tmp.datasets <- c(tmp.datasets, "Method Learning" = "prediction.CART")
  tmp.colors <- c(tmp.colors,"Machine Learning" = "blue")
  # tidy up
  rm(rf)
}

# figure out what data actually arrived after all that
colors <- as.character(tmp.colors,"names" = names(tmp.colors))
names(colors) <- names(tmp.colors)

# Results ----

## Compare the power curves from the methods
d1 <- ggplot() + 
  geom_point(data = prediction.IECbinning,
             aes(x = ws.eq,
                 y = power.mean.predicted,
                 color="Method of Binning")) +
  geom_point(data = prediction.CART,
             aes(x = ws.eq,
                 y = power.mean.predicted,
                 color="Machine Learning")) +
  scale_colour_manual(name="Method", 
                      values=colors) +  
  labs(x ='Wind Speed') + 
  labs(y ='Predicted power') +  
  labs(title='Turbine power curve')
print(d1)

## Compare the power predicted using the methods we have
d1 <- ggplot(data = NULL) +
  geom_point(data=prediction.IECbinning,
             aes(x=power.mean.predicted,
                 y=power.mean.observed,
                 color='Method of Binning')) +
  geom_point(data=prediction.CART,
             aes(x=power.mean.predicted,
                 y=power.mean.observed,
                 color='Machine Learning')) +
  scale_colour_manual(name="Method", 
                      values=colors) +  
  labs(x ='Predicted power') + 
  labs(y ='Observed power') +  
  labs(title='Turbine power')
print(d1)

# Compare the errors ----
# plot actual error versus predicted
d2 <- ggplot(data = NULL) +
  geom_point(data=prediction.IECbinning,
             aes(x = power.sdev.predicted,
                 y = power.mean.predicted - power.mean.observed, 
                 color = 'Method of Binning')) +
  geom_point(data=prediction.CART,
             aes(x = power.sdev.predicted,
                 y = power.mean.predicted - power.mean.observed, 
                 color = 'Machine Learning')) +
  scale_colour_manual(name = "Method", 
                      values = colors) +  
  labs(x='Predicted standard deviation') + 
  labs(y='Actual error') +  
  labs(title='Prediction Errors')
print(d2)

# and lets get our error metrics
# RMSE
cat('\nRMSE\n')
cat('Method of binning: ',
    sqrt(mean((prediction.IECbinning$power.mean.predicted - 
                 prediction.IECbinning$power.mean.observed)^2,
              na.rm=TRUE)),
    '\n')
cat('Machine learning: ',
    sqrt(mean((prediction.CART$power.mean.predicted - 
                 prediction.CART$power.mean.observed)^2,
              na.rm=TRUE)),
    '\n')
# MAE
cat('\nMAE\n')
cat('Method of binning: ',mean(abs(prediction.IECbinning$power.mean.predicted - 
                                     prediction.IECbinning$power.mean.observed),
                               na.rm=TRUE),
    '\n')
cat('Machine learning: ',mean(abs(prediction.CART$power.mean.predicted - 
                                    prediction.CART$power.mean.observed),
                              na.rm=TRUE)
    ,'\n')
