#!/usr/bin/env Rscript

# Install R packages from github using devtools::install_github.
# NOTE: you can also use the remotes::install_github, but I have not tried this.

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
