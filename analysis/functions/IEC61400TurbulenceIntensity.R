IEC61400TurbulenceIntensity <- function(ws,site.class) {
  # Calculate turbulence intensity at a given wind speed from IEC 61400
  #
  # Args:
  #  ws: wind speed
  #   site.class: the class of the site
  # Returns:
  #  turbulence intensity
  
  i15 <- ifelse (site.class =='a',0.16,
                 ifelse(site.class=='b',0.14,
                        NA))
  
  # get the turbulence, noting that R does elementwise multiplication
  sigmau = i15*(0.75*ws+5.6)
  ti = 100* sigmau/ws
  
  return(ti)
}