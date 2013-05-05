# File locations ----

## import locations etc from main file into a single structure for tidyness
# create a directory to host the figures etc that we will create
projectfiles.locations <- data.frame(mainDir = mainDir)
# note that our structure is assumed to be mainDir/<TurbineName>/<site>
projectfiles.locations$TurbineDir <- file.path(projectfiles.locations$mainDir, 
                                TurbineName)
projectfiles.locations$SiteName <- sub("\\.[^.]*$", "", ObservationsFile)
projectfiles.locations$SiteDir <- file.path(projectfiles.locations$mainDir, 
                             TurbineName, 
                             projectfiles.locations$SiteName)


# Create directories ----
# define some directories to store figures and models in
projectfiles.locations$FigureDir <- file.path(projectfiles.locations$SiteDir, 'figures')
projectfiles.locations$ModelDir <- file.path(projectfiles.locations$SiteDir, 'models')

# create the directories
dir.create(projectfiles.locations$FigureDir,
           showWarnings = FALSE)
dir.create(projectfiles.locations$ModelDir,
           showWarnings = FALSE)

# and set our working directorys
setwd(file.path(projectfiles.locations$mainDir))