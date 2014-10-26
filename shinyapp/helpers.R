
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

# Collect DIRAC results
collect_results <- function(diracResult) {
    dysregulatedPathways <- rbind(diracResult$mu1,
                                  diracResult$mu2)
    
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
               diff = mu1 - mu2) %>%
        arrange(desc(abs(diff)))
    pathwayTable
}

# Map gene expression values to an individual pathway
map_genes_to_pathway <- function(pathway, gene_mat) {
    gene_mat %>%
        data.frame() %>%
        mutate(gene = as.factor(row.names(exprsdata))) %>%
        filter(gene %in% diracpathways[[pathway]]) %>%
        group_by(gene) %>%
        summarise_each_(funs(max), list(quote(-gene)))
}

# Label classes and samples
label_samples <- function(pathway_df, phenotypes) {
    classes <- as.numeric(phenotypes)
    labels <- paste0(classes, 
                     rep("_", length(classes)),
                     as.character(c(1:sum(classes == unique(classes)[1]), 
                                    1:sum(classes == unique(classes)[2]))))
    labels <- c("gene", labels)
    names(pathway_df) <- labels    
    row.names(pathway_df) <- pathway_df$gene
    pathway_df
}

# Pull out and format data for specified class
get_class_df <- function(pathway_df, class = "1") {
    genes <- pathway_df %>%
        select(gene)
    class_df <- pathway_df %>%
        select(starts_with(class)) %>%
        mutate_each(funs(rank))
    E_class <- rowMeans(as.matrix(class_df))
    cbind(gene = genes, E_rank_class = E_class, class_df)
}

# Create parallel coordinates plot
make_chart <- function(pathway_df, class) {
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

# Create ggplot2 line plot
make_plot <- function(pathway_df, class) {
    get_class_df(pathway_df, class) %>%
        melt(id.vars = c("gene", "E_rank_class")) %>%
        rename(rank = value, sample = variable) %>%
        ggplot(aes(x = sample, y = rank, group = gene, colour = gene)) +
        geom_line()
}

