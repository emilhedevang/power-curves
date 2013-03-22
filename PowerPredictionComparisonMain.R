# Script to analyze data from FAST and TurbSIM simuations and produce graphics

# clear the current workspace and start from scratch
rm(list=ls())

# define working directory
mainDir <- "~/Documents/projects/PowerSpaces_local/prestudy/papers/method_comparison/data"
# define the data file that we will read in
DataFile <- "PowerSpacesII.csv"
DataName <- "WindPACT1500kW"

### ---- END OF VARIABLES ---- ###

# load packages
library('ggplot2')
library('RColorBrewer')

# create a directory to host the figures etc that we will create
subDir <- DataName
dir.create(file.path(mainDir, subDir), showWarnings = FALSE)
dir.create(file.path(mainDir, subDir,'figures'), showWarnings = FALSE)
setwd(file.path(mainDir))

# read the data
Data <- read.csv(file=file.path(mainDir,DataFile),header=TRUE,sep=",")
Data$DataName <- DataName

# run the various scripts that produce our plots
source(file.path(mainDir,"scripts","PlotObservations.R"))