# Author : Duncan P.
# Shiny UI code for nominateGene form. 
shinyUI(fluidPage(theme=shinytheme('flatly'),
		sidebarLayout(
		sidebarPanel(helpText(paste('Synapse Table',tableId,sep=' '))),
		mainPanel(
		# Loop to output all entry fields of form, which are renderUI objects. 	
		lapply(1:(length(cols)), function(i){uiOutput(paste0('entry',i))}),
		uiOutput('submit'))
		)))
