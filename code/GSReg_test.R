#library(GSBenchMark)
#library(GSReg)

data(diracpathways)
data(GSBenchMarkDatasets)
print(GSBenchMark.Dataset.names)

dataSetName <- GSBenchMark.Dataset.names[[4]]
data(list = dataSetName)

nanGenes <- rowSums(is.nan(exprsdata)) > 0
exprsdata <- exprsdata[!nanGenes, ]

geneNames <- rownames(exprsdata)
head(geneNames)

?GSReg.GeneSets.DIRAC

diracResult <- GSReg.GeneSets.DIRAC(exprsdata, diracpathways, phenotypes, 10)
help(GSReg:::GSReg.DIRAC.Pathways)

sigPathways <- which(diracResult$pvalues < 0.05)
dysregulatedPathways <- rbind(diracResult$mu1[sigPathways],
                             diracResult$mu2[sigPathways], 
                             diracResult$pvalues[sigPathways]);
rownames(dysregulatedPathways) <- c("mu1", "mu2", "pvalues");
print(dysregulatedPathways[,1:5])
