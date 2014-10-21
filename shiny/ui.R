library(shiny)
library(GSReg)
library(GSBenchMark)
library(rCharts)

data(diracpathways)
data(GSBenchMarkDatasets)

shinyUI(fluidPage(
    
    titlePanel("diracViz App"),
    
    fluidRow(
        column(4,
               h3("Load Data"),
               selectInput("data",
                           "Select data set:",
                           GSBenchMark.Dataset.names,
                           selectize = TRUE),
               actionButton("load",
                            "Load data"),
               hr(),
               fluidRow(
                   tableOutput("value")
                   )
               ),
        
        column(8,
               h3("DIRAC Pathway Analysis"),
               tabsetPanel(
                   tabPanel("Results",
                            h4("Top pathways..."),
                            textOutput("currentData")
                            ),
                   tabPanel("Pathway Viz"
                            ),
                   tabPanel("Info"
                            )
                   )
               )
    )

))