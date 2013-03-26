# create a function that will give the power curve
IECBinning <- function(x, ...) UseMethod("IECBinning")

IECBinning.default <- function(WS,P,UBinEdges)
{
  ## Calculate average power per wind speed bin and turn it into a table
  # deal with inputs
  WS <- as.numeric(WS)
  P <- as.numeric(P)
  UBinEdges <- as.numeric(UBinEdges)  
  
  # create bin labels that are the means of the bin edges
  UBinLabels <- rep(NA, NROW(UBinEdges)-1)
  for(UBinEdgei in seq(1,NROW(UBinEdges)-1,by=1))
  {
    UBinLabels[UBinEdgei] = (UBinEdges[UBinEdgei] + UBinEdges[UBinEdgei+1]) /2
  }
  # Allocate the observed wind speed into bins
  WSBinned=cut(WS, breaks=UBinEdges, labels=UBinLabels )
  
  # now create the power curve
  BinLowerWS <- rep(NA, NROW(UBinEdges)-1)
  BinCenterWS <- BinLowerWS
  BinUpperWS <- BinLowerWS
  PowerMean <- BinLowerWS
  PowerSd <- BinLowerWS
  
  for(UBinEdgei in seq(1,NROW(UBinEdges)-1,by=1))
  {
    BinLowerWS[UBinEdgei] = UBinEdges[UBinEdgei]    
    BinCenterWS[UBinEdgei] = (UBinEdges[UBinEdgei] + UBinEdges[UBinEdgei+1]) /2
    BinUpperWS[UBinEdgei] = UBinEdges[UBinEdgei+1]    
    PowerMean[UBinEdgei] = mean(P[WSBinned == UBinLabels[UBinEdgei]],
                                na.rm=TRUE)
    PowerSd[UBinEdgei] = sd(P[WSBinned == UBinLabels[UBinEdgei]],
                            na.rm=TRUE)
  }
  PowerMean[is.nan(PowerMean)]=NA
  PowerSd[is.nan(PowerSd)]=NA
  
  # Gather the data that we used to train the model
  data <- data.frame(WS,P)
  # Create the model
  model <- data.frame(BinLowerWS,BinCenterWS,BinUpperWS,PowerMean,PowerSd)      
  # store the call
  call <- match.call()
  # return the data and model
  list(model=model,data=data,call=call)
}

# now create a function to predict the power based on a wind speed observation
predict.IECBinning <- function(Object, xout, newdata=NULL, ...)
{
  if(is.null(newdata))
  {
    P_pred <- approx(x = Object$model$BinCenterWS,
                y = Object$model$PowerMean,
                xout = xout,
                method = "constant",
                yleft = 0,
                yright = NA,
                ties = min)
    rho_pred <- approx(x = Object$model$BinCenterWS,
                     y = Object$model$PowerSd,
                     xout = xout,
                     method = "constant",
                     yleft = NA,
                     yright = NA,
                     ties = min)
  }
  list(MB_P_pred=P_pred$y,MB_rho_pred=rho_pred$y)  
}

print.IECBinning <- function(x, ...)
{
  cat("Call:\n")
  print(x$call)
  cat("\nModel:\n")
  print(x$model)
}

# create wind speed bins
UBinEdges <- seq(0.25,25.25,by=0.5)
# create our model
TurbineModel.IECBinning <- IECBinning(Obs.train$WS_Eq,
                                      Obs.train$Power_mean,
                                      UBinEdges)

# and plot the trained power curve together with the observed data
d <- ggplot(data=Obs.train,aes(x=WS_Eq,y=Power_mean)) +
  geom_step(data=TurbineModel.IECBinning$model,
            aes(x=BinLowerWS,y=PowerMean,color = 'Method of Binning'),
            size=2) + 
  geom_point(aes(color='Observations')) +
  scale_colour_manual(name="Power", 
                      values=c("Method of Binning"='black',
                               "Observations"='grey')) +  
  labs(x=expression(paste('Wind Speed (m ',s^{-1},')'))) +
  labs(y='Power (kW)') + 
  theme_publish()
print(d)

# tidy up, leaving only the things we actually want
rm(d,UBinEdges)