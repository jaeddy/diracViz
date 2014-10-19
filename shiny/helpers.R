
# Load data set from GSBenchMark library
load_data <- function(dataSetName) {
    data(list = dataSetName)
}

# Remove any genes with missing values or NaN entries
clean_data <- function(exprsdata) {
    nanGenes <- rowSums(is.nan(exprsdata)) > 0
    exprsdata[!nanGenes, ]
}

# Summarize data set
summarize_data <- function(exprsdata, phenotypes, phenotypesLevels) {
    numSamples <- c(sum(phenotypes == 0), 
                    sum(phenotypes == 1),
                    length(phenotypes))
    numGenes <- c(NA, NA, nrow(exprsdata))
    label <- c(phenotypesLevels["0"], 
               phenotypesLevels["1"],
               dataSetName)
    df <- data.frame(label = label,
                     numSamples = numSamples,
                     numGenes = numGenes)
    row.names(df) <- c("class1", "class2", "fullData")
    df
}