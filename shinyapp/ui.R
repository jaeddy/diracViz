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
                       p(em(paste("Each of the following datasets contains", 
                               "'expression' measurements for thousands of",
                               "genes across dozens of patient samples.",
                               "Samples in each dataset are grouped into two",
                               "classes, according to their phenotype",
                               "(i.e., disease vs. normal, severity of disease",
                               "etc.).")), 
                         style = "font-size: 10pt"),
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
                   tabPanel("Home",
                            h4("Getting Started")
                            ),
                   tabPanel("Results",
                            h4("Top pathways..."),
                            textOutput("currentData"),
                            br(),
                            dataTableOutput("topPathways")
                            ),
                   tabPanel("Pathway Viz",
                            selectizeInput("pathway",
                                           "Select pathway:",
                                           choices = NULL,
                                           options = list(
                                               placeholder = "No results yet...",
                                               onInitialize = 
                                                   I(paste0('function()',
                                                            '{ this.setValue(""); }'))
                                           )
                            ),
                            actionButton("plot",
                                         "Visualize Pathway"),
                            hr(),
                            "Class 1",
                            plotOutput("pathwayViz1"),
                            "Class 2",
                            plotOutput("pathwayViz2")
                            ),
                   tabPanel("Info"
                            )
                   )
               )
    )

))