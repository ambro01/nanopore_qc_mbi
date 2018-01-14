library(poRe)
library(Rmisc)

porePlotHistogram <- function (x, breaks = 100, mar = c(4, 4, 3, 0.5), titles = c("template", "complement", "2D"), colours = c("darkred", "dodgerblue4", "darkolivegreen"))
{
  p1 <- qplot(as.numeric(x$tlen[x$tlen > 0]),
        geom="histogram",
        binwidth = breaks,  
        main = "Histogram for template", 
        xlab = "length",
        fill = I(colours[1])) +
        theme(legend.position="none")
  
  p2 <- qplot(as.numeric(x$clen[x$clen > 0]),
              geom="histogram",
              binwidth = breaks,  
              main = "Histogram for Complement", 
              xlab = "length",
              fill = I(colours[2])) + 
              theme(legend.position="none")
  
  p3 <- qplot(as.numeric(x$len2d[x$len2d > 0]),
              geom="histogram",
              binwidth = breaks,  
              main = "Histogram for 2D", 
              xlab = "length",
              fill= I(colours[3])) + 
              theme(legend.position="none")

  return(renderPlot(multiplot(p1, p2, p3, cols=3)))
}

porePlotCumulativeYield <- function (x, mar = c(4, 4, 3, 0.5), titles = c("template", "complement", "2D"), colours = c("darkred", "dodgerblue4", "darkolivegreen")) 
{
  x <- x[!is.na(x$read_start_time), ]
  split.screen(c(1, 3))
  alld <- as.numeric(x$exp_start + x$read_start_time)
  od <- order(alld)
  alld <- alld[od]
  x <- x[od, ]
  mind <- min(alld)
  tlen <- x[, "tlen"]
  clen <- x[, "clen"]
  dlen <- x[, "len2d"]
  ctlen <- as.vector(tlen[1])
  cclen <- as.vector(clen[1])
  c2dlen <- as.vector(dlen[1])
  tplot <- as.vector(alld[1] - mind)
  for (i in 2:nrow(x)) {
    tplot <- c(tplot, alld[i] - mind)
    ctlen <- c(ctlen, ctlen[length(ctlen)] + tlen[i])
    cclen <- c(cclen, cclen[length(cclen)] + clen[i])
    c2dlen <- c(c2dlen, c2dlen[length(c2dlen)] + dlen[i])
  }
  
  p1 <- ggplot(data.frame(tplot, ctlen/1000), aes(x=ctlen/1000, y=tplot)) +
    geom_line(color = I(colours[1])) +
    ggtitle("Template") +
    xlab("time(seconds)") + ylab("cumulative kbases") +
    theme(legend.position="none")

  p2 <- ggplot(data.frame(tplot, cclen/1000), aes(x=cclen/1000, y=tplot)) +
    geom_line(color = I(colours[2])) +
    ggtitle("Complement") +
    xlab("time(seconds)") + ylab("cumulative kbases") +
    theme(legend.position="none")
  
  p3 <- ggplot(data.frame(tplot, c2dlen/1000), aes(x=c2dlen/1000, y=tplot)) +
    geom_line(color = I(colours[3])) +
    ggtitle("2D") +
    xlab("time(seconds)") + ylab("cumulative kbases") +
    theme(legend.position="none")
  
  return (renderPlot(multiplot(p1, p2, p3, cols=3)))
  
}

porePlotChannelYield <- function (x, maxchannels = 512, col.col = "black", col.border = "black", which = "tlen") 
{
    read.yield <- aggregate(x[, which], by = list(x$channel), 
        sum)
    df <- merge(data.frame(channel = 1:512), read.yield, by.x = "channel", 
        by.y = "Group.1", all.x = TRUE)
    df$x[is.na(df$x)] <- 0
    colnames(df) <- c("channel", "yield")
    out <- renderPlot(barplot(df$yield, names = df$channel, xaxt = "n", ylab = "yield", 
        space = c(0, 0), col = col.col, border = col.border))
    labs <- seq(0, maxchannels, by = 12)
    labs <- labs[2:length(labs)]
    axis(side = 1, at = labs, labels = labs, ps = 8, las = 2)
    axis(side = 1, at = maxchannels/2, labels = "channel", line = 1.5, 
        tick = FALSE)
    return (out)
}

porePlotChannelReads <- function (x, maxchannels = 512, col.col = "black", col.border = "black") 
{
  read.counts <- aggregate(x$clen, by = list(x$channel), length)
  df <- merge(data.frame(channel = 1:512), read.counts, by.x = "channel", 
              by.y = "Group.1", all.x = TRUE)
  df$x[is.na(df$x)] <- 0
  colnames(df) <- c("channel", "num_reads")
  out <- (renderPlot(barplot(df$num_reads, names = df$channel, xaxt = "n", ylab = "num reads", 
          space = c(0, 0), col = col.col, border = col.border)))
  labs <- seq(0, maxchannels, by = 12)
  labs <- labs[2:length(labs)]
  axis(side = 1, at = labs, labels = labs, ps = 8, las = 2)
  axis(side = 1, at = maxchannels/2, labels = "channel", line = 1.5, 
       tick = FALSE)
  return (out)
}

porePlotChannelSummary <- function (x, report.col = "nchannels", nrow = 16, ncol = 32, nchannels = 512, cols = NULL) 
{
  loc <- vector("list", nchannels)
  if (is.null(cols)) {
    cols <- c(125, 121, 117, 113, 109, 105, 101, 97, 93, 
              89, 85, 81, 77, 73, 69, 65, 61, 57, 53, 49, 45, 41, 
              37, 33, 29, 25, 21, 17, 13, 9, 5, 1)
  }
  fc <- vector()
  for (i in 1:length(cols)) {
    s <- cols[i]
    for (block in 0:3) {
      for (row in 0:3) {
        location <- s + (128 * block) + row
        loc[[location]]$column <- i
        if (location%%4 == 0) {
          loc[[location]]$row <- (block * 4) + 4
        }
        else {
          loc[[location]]$row <- (block * 4) + (location%%4)
        }
      }
    }
  }
  mat <- matrix(nrow = nrow, ncol = ncol)
  for (i in 1:nchannels) {
    mat[loc[[i]]$row, loc[[i]]$column] <- x[rownames(x) == 
                                              i, report.col]
  }
  return(renderPlot(coreImagePlot(mat)))
}