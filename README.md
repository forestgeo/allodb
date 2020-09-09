
<!-- README.md is generated from README.Rmd. Please edit that file -->

# <img src="https://i.imgur.com/39pvr4n.png" align="left" height=44 /> allodb: An R database for biomass estimation at globally distributed extratropical forest plots

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/forestgeo/allodb.svg?branch=master)](https://travis-ci.org/forestgeo/allodb)
[![Coverage
status](https://coveralls.io/repos/github/forestgeo/allodb/badge.svg)](https://coveralls.io/r/forestgeo/allodb?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/allodb)](https://cran.r-project.org/pkg=allodb)

## Introduction

*allo-db* was conceived as a framework to standardize and simplify the
biomass estimation process across globally distributed extratropical
forests. We were inspired by the lack of standards tree biomass
calculation resources available for temperate sites within the Forest
Global Earth Observatory (ForestGEO). With *allo-db* we aimed to: a)
compile relevant published and unpublished allometries, focusing on AGB
but structured to handle other variables (e.g., height and biomass
components); b) objectively select and integrate appropriate available
equations across the full range of tree sizes; and c) serve as a
platform for future updates and expansion to other research sites
globally.

## Installation

Install the development version of *allo-db* from GitHub:

``` r
# install.packages("remotes")
remotes::install_github("forestgeo/allodb")
```

## Example

Prior to calculating tree biomass using *allo-db* users need to provide
DBH (cm); H (m; optional); parsed species Latin names, and site
coordinates.

Here we use data from the Smithsonian Conservation Biology Institute,
USA (SCBI) ForestGEO dynamics plot (1st census, 1 hectare). Data can be
requested through the ForestGEO portal (<https://forestgeo.si.edu/>)

``` r
library(allodb)

data(scbi_stem1)
scbi_stem1$agb <-
  get_biomass(
    dbh = scbi_stem1$dbh,
    genus = scbi_stem1$genus,
    species = scbi_stem1$species,
    coords = c(-78.2, 38.9)
)
```

You can also estimate biomass for a single tree given dbh and species
Id.

``` r
get_biomass(
  dbh=50, 
  genus="liriodendron", 
  species="tulipifera", 
  coords=c(-78.2, 38.9)
)
```
