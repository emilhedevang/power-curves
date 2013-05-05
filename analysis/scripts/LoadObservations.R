
# list the variables that we are looking for and what we will rename them to
variables.in.list = c("WS_HH",
                      "Ti_HH",
                      "Shear",
                      "WS_Eq",
                      "RSS",
                      "Power_mean",
                      "Power_std")
variables.in.names = c("hub-height wind speed",
                       "hub-height turbulence intensity",
                       "shear",
                       "rotor-equivalent wind speed",
                       "accuracy of power-law fit",
                       "mean power",
                       "standard deviation of power")
variables.out.list = c("ws.hh",
                       "ti.hh",
                       "shear",
                       "ws.eq",
                       "ws.eq.rss",
                       "power.mean.observed",
                       "power.sdev.observed")

# read the observation data
observations.in <- read.csv(file = file.path(projectfiles.locations$TurbineDir,
                                              ObservationsFile),
                             header = TRUE, 
                             sep = ",")
# map the variables to their new names
observations.all <- data.frame(temp=observations.in[,1])
for (Vari in seq(1,NROW(variables.in.list),by=1)){
  eval(parse(text=paste("observations.all$", 
       variables.out.list[[Vari]],
  " <- observations.in$",
       variables.in.list[[Vari]],
             sep="")))
}
# remove the temp column that we used to initialise this data frame
observations.all<- observations.all[,!(colnames(observations.all) %in% c("temp"))]

# and print results to screen
cat(paste("Checking data in ", 
          file.path(projectfiles.locations$TurbineDir,
                    ObservationsFile),
          " \n",
          sep=""))
for (Vari in seq(1,NROW(variables.in.list),by=1)){
  if(variables.in.list[Vari] %in% colnames(observations.in)){
    cat(paste("...Found ",
              variables.in.names[Vari],
              " (",
              variables.in.list[Vari],
              ")\n",
              sep=""));
  }
  else {
    cat(paste("...ERORR: did not find column ", 
              variables.in.names[Vari],
              ", (",
              variables.in.list[Vari],
              ")\n",
              sep=""));
  }
}

# Finally get the operating region
observations.all$turbine.operating.region <- as.factor(as.numeric(observations.all$ws.eq > 
                                                           turbine.design.data$RatedWindSpeed) + 1)

# tidy up, leaving only the things we actually want
rm(Vari, variables.in.list, variables.in.names)