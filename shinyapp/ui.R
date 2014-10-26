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
               # Controls for selecting data and parameters
               h3("Control Panel"),
               wellPanel(
                   # Select and load expression dataset
                   fluidRow(
                       h4("Data Selection"),
                       # Add explanatory text
                       selectizeInput("dataset",
                                   NULL,
                                   choices = GSBenchMark.Dataset.names,
                                   options = list(
                                       placeholder = "Select dataset...",
                                       onInitialize = 
                                           I(paste0('function()',
                                                    '{ this.setValue(""); }'))
                                   )
                       ),
                       actionButton("load",
                                    "Load data")
                   ),
                   hr(),
                   # Preview dataset
                   fluidRow(
                       h4("Data Summary"),
                       # Add explanatory text
                       tableOutput("value")
                   ),
                   hr(),
                   # Set parameters for DIRAC
                   fluidRow(
                       h4("DIRAC Settings"),
                       # Removing permutation option for now
#                        sliderInput("Nperm", 
#                                    "Num. permutations:",
#                                    min = 1, max = 10000, value = 1),
#                        br(),
                       # Add explanatory text
                       sliderInput("minGeneNum", 
                                   "Min. num. genes per pathway",
                                   min = 3, max = 15, value = 5),
                       br(),
                       actionButton("run",
                                    "Run DIRAC")
                   )
               )
        ),
        
        column(8,
               h3("DIRAC Pathway Analysis"),
               tabsetPanel(
                   # Add a home/overview tab
                   tabPanel("Results",
                            h4("Top pathways..."),
                            textOutput("currentData"),
                            textOutput("size"),
                            br(),
                            dataTableOutput("topPathways")
                            ),
                   tabPanel("Pathway Viz"
                            ),
                   tabPanel("Info"
                            )
                   )
               )
    )

))