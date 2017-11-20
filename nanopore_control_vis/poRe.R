library(poRe)
library(minionSummaryData)

dataCatalog = "/home/ra/nanopore_data/nanook_ecoli_500/N79596_dh10b_8kb_11022015/fast5/pass/"
fileName = "/home/ra/nanopore_data/nanook_ecoli_500/N79596_dh10b_8kb_11022015/fast5/pass/N79596_dh10b_8kb_11022015_0627_1_ch1_file23_strand.fast5"
#dataCatalog = "/home/ra/nanopore_data/test_dataset/"

fast5files <- list.files(path = dataCatalog, pattern = "\\.fast5$", full.names = TRUE, recursive = TRUE)

#meta <- read.fast5.info(dataCatalog)
#meta = data(s.typhi.rep1)
meta <- get_fast5_info(fileName)

stats <- run.summary.stats(meta)
plot.length.histogram(meta)
yield <- plot.cumulative.yield(meta)

# find the maximum length
max(pass$len2d)

# get the metadata for that read
pass[pass$len2d==max(pass$len2d),]

plot.channel.reads(meta)
# yield - wydajnosc
plot.channel.yield(meta)

f5 <- "/home/ra/nanopore_data/nanook_ecoli_500/N79596_dh10b_8kb_11022015/fast5/pass/N79596_dh10b_8kb_11022015_0627_1_ch1_file23_strand.fast5"
# NEW FORMAT
ev <- get.events(f5)
names(ev)
head(ev$template)
head(ev$complement)

# 1D
ev <- get.events(f5)
names(ev)
head(ev$template)

plot.squiggle(ev$template)
plot.squiggle(ev$template, minseconds=5)
plot.squiggle(ev$complement)

show.layout()


# the number of times the channel appears in any context
plot.channel.summary(meta.s)

# cumulative 2D length
plot.channel.summary(meta.s, report.col="l2d")
