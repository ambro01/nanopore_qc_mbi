library(shiny)
library(shinyjs)
library(shinyFiles)

source('global.R')
source('ui_ioniser.R')
source('ui_pore.R')
source('ui_poretools.R')

ui <- fluidPage(
  useShinyjs(),
  navbarPage(
    "Control analyses of DNA data from MinION seqencer",
    id = "navbar",
    tabIoniser,
    tabPore,
    tabPoretools
  )
)
