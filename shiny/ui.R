library(shiny)
library(GSReg)
library(GSBenchMark)
library(rCharts)

data(diracpathways)
data(GSBenchMarkDatasets)

shinyUI(fluidPage(
    
    titlePanel("diracViz App"),
    
    fluidRow(
        column(3,
               h3("Load Data"),
               selectInput("data",
                           "Select data set:",
                           GSBenchMark.Dataset.names,
                           selectize = TRUE),
               actionButton("load",
                            "Load data"),
               hr(),
               fluidRow(
                   verbatimTextOutput("value")
                   )
               ),
        
        column(9,
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