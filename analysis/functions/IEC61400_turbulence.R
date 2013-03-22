# function to calculate wind turbulence according to IEC 61400-1 (1999)
IEC61400_turbulence <- function(u,SiteClass) {
  
  I15 <- ifelse (SiteClass =='a',0.16,
                 ifelse(SiteClass=='b',0.14,
                        NA))

# get the turbulence, noting that R does elementwise multiplication
sigmau = I15*(0.75*u+5.6)
Ti = 100* sigmau/u

return(Ti)
}