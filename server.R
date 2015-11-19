# Author : Duncan P.
# shiny server code for nominateGene form. 

# Function for generating a form for single gene submission!
singleForm <- function(i){	
		type <- cols[[i]]$columnType
		name <- cols[[i]]$name
		id <- paste0('id',name) 

		if(name == 'comment'){
			return(renderUI({
				tags$textarea(placeholder='Description',id='idcomment',rows=6,cols=35)})
				)}

		else if(type == 'STRING' | type == 'ENTITYID' | type == 'LINK'){
			if(length(cols[[i]]$enumValues) > 0){
				return(renderUI({
					selectInput(id,name,choices=cols[[i]]$enumValues,selected=cols[[i]]$enumValues[1])}
				))}
			else{
				return(renderUI({
					textInput(id,paste(name),value='')})
			)}}
		if(name == 'vote'){return(renderUI({}))}

		else if(type == 'INTEGER' | type == 'DOUBLE'){
			if(length(cols[[i]]$enumValues) > 0){
				return(renderUI({selectInput(id,name,choices=cols[[i]]$enumValues,selected=cols[[i]]$enumValues[2])}
				))}
			else{
			return(renderUI({
				numericInput(id,paste(name,'-',type),value=1)
			}))}}

		if(type == 'BOOLEAN'){
			return(renderUI({
				checkboxInput(id,name)
			}))}

		if(type == 'DATE'){
			return(renderUI({
				dateInput(id,name)
			}))}

		if(type == 'FILEHANDLEID'){
			return(renderUI({
				fileInput(id,name)})
			)}}

# Function to generate form for Group submission!
GroupForm <- function(i){
		if(i == 1){
			return(renderUI({
				fileInput('Group','Select File',accept='text/csv')}))}

		else if(i==2){
			return(renderUI({
				radioButtons('separator','Separator',choices = list('TSV' = '\t', 'CSV' = ','))}))}

		else if(i ==3){
			return(renderUI({
				checkboxInput('header','Header')}))}

		else{return(renderUI({}))}
			}

shinyServer(
	function(input,output){
		# Code ran after submit button pressed
		# Call renderUI for number of columns in table, with type of input box generated dependent on data type of column.
		observeEvent(input$choice,
			if(input$choice == 1){
				output$uploadType <- renderUI({tags$h3('Single Upload')})
				lapply(1:length(cols),function(i){
				output[[paste0('entry',i)]] <- singleForm(i)})}	

			else{
				output$uploadType <- renderUI({tags$h3('Group Upload')})
				lapply(1:length(cols), function(i) {
				output[[paste0('entry',i)]] <- GroupForm(i)})})	

		# Form submit button.
		output$submit <- renderUI({
			actionButton('formSubmit','Submit')
				})

		# Upload form to synapse after user submits. 
		observeEvent(input$formSubmit,{

			# Get TableColumnList object and populate one row data frame with entries from form, set up colsId vector which 
			# contains column I.D.'s of synapse table form is uploaded to.  
			colsId <- as.numeric(length(cols))
			for(i in 1:length(cols)){colsId[i] <- cols[[i]]$id}
			schema <- TableSchema(name='genes',parent='syn5051764',columns=colsId)

			if(input$choice == 1){
				df <- data.frame(matrix(,nrow=1,ncol=0))
			# iteratively add values input through HTML widgets to dataframe which will be used to create table row. 
			# To-Do - process file inputs as necessary to provide compatibility with what synapse expects. Perhaps also error handling. 

				for(i in 1:length(cols)){

					if(cols[[i]]$name == 'vote'){value <- 1}
					else if(cols[[i]]$columnType == 'INTEGER'){value <- as.numeric(input[[paste0('id',cols[[i]]$name)]])}
					else{
					value <- input[[paste0('id',cols[[i]]$name)]]}

					df[[cols[[i]]$name]] <- value
						}

					print(df)
					
					# Define schema with parent project ID of table and columnID vector, create table w/ schema and dataframe, upload table.
					# To-Do : change parentID to not be hardcoded. 

					tableAdd <- synapseClient::Table(schema,df)
					table <- synStore(tableAdd, retrieveData=TRUE)}
			else{
				inFile <- input$Group
				file <- read.table(inFile$datapath,sep=input$separator,quote='',header=input$header)
				if(!input$header){
				#colNames <- c('geneName','nominee','comment')
				colNames <- c('a','b','c')	
				colnames(file) <- colNames}

				print(file)	

				tableAdd <- synapseClient::Table(schema,file)
				table <- synStore(tableAdd, retrieveData=TRUE)

				}
})})		
