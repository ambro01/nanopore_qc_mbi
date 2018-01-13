library(IONiseR)
library(minionSummaryData)
library(ggplot2)
library(gridExtra)
library(poRe)

source('global.R')
source('ui.R')
source('server_ioniser.R')
source('server_pore.R')
source('server_poretools.R')

server <- function(input, output, session) {

  # wszystko co laczy sie z odczytywanie stanu kontrolek na widoku musi byc zawarte w blokach
  # oberwatora (jak ponizej) lub w blokach reactive()
  
  observeEvent(ignoreNULL = TRUE, eventExpr = input$navbar, handlerExpr = {
    name <- input$navbar
    description <- generateProgramDescription(name)
    if(name == "ioniser"){
      hide("ioniserTable")
      hide("ioniserPlot")
      show("ioniserDescription")
      output$ioniserDescription <- renderText(description)
    } else if(name == "pore"){
      hide("poreTable")
      hide("porePlot")
      show("poreDescription")
      output$poreDescription <- renderText(description)
    } else if(name == "poretools"){
      hide("poretoolsTable")
      hide("poretoolsPlot")
      show("poretoolsDescription")
      output$poretoolsDescription <- renderText(description)
    }
  })
  
  ############ ioniser ###########
  
  # wybor zrodla danych
  dataSource <- NULL
  observeEvent(ignoreNULL = TRUE, eventExpr = input$ioniserRadio, handlerExpr = {
    dataSource <<- input$ioniserRadio
  })
  
  # zaczytywanie sciezek wskazanych plikow
  dataPath <- NULL
  observeEvent(ignoreNULL = TRUE, eventExpr = input$ioniserFile, handlerExpr = {
    dataPath <<- input$ioniserFile$datapath
  })
  
  # wszystko co ponizej wykona sie po wcisnieciu przycisku 'generate plot'
  observeEvent(ignoreNULL = TRUE, eventExpr = input$ioniserPlotButton, handlerExpr = {
    hide("ioniserTable")
    hide("ioniserPlot")
    hide("ioniserDescription")
    show("loadingImage")
    
    #dane wejciowe moga zostac zaczytane z plikow lub z biblioteki 
    summaryData <- (
      if (isValid(dataSource)){
        getSummaryData(dataSource, dataPath) 
      })
    # to wybranej metody generuje sie wykres i opis
    selectedMethod <- input$ioniserPlotSelect
    plot <- if (isValid(summaryData) && isValid(selectedMethod)){
        generateIoniserPlotByFunctionName(selectedMethod, summaryData)
      }
    description <- generateIoniserDescription(selectedMethod, plot)
    
    hide("loadingImage")
    hide("ioniserTable")
    show("ioniserDescription")
    show("ioniserPlot")
    
    # ustawienie wartosci wyjsc
    output$ioniserPlot <- renderPlot(plot)
    output$ioniserDescription <- renderText(description)
  })
  
  # wszystko co ponizej wykona sie po wcisnieciu przycisku 'generate stat'
  observeEvent(ignoreNULL = TRUE, eventExpr = input$ioniserStatButton, handlerExpr = {
    hide("ioniserDescription")
    hide("ioniserTable")
    hide("ioniserPlot")
    show("loadingImage")
    
    summaryData <- (
      if (isValid(dataSource)){
        getSummaryData(dataSource, dataPath) 
      })
    
    selectedMethod <- input$ioniserStatSelect
    stat <- if (isValid(summaryData) && isValid(selectedMethod)){
      generateIoniserStatByFunctionName(selectedMethod, summaryData)
    }
    description <- generateIoniserDescription(selectedMethod, stat)
    
    hide("loadingImage")
    hide("ioniserPlot")
    show("ioniserDescription")
    show("ioniserTable")
    
    output$ioniserTable <- renderTable(stat)
    output$ioniserDescription <- renderText(description)
  })
  
  ############ pore ###########
  
  # wszystko co ponizej wykona sie po wcisnieciu przycisku 'generate plot'
  summaryData <- NULL

  observeEvent(ignoreNULL = TRUE, eventExpr = input$poreDir, handlerExpr = {
    # odpowiada wylacznie za uaktualnianie sciezki katalogu
    path <<- dirname(input$poreDir$datapath)
      # by <<- variable is also visible outside the function
    show("fileLoading")
    summaryData <<- if (isValid(path)){
      getPoreData(path)
    }
      hide("fileLoading")
  })
  
  observeEvent(ignoreNULL = TRUE, eventExpr = input$porePlotButton, handlerExpr = {
    hide("poreDescription")
    hide("poreTable")
    hide("porePlot")
    show("loadingImage")
    
    selectedMethod <- input$porePlotSelect
    plot <- if (isValid(summaryData) && isValid(selectedMethod)){
        generatePorePlotByFunctionName(selectedMethod, summaryData)
    } else NULL
    
    description <- generatePoreDescription(selectedMethod, plot)
    
    hide("loadingImage")
    hide("poreTable")
    show("poreDescription")
    show("porePlot")
    
    output$porePlot <- renderPlot(replayPlot(plot))
    output$poreDescription <- renderText(description)
  })
  
  # wszystko co ponizej wykona sie po wcisnieciu przycisku 'generate stat'
  observeEvent(ignoreNULL = TRUE, eventExpr = input$poreStatButton, handlerExpr = {
    hide("poreDescription")
    hide("poreTable")
    hide("porePlot")
    show("loadingImage")
    
    selectedMethod <- input$poreStatSelect
    stat <- if (isValid(summaryData) && isValid(selectedMethod)){
      generatePoreStatByFunctionName(selectedMethod, summaryData)
    }
    description <- generatePoreDescription(selectedMethod, stat)
    
    hide("loadingImage")
    hide("porePlot")
    show("poreDescription")
    show("poreTable")
    
    output$poreTable <- renderTable(stat)
    output$poreDescription <- renderText(description)
  })
  
  ############ poretools ###########
  
  # wszystko co ponizej wykona sie po wcisnieciu przycisku 'generate plot'
  dirPath <- NULL
  observeEvent(ignoreNULL = TRUE, eventExpr = input$poretoolsDir, handlerExpr = {
    # odpowiada wylacznie za uaktualnianie sciezki katalogu
    dirPath <<- dirname(input$poretoolsDir$datapath)
  })
  
  observeEvent(ignoreNULL = TRUE, eventExpr = input$poretoolsPlotButton, handlerExpr = {
    hide("poretoolsDescription")
    hide("poretoolsTable")
    hide("poretoolsPlot")
    show("loadingImage")
    
    selectedMethod <- input$poretoolsPlotSelect
    
    plot <- if (isValid(dirPath) && isValid(selectedMethod)){
      generatePoretoolsPlotByFunctionName(selectedMethod, dirPath)
    }
    
    description <- generatePoretoolsDescription(selectedMethod, plot)
    
    hide("loadingImage")
    hide("poretoolsTable")
    show("poretoolsDescription")
    show("poretoolsPlot")
    
    output$poretoolsPlot <- renderImage({
      filename <- normalizePath(file.path('./images', 'foo.png'))
      # Return a list containing the filename and alt text
      list(src = filename)
    }, deleteFile = TRUE)

    output$poretoolsDescription <- renderText(description)
  })
  
  # wszystko co ponizej wykona sie po wcisnieciu przycisku 'generate stat'
  observeEvent(ignoreNULL = TRUE, eventExpr = input$poretoolsStatButton, handlerExpr = {
    hide("poretoolsDescription")
    hide("poretoolsTable")
    hide("poretoolsPlot")
    show("loadingImage")
    
    selectedMethod <- input$poretoolsStatSelect
    
    stat <- if (isValid(dirPath) && isValid(selectedMethod)){
      generatePoretoolsStatByFunctionName(selectedMethod, dirPath)
    }
    descrption <- generatePoretoolsDescription(selectedMethod, stat)
    
    hide("loadingImage")
    hide("poretoolsPlot")
    show("poretoolsDescription")
    show("poretoolsTable")
    
    output$poretoolsTable <- renderTable(stat)
    output$poretoolsDescription <- renderText(descrption)
  })
}
