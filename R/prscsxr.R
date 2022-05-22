
#' PRScsx
#'
#' @param ref_dir Full path to the directory that contains the SNP information file and LD reference panels. If the 1000 Genomes reference is used, the folder would contain the SNP information file \code{snpinfo_mult_1kg_hm3} and one or more of the LD reference files: \code{ldblk_1kg_afr}, \code{ldblk_1kg_amr}, \code{ldblk_1kg_eas}, \code{ldblk_1kg_eur}, \code{ldblk_1kg_sas}; if the UK Biobank reference is used, the folder would contain the SNP information file \code{snpinfo_mult_ukbb_hm3} and one or more of the LD reference files: \code{ldblk_ukbb_afr}, \code{ldblk_ukbb_amr}, \code{ldblk_ukbb_eas}, \code{ldblk_ukbb_eur}, \code{ldblk_ukbb_sas}.
#' @param bim_prefix Full path and the prefix of the bim file for the target (validation/testing) dataset. This file is used to provide a list of SNPs that are available in the target dataset.
#' @param sst_file Full path and the file name of the GWAS summary statistics. Multiple GWAS summary statistics files are allowed and should be separated by comma. Summary statistics files must have the following format (SNP, A1, A2, BETA, P)
#' @param n_gwas Sample sizes of the GWAS, in the same order of the GWAS summary statistics files, separated by comma.
#' @param pop Population of the GWAS sample, in the same order of the GWAS summary statistics files, separated by comma. For both the 1000 Genomes reference and the UK Biobank reference, AFR, AMR, EAS, EUR and SAS are allowed.
#' @param out_dir Output directory of the posterior effect size estimates.
#' @param out_name Output filename prefix of the posterior effect size estimates.
#' @param a Parameter a in the gamma-gamma prior. Default is 1.
#' @param b Parameter b in the gamma-gamma prior. Default is 0.5.
#' @param phi Global shrinkage parameter phi. If phi is not specified, it will be learnt from the data using a fully Bayesian approach. This usually works well for polygenic traits with very large GWAS sample sizes (hundreds of thousands of subjects). For GWAS with limited sample sizes (including most of the current disease GWAS), fixing phi to 1e-2 (for highly polygenic traits) or 1e-4 (for less polygenic traits), or doing a small-scale grid search (e.g., phi=1e-6, 1e-4, 1e-2, 1) to find the optimal phi value in the validation dataset often improves perdictive performance.
#' @param n_iter Total number of MCMC iterations. Default is 1,000 * the number of discovery populations.
#' @param n_burnin Number of burnin iterations. Default is 500 * the number of discovery populations. Both --n_iter and --n_burnin need to be specified to overwrite their default values.
#' @param thin Thinning factor of the Markov chain. Default is 5.
#' @param chrom The chromosome on which the model is fitted, separated by comma, e.g., --chrom=1,3,5. Parallel computation for the 22 autosomes is recommended. Default is iterating through 22 autosomes (can be time-consuming).
#' @param meta If True, return combined SNP effect sizes across populations using an inverse-variance-weighted meta-analysis of the population-specific posterior effect size estimates. Default is True.
#' @param seed Non-negative integer which seeds the random number generator.
#' @param prscsx_bin Location of PRScsx binary
#'
#' @return
#' @export
#' @import reticulate

prscsx <- function(ref_dir,
                   bim_prefix,
                   sst_file,
                   n_gwas,
                   pop,
                   out_dir,
                   out_name,
                   a = NULL,
                   b = NULL,
                   phi = NULL,
                   n_iter = NULL,
                   n_burnin = NULL,
                   thin = NULL,
                   chrom,
                   meta = TRUE,
                   seed = NULL,
                   prscsx_bin,
                   log_file){

  # args <- glue::glue(
  #           "python {shQuote(prscsx_bin)}
  #           --ref_dir={shQuote(ref_dir)}
  #           --bim_prefix={shQuote(bim_prefix)}
  #           --sst_file={glue::glue_collapse(shQuote(sst_file), sep = ',')}
  #           --n_gwas={glue::glue_collapse(n_gwas, sep = ',')}
  #           --pop={glue::glue_collapse(pop, sep = ',')}
  #           --out_dir={shQuote(out_dir)}
  #           --out_name={out_name}
  #           --chrom={chrom}
  #           --meta={meta}")

  args <- glue::glue(
    "python {shQuote(prscsx_bin)} --ref_dir={shQuote(ref_dir)} --bim_prefix={shQuote(bim_prefix)} --sst_file={glue::glue_collapse(shQuote(sst_file), sep = ',')} --n_gwas={glue::glue_collapse(n_gwas, sep = ',')} --pop={glue::glue_collapse(pop, sep = ',')} --out_dir={shQuote(out_dir)} --out_name={out_name} --chrom={chrom} --meta={meta}")

  # cli::cli_alert_info("Testing if python is available")
  # reticulate::py_available()
  cli::cli_alert_info("Running PRScsx with the following arguments:")
  cli::cat_print(args)
  # processx::run("which", "python")
  # processx::run("python", c(prscsx_bin,
  #                           "--ref_dir", ref_dir),
  #               echo_cmd = TRUE)

  system(args)

}

# res <- prscsx(ref_dir = "/scratch/Applications/PRScsx/LD-Reference",
#               bim_prefix = "/scratch/Applications/PRScsx/PRScsx/test_data/test",
#               sst_file = c('/scratch/Applications/PRScsx/PRScsx/test_data/EUR_sumstats.txt', '/scratch/Applications/PRScsx/PRScsx/test_data/EAS_sumstats.txt'),
#               n_gwas = c("200000", "100000"),
#               pop = c("EUR", "EAS"),
#               out_dir = "/home/mglevin",
#               out_name = "r_test",
#               chrom = 22,
#               prscsx_bin = "/scratch/Applications/PRScsx/PRScsx/PRScsx.py"
# )

