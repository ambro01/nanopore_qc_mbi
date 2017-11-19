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
ioniserBaseProductionRate = "Base production rate"
ioniserReadsLayout = "Reads layout"
ioniserBasesLayout = "Bases layout"

ioniserSelectList <- c("", 
                       ioniserReadAccumulation, 
                       ioniserActiveChannels, 
                       ioniserReadCategoryCounts,
                       ioniserReadCategoryQuals,
                       ioniserEventRate,
                       ioniserBaseProductionRate,
                       ioniserReadsLayout,
                       ioniserBasesLayout)

#fast5files <- list.files(path = "/path/to/data/", pattern = ".fast5$", full.names = TRUE)
#data <- readFast5Summary( fast5files )
data = s.typhi.rep1

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
    if(x() == ioniserReadAccumulation) plotReadAccumulation(data)
    else if(x() == ioniserActiveChannels) plotActiveChannels(data)
    else if(x() == ioniserReadCategoryCounts) plotReadCategoryCounts(data)
    else if(x() == ioniserReadCategoryQuals) plotReadCategoryQuals(data)
    else if(x() == ioniserEventRate) plotEventRate(data)
    else if(x() == ioniserBaseProductionRate) plotBaseProductionRate(data)
    else if(x() == ioniserReadsLayout) layoutPlot(data, attribute = "nreads")
    else if(x() == ioniserBasesLayout) layoutPlot(data, attribute = "kb")
  })
  desc <- reactive({
    fileName <- gsub(" ", "", paste("plot_descriptions/", gsub(" ", "_", x()), step=""))
    #fileName <- "plot_descriptions/Read_accumulation"
    readChar(fileName, file.info(fileName)$size)
  })
  
  output$plotIoniser <- renderPlot({ y() })
  output$plotDescription <- renderText(desc())
}

# Run the application 
shinyApp(ui = ui, server = server)

