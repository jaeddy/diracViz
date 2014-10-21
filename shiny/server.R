library(shiny)
library(GSReg)
library(GSBenchMark)
library(rCharts)

source("helpers.R")

data(diracpathways)
data(GSBenchMarkDatasets)

shinyServer(function(input, output, session) {

    output$currentData <- renderText({
        input$data
    })
    
    getData <- observe({
        if (input$load > 0) {
            dataSetName <- input$data
            load_data(dataSetName)
            exprsdata <- clean_data(exprsdata)
            df <- summarize_data(exprsdata, phenotypes, phenotypesLevels)
            output$value <- renderTable({ df })
        }
    })
})