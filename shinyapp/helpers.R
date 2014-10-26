
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
    numSamples <- as.character(c(sum(phenotypes == 0), 
                    sum(phenotypes == 1),
                    length(phenotypes)))
    numGenes <- c("NA", "NA", nrow(exprsdata))
    label <- c(phenotypesLevels["0"], 
               phenotypesLevels["1"],
               NA)
    df <- data.frame(label = label,
                     samples = numSamples,
                     genes = numGenes)
    row.names(df) <- c("class1", "class2", "total")
    df
}

# Select significant results
collect_results <- function(diracResult) {
    sigPathways <- which(diracResult$pvalues < 0.05)
    dysregulatedPathways <- rbind(diracResult$mu1[sigPathways],
                                  diracResult$mu2[sigPathways])
    
    rownames(dysregulatedPathways) <- c("mu1", "mu2")
    t(dysregulatedPathways)
}


# Format DIRAC results
format_results <- function(results) {
    pathwayTable <- data.frame(results)
    pathwayTable <- cbind(pathway = row.names(pathwayTable),
                          pathwayTable) %>%
        mutate(mu1 = 1 - mu1,
               mu2 = 1 - mu2,
               diff = mu1 - mu2)
    pathwayTable
}

# Map gene expression values to an individual pathway
map_gene_to_gs <- function(gs, gene_mat) {
    gene_mat %>%
        data.frame() %>%
        mutate(gene = as.factor(row.names(exprsdata))) %>%
        filter(gene %in% diracpathways[[gs]]) %>%
        group_by(gene) %>%
        summarise_each_(funs(max), list(quote(-gene)))
}

# Label classes and samples
label_samples <- function(gs_df, phenotypes) {
    classes <- as.numeric(phenotypes)
    labels <- paste0(classes, 
                     rep("_", length(classes)),
                     as.character(c(1:sum(classes == 1), 
                                    1:sum(classes == 2))))
    labels <- c("gene", labels)
    names(gs_df) <- labels    
    row.names(gs_df) <- gs_df$gene
    gs_df %>%
        select(-gene)
}