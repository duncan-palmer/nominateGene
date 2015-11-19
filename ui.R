# Author : Duncan P.
# Shiny UI code for nominateGene form. 

shinyUI(fluidPage(theme=shinytheme('flatly'),
	sidebarLayout(

	      sidebarPanel(h1('Gene Nomination'),br(),
		# Radio buttons html widget for selecting type of upload, single or group.
		radioButtons('choice',label='Single or Group Upload?',choices = list('Single' = 1,'Group' = 2), selected = 2)
		), 

	      mainPanel(
		# Loop to output all entry fields of form, which are renderUI objects. 	
			uiOutput('uploadType'),
			lapply(1:(length(cols)), function(i){uiOutput(paste0('entry',i))}),
			uiOutput('submit')
			))
))


