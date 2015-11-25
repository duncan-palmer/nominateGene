# Author : Duncan P.
# shiny server code for nominateGene form. 
# Function for generating a form for single gene submission!
singleForm <- function(i){	
		type <- cols[[i]]$columnType
		name <- cols[[i]]$name
		id <- paste0('id',name) 

		if(type == 'STRING' | type == 'ENTITYID' | type == 'LINK'){
			if(length(cols[[i]]$enumValues) > 0){
				return(renderUI({
					selectInput(id,name,choices=cols[[i]]$enumValues,selected=cols[[i]]$enumValues[1])}
				))}
			else{
				return(renderUI({
					textInput(id,paste(name),value='')})
			)}}
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
shinyServer(
	function(input,output){
		# Call renderUI for number of columns in table, with type of input box generated dependent on data type of column.
		lapply(1:length(cols),function(i){output[[paste0('entry',i)]] <- singleForm(i)})	
		output$submit <- renderUI({actionButton('formSubmit','Submit')})

		observeEvent(input$formSubmit,{
			withProgress(message='Uploading Gene Nomination(s)',{
			# Get TableColumnList object and populate one row data frame with entries from form, set up colsId vector which 
			# contains column I.D.'s of synapse table form is uploaded to.  
			colsId <- as.numeric(length(cols))
			for(i in 1:length(cols)){colsId[i] <- cols[[i]]$id}
				schema <- TableSchema(name='genes',parent='syn5051764',columns=colsId)
				df <- data.frame(matrix(,nrow=1,ncol=0))
				for(i in 1:length(cols)){
					if(cols[[i]]$columnType == 'INTEGER'){value <- as.numeric(input[[paste0('id',cols[[i]]$name)]])}
					else{value <- input[[paste0('id',cols[[i]]$name)]]}
					df[[cols[[i]]$name]] <- value}
					print(df)
					row_to_add <- synapseClient::Table(schema,df)
					table <- synStore(row_to_add, retrieveData=TRUE)}

)})})		
