# read the observation data
Obs <- read.csv(file=file.path(mainDir,TurbineName,ObservationsFile),header=TRUE,sep=",")
Obs$SiteName <- SiteDir

# now check for the presence of the variables we need
VarList = c("WS_HH",
            "Ti_HH",
            "Shear",
            "WS_Eq",
            "RSS",
            "Power_mean",
            "Power_std")
VarLongName = c("hub-height wind speed",
                "hub-height turbulence intensity",
                "shear",
                "rotor-equivalent wind speed",
                "accuracy of power-law fit",
                "mean power",
                "standard deviation of power")

# and print results to screen
cat(paste("Checking data in ", file.path(TurbineName,ObservationsFile)," \n",sep=""))
for(Vari in seq(1,NROW(VarList),by=1))
{
  if(VarList[Vari] %in% colnames(Obs))
  {
    cat(paste("...Found ", VarLongName[Vari], " (", VarList[Vari], ")\n",sep=""));
  }
  else
  {
    cat(paste("...ERORR: did not find column ", VarLongName[Vari], ", (", VarList[Vari], ")\n",sep=""));
  }
}

# Finally get the operating region
Obs$TurbineOpRegion <- as.factor(as.numeric(Obs$WS_Eq > TurbineDesign$RatedWindSpeed) + 1)