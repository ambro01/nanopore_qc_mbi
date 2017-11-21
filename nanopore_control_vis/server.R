library(IONiseR)
library(minionSummaryData)
library(ggplot2)
library(gridExtra)
library(poRe)

source('global.R')
source('ui.R')
source('server_ioniser.R')
source('server_pore.R')

server <- function(input, output, session) {
  
  dataSource <- reactive(input$ioniserRadio)
  dataPath <- reactive(input$ioniserFile$datapath)
  
  summaryData <- reactive(
    if (isValid(dataSource())){
      getSummaryData(dataSource(), dataPath())
    })
  
  selectedMethod <- reactive(input$ioniserSelect)
  yIoniser <- reactive(
    if (isValid(summaryData()) && isValid(selectedMethod())){
      generatePlotByFunctionName(selectedMethod(), summaryData())
    })
  
  descIoniser <- reactive(generateDescription(selectedMethod()))
  
  observeEvent(input$ioniserButton,{
    drawing <- yIoniser()
    description <- descIoniser()
    output$plotIoniser <- renderPlot(drawing)
    output$plotDescription <- renderText(description)
  })
  
  dirPath <- reactive(readDirectoryInput(session, 'poreDir'))
  observeEvent(ignoreNULL = TRUE, eventExpr = {
      input$poreDir
    },
    handlerExpr = {
      if (input$poreDir > 0) {
        path = choose.dir(default = readDirectoryInput(session, 'poreDir'))
        updateDirectoryInput(session, 'poreDir', value = path)
      }
    }
  )
  
  
  
  observeEvent(input$poreButton,{
    
    poreSummaryData <- reactive(
      if (isValid(dirPath())){
        getPoreData(dirPath())
      })
    
    poreSelectedMethod <- reactive(input$poreSelect)
    yPore <- reactive(
      if (isValid(poreSummaryData()) && isValid(poreSelectedMethod())){
        generatePorePlotByFunctionName(poreSelectedMethod(), poreSummaryData())
      })
    
    drawingPore <- yPore()
    output$plotPore <- renderPrint(plot.length.histogram(poreSummaryData()))
  })
}