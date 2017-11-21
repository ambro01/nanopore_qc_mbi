tabPore <- tabPanel("poRe",
             value = "tabPore",
             sidebarLayout(
               sidebarPanel(
                 directoryInput("poreDir", "Choose FAST5 dir", value = '~'),
                 # Horizontal line ----
                 tags$hr(),
                 selectInput(inputId = "poreSelect", 
                             label = "Select control method", 
                             choices = poreSelectList),
                 tags$hr(),
                 actionButton("poreButton", "Generate", width = "100%")
               ),
               mainPanel(
                 h4(textOutput(outputId = "porePlotDescription")),
                 tags$hr(),
                 plotOutput(outputId = "plotPore", width = "600px", height = "400px"))))
