# read the turbine design information
x <- read.table(file.path(projectfiles.locations$TurbineDir,
                          TurbineFile), 
                header=FALSE, row.names=1, sep ="=")
turbine.design.data <- as.data.frame(t(x), row.names=TurbineName)

# look for the power curve for this turbine that goes with this site
projectdata.switches$turbine.design.powercurve = FALSE
if (nchar(TurbinePowerCurve)>0)
{ # look to see if there is a power curve
  xinfo <- file.info(file.path(projectfiles.locations$TurbineDir,
                               TurbinePowerCurve)) 
  
  if (!(is.na(xinfo$size)))
  {x <- read.csv(file.path(projectfiles.locations$TurbineDir,
                           TurbinePowerCurve), 
                 header=TRUE, sep =",")
   turbine.design.powercurve <- x
   projectdata.switches$turbine.design.powercurve = TRUE
  } else {
    turbine.design.powercurve <- data.frame(WS=seq(0,25,by=1),
                                      power = NA*seq(0,25,by=1))  
  }
} else
{
  turbine.design.powercurve <- data.frame(WS=seq(0,25,by=1),
                                    power = NA*seq(0,25,by=1))  
}
# tidy up, leaving only the things we actually want
rm(x)