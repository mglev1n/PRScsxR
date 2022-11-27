
<!-- README.md is generated from README.Rmd. Please edit that file -->

# PRScsxR

<!-- badges: start -->
<!-- badges: end -->

The goal of PRScsxR is to provide an interface to the `PRScsx.py`
command-line python script in R. PRS-CSx
(<https://github.com/getian107/PRScsx>) is a tool for constructing
polygenic risk scores by combining GWAS summary statistics with external
linkage disequilibrium reference panels.

## Installation

You can install the development version of PRScsxR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mglev1n/PRScsxR")
```

`PRScsx.py` requires `scipy` and `h5py` as dependencies
