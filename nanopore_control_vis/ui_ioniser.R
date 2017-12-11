source('global.R')

tabIoniser <- tabPanel("IONiser", 
               value = "tabIoniser",
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
                   selectInput(inputId = "ioniserSelect", 
                               label = "Select plot", 
                               choices = ioniserSelectList),
                   tags$hr(),
                   actionButton("ioniserButton", "Generate", width = "100%"),
                   tags$hr(),
                   selectInput(inputId = "ioniserSelectStat", 
                               label = "Select statistics", 
                               choices = ioniserSelectListStat),
                   tags$hr(),
                   actionButton("ioniserStatButton", "Generate statistics", width = "100%")
                 ),
                 
                 mainPanel(
                   h4(textOutput(outputId = "ioniserPlotDescription")),
                   tags$hr(),
                   plotOutput(outputId = "plotIoniser", width = "100%"),
                   tableOutput(outputId = "tableIoniser"))))