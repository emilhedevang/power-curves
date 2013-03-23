# create a directory to host the figures etc that we will create
TurbineDir <- TurbineName
SiteDir <- sub("\\.[^.]*$", "", ObservationsFile)
dir.create(file.path(mainDir, TurbineDir, SiteDir), showWarnings = FALSE)
# define some directories to store figures and models in
TurbineSiteFigureDir <-file.path(mainDir, TurbineDir, SiteDir, 'figures')
TurbineSiteModelDir <-file.path(mainDir, TurbineDir, SiteDir, 'models')
# create said directories
dir.create(TurbineSiteFigureDir, showWarnings = FALSE)
dir.create(TurbineSiteModelDir, showWarnings = FALSE)
# and set our working directorys
setwd(file.path(mainDir))