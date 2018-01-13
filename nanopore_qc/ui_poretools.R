tabPoretools <- tabPanel("poretools",
             value = "poretools",
             sidebarLayout(
               sidebarPanel(width = 2,
                 fileInput("poretoolsDir", "Choose FAST5 files", multiple = TRUE),
                 # Horizontal line ----
                 tags$hr(),
                 selectInput(inputId = "poretoolsPlotSelect", 
                             label = "Select plot", 
                             choices = poretoolsSelectList),
                 tags$hr(),
                 actionButton("poretoolsPlotButton", "Generate plot", width = "100%"),
                 tags$hr(),
                 selectInput(inputId = "poretoolsStatSelect", 
                             label = "Select statistics", 
                             choices = poretoolsSelectListStat),
                 tags$hr(),
                 actionButton("poretoolsStatButton", "Generate statistics", width = "100%")
               ),
               mainPanel(
                 h4(textOutput(outputId = "poretoolsDescription")),
                 tags$hr(),
                 hidden(
                   tags$img(id = "loadingImage", src = "loading.gif")
                 ),
                 imageOutput(outputId = "poretoolsPlot", height = "640px"),
                 tableOutput(outputId = "poretoolsTable"))))