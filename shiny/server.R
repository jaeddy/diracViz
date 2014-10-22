library(shiny)
library(GSReg)
library(GSBenchMark)
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
            
            sigPathways <- which(diracResult$pvalues < 0.05)
            dysregulatedPathways <- rbind(diracResult$mu1[sigPathways],
                                          diracResult$mu2[sigPathways], 
                                          diracResult$pvalues[sigPathways])

            rownames(dysregulatedPathways) <- c("mu1", "mu2", "pvalue")
            
            data$results <- t(dysregulatedPathways)
        }  
    })
    
    output$topPathways <- renderDataTable({
        input$run
        
        if (input$run > 0) {
            results <- isolate(data$results)
            pathwayTable <- data.frame(results)
            pathwayTable <- cbind(pathway = row.names(pathwayTable),
                                  pathwayTable)
            pathwayTable$mu1 <- 1 - pathwayTable$mu1
            pathwayTable$mu2 <- 1 - pathwayTable$mu2
            pathwayTable
        }
    })
})