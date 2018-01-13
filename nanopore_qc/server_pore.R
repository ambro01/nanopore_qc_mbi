library(poRe)

source('global.R')

# funckje stosowane wylacznie w logice dotyczacej narzedzia pore

getPoreData <- function(dirPath){
  read.fast5.info(dirPath)
}

generatePorePlotByFunctionName <- function(x, data){
  out <- tryCatch({
    if(x == poreHistogram) {
      plot.length.histogram(data)
    } else if(x == poreCumulativeYield){
      plot.cumulative.yield(data)
    } else if(x == poreChannelYield){
      plot.channel.yield(data)
    } else if(x == poreChannelReads){
      plot.channel.reads(data)
    } else if(x == poreChannelSummary){
      plot.channel.summary(summarise.by.channel(data, nchannels=512))
    } else if(x == poreLayout){
      show.layout()
    } else return (NULL)
    
    p <- recordPlot()
    plot.new()
    return (p)
  },
  error = function(cond){
    return (NULL)
  })
  
  return (out)
}

generatePoreStatByFunctionName <- function(x, data){
  out <- tryCatch({
    if(x == poreSummaryStats) {
      run.summary.stats(data)
    } else if(x == poreSummariseByChannel){
      summarise.by.channel(data)
    } else return (NULL)
  },
  error = function(cond){
    return (NULL)
  })
  
  return(out)
}

generatePoreDescription <- function(x, y){
  if(is.null(y)){
    return ("Generating has failed. Data could not be loaded.")
  }
  
  if (x != poreNone){
    fileName <- gsub(" ", "", paste("descriptions/pore/", gsub(" ", "_", x), step=""))
    readChar(fileName, file.info(fileName)$size)
  } else {
    NULL
  }
}
