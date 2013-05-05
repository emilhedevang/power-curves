# Script to analyze data from FAST and TurbSIM simuations and produce graphics

# PEAMBLE ----
# clear the current workspace and start from scratch
rm(list=ls())

# USER VARIABLES ----
# define working directory
mainDir <- "~/Documents/projects/PowerSpaces_local/Collaborations/Aarhus/method_comparison/data"
# define the data file that we will read in
TurbineName <- "WindPACT1500kW" # we will look for this directory in mainDir
TurbineFile <- "WindPACT1500kW.txt"  # contains details of the turbine geometry
# the following files should be placed in mainDir/TurbineName
TurbinePowerCurve <- ""  # contains the reference power curve (empty if non defined)
ObservationsFile <- "PowerSpacesII.csv" # contains site observations of inflow and power
TestFile <- ""  # the name of the inflow data which we test our new model with 

# end of variables


# ANALYSIS ----
## prepare the work space
source(file.path(mainDir, "scripts", "LoadPackages.R"))
source(file.path(mainDir, "scripts", "PrepareDirectories.R"))
source(file.path(mainDir, "scripts", "PrepareWorkspace.R"))
# prepare graphics
theme_set(theme_gray(base_size = 10))
# load functions that we will need
source(file.path(mainDir, "functions", "IEC61400BinByWindSpeed.R"))
source(file.path(mainDir, "functions", "IEC61400TurbulenceIntensity.R"))

# load the information about the turbine
source(file.path(mainDir, "scripts", "LoadTurbineFile.R"))
# load the observations data and generate some plots showing the observations
source(file.path(mainDir, "scripts", "LoadObservations.R"))
source(file.path(mainDir, "scripts", "PlotObservations.R"))

# Create models of the existing observation set to define a model that might be
# used later for predictions
# divide data in to training and testing data
source(file.path(mainDir, "scripts", "SplitObservationsTrainingTesting.R"))
# create a machine learning model of the turbine data
source(file.path(mainDir, "scripts", "TrainRegressionTree.R"))
# create a power curve model of the turbine data
source(file.path(mainDir, "scripts", "TrainMethodofBinning.R"))

# TO DO: create a model of the turbine data using Emil's method

# test the models
source(file.path(mainDir, "scripts", "TestMethods.R"))

# TO DO: compare model dispersion with observed dispersion

# OPTIONAL
# Import data that give forcing conditions for which we have no power data 
# (i.e. blind prediction)