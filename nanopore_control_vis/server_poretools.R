library(png)
library(imager)
source('global.R')

# funckje stosowane wylacznie w logice dotyczacej narzedzia poretools
generatePoretoolsPlotByFunctionName <- function(x, dir){
  tool <- "poretools"
  fileName <- "images/foo.png"
  func <- ""
  if(x == poretoolsHistogram) {
    func <- "hist"
  } else if(x == poretoolsYieldOfReads){
    func <- "yield_plot --plot-type reads"
  } else if(x == poretoolsYieldOfBasePairs){
    func <- "yield_plot --plot-type basepairs"
  } else if(x == poretoolsQualityScore){
    func <- "qualpos"
  } else if(x == poreroolsOccupancy){
    func <- "occupancy"
  } else {
   return (NULL)
  }
  
  cmd <- paste(tool, func, "--saveas", fileName, dir, step=" ")
  system(cmd)
  return (NULL)
}

generatePoretoolsStatByFunctionName <- function(x, dir){
  tool <- "poretools"
  func <- ""
  list <- NULL
  if(x == poretoolsSummaryStats) {
    func <- "stats"
    list <- c("stat", "value")
  } else if(x == poretoolsNucleotideComposition){
    func <- "nucdist"
    list <- c("type", "count", "total", "count/total")
  } else if(x == poretoolsQualityScoreComposition){
    func <- "qualdist"
    list <- c("symbol", "quality", "count", "total", "count/total")
  } else if(x == poretoolsMetadataOfEachFile){
    func <- "index"
    list <- c("file name", "temlate lenght", "component lenght", "2d lenght", "asic id",
              "asic temperature", "heatsink temperature", "channel number", "x1", "experiment start date", "experiment start time", "x2", "start date",
              "start time", "duration", "fast5 version")
  } else {
    return (NULL)
  }
  cmd <- paste(tool, func, dir, step=" ")
  result <- base::system(cmd, intern = TRUE)
  return(generateTableFromText(result, list, func))
}

generatePoretoolsDescription <- function(x){
  if (x != poretoolsNone){
    fileName <- gsub(" ", "", paste("plot_descriptions/poretools/", gsub(" ", "_", x), step=""))
    readChar(fileName, file.info(fileName)$size)
  } else NULL
}

generateTableFromText <- function(x, list, func){
  df <- data.frame(x)
  foo <- data.frame(do.call('rbind', strsplit(as.character(df$x),'\t',fixed=TRUE)))
  colnames(foo) <- list
  
  if(func == "index"){
    drops <- c("x1","x2")
    foo <- foo[-c(1), ]
    foo <- foo[ , !(names(foo) %in% drops)]
  }
  
  return (foo)
}