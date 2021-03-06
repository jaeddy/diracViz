library(shiny)
library(GSReg)
# library(GSBenchMark)
library(dplyr)
library(rCharts)

source("helpers.R")

load("gsRegEx.RData")
# data(diracpathways)
# data(GSBenchMarkDatasets)

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
            load("gsRegEx.RData")
            exprsdata <- clean_data(exprsdata)
            
            data$exprsdata <- exprsdata
            data$phenotypes <- phenotypes
            data$phenotypesLevels <- phenotypesLevels
            
            df <- summarize_data(exprsdata, phenotypes, phenotypesLevels)
            df
        }       
    })
    
    runDirac <- observe({
        if (input$run > 0) {
            Nperm <- 0
            minGeneNum <- input$minGeneNum
            exprsdata <- data$exprsdata
            phenotypes <- data$phenotypes
            
            diracResult <- GSReg.GeneSets.DIRAC(exprsdata, 
                                                diracpathways, phenotypes, 
                                                Nperm, minGeneNum)
            
            data$results <- collect_results(diracResult)

            updateSelectizeInput(session, "pathway",
                              "Select pathway:",
                              choices = row.names(data$results),
                              options = list(
                                  placeholder = "...",
                                  onInitialize = 
                                      I(paste0('function()',
                                               '{ this.setValue(""); }'))                          
                              )
            )
        }  
    })
    
    output$topPathways <- renderDataTable({
        input$run
        
        if (input$run > 0) {
            results <- isolate(data$results)
            format_results(results)
        }
    }, options = list(pageLength = 10, searching = FALSE))
    
    output$pathwayViz1 <- renderPlot({
        input$plot
        
        if (input$plot > 0) {
            pathway <- isolate(input$pathway)
            gene_mat <- isolate(data$exprsdata)
            phenotypes <- isolate(data$phenotypes)
            
            pathway_df <- map_genes_to_pathway(pathway, diracpathways, gene_mat)
            pathway_df <- label_samples(pathway_df, phenotypes)
            make_plot(pathway_df, "1")
        }
    })
    
    output$pathwayViz2 <- renderPlot({
        input$plot
        
        if (input$plot > 0) {
            pathway <- isolate(input$pathway)
            gene_mat <- isolate(data$exprsdata)
            phenotypes <- isolate(data$phenotypes)
            
            pathway_df <- map_genes_to_pathway(pathway, diracpathways, gene_mat)
            pathway_df <- label_samples(pathway_df, phenotypes)
            make_plot(pathway_df, "2")
        }
    })
})