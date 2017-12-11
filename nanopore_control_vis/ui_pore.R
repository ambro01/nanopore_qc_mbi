tabPore <- tabPanel("poRe",
             value = "tabPore",
             sidebarLayout(
               sidebarPanel(width = 2,
                 directoryInput("poreDir", "Choose FAST5 dir", value = '~'),
                 actionButton("poreLoadDataButton", "Load data", width = "100%"),
                 # Horizontal line ----
                 tags$hr(),
                 selectInput(inputId = "poreSelect", 
                             label = "Select plot", 
                             choices = poreSelectList),
                 tags$hr(),
                 actionButton("poreButton", "Generate plot", width = "100%"),
                 tags$hr(),
                 selectInput(inputId = "poreSelectStat", 
                             label = "Select statistics", 
                             choices = poreSelectListStat),
                 tags$hr(),
                 actionButton("poreStatButton", "Generate statistics", width = "100%")
               ),
               mainPanel(
                 h4(textOutput(outputId = "porePlotDescription")),
                 tags$hr(),
                 plotOutput(outputId = "plotPore", width = "100%"),
                 tableOutput(outputId = "tablePore"))))