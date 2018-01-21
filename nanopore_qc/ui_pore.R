tabPore <- tabPanel("poRe",
             value = "poRe",
               mainPanel(
                 h4(textOutput(outputId = "poreDescription")),
                 tags$hr(),
                 hidden(
                   tags$img(id = "loadingImage", src = "loading.gif")
                 ),
                 plotOutput(outputId = "porePlot", height = "640px"),
                 tableOutput(outputId = "poreTable")))