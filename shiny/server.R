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
    
    output$value <- renderPrint({
        input$load
        isolate(input$data)
    })
#     getData <- observe({
#         if (input$load > 0) {
#             load_data(input$data)
#             output$value <- renderPrint({ input$data })
# #             load_data(input$data)
# #             exprsdata <- clean_data(exprs_dat)
# #             df <- summarize_data(exprsdata, phenotypes, phenotypesLevels)
#         }
#     })
})