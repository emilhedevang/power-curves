# read the turbine design information
x <- read.table(file.path(mainDir,TurbineName,TurbineFile), 
                header=FALSE, row.names=1, sep ="=")
TurbineDesign <- as.data.frame(t(x), row.names=TurbineName)

# tidy up, leaving only the things we actually want
rm(x)