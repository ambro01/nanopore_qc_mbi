source('global.R')
source('css.R')

tabIoniser <- tabPanel("IONiseR", 
               value = "IONiseR",
               # Sidebar layout with input and output definitions ----
               
                 mainPanel(
                   h4(textOutput(outputId = "ioniserDescription")),
                   tags$hr(),
                   hidden(
                    tags$img(id = "loadingImage", src = "loading.gif")
                   ),
                   plotOutput(outputId = "ioniserPlot", height = "640px"),
                   tableOutput(outputId = "ioniserTable")))
