# script based on examples at http://www.statmethods.net/advstats/cart.html
# and http://stat-www.berkeley.edu/users/breiman/RandomForests/

# note that we installed the randomForest package in LoadPackages.R

# Need the Operating Region to make the model work
Obs$TurbineOpRegion <- as.factor(as.numeric(Obs$WS_Eq > TurbineDesign$RatedWindSpeed) + 1)

# create the model from the data
# set a random seed so that we have repeatable results
set.seed(1)
TurbineCART <- randomForest(Power_mean ~ WS_Eq + Ti_HH + Shear + TurbineOpRegion,
                            data=Obs,
                            ntree=500,
                            importance=TRUE)
print(TurbineCART) # view results 
importance(TurbineCART) # importance of each predictor

# look at how the model improves with number of trees
plot(TurbineCART)

# define a function to plot the dendogram of one tree, based on script at
# http://stats.stackexchange.com/questions/2344/best-way-to-present-a-random-forest-in-a-publication

to.dendrogram <- function(dfrep,rownum=1,height.increment=0.1){
  
  if(dfrep[rownum,'status'] == -1){
    rval <- list()
    
    attr(rval,"members") <- 1
    attr(rval,"height") <- 0.0
    attr(rval,"label") <- dfrep[rownum,'prediction']
    attr(rval,"leaf") <- TRUE
    
  }else{
    left <- to.dendrogram(dfrep,dfrep[rownum,'left daughter'],height.increment)
    right <- to.dendrogram(dfrep,dfrep[rownum,'right daughter'],height.increment)
    rval <- list(left,right)
    
    attr(rval,"members") <- attr(left,"members") + attr(right,"members")
    attr(rval,"height") <- max(attr(left,"height"),attr(right,"height")) + height.increment
    attr(rval,"leaf") <- FALSE
    attr(rval,"edgetext") <- dfrep[rownum,'split var']
  }
  
  class(rval) <- "dendrogram"
  
  return(rval)
}

tree <- getTree(TurbineCART,2,labelVar=TRUE)

d <- to.dendrogram(tree)
str(d)
plot(d,center=TRUE,leaflab='none',edgePar=list(t.cex=1,p.col=NA,p.lty=0))