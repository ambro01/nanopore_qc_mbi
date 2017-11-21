source('global.R')

tabIoniser <- tabPanel("IONiser", 
               value = "tabIoniser",
               # Sidebar layout with input and output definitions ----
               sidebarLayout(
                 sidebarPanel(
                   radioButtons("ioniserRadio", "Choose data source",
                                choices = ioniserRadioList,
                                selected = "Data set 1"),
                   fileInput("ioniserFile", "Choose FAST5 files",
                             multiple = TRUE,
                             accept = c(".fast5")),
                   # Horizontal line ----
                   tags$hr(),
                   selectInput(inputId = "ioniserSelect", 
                               label = "Select control method", 
                               choices = ioniserSelectList),
                   tags$hr(),
                   actionButton("ioniserButton", "Generate", width = "100%")
                 ),
                 
                 mainPanel(
                   h4(textOutput(outputId = "plotDescription")),
                   tags$hr(),
                   plotOutput(outputId = "plotIoniser", width = "600px", height = "400px"))))