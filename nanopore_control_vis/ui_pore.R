tabPore <- tabPanel("poRe",
             value = "tabPore",
             sidebarLayout(
               sidebarPanel(width = 2,
                 directoryInput("poreDir", "Choose FAST5 dir", value = '~'),
                 hidden(
                   tags$img(id = "fileLoading", src = "file_loading.gif", width = "100%")
                 ),
                 # Horizontal line ----
                 tags$hr(),
                 selectInput(inputId = "porePlotSelect", 
                             label = "Select plot", 
                             choices = poreSelectList),
                 tags$hr(),
                 actionButton("porePlotButton", "Generate plot", width = "100%"),
                 tags$hr(),
                 selectInput(inputId = "poreStatSelect", 
                             label = "Select statistics", 
                             choices = poreSelectListStat),
                 tags$hr(),
                 actionButton("poreStatButton", "Generate statistics", width = "100%")
               ),
               mainPanel(
                 h4(textOutput(outputId = "poreDescription")),
                 tags$hr(),
                 hidden(
                   tags$img(id = "loadingImage", src = "loading.gif")
                 ),
                 plotOutput(outputId = "porePlot", height = "640px"),
                 tableOutput(outputId = "poreTable"))))