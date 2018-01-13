#!/bin/sh

Rscript -e "library('shiny')"
Rscript -e "shiny::runApp('/srv/shiny-server/nanopore_qc/', host = '172.17.0.2', port = 8080, launch.browser = FALSE)"
