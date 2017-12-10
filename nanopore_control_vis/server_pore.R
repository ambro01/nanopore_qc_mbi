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

generatePoreDescription <- function(x){
  if (x != poreNone){
    fileName <- gsub(" ", "", paste("plot_descriptions/pore/", gsub(" ", "_", x), step=""))
    readChar(fileName, file.info(fileName)$size)
  } else {
    NULL
  }
}