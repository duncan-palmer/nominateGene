# shiny UI for form application.

shinyUI(fluidPage(

	titlePanel('Synapse Form Submission'),
	sidebarLayout(
		      sidebarPanel(

		      	textInput('tableId','Synapse Table I.D.',value=''),
		      	helpText('Enter the Synapse I.D. of table to upload form to.'),
		      	actionButton('idSubmit','Submit')

		      	),
		      mainPanel(
			lapply(1:length(cols),function(i){

				uiOutput(paste0('entry',i))

							}),

				        uiOutput('button')
				 )
		)	
	)
)

