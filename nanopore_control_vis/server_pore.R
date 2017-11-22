library(poRe)

source('global.R')

# funckje stosowane wylacznie w logice dotyczacej narzedzia pore

getPoreData <- function(dirPath){
  read.fast5.info(dirPath)
}

generatePorePlotByFunctionName <- function(x, data){
  if(x == poreHistogram) {
    plot.length.histogram(data)
    p <- recordPlot()
    plot.new()
    return (p)
  }
  else {
   return (NULL)
  }
}