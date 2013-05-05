# PlotObservations.R
#
# Script to plot observations

# start with some histograms of the data; let's see what we have.
# hub-height wind speed
d <- ggplot(data = observations.all,
            aes(x = ws.hh)) +
  geom_histogram(binwidth = 1, colour="black", fill="#DD8888", width=.7) +
  labs(x = expression(paste('Wind Speed (m ',s^{-1},')'))) + 
  labs(y = 'Count') +
  labs(title = 'Hub-height wind speed')
print(d)
ggsave(filename = file.path(projectfiles.locations$FigureDir,
                            'WS_Histogram.png'),
       width = 6, height = 3, units = c("in"), dpi = 300 )

# shear
d <- ggplot(data = observations.all, 
            aes(x = shear)) +
  geom_histogram(binwidth = 0.05, colour="black", fill="#DD8888", width=.7) +
  labs(x = expression(paste('Shear (-)'))) + 
  labs(y = 'Count') +
  labs(title = 'Rotor-disk shear')
print(d)
ggsave(filename = file.path(projectfiles.locations$FigureDir,
                            'shear_Histogram.png'),
       width = 6, height = 3, units = c("in"), dpi = 300 )

# Turbulence intensity ----
# scatter plot
# get the IEC level
UBinMid = seq(4.25,25.25,by = 0.5)
TiBinA = IEC61400TurbulenceIntensity(UBinMid,'a')
TiBinB = IEC61400TurbulenceIntensity(UBinMid,'b')
IEC61400 <- data.frame(UBinMid,TiBinA,TiBinB)

d <- ggplot() +
  geom_point(data = observations.all,
             aes(x = ws.hh,
                 y = ti.hh),
             size = 0.5,
             alph = 0.5) +
  geom_line(data = IEC61400,
            aes(x = UBinMid,
                y = TiBinA,
                group = 'a'),
            color = 'red') +
  geom_line(data = IEC61400,
            aes(x = UBinMid,
                y = TiBinB,
                group = 'b'),
            color = 'blue') +
  labs(x = expression(paste('Wind Speed (m ',s^{-1},')'))) + 
  labs(y = 'Ti (%)') +
  labs(title = 'Turbulence Intensity')
print(d)
ggsave(filename = file.path(projectfiles.locations$FigureDir,
                            'Ti_ScatterPlot.png'),
       width = 6, height = 3, units = c("in"), dpi = 300 )

# Range of observed turbulence intensity
d <- ggplot() +
  geom_ribbon(data = IEC61400BinByWindSpeed(ws = observations.all$ws.eq, 
                                            y = observations.all$ti.hh), 
              aes(x = ws.mean,
                  y = y.mean,
                  ymin = y.05,
                  ymax = y.95),
              alpha = 0.5,
              fill = 'lightgrey') + 
  geom_ribbon(data = IEC61400BinByWindSpeed(ws = observations.all$ws.eq, 
                                            y = observations.all$ti.hh), 
              aes(x = ws.mean, 
                  y = y.mean, 
                  ymin = y.25,
                  ymax = y.75),
              alpha = 0.5,
              fill = 'grey50') + 
  geom_line(data = IEC61400BinByWindSpeed(ws = observations.all$ws.eq, 
                                          y = observations.all$ti.hh), 
            aes(x = ws.mean,
                y = y.mean),
            color = 'black') +  
  geom_line(data = IEC61400,aes(x = UBinMid,
                                y = TiBinA,
                                group = 'a'),
            color = 'red') +
  geom_line(data = IEC61400,
            aes(x = UBinMid,
                y = TiBinB,
                group = 'b'),
            color = 'blue') +
  labs(x = expression(paste('Wind Speed (m ',s^{-1},')',sep=""))) + 
  labs(y = 'Ti (%)') +
  labs(title = 'Turbulence Intensity')
print(d)
ggsave(filename = file.path(projectfiles.locations$FigureDir,
                            'WS_Ti_Boxplot.png'),
       width = 6, height = 3, units = c("in"), dpi = 300 )

# Wind speed distribution ----
# compare the rotor-equivalent and hub-height wind speeds
d <- ggplot(data = observations.all) +
  geom_point(aes(x = ws.eq.rss,
                 y = ws.eq/ws.hh), 
             color = 'blue',
             alpha = 1/2) + 
  labs(y = expression(paste(U[eq]/ U[H]))) + 
  labs(x = expression(paste('RSS (',
                            m^2,' ',s^{-2},')'))) +
  labs(title = 'Quality of Power Law Fit')
print(d)
ggsave(filename = file.path(projectfiles.locations$FigureDir,
                            'RS_WSRatio_Scatter.png'),
       width = 3, height = 3, units = c("in"), dpi = 300 )

# Power curve grouped by turbulence intensity ----
## plot a quick power curve, cutting the turbulence intensity in 2% bins
d <- ggplot(data = observations.all) + 
  geom_point(aes(x = ws.hh,
                 y = power.mean.observed, 
                 color = cut(ti.hh,
                             breaks = seq(0, 50, by = 5),
                             labels = paste(seq(0, 45, by = 5),
                                            '-',
                                            seq(5, 50, by = 5)),
                             right = TRUE)),
             shape = 19,
             alpha = 1/2,
             size = 1) + 
  labs(colour = "Ti (%)") +
  labs(x = expression(paste('Wind Speed (m ',s^{-1},')'))) + 
  labs(y = 'Power (kW)')
