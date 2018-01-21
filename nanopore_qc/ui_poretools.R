tabPoretools <- tabPanel("poreTools",
             value = "poreTools",
               mainPanel(
                 h4(textOutput(outputId = "poretoolsDescription")),
                 tags$hr(),
                 hidden(
                   tags$img(id = "loadingImage", src = "loading.gif")
                 ),
                 imageOutput(outputId = "poretoolsPlot", height = "640px"),
                 tableOutput(outputId = "poretoolsTable")))