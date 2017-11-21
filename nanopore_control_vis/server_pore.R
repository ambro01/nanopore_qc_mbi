library(poRe)

source('global.R')

getPoreData <- function(dirPath){
  read.fast5.info(dirPath)
}

generatePorePlotByFunctionName <- function(x, data){
  if(x == poreHistogram) plot.length.histogram(data) 
  else NULL
}