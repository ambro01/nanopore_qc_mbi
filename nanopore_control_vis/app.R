library(shiny)
library(IONiseR)
library(ggplot2)
library(gridExtra)
library(minionSummaryData)

ioniserReadAccumulation = "Read accumulation"

ioniserSelectList <- c("",ioniserReadAccumulation)

ui <- fluidPage(
  ui <- navbarPage(
    "Control analyses of DNA data from MinION seqencer",
    id = "navbar",
    tabPanel("IONiser", 
             value = "ioniser",
             selectInput(inputId = "ioniserSelect", 
                         label = "Select control process", 
                         choices = ioniserSelectList),
             h3("xxx"),
             plotOutput(outputId = "plotIoniserReadsInTime", width = "400px", height = "400px"),
             textOutput(outputId = "text1")),
    
    tabPanel("poRe"), 
    tabPanel("xxx")
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  x <- reactive(input$ioniserSelect)
  y <- reactive( if (x()==ioniserReadAccumulation) plotReadAccumulation(s.typhi.rep1))
  
  p <- plotReadAccumulation(s.typhi.rep1)
  
  data(s.typhi.rep1)
  baseCalled(s.typhi.rep1)

  output$plotIoniserReadsInTime <- renderPlot({
    y()
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)