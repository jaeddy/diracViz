---
title       : diracExplorer for Biological Pathway Analysis
subtitle    : Interactive analysis and visualization of gene expression in 
              biological pathways with Differential Rank Conservation
author      : James Eddy
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---

## Pathway analysis in disease genomics

+ Modern genomics studies obtain measurements for tens of thousands of
individual genes across dozens to hundreds of samples (patients, cells, etc.)  
+ Computational biologists apply statistics and machine learning to these 
large-scale "gene expression" datasets to aid in disease classification or 
diagnosis  
+ Studying gene expression in the context of functionally relevant biological
pathways can lead to more interpretable results and more clear insights into
disease mechanism

--- 

## Quantifying pathway regulation with DIRAC

+ Differential Rank Conservation (DIRAC) is an approach I developed in my PhD 
to examine how within-pathway gene rankings change from sample-to-sample
+ Parts of the DIRAC method were recently published in the `GSReg` package in
Bioconductor
+ For example, DIRAC will look at three genes in a pathway: gene A, gene B, and
gene C; if the expression values of these genes in a selected sample are 3.4,
8.9, and 1.2, then the corresponding ranks are 2, 3, 1.
DIRAC then examines the consistency of this ordering across samples.

---

## Identifying dysregulated pathways with diracExplorer

+ If a pathway exhibits a significant increase or decrease in consistency of
sample-to-sample ranking between populations, it is considered to be 
"dysregulated"
+ The diracExplorer app allows researchers to easily identify the most
dysregulated pathways between phenotypes (e.g., normal or cancer) in disease
datasets

---

## Visualizing pathway dysregulation with diracExplorer

+ Using diracExplorer and `ggplot2`, researchers can also select individual 
pathways and visualize their gene expression patterns across samples in the data  
+ Visualizing pathways can help researchers understand the patterns quantified
by DIRAC, and highlight interesting features worth exploring in follow-up
experiments

The current version of diracExplorer includes only minimal features and options.
I hope to expand the flexibility and capabilities of this app in the future.

---

