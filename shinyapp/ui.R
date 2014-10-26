library(shiny)
library(GSReg)
# library(GSBenchMark)
library(ggplot2)
library(reshape2)

data(diracpathways)
# data(GSBenchMarkDatasets)

shinyUI(fluidPage(
    
    titlePanel("diracExplorer"),
    
    fluidRow(
        column(4,
               # Controls for selecting data and parameters
               h3("Control Panel"),
               wellPanel(
                   # Select and load expression dataset
                   fluidRow(
                       h4("Data Selection"),
                       p(em("Each of the following datasets contains", 
                            "'expression' measurements for thousands of",
                            "genes across dozens of patient samples.",
                            "Samples in each dataset are grouped into two",
                            "classes, according to their phenotype",
                            "(i.e., disease vs. normal, severity of disease",
                            "etc.)."), 
                         style = "font-size: 10pt"),
                       selectizeInput("dataset",
                                   NULL,
#                                    choices = GSBenchMark.Dataset.names,
                                   choices = "prostate_GDS2545_m_nf*",
                                   options = list(
                                       placeholder = "Select dataset...",
                                       onInitialize = 
                                           I(paste0('function()',
                                                    '{ this.setValue(""); }'))
                                   )
                       ),
                       p(em("* more datasets to be available in future",
                            "versions"),
                         options = "font-size: 9pt"),
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
                       p(em("As a preprocessing step, GSReg will remove any",
                            "pathways with less than the specified minimum",
                            "number of genes. While a greater number of genes",
                            "is more likely to represent a functional unit,",
                            "larger sets can also be more difficult to",
                            "interpret."),
                         style = "font-size: 10pt"),
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
                            h4("Overview"),
                            p(strong("Differential Rank Conservation (DIRAC)"),
                              "is a computational approach to investigate",
                              "patterns of gene expression in functionally",
                              "relevant biological", strong("pathways."),
                              "This app allows users to generate results with",
                              "several example datasets using the",
                              strong("GSReg"), "package.", "Users can also",
                              "select individual pathways and visualize",
                              "expression patterns across different",
                              "samples and conditions."),
                            br(),
                            h4("Getting Started"),
                            p("The ", strong("GSReg"), "package from",
                              "Bioconductor comes with 11 pre-built",
                              "gene expression datasets from the",
                              "original DIRAC publication. Choose a",
                              "dataset from the dropdown menu on the",
                              "left to preview the data and begin the",
                              "analysis."),
                            br(),
                            h4("Running DIRAC"),
                            p("After loading a dataset and specifying", 
                              "parameters using the Control Panel,",
                              "clicking the", strong("Run DIRAC"), "button",
                              "will generate a list of the most dysregulated",
                              "pathways identified with the method. This list",
                              "as well as more information about the results",
                              "will be displayed in the", strong("Results"),
                              "tab."),
                            h4("Visualizing Pathways"),
                            p("For any individual pathways that appear",
                              "interesting in the results, users can go to",
                              "the", strong("Pathway Viz"), "tab to produce",
                              "some basic plots with", strong("ggplot2."))
                            ),
                   tabPanel("Results",
                            h4("Most Dysregulated Pathways"),
                            h5("Key:"),
                            p(strong("mu1:"), "measure of consistency of gene",
                              "ordering in class 1; 0.5 would indicate random",
                              "ordering from samle to sample, while 1.0",
                              "indicates identical ordering in all samples."),
                            p(strong("mu2:"), "measure of consistency of gene",
                              "ordering in class 2; 0.5 would indicate random",
                              "ordering from samle to sample, while 1.0",
                              "indicates identical ordering in all samples."),
                            p(strong("diff:"), "mu1 - mu2; difference in",
                              "gene ordering consistency measures between",
                              "class 1 and 2, representing the amount of",
                              strong("dysregulation"), "for the pathway."),
                            br(),
                            dataTableOutput("topPathways")
                            ),
                   tabPanel("Pathway Viz",
                            h4("Visualize Pathway Dysregulation"),
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
                            )
#                    tabPanel("Info"
#                             )
                   )
               )
    )

))