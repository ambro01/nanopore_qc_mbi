library(IONiseR)
library(minionSummaryData)
library(ggplot2)
library(gridExtra)
library(poRe)
library(ggplot2)

source('global.R')
source('ui.R')
source('server_ioniser.R')
source('server_pore.R')

server <- function(input, output, session) {
  
  # wszystko co laczy sie z odczytywanie stanu kontrolek na widoku musi wyc zawarte w blokach
  # oberwatora (jak ponizej) lub w blokach reactive()
  
  ############ ioniser ###########
  # wszystko co ponizej wykona sie po wcisnieciu przycisku 'generate'
  observeEvent(ignoreNULL = TRUE, eventExpr = input$ioniserButton, handlerExpr = {
    # zaczytywanie wartosci zmiennych wejsciowych
    dataSource <- input$ioniserRadio
    dataPath <- input$ioniserFile$datapath
    
    #dane wejciowe moga zostac zaczytane z plikow lub z biblioteki 
    summaryData <- (
      if (isValid(dataSource)){
        getSummaryData(dataSource, dataPath) 
      })
    # to wybranej metody generuje sie wykres i opis
    selectedMethod <- input$ioniserSelect
    yIoniser <- if (isValid(summaryData) && isValid(selectedMethod)){
        generatePlotByFunctionName(selectedMethod, summaryData)
      }
    descIoniser <- generateDescription(selectedMethod)
    
    # ustawienie wartosci wyjsc
    output$plotIoniser <- renderPlot(yIoniser)
    output$ioniserPlotDescription <- renderText(descIoniser)
  })
  
  ############ pore ###########
  
  observeEvent(ignoreNULL = TRUE, eventExpr = input$poreDir, handlerExpr = {
    # odpowiada wylacznie za uaktualnianie sciezki katalogu
    if (input$poreDir > 0) {
      path = choose.dir(default = readDirectoryInput(session, 'poreDir'))
      updateDirectoryInput(session, 'poreDir', value = path)
    }
  })
  
  poreSummaryData <- NULL
  observeEvent(ignoreNULL = TRUE, eventExpr = input$poreButton, handlerExpr = {
    dirPath <- readDirectoryInput(session, 'poreDir')
    # by <<- variable is also visible outside the function
    poreSummaryData <<- if (isValid(dirPath)){
      getPoreData(dirPath)
    }
  })
  
  observeEvent(ignoreNULL = TRUE, eventExpr = input$poreButton, handlerExpr = {
    print(poreSummaryData)
    poreSelectedMethod <- input$poreSelect
    yPore <- if (isValid(poreSummaryData) && isValid(poreSelectedMethod)){
        generatePorePlotByFunctionName(poreSelectedMethod, poreSummaryData)
    }
    
    descPore <- generateDescription(poreSelectedMethod)
    
    hide("tablePore")
    show("plotPore")
    
    output$plotPore <- renderPlot(replayPlot(yPore))
    output$porePlotDescription <- renderText(descPore)
  })
  
  observeEvent(ignoreNULL = TRUE, eventExpr = input$poreStatButton, handlerExpr = {
    poreSelectedMethod <- input$poreSelectStat
    poreStat <- if (isValid(poreSummaryData) && isValid(poreSelectedMethod)){
      generatePoreStatByFunctionName(poreSelectedMethod, poreSummaryData)
    }
    
    hide("plotPore")
    hide("porePlotDescription")
    show("tablePore")
    
    output$tablePore <- renderTable(poreStat)
  })
}