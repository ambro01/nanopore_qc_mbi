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
source('server_poretools.R')

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
    output$plotDescription <- renderText(descIoniser)
  })
  
  ############ pore ###########
  
  observeEvent(ignoreNULL = TRUE, eventExpr = input$poreDir, handlerExpr = {
    # odpowiada wylacznie za uaktualnianie sciezki katalogu
    if (input$poreDir > 0) {
      path <- choose.dir(default = readDirectoryInput(session, 'poreDir'))
      updateDirectoryInput(session, 'poreDir', value = path)
    }
  })
  
  observeEvent(ignoreNULL = TRUE, eventExpr = input$poreButton, handlerExpr = {
    dirPath <- readDirectoryInput(session, 'poreDir')
    # by <<- variable is also visible outside the function
    poreSummaryData <- if (isValid(dirPath)){
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
      }
    }
    
    descPore <- generatePoreDescription(poreSelectedMethod)
    
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
  
  ############ poretools ###########
  
  observeEvent(ignoreNULL = TRUE, eventExpr = input$poretoolsDir, handlerExpr = {
    # odpowiada wylacznie za uaktualnianie sciezki katalogu
    if (input$poretoolsDir > 0) {
      path <- choose.dir(default = readDirectoryInput(session, 'poretoolsDir'))
      updateDirectoryInput(session, 'poretoolsDir', value = path)
    }
  })
  
  observeEvent(ignoreNULL = TRUE, eventExpr = input$poretoolsButton, handlerExpr = {
    dirPath <- readDirectoryInput(session, 'poretoolsDir')
    poretoolsSelectedMethod <- input$poretoolsSelect
    yPoretools <- if (isValid(dirPath) && isValid(poretoolsSelectedMethod)){
      generatePoretoolsPlotByFunctionName(poretoolsSelectedMethod, dirPath)
    }
    
    descPore <- generatePoretoolsDescription(poretoolsSelectedMethod)
    
    hide("tablePoretools")
    show("plotPoretools")
    
    output$plotPoretools <- renderImage({
      filename <- normalizePath(file.path('./images', 'foo.png'))
      
      # Return a list containing the filename and alt text
      list(src = filename,
           alt = "Image could not be loaded")
      
    }, deleteFile = TRUE)

    output$poretoolsPlotDescription <- renderText(descPore)
  })
  
  observeEvent(ignoreNULL = TRUE, eventExpr = input$poretoolsStatButton, handlerExpr = {
    dirPath <- readDirectoryInput(session, 'poretoolsDir')
    poretoolsSelectedMethod <- input$poretoolsSelectStat
    poretoolsStat <- if (isValid(dirPath) && isValid(poretoolsSelectedMethod)){
      generatePoretoolsStatByFunctionName(poretoolsSelectedMethod, dirPath)
    }
    hide("plotPoretools")
    hide("poretoolsPlotDescription")
    show("tablePoretools")
    
    output$tablePoretools <- renderTable(poretoolsStat)
  })
}