source('global.R')
source('css.R')

tabIoniser <- tabPanel("IONiseR", 
               value = "ioniser",
               # Sidebar layout with input and output definitions ----
               sidebarLayout(
                 sidebarPanel(width = 2,
                   radioButtons("ioniserRadio", "Choose data source",
                                choices = ioniserRadioList,
                                selected = "Data set 1"),
                   fileInput("ioniserFile", "Choose FAST5 files",
                             multiple = TRUE,
                             accept = c(".fast5")),
                   # Horizontal line ----
                   tags$hr(),
                   selectInput(inputId = "ioniserPlotSelect", 
                               label = "Select plot", 
                               choices = ioniserSelectList),
                   tags$hr(),
                   actionButton("ioniserPlotButton", "Generate", width = "100%"),
                   tags$hr(),
                   selectInput(inputId = "ioniserStatSelect", 
                               label = "Select statistics", 
                               choices = ioniserSelectListStat),
                   actionButton("ioniserStatButton", "Generate statistics", width = "100%")
                 ),
                 
                 mainPanel(
                   h4(textOutput(outputId = "ioniserDescription")),
                   tags$hr(),
                   hidden(
                    tags$img(id = "loadingImage", src = "loading.gif")
                   ),
                   plotOutput(outputId = "ioniserPlot", height = "640px"),
                   tableOutput(outputId = "ioniserTable"))))
