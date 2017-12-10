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
  } else if(x == poreroolsThroughputPerformance){
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
  if(x == poretoolsSummaryStats) {
    func <- "stats"
  } else if(x == poretoolsNucleotideComposition){
    func <- "nucdist"
  } else if(x == poretoolsQualityScoreComposition){
    func <- "qualdist"
  } else if(x == poretoolsMetadataOfEachFile){
    func <- "index"
  } else {
    return (NULL)
  }
  cmd <- paste(tool, func, dir, step=" ")
  result <- base::system(cmd, intern = TRUE)
  return(result)
}

generatePoretoolsDescription <- function(x){
  if (x != poretoolsNone){
    fileName <- gsub(" ", "", paste("plot_descriptions/poretools/", gsub(" ", "_", x), step=""))
    readChar(fileName, file.info(fileName)$size)
  } else {
    NULL
  }
}