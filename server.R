# server.R file to generate form based off user inputted synapse table I.D.
library(synapseClient)
synapseLogin()

shinyServer(
	function(input,output){
		observeEvent(input$idSubmit,{
			# Retrieve TableColumnList object to pull fields from to use in generating form. 	
			cols <- synGetColumns(input$tableId)
			# Call renderUI for number of columns in table, with type of input box generated dependent on data type of column.
			lapply(1:length(cols),function(i){
				type <- cols[[i]]$columnType

				if(type == 'STRING' | type == 'ENTITYID' | type == 'LINK'){
				output[[paste('entry',i,sep='')]] <- renderUI({
						textInput(paste0('field',cols[[i]]$name),paste(cols[[i]]$name,'-',cols[[i]]$columnType),value='')}
					)}

				if(type == 'INTEGER' | type == 'DOUBLE'){
				output[[paste('entry',i,sep='')]] <- renderUI({
					numericInput(paste0('field',cols[[i]]$name),paste(cols[[i]]$name,'-',cols[[i]]$columnType),value=1)
					})
				}

				if(type == 'BOOLEAN'){
				output[[paste('entry',i,sep='')]] <- renderUI({
					checkboxInput(paste0('field',cols[[i]]$name),paste(cols[[i]]$name),value=FALSE)
					})
					}
				})
			# Form submit button.
			output$submit <- renderUI({
				actionButton('formSubmit','Submit')
					})
						})	
		
			# Upload form to synapse after user submits. 
		observeEvent(input$formSubmit,{
			# Get TableColumnList object and populate one row data frame with entries from form, set up colsId vector which 
			# contains column I.D.'s of synapse table form is uploaded to.  
			cols <- synGetColumns(input$tableId)
			df <- data.frame(matrix(,nrow=1,ncol=0))
			colsId <- as.numeric(length(cols))
			
			for(i in 1:length(cols)){	
				df[[cols[[i]]$name]] <- input[[paste0('field',cols[[i]]$name)]]
				colsId[i] <- cols[[i]]$id
					}
			# Define schema with parent project ID of table and columnID vector, create table w/ schema and dataframe, upload table.
			# To-Do : change parentID to not be hardcoded. 
			schema <- TableSchema(name='Test',parent='syn5016376',columns=colsId)
			rowToAppend <- Table(schema,df)
			table <- synStore(rowToAppend, retrieveData=TRUE)
						})
})			
