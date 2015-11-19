# Author : Duncan P
# Global variables for nominateGene Shiny application.

library(synapseClient)
library(shinythemes)
synapseLogin()
tableId <- 'syn5260108'
cols <- synGetColumns(tableId)
