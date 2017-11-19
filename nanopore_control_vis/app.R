library(shiny)
library(IONiseR)
library(ggplot2)
library(gridExtra)
library(minionSummaryData)
library(stringr)

# names of drawings
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

ioniserSelectList <- c("", 
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

#fast5files <- list.files(path = "/path/to/data/", pattern = ".fast5$", full.names = TRUE)
#data <- readFast5Summary( fast5files )
summaryData = s.typhi.rep1

ui <- fluidPage(
    ui <- navbarPage(
    "Control analyses of DNA data from MinION seqencer",
    id = "navbar",
    tabPanel("IONiser", 
             value = "ioniser",
             mainPanel(
               selectInput(inputId = "ioniserSelect", 
                           label = "Select control process", 
                           choices = ioniserSelectList),
               h4("Description of method"),
               textOutput(outputId = "plotDescription"),
               h4(""),
               plotOutput(outputId = "plotIoniser", width = "600px", height = "400px"))),
    tabPanel("poRe"), 
    tabPanel("xxx")
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  #data(s.typhi.rep1)
  #baseCalled(s.typhi.rep1)
  
  x <- reactive(input$ioniserSelect)
  y <- reactive({
    if(x() == ioniserReadAccumulation) plotReadAccumulation(summaryData)
    else if(x() == ioniserActiveChannels) plotActiveChannels(summaryData)
    else if(x() == ioniserReadCategoryCounts) plotReadCategoryCounts(summaryData)
    else if(x() == ioniserReadCategoryQuals) plotReadCategoryQuals(summaryData)
    else if(x() == ioniserEventRate) plotEventRate(summaryData)
    else if(x() == ioniserBaseProductionRate) plotBaseProductionRate(summaryData)
    else if(x() == ioniserReadTypeProduction) plotReadTypeProduction(summaryData)
    else if(x() == ioniserCurrentByTime) plotCurrentByTime(summaryData)
    else if(x() == ioniserReadsLayout) layoutPlot(summaryData, attribute = "nreads")
    else if(x() == ioniserBasesLayout) layoutPlot(summaryData, attribute = "kb")
  })
  desc <- reactive({
    fileName <- gsub(" ", "", paste("plot_descriptions/", gsub(" ", "_", x()), step=""))
    readChar(fileName, file.info(fileName)$size)
  })
  
  output$plotIoniser <- renderPlot({ y() })
  output$plotDescription <- renderText(desc())
}

# Run the application 
shinyApp(ui = ui, server = server)

