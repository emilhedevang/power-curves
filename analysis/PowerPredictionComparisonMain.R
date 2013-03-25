# Script to analyze data from FAST and TurbSIM simuations and produce graphics

# clear the current workspace and start from scratch
rm(list=ls())

# define working directory
mainDir <- "~/Documents/projects/PowerSpaces_local/prestudy/papers/method_comparison/data"
# define the data file that we will read in
TurbineName <- "WindPACT1500kW" # we will look for this directory in mainDir
TurbineFile <- "WindPACT1500kW.txt"
ObservationsFile <- "PowerSpacesII.csv" # we will look for this directory in mainDir/TurbineName

# END OF VARIABLES
# ----------------
# START OF ANALYSIS
# prepare the work space
source(file.path(mainDir,"scripts","LoadPackages.R"))
source(file.path(mainDir,"scripts","PrepareDirectories.R"))
# load the information about the turbine
source(file.path(mainDir,"scripts","LoadTurbineFile.R"))
# load the observations data and generate some plots showing the observations
source(file.path(mainDir,"scripts","LoadObservations.R"))
source(file.path(mainDir,"functions","theme_publish.R"))
source(file.path(mainDir,"scripts","PlotObservations.R"))

# Create models of the existing observation set to define a model that might be
# used later for predictions
# divide data in to training and testing data
source(file.path(mainDir,"scripts","SplitObservationsTrainingTesting.R"))
# create a machine learning model of the turbine data
source(file.path(mainDir,"scripts","TrainRegressionTree.R"))
# TO DO: create a power curve model of the turbine data

# TO DO: create a model of the turbine data using Emil's method

# TO DO: test the different models using the testing data set

# TO DO: compare model dispersion with observed dispersion

# OPTIONAL
# Import data that give forcing conditions for which we have no power data 
# (i.e. blind prediction)