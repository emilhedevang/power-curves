# PlotObservations.R
#
# Script to plot observations

# to be safe, we'll move the input data into a new dataframe
Obs.temp <- Obs

# start with some histograms of the data; let's see what we have.
# hub-height wind speed
d <- ggplot(data=Obs.temp) +
  geom_histogram(aes(x=WS_HH),binwidth=1) +
  labs(x=expression(paste('Wind Speed (m ',s^{-1},')'))) + 
  labs(y='Count') +
  labs(title = 'Hub-height wind speed')
print(d)
ggsave(filename=file.path(TurbineSiteFigureDir,'WS_Histogram.png'),
       width = 3, height =2, units =c("in"), dpi =300  )

# shear
d <- ggplot(data=Obs.temp) +
  geom_histogram(aes(x=Shear),binwidth=0.05) +
  labs(x=expression(paste('Shear (-)'))) + 
  labs(y='Count') +
  labs(title = 'Shear')
print(d)
ggsave(filename=file.path(TurbineSiteFigureDir,'shear_Histogram.png'),
       width = 3, height =2, units =c("in"), dpi =300  )


# turbulence intensity scatter plot
# get the IEC level
source(file=file.path(mainDir,"functions","IEC61400_turbulence.R"))
UBinMid = seq(4.25,25.25,by=0.5)
TiBinA = IEC61400_turbulence(UBinMid,'a')
TiBinB = IEC61400_turbulence(UBinMid,'b')
IEC61400 <- data.frame(UBinMid,TiBinA,TiBinB)

d <- ggplot() +
  geom_point(data=Obs.temp,aes(x=WS_HH,y=Ti_HH)) +
  geom_line(data=IEC61400,aes(x=UBinMid,y=TiBinA,group='a'),color='red') +
  geom_line(data=IEC61400,aes(x=UBinMid,y=TiBinB,group='b'),color='blue') +
  labs(x=expression(paste('Wind Speed (m ',s^{-1},')'))) + 
  labs(y='Ti (%)') +
  labs(title = 'Turbulence Intensity')
