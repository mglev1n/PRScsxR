#' prep_prscsx_sumstats
#'
#' @param file filename containing GWAS summary statistics to prepare for PRS-CSx
#' @param outfile filename where prepared summary statistics should be written
#' @param snp_col unquoted column name containing SNP rsids
#' @param effect_allele_col unquoted column name containing effect alleles
#' @param other_allele_col unquoted column name containing non-effect alleles
#' @param effect_col unquoted column name containing effect sizes
#' @param pval_col unquoted column name containing p-values
#' @param delim delimiter used to define columns in the GWAS summary statistics file (default "\t")
#'
#' @return filename containing the prepared summary statistics
#' @export
#'
#' @import data.table
#' @import dplyr
#' @import rlang
#' @import stringr

prep_prscsx_sumstats <- function(file, outfile, snp_col, effect_allele_col, other_allele_col, effect_col, pval_col, delim = "\t") {

  fs::dir_create(dirname(outfile))

  sumstats <- data.table::fread(file, sep = delim) %>%
    select(SNP = {{ snp_col }}, A1 = {{ effect_allele_col }}, A2 = {{ other_allele_col }}, BETA = {{ effect_col }}, P = {{ pval_col }}) %>%
    filter(!is.na(SNP)) %>%
    filter(!is.na(A1)) %>%
    filter(!is.na(A2)) %>%
    filter(str_detect(A1, "A|T|G|C")) %>%
    filter(str_detect(A2, "A|T|G|C"))

  sumstats %>%
    data.table::fwrite(outfile, sep = "\t")

  return(outfile)
}
