# PlotObservations.R
#
# Script to plot observations

# start with some histograms of the data; let's see what we have.
# hub-height wind speed
d <- ggplot(data=Data) +
  geom_histogram(aes(x=WS_HH),binwidth=1) +
  labs(x=expression(paste('Wind Speed (m ',s^{-1},')'))) + 
  labs(y='Count') +
  labs(title = 'Hub-height wind speed')
print(d)
ggsave(filename=file.path(mainDir,subDir,'figures','WS_Histogram.png'),
       width = 3, height =2, units =c("in"), dpi =300  )

# shear
d <- ggplot(data=Data) +
  geom_histogram(aes(x=Shear),binwidth=0.05) +
  labs(x=expression(paste('Shear (-)'))) + 
  labs(y='Count') +
  labs(title = 'Shear')
print(d)
ggsave(filename=file.path(mainDir,subDir,'figures','shear_Histogram.png'),
       width = 3, height =2, units =c("in"), dpi =300  )


# turbulence intensity scatter plot
# get the IEC level
source(file=file.path(mainDir,"functions","IEC61400_turbulence.R"))
UBinMid = seq(4.25,25.25,by=0.5)
TiBinA = IEC61400_turbulence(UBinMid,'a')
TiBinB = IEC61400_turbulence(UBinMid,'b')
IEC61400 <- data.frame(UBinMid,TiBinA,TiBinB)

d <- ggplot() +
  geom_point(data=Data,aes(x=WS_HH,y=Ti_HH)) +
  geom_line(data=IEC61400,aes(x=UBinMid,y=TiBinA,group='a'),color='red') +
  geom_line(data=IEC61400,aes(x=UBinMid,y=TiBinB,group='b'),color='blue') +
  labs(x=expression(paste('Wind Speed (m ',s^{-1},')'))) + 
  labs(y='Ti (%)') +
  labs(title = 'Turbulence Intensity')
print(d)
ggsave(filename=file.path(mainDir,subDir,'figures','Ti_ScatterPlot.png'),
       width = 3, height =2, units =c("in"), dpi =300  )


# turbulence intensity boxplot
# define the summary function using the example at 
# http://stackoverflow.com/questions/4765482/changing-whisker-definition-in-geom-boxplot
f <- function(x) {
  r <- quantile(x, probs = c(0.05, 0.25, 0.5, 0.75, 0.95))
  names(r) <- c("ymin", "lower", "middle", "upper", "ymax")
  r
}
# define outliers
o <- function(x) {
  subset(x, x < quantile(x,probs = c(0.05, 0.95)[1]) | quantile(x,probs = c(0.05, 0.95)[2]) < x)
}

d <- ggplot(data=Data,aes(x = cut(WS_HH,
                                  breaks=seq(0.25,25.25,by=0.5),
                                  labels = seq(0.5,25,by=0.5)),
                          y=Ti_HH)) +
  stat_summary(fun.data = f, geom="boxplot") +
  stat_summary(fun.y = o, geom="point") + 
  labs(x=expression(paste('Wind Speed (m ',s^{-1},')'))) + 
  labs(y='Ti (%)') +
  labs(title = 'Turbulence Intensity')
print(d)
ggsave(filename=file.path(mainDir,subDir,'figures','WS_Ti_Boxplot.png'),
       width = 3, height =2, units =c("in"), dpi =300  )

# compare the rotor-equivalent and hub-height wind speeds
d <- ggplot(data = Data) +
  geom_point(aes(x=RSS,y = WS_Eq/WS_HH), color = 'blue',
             alpha=1/2) + 
  labs(y = expression(paste(U[eq]/ U[H]))) + 
  labs(x = expression(paste('RSS (',m^2,' ',s^{-2},')'))) +
  labs(title = 'Quality of Power Law Fit')
print(d)
ggsave(filename=file.path(mainDir,subDir,'figures','RS_WSRatio_Scatter.png'),
       width = 3, height =2, units =c("in"), dpi =300  )


# plot a quick power curve, cutting the turbulence intensity in 2% bins
d <- ggplot(data=Data) + 
  geom_point(aes(x=WS_HH,y=Power_mean, 
                 color = cut(Data$Ti_HH,
                             breaks = seq(0,50,by=2),
                             labels = paste(seq(0,48,by=2),' - ', seq(2,50,by=2)),
                             right=TRUE)),shape =19,alpha=1/2) +
  labs(colour = "Ti (%)") +
  labs(x=expression(paste('Wind Speed (m ',s^{-1},')'))) + 
  labs(y='Power (kW)')
print(d)
ggsave(filename=file.path(mainDir,subDir,'figures','WS_Power_ColoredByTi.png'),
       width = 6, height =4, units =c("in"), dpi =300  )
