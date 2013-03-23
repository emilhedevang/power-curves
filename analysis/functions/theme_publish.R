# theme ripped off from theme_bw
theme_publish <- function (base_size = 10, base_family = "") 
{
  theme_grey(base_size = base_size, base_family = base_family) %+replace%
    theme(axis.text = element_text(size = rel(0.8)), 
          axis.title.x = element_text(size = rel(1.0)), 
          axis.title.y = element_text(size = rel(1.0), angle=90), 
          axis.ticks = element_line(colour = "grey50"), 
          legend.key = element_rect(fill = NA, colour = NA, size = 1),
          legend.text = element_text(size = rel(0.8)), 
          legend.background = element_rect(fill = "white",colour = NA), 
          panel.background = element_rect(fill = "white",colour = NA), 
          panel.border = element_rect(fill = NA,colour = "grey50"), 
          panel.grid.major = element_line(colour = "grey90",size = 0.2), 
          panel.grid.minor = element_line(colour = "grey98",size = 0.5), 
          strip.background = element_rect(fill = "grey80",colour = "grey50"), 
          strip.background = element_rect(fill = "grey80",colour = "grey50"))
}