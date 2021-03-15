library(devtools)

# getPPIs - protein-protein interaction data
install_github("soderling-lab/getPPIs")

# geneLists - lists of genes and functions to map gene identifiers
install_github("soderling-lab/geneLists")

# tidyProt - functions for model-based statistical comparisons
install_github("soderling-lab/tidyProt")

# Uezu2016 - iPSD BioID data from Uezu et al., 2016
install_github("soderling-lab/Uezu2016")

# SwipProteomics - WASHC4 spatial proteomics data
install_github("soderling-lab/SwipProteomics")

# SynaptopathyProteomics - synaptosome proteomics data
install_github("soderling-lab/SynaptopathyProteomics")


## using lmTestContrast to assess differential abundance

library(dplyr)
library(data.table)

library(tidyProt)

data(gphn, package="Uezu2016")
data(ipsd_bioid, package="Uezu2016")

# drop QC data before fitting models
tidy_prot <- ipsd_bioid %>% filter(Condition != "QC")

fx <- log2(Intensity) ~ 0 + Condition

# NOTE: by setting the intercept to 0,
# we explicitly estimate all levels of Condition

# fit the model to protein data for gephyrin
fm <- lm(fx, data = tidy_prot %>% subset(Protein == gphn))

# create a contrast
LT <- tidyProt::getContrast(fm, "Gephyrin","Control")
LT

# assess contrast for gphn 
lmTestContrast(fm, LT) 



# load the normalized data
data(swip_tmt, package="SwipProteomics")

# washc4's uniprot ID
data(swip, package="SwipProteomics")

# fit a model
fx <- log2(Intensity) ~ 0 + Condition + (1|Mixture)
fm <- lmerTest::lmer(fx, data=swip_tmt %>% subset(Protein==swip))

# create intra-BioFraction comparison between Mutant-Control groups
LT7 <- getContrast(fm, "Mutant.F7", "Control.F7")
LT7

# create overall Mutant-Control contrast
LT8 <- getContrast(fm, "Mutant", "Control")
LT8


# assess intra-BioFraction contrast 
lmerTestContrast(fm, LT7)

# assess overall Mutant-Control comparison
res <- lmerTestContrast(fm, LT8) %>% 
	mutate(Contrast='Mutant-Control') %>%
	unique()
res


## fit WASH Complex

# load the WASHC UniProt identifiers
data(washc, package="SwipProteomics")

# module-level model includes ranef term Protein
fx <- log2(Intensity) ~ 0 + Condition + (1|Protein)

# fit the model
fm <- lmerTest::lmer(fx, data = swip_tmt %>% subset(Protein %in% washc))

# assess overall 'Mutant-Control' comparison
res <- lmerTestContrast(fm, LT8) %>% 
	mutate(Contrast='Mutant-Control') %>% unique()
res


## using geneLists to perform GSEA

library(geneLists)

# to see all available gene lists:
# geneLists()

library(dplyr)
library(data.table)

# load the ePSD BioID data
data(epsd, package="Uezu2016") # DLG4-BioID sig prots
data(epsd_bioid, package="Uezu2016") # BioID data

# load the SFARI ASD-associated genes
data("sfariGene", package = "geneLists")
data("sfariAnimal", package = "geneLists")

# a geneList is just a named list of Entrez IDs
str(sfariGene)

# combine SFARI gene lists
sfari <- unique(c(sfariGene[["ASD"]], sfariAnimal[["ASD"]]))

# use all genes identified in proteomics experiment as background
all_entrez <- unique(epsd_bioid$Entrez)

# test for enrichment of SFARI genes in DLG4 (epsd) proteome
geneLists::hyperTest(sfari, epsd, background = all_entrez)

# convert entrez IDs to mouse genes using getIDs
genes <- geneLists::getIDs(sfari, "entrez", "symbol", "mouse")
head(genes[which(sfari %in% epsd)])


## using getPPIs to build a PPI network

library(dplyr)
library(data.table)
library(igraph) # for working with graphs

# load iPSD proximity proteome genes
data(ipsd, package="Uezu2016") # soderling-lab/Uezu2016

# load mouse PPI dataset
data(musInteractome, package="getPPIs")

## collect PPIs

# keep interactions from mouse human and rat
os_keep <- c(9606, 10116, 10090)

# subset the data using dplyr's pipe %>% and filter
edges <- musInteractome %>% 
	filter(osEntrezA %in% ipsd & osEntrezB %in% ipsd) %>%
	filter(Interactor_A_Taxonomy %in% os_keep) %>%
	dplyr::select(osEntrezA,osEntrezB) %>% mutate(weight=1)


## convert edges data.frame to adjm with igraph

G <- graph_from_data_frame(edges, directed=FALSE)

g <- simplify(G) # removes duplicated edges

# convert to adjm with igraph's as_adjacency_matrix
A <- as_adjacency_matrix(g)
adjm <- as.matrix(A)

# save this and cluster it with the leiden alg!

# to preserve rownames, we must convert to data.table first
a <- as.data.table(adjm, keep.rownames="Protein")

# be careful, adjacency matrices can be heavy!
#fwrite(a,"adjm.csv")


library(dplyr)
library(data.table)

library(tidyProt)

data(swip, package="SwipProteomics")
data(swip_tmt, package="SwipProteomics")
data(swip_partition, package="SwipProteomics")

fx <- log2(rel_Intensity) ~ 0 + Condition + (1|Protein)

# Swip is in M38
partition[swip]

m38 <- names(which(partition==38))

fm <- lmerTest::lmer(fx, data = swip_tmt %>% subset(Protein %in% m38))

LT = getContrast(fm, "Mutant", "Control")

# assess the contrast
lmerTestContrast(fm, LT) %>% 
	mutate(Contrast="Mutant-Control") %>% unique()

