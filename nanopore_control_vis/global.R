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

ioniserRadioList <- c("Files from disc" = 1,
                      "Data set 1" = 2,
                      "Data set 2" = 3,
                      "Data set 3" = 4)

#-------------- poRe ---------------

poreNone = "---"
poreHistogram = "Histogram"
poreSelectList <- c(poreNone,
                    poreHistogram)

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
                         poreroolsThroughputPerformance)

poretoolsSummaryStats = "Pore summary stats"
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