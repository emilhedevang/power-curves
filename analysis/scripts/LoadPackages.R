# define a function to use to check for a package
is.installed <- function(mypkg) is.element(mypkg, installed.packages()[,1]) 

# load packages
# ggplot2 is required for graphics
if (!is.installed('ggplot2'))
{
  install.packages('ggplot2')
}
library('ggplot2')

# ColorBrewer, required for plots
if (!is.installed('RColorBrewer'))
{
  install.packages('RColorBrewer')
}
library('RColorBrewer')

# randomForest, required for regression tree method
if (!is.installed('randomForest'))
{
  install.packages('randomForest')
}
library('randomForest')


