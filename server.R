# shiny server for synapseForm app

library(synapseClient)
synapseLogin()

shinyServer(
	function(input,output){
		observeEvent(input$idSubmit,{
			
			cols <- synGetColumns(input$tableId)

			lapply(1:length(cols),function(i){

				output[[paste('entry',i,sep='')]] <- renderUI({
						textInput(paste0('field',cols[[i]]$name),cols[[i]]$name,value='')}

					)
				})

			output$button <- renderUI({
				actionButton('formSubmit','Submit Form')
					})
						})	


		observeEvent(input$formSubmit,{
			cols <- synGetColumns(input$tableId)
			df <- data.frame(matrix(,nrow=1,ncol=0))
			colsId <- as.numeric(length(cols))
			
			for(i in 1:length(cols)){	
				df[[cols[[i]]$name]] <- input[[paste0('field',cols[[i]]$name)]]
				colsId[i] <- cols[[i]]$id
					}

		schema <- TableSchema(name='Test',parent='syn5016376',columns=colsId)
		rowToAppend <- Table(schema,df)
		table <- synStore(rowToAppend, retrieveData=TRUE)
		table@values

						}
						)
}	)			