print(d)
ggsave(filename=file.path(TurbineSiteFigureDir,'Ti_ScatterPlot.png'),
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

d <- ggplot(data=Obs.temp,aes(x = cut(WS_HH,
                                      breaks=seq(0.25,25.25,by=0.5),
                                      labels = seq(0.5,25,by=0.5)),
                              y=Ti_HH)) +
  stat_summary(fun.data = f, geom="boxplot") +
  stat_summary(fun.y = o, geom="point") + 
  labs(x=expression(paste('Wind Speed (m ',s^{-1},')'))) + 
  labs(y='Ti (%)') +
  labs(title = 'Turbulence Intensity')
print(d)
ggsave(filename=file.path(TurbineSiteFigureDir,'WS_Ti_Boxplot.png'),
       width = 3, height =2, units =c("in"), dpi =300  )

# compare the rotor-equivalent and hub-height wind speeds
d <- ggplot(data = Obs.temp) +
  geom_point(aes(x=RSS,y = WS_Eq/WS_HH), color = 'blue',
             alpha=1/2) + 
  labs(y = expression(paste(U[eq]/ U[H]))) + 
  labs(x = expression(paste('RSS (',m^2,' ',s^{-2},')'))) +
  labs(title = 'Quality of Power Law Fit')
print(d)
ggsave(filename=file.path(TurbineSiteFigureDir,'RS_WSRatio_Scatter.png'),
       width = 3, height =2, units =c("in"), dpi =300  )

# plot a quick power curve, cutting the turbulence intensity in 2% bins
d <- ggplot(data=Obs.temp) + 
  geom_point(aes(x=WS_HH,y=Power_mean, 
                 color = cut(Ti_HH,
                             breaks = seq(0,50,by=5),
                             labels = paste(seq(0,45,by=5),' - ', seq(5,50,by=5)),
                             right=TRUE)),shape =19,alpha=1/2,size=1) +  
  labs(colour = "Ti (%)") +
  labs(x=expression(paste('Wind Speed (m ',s^{-1},')'))) + 
  labs(y='Power (kW)') +
  theme_publish()
print(d)
ggsave(filename=file.path(TurbineSiteFigureDir,'WS_Power_ColoredByTi.png'),
       width = 6, height =4, units =c("in"), dpi =300  )

# The following plots generate e.g. median and standard deviation of power, Cp,
# versus shear and Ti. 

# Therefore we will define some common bin edges
Obs.temp$WS_HH_binned <- cut(Obs.temp$WS_HH,
                             breaks = seq(3,25,by=1),
                             labels = paste(seq(3,24,by=1),' - ',seq(4,25,by=1)),
                             right=TRUE)
AlphaBinEdges <- seq(-0.5, 0.5, by = 0.05)
TiBinEdges <- seq(0, 50, by = 2)

# plot the number of observations as a function of wind speed, shear and Ti
d<- ggplot(data=Obs.temp, aes(x=Shear,y=Ti_HH, z=Power_mean)) +
  stat_bin2d(breaks = list(x = AlphaBinEdges, 
                           y = TiBinEdges)) +
  facet_wrap( ~ WS_HH_binned, ncol=4) +
  scale_fill_gradientn(colours = brewer.pal(4,"YlOrRd"))+
  labs(fill = "Power (kW)") +
  labs(x='Shear (-)') + 
  labs(y='Ti (%)')  +
  theme_publish() +
  theme(axis.text.x = element_text(angle=45,vjust=1,hjust=1))
print(d)
ggsave(filename=file.path(TurbineSiteFigureDir,'Count_ByTiShearWSBin.png'),
       width = 6, height =8, units =c("in"), dpi =300  )

# plot the median power produced as a function of wind speed, shear and Ti
d<- ggplot(data=Obs.temp, aes(x=Shear,y=Ti_HH, z=Power_mean)) +
  stat_summary2d(fun=function(z) median(z,na.rm=TRUE),
                 breaks = list(x = AlphaBinEdges, 
                               y = TiBinEdges)) +
  facet_wrap( ~ WS_HH_binned, ncol=4) +
  scale_fill_gradientn(colours = brewer.pal(4,"YlOrRd"))+
  labs(fill = "Power (kW)") +
  labs(x='Shear (-)') + 
  labs(y='Ti (%)')  +
  theme_publish() +
  theme(axis.text.x = element_text(angle=45,vjust=1,hjust=1))
print(d)
ggsave(filename=file.path(TurbineSiteFigureDir,'Power_ByTiShearWSBin.png'),
       width = 6, height =8, units =c("in"), dpi =300  )

# plot the dispersion in power produced as a function of wind speed, shear and Ti
d<- ggplot(data=Obs.temp, aes(x=Shear,y=Ti_HH, z=Power_mean)) +
  stat_summary2d(fun=function(z) sd(z,na.rm=TRUE),
                 breaks = list(x = AlphaBinEdges, 
                               y = TiBinEdges)) +
  facet_wrap( ~ WS_HH_binned, ncol=4) +
  scale_fill_gradientn(colours = brewer.pal(4,"YlOrRd"))+
  labs(fill = expression(paste(sigma," Power (kW)",sep = ""))) +
  labs(x='Shear (-)') + 
  labs(y='Ti (%)')  +
  theme_publish() +
  theme(axis.text.x = element_text(angle=45,vjust=1,hjust=1))
print(d)
ggsave(filename=file.path(TurbineSiteFigureDir,'PowerDispersion_ByTiShearWSBin.png'),
       width = 6, height =8, units =c("in"), dpi =300  )

# plot the Cp as a function of wind speed, shear and Ti
Obs.temp$CP_WS_Eq <- Obs.temp$Power_mean* 1000 /
  (1/2*1.225*pi*TurbineDesign$RotorDiameter^2/4*Obs$WS_Eq^3)
d<- ggplot(data=Obs.temp, aes(x=Shear,y=Ti_HH, z=CP_WS_Eq)) +
  stat_summary2d(fun=function(z) median(z,na.rm=TRUE),
                 breaks = list(x = AlphaBinEdges, 
                               y = TiBinEdges)) +
  facet_wrap( ~ WS_HH_binned, ncol=4) +
  scale_fill_gradientn(colours = brewer.pal(4,"YlOrRd"))+
  labs(fill = "Cp (-)") +
  labs(x='Shear (-)') + 
  labs(y='Ti (%)') +
  theme_publish() +
  theme(axis.text.x = element_text(angle=45,vjust=1,hjust=1))
print(d)
ggsave(filename=file.path(TurbineSiteFigureDir,'Cp_ByTiShearWSBin.png'),
       width = 6, height =8, units =c("in"), dpi =300  )