print(d)
ggsave(filename = file.path(projectfiles.locations$FigureDir,
                            'WS_Power_ColoredByTi.png'),
       width = 6, height = 4, units = c("in"), dpi = 300 )

# The following plots generate e.g. median and standard deviation of power, Cp,
# versus shear and Ti. 

# Therefore we will define some common bin edges
observations.temp <- observations.all
observations.temp$WS_HH_binned <- cut(observations.temp$ws.hh,
                                      breaks = seq(3, 25, by = 1),
                                      labels = paste(seq(3, 24, by = 1),
                                                     ' - ',
                                                     seq(4, 25, by = 1)),
                                      right = TRUE)
AlphaBinEdges <- seq(-0.5, 0.5, by = 0.05)
TiBinEdges <- seq(0, 50, by = 2)

# plot the number of observations as a function of wind speed, shear and Ti
d<- ggplot(data = observations.temp, 
           aes(x = shear,
               y = ti.hh, 
               z = power.mean.observed)) +
  stat_bin2d(breaks = list(x = AlphaBinEdges, 
                           y = TiBinEdges)) +
  facet_wrap( ~ WS_HH_binned, ncol = 4) +
  scale_fill_gradientn(colours = brewer.pal(4,"YlOrRd"))+
  labs(fill = "Count (-)") +
  labs(x = 'Shear (-)') + 
  labs(y = 'Ti (%)') +
  labs(title = 'Number of wind speed, shear and turbulence observations per bin') +
  theme(axis.text.x = element_text(angle = 45,
                                   vjust = 1,
                                   hjust = 1))
print(d)
ggsave(filename = file.path(projectfiles.locations$FigureDir,
                             'Count_ByTiShearWSBin.png'),
       width = 6, height = 8, units = c("in"), dpi = 300 )

# plot the median power produced as a function of wind speed, shear and Ti
d<- ggplot(data = observations.temp, 
           aes(x = shear, 
               y = ti.hh, 
               z = power.mean.observed)) +
  stat_summary2d(fun = function(z) median(z,na.rm = TRUE),
                 breaks = list(x = AlphaBinEdges, 
                               y = TiBinEdges)) +
  facet_wrap( ~ WS_HH_binned, ncol = 4) +
  scale_fill_gradientn(colours = brewer.pal(4,"YlOrRd"))+
  labs(fill = "Power (kW)") +
  labs(x = 'Shear (-)') + 
  labs(y = 'Ti (%)') +
  labs(title = 'Effect of wind speed, shear and turbulence on power') +
  theme(axis.text.x = element_text(angle = 45,vjust = 1,hjust = 1))
print(d)
ggsave(filename = file.path(projectfiles.locations$FigureDir,
                            'Power_ByTiShearWSBin.png'),
       width = 6, height = 8, units = c("in"), dpi = 300 )

# plot the dispersion in power produced as a function of wind speed, shear and Ti
d<- ggplot(data = observations.temp, 
           aes(x = shear,
               y = ti.hh, 
               z = power.mean.observed)) +
  stat_summary2d(fun = function(z) sd(z,na.rm = TRUE),
                 breaks = list(x = AlphaBinEdges, 
                               y = TiBinEdges)) +
  facet_wrap( ~ WS_HH_binned, ncol = 4) +
  scale_fill_gradientn(colours = brewer.pal(4,"YlOrRd"))+
  labs(fill = expression(paste(sigma," Power (kW)",sep = ""))) +
  labs(x = 'Shear (-)') + 
  labs(y = 'Ti (%)') +
  labs(title = 'Effect of wind speed, shear and turbulence on power dispersion') +
  theme(axis.text.x = element_text(angle = 45,
                                   vjust = 1,
                                   hjust = 1))
print(d)
ggsave(filename = file.path(projectfiles.locations$FigureDir,
                            'PowerDispersion_ByTiShearWSBin.png'),
       width = 6, height = 8, units = c("in"), dpi = 300 )

# calculate Cp from equiavlent wind speed
observations.temp$cp.ws.eq <- observations.temp$power.mean.observed * 1000 /
  (1/2 * 1.225 * pi * turbine.design.data$RotorDiameter^2/4 * 
     observations.temp$ws.eq^3)

# plot the Cp as a function of wind speed, shear and Ti
d<- ggplot(data = observations.temp, 
           aes(x = shear,
               y = ti.hh, 
               z = cp.ws.eq)) +
  stat_summary2d(fun = function(z) median(z,na.rm = TRUE),
                 breaks = list(x = AlphaBinEdges, 
                               y = TiBinEdges)) +
  facet_wrap( ~ WS_HH_binned, ncol = 4) +
  scale_fill_gradientn(colours = brewer.pal(4, "YlOrRd"))+
  labs(fill = "Cp (-)") +
  labs(x = 'Shear (-)') + 
  labs(y = 'Ti (%)') +
  labs(title = 'Effect of wind speed, shear and turbulence on Cp') +
  theme(axis.text.x = element_text(angle = 45,
                                   vjust = 1,
                                   hjust = 1))
print(d)
ggsave(filename = file.path(projectfiles.locations$FigureDir,
                            'Cp_ByTiShearWSBin.png'),
       width = 6, height = 8, units = c("in"), dpi = 300 )

# tidy up, leaving only the things we actually want
rm(observations.temp,
   d,
   AlphaBinEdges,TiBinA,TiBinB,TiBinEdges,IEC61400,UBinMid)