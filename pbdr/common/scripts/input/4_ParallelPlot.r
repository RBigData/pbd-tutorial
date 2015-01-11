raster_plot <- function(x, nrow, ncol, basename="raster", sequence=1, swidth=3) 
{                                                                               
    x <- data.frame(rasterToPoints(raster(matrix(x, nrow, ncol),                
                                          xmn=0, xmx=ncol, ymn=0, ymx=nrow)))   
    names(x) <- c("x", "y", basename)                                           
    png(paste(basename, "_", formatC(sequence, width=swidth, flag=0), "_",      
              comm.rank(), ".png", sep=""))                                     
    print(ggplot(x, aes_string(x="x", y="y", fill=basename)) + geom_raster() +  
          theme_minimal() + theme(axis.text.x=element_blank(),                  
                                  axis.ticks.x=element_blank(),                 
                                  axis.title.x=element_blank(),                 
                                  legend.position="none",                       
                                  plot.margin=unit(c(0,0,0,0),"cm")             
                                  )                                             
          )                                                                     
    dev.off()                                                                   
}                                                                               
## not sure above minimal theme is needed, nor the plot.margin.
## rest may be in Japan talk and in NIMBIOS talk!!
