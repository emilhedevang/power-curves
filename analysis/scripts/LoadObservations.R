# read the observation data
Obs <- read.csv(file=file.path(mainDir,TurbineName,ObservationsFile),header=TRUE,sep=",")
Obs$SiteName <- SiteDir
