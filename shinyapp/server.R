library(shiny)
library(GSReg)
library(GSBenchMark)
library(dplyr)
library(rCharts)

source("helpers.R")

data(diracpathways)
data(GSBenchMarkDatasets)

shinyServer(function(input, output, session) {

    output$currentData <- renderText({
        input$dataset
    })
    
    data <- reactiveValues()
    
    # Load and summarize the selected dataset
    output$value <- renderTable({
        input$load
        
        if (input$load > 0) {
            dataSetName <- isolate(input$dataset)
            load_data(dataSetName)
            exprsdata <- clean_data(exprsdata)
            
            data$exprsdata <- exprsdata
            data$phenotypes <- phenotypes
            data$phenotypesLevels <- phenotypesLevels
            
            df <- summarize_data(exprsdata, phenotypes, phenotypesLevels)
            df
        }       
    })
    
    output$size <- renderText({
        input$load
        
        if (input$load > 0) {
            exprsdata <- data$exprsdata
            nrow(exprsdata)
        }
    })
    
    runDirac <- observe({
        if (input$run > 0) {
            Nperm <- input$Nperm
            minGeneNum <- input$minGeneNum
            exprsdata <- data$exprsdata
            phenotypes <- data$phenotypes
            
            diracResult <- GSReg.GeneSets.DIRAC(exprsdata, 
                                                diracpathways, phenotypes, 
                                                Nperm, minGeneNum)
            
            data$results <- collect_results(diracResult)
        }  
    })
    
    output$topPathways <- renderDataTable({
        input$run
        
        if (input$run > 0) {
            results <- isolate(data$results)
            format_results(results)
        }
    }, options = list(pageLength = 10))
})