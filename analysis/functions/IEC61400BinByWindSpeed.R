IEC61400BinByWindSpeed <- function(ws,y){
  # Bins data into wind speed ranges according to IEC61400.
  #
  # Args:
  #  ws: wind speed
  #   y: the data to be grouped into bins.
  # Returns:
  #  statistics about the data in each wind speed bin.
  
  
  # figure out the bin that the y data belong in. 
  # Do this in 0.5 m/s bins, centered on 0.5 m/s
  ws.breaks = seq(2.25, 35.25, by = 0.5)
  ws.labels = seq(2.5, 35, by = 0.5)
  ws.bin <- cut(ws,
                breaks = ws.breaks,
                labels = ws.labels)    
  
  # now get the statistics that we might be interested in
  results <- data.frame(count = tapply(y, ws.bin, length))
  
  # get details of the wind speed
  results$ws.mean <- tapply(ws, ws.bin, mean, na.rm = TRUE)
  results$ws.breaks <- ws.breaks[1:length(ws.breaks)-1]
  results$ws.labels <- ws.labels
  
  # get details of the data at this wind speed
  results$y.count <- tapply(y, ws.bin, length)
  results$y.mean <- tapply(y, ws.bin, mean, na.rm = TRUE)
  results$y.median <- tapply(y, ws.bin, median, na.rm = TRUE)
  results$y.sdev <- tapply(y, ws.bin, sd, na.rm = TRUE)
  results$y.95 <- tapply(y, ws.bin, quantile, probs = c(0.95), na.rm = TRUE)
  results$y.75 <- tapply(y, ws.bin, quantile, probs = c(0.75), na.rm = TRUE)
  results$y.50 <- tapply(y, ws.bin, quantile, probs = c(0.50), na.rm = TRUE)
  results$y.25 <- tapply(y, ws.bin, quantile, probs = c(0.25), na.rm = TRUE)
  results$y.05 <- tapply(y, ws.bin, quantile, probs = c(0.05), na.rm = TRUE)
  
  # return the data
  return(results)
}