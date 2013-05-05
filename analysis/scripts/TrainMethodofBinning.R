# Train the method of binning to get a power curve----
## create a function that will give the power curve
IECBinning <- function(x, ...) UseMethod("IECBinning")

IECBinning.default <- function(ws, power){
  DataBinned <- IEC61400BinByWindSpeed(ws = ws,
                                       y = power)
  
  # now create the power curve
  ws.mean <- DataBinned$ws.mean
  power.mean <- DataBinned$y.mean
  power.sdev <- DataBinned$y.sdev
  
  # Create the model
  model <- data.frame(ws.mean,
                      power.mean,
                      power.sdev)   
  
  # return the model
  return(model)
}

# now create a function to predict the power based on a wind speed observation
predict.IECBinning <- function(Object, xout, newdata = NULL, ...){
  if(is.null(newdata)){
    P_pred <- approx(x = Object$ws.mean,
                     y = Object$power.mean,
                     xout = xout,
                     method = "constant",
                     yleft = 0,
                     yright = NA,
                     ties = min)
    rho_pred <- approx(x = Object$ws.mean,
                       y = Object$power.sdev,
                       xout = xout,
                       method = "constant",
                       yleft = NA,
                       yright = NA,
                       ties = min)
  }
  list(power.mean.predicted = P_pred$y,
       power.sdev.predicted = rho_pred$y) 
}

print.IECBinning <- function(x, ...){
  cat("Call:\n")
  print(x$call)
  cat("\nModel:\n")
  print(x$model)
}

# Train the power curve ----
model.IECbinning <- IECBinning.default(ws = observations.train$ws.eq,
                                       power = observations.train$power.mean.observed)
# set a switch to say we did it
projectdata.switches$TrainedBinnedPowerCurve <- TRUE

# Plot the power curve ----
## plot the trained power curve together with the observed data
d <- ggplot() +
  geom_line(data = IECBinning(observations.train$ws.eq,
                              observations.train$power.mean.observed),
            aes(x = ws.mean,
                y = power.mean,            
                color = "Method of Binning")) + 
  geom_point(data = observations.train,
             aes(x = ws.eq,
                 y = power.mean.observed,
                 color = "Observations"),
             size =1,
             alpha=0.5) +
  scale_colour_manual(name = "Power", 
                      values = c("Method of Binning" = 'black',
                                 "Observations" = 'blue')) + 
  labs(x = expression(paste('Wind Speed (m ',s^{-1},')'))) +
  labs(y = 'Power (kW)') + 
  labs(title = 'Power curve derived using different methods')
# check to see if there was a reference power curve
if (projectdata.switches$turbine.design.powercurve == TRUE){
  d <- d + geom_line(data = turbine.design.powercurve,
                     aes(x = ws, 
                         y = power.mean),
                     coclor = "Reference")
  + scale_colour_manual(name = "Power", 
                        values = c("Method of Binning" = 'black',
                                   "Observations" = 'blue',
                                   "Reference" = 'red'))  
}
print(d)
ggsave(filename = file.path(projectfiles.locations$FigureDir,
                            'TrainedBinnedPowerCurve.png'),
       width = 6, height = 3, units = c("in"), dpi = 300 )

# tidy up, leaving only the things we actually want
rm(d)