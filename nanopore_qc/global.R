source('directoryInput.R')

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

ioniserSelectList <- c(ioniserNone,
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

ioniserSelectListStat <- c(ioniserNone,
                           ioniserReadInfo,
                           ioniserEventData,
                           ioniserBaseCalled)

ioniserRadioList <- c("Files from disc" = 1,
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
poreLayout = "Layout"

poreSelectList <- c(poreNone,
                    poreHistogram,
                    poreCumulativeYield,
                    poreChannelYield,
                    poreChannelReads,
                    poreChannelSummary,
                    poreLayout)

poreSummaryStats = "Summary stats"
poreSummariseByChannel = "Summarise by channel"
poreSelectListStat <- c(poreNone,
                        poreSummaryStats,
                        poreSummariseByChannel)

#-------------- poretools ---------------

poretoolsNone = "---"
poretoolsHistogram = "Histogram"
poretoolsYieldOfReads = "Yield of reads"
poretoolsYieldOfBasePairs = "Yield of base pairs"
poretoolsQualityScore = "Quality score distribution"
poreroolsOccupancy= "Occupancy"

poretoolsSelectList <- c(poretoolsNone,
                         poretoolsHistogram,
                         poretoolsYieldOfReads,
                         poretoolsYieldOfBasePairs,
                         poretoolsQualityScore,
                         poreroolsOccupancy)

poretoolsSummaryStats = "Summary stats"
poretoolsNucleotideComposition = "Nucleotide composition"
poretoolsQualityScoreComposition = "Quality score composition"
poretoolsMetadataOfEachFile = "Metadata of each file"

poretoolsSelectListStat <- c(poretoolsNone,
                             poretoolsSummaryStats,
                             poretoolsNucleotideComposition,
                             poretoolsQualityScoreComposition,
                             poretoolsMetadataOfEachFile)

#-------------- common ---------------

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