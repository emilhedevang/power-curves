# test the prediction of power using various methods

# get our testing data
tmp.test <- Obs.test

# predict power output with different methods
# 1. IEC method of binning
tmp.test <- cbind(tmp.test, 
                  predict.IECBinning(TurbineModel.IECBinning,tmp.test$WS_Eq))

# 2. Random Forest method
# Get the results for all trees so we can estimate the dispersion for each set 
# of inputs
rf <- predict(TurbineModel.CART,
              newdata = data.frame('WS_Eq' = Obs.test$WS_Eq,
                                   'Ti_HH' = Obs.test$Ti_HH,
                                   'Shear' = Obs.test$Shear,
                                   'TurbineOpRegion' = Obs.test$TurbineOpRegion),
              type= "response",
              predict.all=TRUE)
tmp.test$ML_P_pred <-apply(rf$individual,1,mean)
tmp.test$ML_rho_pred <- apply(rf$individual,1,sd)
# tidy up
rm(rf)

## plots
# plot the results
d1 <- ggplot(data=tmp.test) +
  geom_point(aes(x=Power_mean,y=MB_P_pred,color='Method of Binning')) +
  geom_point(aes(x=Power_mean,y=ML_P_pred,color='Machine Learning')) +
  scale_colour_manual(name="Method", 
                      values=c("Method of Binning"='black',
                               "Machine Learning"='grey')) +  
  labs(x='Observed power') +
  labs(y='Predicted power') + 
  labs(title='Turbine power') +
  theme_publish()
print(d1)

# just for a laugh, let's compare the errors
# plot actual error versus predicted
d2 <- ggplot(data=tmp.test) +
  geom_point(aes(x=MB_P_pred - Power_mean, 
                 y=MB_rho_pred,
                 color='Method of Binning')) +
  geom_point(aes(x=ML_P_pred - Power_mean, 
                 y=ML_rho_pred,
                 color='Machine Learning')) +
  scale_colour_manual(name="Method", 
                      values=c("Method of Binning"='black',
                               "Machine Learning"='grey')) +  
  labs(x='Actual error') +
  labs(y='Predicted standard deviation') + 
  labs(title='Prediction Errors') +
  theme_publish()
print(d2)

# and lets get our error metrics
# RMSE
cat('\nRMSE\n')
cat('Method of binning: ',sqrt(mean((tmp.test$MB_P_pred-tmp.test$Power_mean)^2,na.rm=TRUE)),'\n')
cat('Machine learning: ',sqrt(mean((tmp.test$ML_P_pred-tmp.test$Power_mean)^2)),'\n')
# MAE
cat('\nMAE\n')
cat('Method of binning: ',mean(abs(tmp.test$MB_P_pred-tmp.test$Power_mean),na.rm=TRUE),'\n')
cat('Machine learning: ',mean(abs(tmp.test$ML_P_pred-tmp.test$Power_mean)),'\n')
