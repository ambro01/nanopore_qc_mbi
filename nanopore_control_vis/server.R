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
  
  observeEvent(
    ignoreNULL = TRUE,
    eventExpr = {
      input$poreDir
    },
    handlerExpr = {
      if (input$poreDir > 0) {
        # condition prevents handler execution on initial app launch
        
        # launch the directory selection dialog with initial path read from the widget
        path = choose.dir(default = readDirectoryInput(session, 'directory'))
        
        # update the widget value
        updateDirectoryInput(session, 'directory', value = path)
      }
    }
  )
}