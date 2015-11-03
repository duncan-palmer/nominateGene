# UI for form submission to synapse table. 

shinyUI(fluidPage(
	titlePanel('Synapse Form Submission'),
	sidebarLayout(
	      sidebarPanel(
		# Box to enter table I.D. with help comment and submit button. 	
		textInput('tableId','Synapse Table I.D.',value=''),
		helpText('Enter the Synapse I.D. of table to upload form to.'),
		actionButton('idSubmit','Submit')
			),
	      mainPanel(
		# Loop to output all entry fields of form, which are renderUI objects. 	
		lapply(1:length(cols),function(i){
			uiOutput(paste0('entry',i))
						}),
				uiOutput('submit')
			 )
		     )	
))

