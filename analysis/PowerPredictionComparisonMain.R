# Script to analyze data from FAST and TurbSIM simuations and produce graphics

# clear the current workspace and start from scratch
rm(list=ls())

# define working directory
mainDir <- "~/Documents/projects/PowerSpaces_local/prestudy/papers/method_comparison/data"
# define the data file that we will read in
TurbineName <- "WindPACT1500kW" # we will look for this directory in mainDir
TurbineFile <- "WindPACT1500kW.txt"
ObservationsFile <- "PowerSpacesII.csv" # we will look for this directory in mainDir/TurbineName

### END OF VARIABLES ###
### START OF ANALYSIS ###
# prepare the work space
source(file.path(mainDir,"scripts","LoadPackages.R"))
source(file.path(mainDir,"scripts","PrepareDirectories.R"))
# load the information about the turbine
source(file.path(mainDir,"scripts","LoadTurbineFile.R"))
# load the observations data
source(file.path(mainDir,"scripts","LoadObservations.R"))
# run the analysis
source(file.path(mainDir,"functions","theme_publish.R"))
source(file.path(mainDir,"scripts","PlotObservations.R"))
# create a CART model of the turbine data
source(file.path(mainDir,"scripts","TrainRegressionTree.R"))