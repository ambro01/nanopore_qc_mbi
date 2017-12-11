tabPoretools <- tabPanel("poretools",
             value = "tabPoretools",
             sidebarLayout(
               sidebarPanel(width = 2,
                 directoryInput("poretoolsDir", "Choose FAST5 dir", value = '~'),
                 actionButton("poretoolsLoadDataButton", "Load data", width = "100%"),
                 # Horizontal line ----
                 tags$hr(),
                 selectInput(inputId = "poretoolsSelect", 
                             label = "Select plot", 
                             choices = poretoolsSelectList),
                 tags$hr(),
                 actionButton("poretoolsButton", "Generate plot", width = "100%"),
                 tags$hr(),
                 selectInput(inputId = "poretoolsSelectStat", 
                             label = "Select statistics", 
                             choices = poretoolsSelectListStat),
                 tags$hr(),
                 actionButton("poretoolsStatButton", "Generate statistics", width = "100%")
               ),
               mainPanel(
                 h4(textOutput(outputId = "poretoolsPlotDescription")),
                 tags$hr(),
                 imageOutput(outputId = "plotPoretools", width = "100%"),
                 tableOutput(outputId = "tablePoretools"))))