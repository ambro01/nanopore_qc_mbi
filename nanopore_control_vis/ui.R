library(shiny)

source('global.R')
source('ui_ioniser.R')
source('ui_pore.R')

ui <- fluidPage(
  ui <- navbarPage(
    "Control analyses of DNA data from MinION seqencer",
    id = "navbar",
    tabIoniser,
    tabPore,
    tabPanel("xxx")
  )
)
