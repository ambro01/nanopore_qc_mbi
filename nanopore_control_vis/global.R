source('directoryInput.R')

# deklaracja nazw metod i funkcji globalnych

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

ioniserRadioList <- c("Files from disc" = 1,
                      "Data set 1" = 2,
                      "Data set 2" = 3,
                      "Data set 3" = 4)

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

poreSummaryStats = "Pore summary stats"
poreSummariseByChannel = "Summarise by channel"
poreSelectListStat <- c(poreNone,
                        poreSummaryStats,
                        poreSummariseByChannel)

isValid <- function(x){
  return (!is.null(x) && length(x) > 0)
}