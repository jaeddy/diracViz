library(GSBenchMark)
library(GSReg)
library(dplyr)
library(rCharts)

source("shinyapp/helpers.R")

data(diracpathways)
data(GSBenchMarkDatasets)
print(GSBenchMark.Dataset.names)

# Load and clean the data
dataSetName <- GSBenchMark.Dataset.names[[5]]
load_data(dataSetName)
exprsdata <- clean_data(exprsdata)

# Generate, compile, and format DIRAC results
diracResult <- GSReg.GeneSets.DIRAC(exprsdata, diracpathways, phenotypes, 0)
results <- collect_results(diracResult)
pathway_df <- format_results(results)

# Pull out pathway expression data
pathway <- row.names(results)[86]
pathway_df <- map_genes_to_pathway(pathway, exprsdata)
pathway_df <- label_samples(pathway_df, phenotypes)


get_class_df <- function(pathway_df, class = "1") {
    genes <- pathway_df %>%
        select(gene)
    class_df <- pathway_df %>%
        select(starts_with(class)) %>%
        mutate_each(funs(rank))
    E_class <- rowMeans(as.matrix(class_df))
    cbind(gene = genes, E_rank_class = E_class, class_df)
}

test <- get_class_df(pathway_df)

make_plot <- function(pathway_df, class) {
    class_df <- get_class_df(pathway_df, class)
    p <- rCharts$new()
    p$setLib("http://rcharts.github.io/parcoords/libraries/widgets/parcoords")
    p$set(padding = list(top = 24, left = 0, bottom = 12, right = 0))
    p$set(
        data = toJSONArray(class_df, json = F),
        colorby = 'E_rank_class',
        range = c(1, nrow(test)),
        colors = c('steelblue', 'brown')
    )
    p
}

make_plot(pathway_df, "1")

