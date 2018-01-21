library(shiny)
library(shinyjs)

source('global.R')
source('ui_ioniser.R')
source('ui_pore.R')
source('ui_poretools.R')

ui <- fluidPage(
  useShinyjs(),
  sidebarPanel(width = 2,
               radioButtons("dataSource", "Choose data source",
                            choices = defaultDataChoiceList,
                            selected = 1),
               fileInput("fileInput", "Choose FAST5 files", multiple = TRUE),
               # Horizontal line ----
               tags$hr(),
               selectInput(inputId = "plotSelect", 
                           label = "Select plot",
                           choices = c("---")),
               tags$hr(),
               actionButton("plotButton", "Generate", width = "100%"),
               tags$hr(),
               selectInput(inputId = "statSelect", 
                           label = "Select statistics",
                           choices = c("---")),
               actionButton("statButton", "Generate statistics", width = "100%")
  ),
  
  mainPanel(
    tabsetPanel(id = "navbar",
      tabPanel("IONiseR", tabIoniser), 
      tabPanel("poRe", tabPore), 
      tabPanel("poreTools", tabPoretools)
    )
  )
)

