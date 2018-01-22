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
  
  # ponizej operacje ktore dzieja sie po przejsciu na inna zakladke
  toolName <- NULL
  observeEvent(ignoreNULL = TRUE, eventExpr = input$navbar, handlerExpr = {
    toolName <<- input$navbar
    print(toolName)
    description <- generateProgramDescription(toolName)
    if(toolName == "IONiseR"){
      updateSelectInput(session, "plotSelect", choices = ioniserPlotSelectList)
      updateSelectInput(session, "statSelect", choices = ioniserStatSelectList)
      updateRadioButtons(session, "dataSource", choices = ioniserDataChoiceList)
      hide("ioniserTable")
      hide("ioniserPlot")
      show("ioniserDescription")
      output$ioniserDescription <- renderText(description)
    } else if(toolName == "poRe"){
      updateSelectInput(session, "plotSelect", choices = porePlotSelectList)
      updateSelectInput(session, "statSelect", choices = poreStatSelectList)
      updateRadioButtons(session, "dataSource", choices = poreDataChoiceList)
      hide("poreTable")
      hide("porePlot")
      show("poreDescription")
      output$poreDescription <- renderText(description)
    } else if(toolName == "poreTools"){
      updateSelectInput(session, "plotSelect", choices = poretoolsPlotSelectList)
      updateSelectInput(session, "statSelect", choices = poretoolsStatSelectList)
      updateRadioButtons(session, "dataSource", choices = poretoolsDataChoiceList)
      hide("poretoolsTable")
      hide("poretoolsPlot")
      show("poretoolsDescription")
      output$poretoolsDescription <- renderText(description)
    }
  })
  
  # zaczytywanie sciezek wskazanych plikow
  dataSource <- NULL
  dataPath <- NULL
  dirPath <- NULL
  summaryData <- NULL
  
  # wybor danych w zaleznosci od obecnie wybranego narzedzia
  observeEvent(ignoreNULL = TRUE, eventExpr = c(input$fileInput, input$dataSource, input$navbar), handlerExpr = {
    dataSource <<- input$dataSource
    dataPath <<- input$fileInput$datapath
    if(!is.null(dataPath)){
      dirPath <<- dirname(input$fileInput$datapath)
    }
    if(toolName == "IONiseR"){
      # by <<- variable is also visible outside the function
      summaryData <<- (
        if (isValid(dataSource)){
          getSummaryData(dataSource, dataPath) 
        })
    } else if(toolName == "poRe"){
      show("fileLoading")
      summaryData <<- if (isValid(dirPath)){
        getPoreData(dirPath)
      }
      hide("fileLoading")
    } else if(toolName == "poreTools"){
    }
  })
  
  # wszystko co ponizej wykona sie po wcisnieciu przycisku 'generate plot'
  observeEvent(ignoreNULL = TRUE, eventExpr = input$plotButton, handlerExpr = {
    
    selectedMethod <- input$plotSelect
    
    if(toolName == "IONiseR"){
      hide("ioniserTable")
      hide("ioniserPlot")
      hide("ioniserDescription")
      show("loadingImage")
      
      #dane wejciowe moga zostac zaczytane z plikow lub z biblioteki 
  
      # to wybranej metody generuje sie wykres i opis
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
    } else if (toolName == "poRe"){
      hide("poreDescription")
      hide("poreTable")
      hide("porePlot")
      show("loadingImage")
      
      plot <- if (isValid(summaryData) && isValid(selectedMethod)){
        generatePorePlotByFunctionName(selectedMethod, summaryData)
      } else NULL
      
      description <- generatePoreDescription(selectedMethod, plot)
      
      hide("loadingImage")
      hide("poreTable")
      show("poreDescription")
      show("porePlot")
      
      output$porePlot <- plot
      output$poreDescription <- renderText(description)
    } else if (toolName == "poreTools"){
      hide("poretoolsDescription")
      hide("poretoolsTable")
      hide("poretoolsPlot")
      show("loadingImage")
      
      plot <- if (isValid(dirPath) && isValid(selectedMethod)){
        generatePoretoolsPlotByFunctionName(selectedMethod, dirPath)
      }
      
      description <- generatePoretoolsDescription(selectedMethod, plot)
      
      hide("loadingImage")
      hide("poretoolsTable")
      show("poretoolsDescription")
      show("poretoolsPlot")
      
      output$poretoolsPlot <- renderImage({
        filename <- base::normalizePath(file.path('./images', 'foo.png'))
        # Return a list containing the filename and alt text
        list(src = filename)
      }, deleteFile = TRUE)
      
      output$poretoolsDescription <- renderText(description)
    }
  })
  
  # wszystko co ponizej wykona sie po wcisnieciu przycisku 'generate stat'
  observeEvent(ignoreNULL = TRUE, eventExpr = input$statButton, handlerExpr = {
    
    selectedMethod <- input$statSelect
    
    if (toolName == "IONiseR"){
      hide("ioniserDescription")
      hide("ioniserTable")
      hide("ioniserPlot")
      show("loadingImage")
      
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
    } else if (toolName == "poRe"){
      hide("poreDescription")
      hide("poreTable")
      hide("porePlot")
      show("loadingImage")
      
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
    } else if (toolName == "poreTools"){
      hide("poretoolsDescription")
      hide("poretoolsTable")
      hide("poretoolsPlot")
      show("loadingImage")
      
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
    }
  })
  
}
