library(shiny)

ui <- fluidPage(
  ui <- navbarPage(
    "Control analyses of DNA data from MinION seqencer",
    id = "navbar",
    tabPanel("IONiser", 
             value = "ioniser",
             # Sidebar layout with input and output definitions ----
             sidebarLayout(
               sidebarPanel(
                 radioButtons("ioniserRadio", "Choose data source",
                              choices = ioniserRadioList,
                              selected = "Files from disc"),
                 fileInput("ioniserFile", "Choose FAST5 files",
                           multiple = TRUE,
                           accept = c(".fast5")),
                 # Horizontal line ----
                 tags$hr(),
                 selectInput(inputId = "ioniserSelect", 
                             label = "Select control process", 
                             choices = ioniserSelectList),
                 tags$hr(),
                 actionButton("ioniserButton", "Generate", width = "280px")
               ),
               
               mainPanel(
                 h4(textOutput(outputId = "plotDescription")),
                 tags$hr(),
                 plotOutput(outputId = "plotIoniser", width = "600px", height = "400px")))),
    tabPanel("poRe",
             value = "pore",
             sidebarLayout(
               sidebarPanel(
                 directoryInput("poreDir", "Choose FAST5 dir", value = '~'),
                 # Horizontal line ----
                 tags$hr(),
                 selectInput(inputId = "poreSelect", 
                             label = "Select control process", 
                             choices = ioniserSelectList),
                 tags$hr(),
                 actionButton("poreButton", "Generate", width = "280px")
               ),
            mainPanel(
              tags$hr()
            ))),
    tabPanel("xxx")
  )
)