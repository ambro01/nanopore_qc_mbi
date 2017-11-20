library(shiny)
library(IONiseR)
library(ggplot2)
library(gridExtra)
library(minionSummaryData)
library(stringr)

# names of drawings
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

#fast5files <- list.files(path = "/path/to/data/", pattern = ".fast5$", full.names = TRUE)
#data <- readFast5Summary( fast5files )
#data(s.typhi.rep1)
#summaryData = s.typhi.rep1

ui <- fluidPage(
    ui <- navbarPage(
    "Control analyses of DNA data from MinION seqencer",
    id = "navbar",
    tabPanel("IONiser", 
             value = "ioniser",
             # Sidebar layout with input and output definitions ----
             sidebarLayout(
               sidebarPanel(
                 radioButtons("ioniserRadio", "Choose data source",
                              choices = ioniserRadioList,
                              selected = "Files from disc"),
                 fileInput("ioniserFile", "Choose FAST5 files",
                           multiple = TRUE,
                           accept = c(".fast5")),
                 # Horizontal line ----
                 tags$hr(),
                 selectInput(inputId = "ioniserSelect", 
                             label = "Select control process", 
                             choices = ioniserSelectList),
                 tags$hr(),
                 actionButton("ioniserButton", "Generate", width = "280px")
               ),
               
             mainPanel(
               h4(textOutput(outputId = "plotDescription")),
               tags$hr(),
               plotOutput(outputId = "plotIoniser", width = "600px", height = "400px")))),
    tabPanel("poRe"), 
    tabPanel("xxx")
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  dataSource <- reactive({input$ioniserRadio})
  
  summaryData <- reactive({
      if(dataSource() == 1) readFast5Summary(input$ioniserFile$datapath)
      else if(dataSource() == 2){
        data(s.typhi.rep1) 
        return(s.typhi.rep1)
      } else if(dataSource() == 3){
        data(s.typhi.rep2) 
        return(s.typhi.rep2)
      } else if(dataSource() == 4){
        data(s.typhi.rep3) 
        return(s.typhi.rep3)
      }
    })

    x <- reactive(input$ioniserSelect)
    y <- reactive({
      if(x() == ioniserReadAccumulation) plotReadAccumulation(summaryData())
      else if(x() == ioniserActiveChannels) plotActiveChannels(summaryData())
      else if(x() == ioniserReadCategoryCounts) plotReadCategoryCounts(summaryData())
      else if(x() == ioniserReadCategoryQuals) plotReadCategoryQuals(summaryData())
      else if(x() == ioniserEventRate) plotEventRate(summaryData())
      else if(x() == ioniserBaseProductionRate) plotBaseProductionRate(summaryData())
      else if(x() == ioniserReadTypeProduction) plotReadTypeProduction(summaryData())
      else if(x() == ioniserCurrentByTime) plotCurrentByTime(summaryData())
      else if(x() == ioniserReadsLayout) layoutPlot(summaryData(), attribute = "nreads")
      else if(x() == ioniserBasesLayout) layoutPlot(summaryData(), attribute = "kb")
    })
    desc <- reactive({
      if (x() != ioniserNone){
        fileName <- gsub(" ", "", paste("plot_descriptions/", gsub(" ", "_", x()), step=""))
        readChar(fileName, file.info(fileName)$size)
      }
    })
    
    observeEvent(input$ioniserButton,{
      drawing <- y()
      description <- desc()
      output$plotIoniser <- renderPlot(drawing)
      output$plotDescription <- renderText(description)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

