# deklaracja nazw metod i funkcji globalnych

#-------------- IONiser ---------------

ioniserNone = "---"
ioniserReadAccumulation = "Read accumulation"
ioniserActiveChannels = "Active channels"
ioniserReadCategoryCounts = "Read category counts"
ioniserReadCategoryQuals = "Read category quals"
ioniserEventRate = "Event rate"
ioniserBaseProductionRate = "Base production rate"
ioniserReadTypeProduction = "Read type production"
ioniserCurrentByTime = "Current by time"
ioniserReadsLayout = "Reads layout"
ioniserBasesLayout = "Bases layout"

ioniserPlotSelectList <- c(ioniserNone,
                       ioniserReadAccumulation, 
                       ioniserActiveChannels, 
                       ioniserReadCategoryCounts,
                       ioniserReadCategoryQuals,
                       ioniserEventRate,
                       ioniserBaseProductionRate,
                       ioniserReadTypeProduction,
                       ioniserCurrentByTime,
                       ioniserReadsLayout,
                       ioniserBasesLayout)

ioniserReadInfo = "Read info"
ioniserSummaryInfo = "Summary info"
ioniserEventData = "Event data"
ioniserBaseCalled = "Base called"

ioniserStatSelectList <- c(ioniserNone,
                           ioniserReadInfo,
                           ioniserEventData,
                           ioniserBaseCalled)

ioniserDataChoiceList <- c("Files from disc" = 1,
                      "Data set 1" = 2,
                      "Data set 2" = 3,
                      "Data set 3" = 4)

#-------------- poRe ---------------

poreNone = "---"
poreHistogram = "Histogram"
poreCumulativeYield = "Cumulative yield"
poreChannelYield = "Channel yield"
poreChannelReads = "Channel reads"
poreChannelSummary = "Channel summary"

porePlotSelectList <- c(poreNone,
                    poreHistogram,
                    poreCumulativeYield,
                    poreChannelYield,
                    poreChannelReads,
                    poreChannelSummary)

poreSummaryStats = "Summary stats"
poreSummaryByChannel = "Summary by channel"
poreStatSelectList <- c(poreNone,
                        poreSummaryStats,
                        poreSummaryByChannel)

poreDataChoiceList <- c("Files from disc" = 1)

#-------------- poretools ---------------

poretoolsNone = "---"
poretoolsHistogram = "Histogram"
poretoolsYieldOfReads = "Yield of reads"
poretoolsYieldOfBasePairs = "Yield of base pairs"
poretoolsQualityScore = "Quality score distribution"
poreroolsOccupancy= "Occupancy"

poretoolsPlotSelectList <- c(poretoolsNone,
                         poretoolsHistogram,
                         poretoolsYieldOfReads,
                         poretoolsYieldOfBasePairs,
                         poretoolsQualityScore,
                         poreroolsOccupancy)

poretoolsSummaryStats = "Summary stats"
poretoolsNucleotideComposition = "Nucleotide composition"
poretoolsQualityScoreComposition = "Quality score composition"
poretoolsMetadataOfEachFile = "Metadata of each file"

poretoolsStatSelectList <- c(poretoolsNone,
                             poretoolsSummaryStats,
                             poretoolsNucleotideComposition,
                             poretoolsQualityScoreComposition,
                             poretoolsMetadataOfEachFile)

poretoolsDataChoiceList <- c("Files from disc" = 1)

#-------------- common ---------------

defaultDataChoiceList <- c("Files from disc" = 1)

isValid <- function(x){
  return (!is.null(x) && length(x) > 0)
}

generateProgramDescription <- function(name){
  if(is.null(name)){
    return (NULL)
  }
  fileName <- gsub(" ", "", paste("descriptions/common/", gsub(" ", "_", name), step = ""))
  return (readChar(fileName, file.info(fileName)$size))
}
