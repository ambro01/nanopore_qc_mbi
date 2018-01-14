library(poRe)

source('global.R')
source('pore_functions.R')

# funckje stosowane wylacznie w logice dotyczacej narzedzia pore

getPoreData <- function(dirPath){
  read.fast5.info(dirPath)
}

generatePorePlotByFunctionName <- function(x, data){
  out <- tryCatch({
    if(x == poreHistogram) {
      porePlotHistogram(data)
    } else if(x == poreCumulativeYield){
      porePlotCumulativeYield(data)
    } else if(x == poreChannelYield){
      return(porePlotChannelYield(data))
    } else if(x == poreChannelReads){
      porePlotChannelReads(data)
    } else if(x == poreChannelSummary){
      porePlotChannelSummary(summarise.by.channel(data, nchannels=512))
    } else NULL
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
