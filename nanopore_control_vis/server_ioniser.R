library(IONiseR)
library(minionSummaryData)
library(ggplot2)
library(gridExtra)

source('global.R')
source('ui.R')
source('ui_ioniser.R')

# funkcje dotyczace narzedzia ioniser

getSummaryData <- function(dataSource, dataPath) {
  out <- tryCatch({
    if(dataSource == 1 && isValid(dataPath)){
      return (readFast5Summary(dataPath))
    } else if(dataSource == 2){
      data(s.typhi.rep1) 
      return (s.typhi.rep1)
    } else if(dataSource == 3){
      data(s.typhi.rep2) 
      return (s.typhi.rep2)
    } else if(dataSource == 4){
      data(s.typhi.rep3) 
      return (s.typhi.rep3)
    } else {
      return (NULL)
    }},
    error = function(cond){
      return (NULL)
    })
  return (out)
}

generateIoniserPlotByFunctionName <- function(x, data){
  out <- tryCatch({
    if(x == ioniserReadAccumulation) plotReadAccumulation(data)
    else if(x == ioniserActiveChannels) plotActiveChannels(data)
    else if(x == ioniserReadCategoryCounts) plotReadCategoryCounts(data)
    else if(x == ioniserReadCategoryQuals) plotReadCategoryQuals(data)
    else if(x == ioniserEventRate) plotEventRate(data)
    else if(x == ioniserBaseProductionRate) plotBaseProductionRate(data)
    else if(x == ioniserReadTypeProduction) plotReadTypeProduction(data)
    else if(x == ioniserCurrentByTime) plotCurrentByTime(data)
    else if(x == ioniserReadsLayout) layoutPlot(data, attribute = "nreads")
    else if(x == ioniserBasesLayout) layoutPlot(data, attribute = "kb")
    else NULL
  },
  error = function(cond){
    return (NULL)
  })
  return (out)
}

generateIoniserStatByFunctionName <- function(x, data){
  if(x == ioniserEventData){
    eventData(data)
  } else if(x == ioniserBaseCalled){
    baseCalled(data)
  } else if(x == ioniserReadInfo){
    readInfo(data)
  } else {
    return (NULL)
  }
}

generateIoniserDescription <- function(x, y){
  if(is.null(y)){
    return ("Generating has failed. Data could not be loaded.")
  }
  
  if (x != ioniserNone){
    fileName <- gsub(" ", "", paste("plot_descriptions/ioniser/", gsub(" ", "_", x), step = ""))
    return (readChar(fileName, file.info(fileName)$size))
  } else {
    return (NULL)
  }
}
  