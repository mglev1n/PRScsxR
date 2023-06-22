#' PRScsx-jl
#'
#' Function to use the `julia` implementation of PRScsx, which has better performance than the `python` implementation: \url{https://doi.org/10.26508/lsa.202201382}. This function requires that both `julia` and the `PolygenicRiskScore.jl` package are already installed.
#'
#' @param ref_dir Full path to the directory that contains the SNP information file and LD reference panels. If the 1000 Genomes reference is used, the folder would contain the SNP information file \code{snpinfo_mult_1kg_hm3} and one or more of the LD reference files: \code{ldblk_1kg_afr}, \code{ldblk_1kg_amr}, \code{ldblk_1kg_eas}, \code{ldblk_1kg_eur}, \code{ldblk_1kg_sas}; if the UK Biobank reference is used, the folder would contain the SNP information file \code{snpinfo_mult_ukbb_hm3} and one or more of the LD reference files: \code{ldblk_ukbb_afr}, \code{ldblk_ukbb_amr}, \code{ldblk_ukbb_eas}, \code{ldblk_ukbb_eur}, \code{ldblk_ukbb_sas}.
#' @param bim_prefix Full path and the prefix of the bim file for the target (validation/testing) dataset. This file is used to provide a list of SNPs that are available in the target dataset.
#' @param sst_file Full path and the file name of the GWAS summary statistics. Multiple GWAS summary statistics files are allowed and should be separated by comma. Summary statistics files must have the following format (SNP, A1, A2, BETA, P)
#' @param n_gwas Sample sizes of the GWAS, in the same order of the GWAS summary statistics files, separated by comma.
#' @param pop Population of the GWAS sample, in the same order of the GWAS summary statistics files, separated by comma. For both the 1000 Genomes reference and the UK Biobank reference, AFR, AMR, EAS, EUR and SAS are allowed.
#' @param out_dir Output directory of the posterior effect size estimates.
#' @param a Parameter a in the gamma-gamma prior. Default is 1.
#' @param b Parameter b in the gamma-gamma prior. Default is 0.5.
#' @param phi Global shrinkage parameter phi. If phi is not specified, it will be learnt from the data using a fully Bayesian approach. This usually works well for polygenic traits with very large GWAS sample sizes (hundreds of thousands of subjects). For GWAS with limited sample sizes (including most of the current disease GWAS), fixing phi to 1e-2 (for highly polygenic traits) or 1e-4 (for less polygenic traits), or doing a small-scale grid search (e.g., phi=1e-6, 1e-4, 1e-2, 1) to find the optimal phi value in the validation dataset often improves perdictive performance.
#' @param n_iter Total number of MCMC iterations. Default is 1,000 * the number of discovery populations.
#' @param n_burnin Number of burnin iterations. Default is 500 * the number of discovery populations. Both --n_iter and --n_burnin need to be specified to overwrite their default values.
#' @param thin Thinning factor of the Markov chain. Default is 5.
#' @param chrom The chromosome on which the model is fitted, separated by comma, e.g., --chrom=1,3,5. Parallel computation for the 22 autosomes is recommended. Default is iterating through 22 autosomes (can be time-consuming).
#' @param meta If True, return combined SNP effect sizes across populations using an inverse-variance-weighted meta-analysis of the population-specific posterior effect size estimates. Default is True.
#' @param julia_bin Path to julia executable; requires the `PolygenicRiskScores.jl` to be installed
#' @param seed Non-negative integer which seeds the random number generator.
#'
#' @return list containing status, stdout, stderr, and timeout status of the python process
#' @export

prscsx_jl <- function(ref_dir,
                      bim_prefix,
                      sst_file,
                      n_gwas,
                      pop,
                      out_dir,
                      a = NULL,
                      b = NULL,
                      phi = NULL,
                      n_iter = NULL,
                      n_burnin = NULL,
                      thin = NULL,
                      chrom = NULL,
                      meta = "true",
                      seed = NULL,
                      julia_bin = "/appl/julia-1.8.5/bin/julia") {
  fs::dir_create(fs::path_abs(out_dir), recurse = TRUE)

  cb <- function(line, proc) {
    cat(line, "\n")
  }

  # if (!fs::dir_exists(fs::path_real(out_dir))) {
  #   cli::cli_progress_step("Creating output directory {.file {fs::path_real(out_dir)}}")
  #   fs::dir_create(fs::path_real(out_dir), recurse = TRUE)
  # }

  cli::cli_alert_info("Running PRScsx on: {.file {fs::path_file(sst_file)}}")
  cli::cli_progress_step("Running PRScsx on: {.file {fs::path_file(sst_file)}}")
  processx::run(julia_bin,
    c(
      "--project", "-e", "using PolygenicRiskScores; PolygenicRiskScores.main()", "--",
      "--ref_dir", fs::path_abs(ref_dir),
      "--bim_prefix", bim_prefix,
      "--sst_file", glue::glue_collapse(fs::path_real(sst_file), sep = ","),
      "--n_gwas", glue::glue_collapse(n_gwas, sep = ","),
      "--pop", glue::glue_collapse(pop, sep = ","),
      "--out_dir", fs::path_abs(out_dir),
      "--meta", meta,
      if (!is.null(chrom)) {
        c("--chrom", glue::glue_collapse(chrom, sep = ","))
      },
      if (!is.null(a)) {
        c("--a", a)
      },
      if (!is.null(b)) {
        c("--b", b)
      },
      if (!is.null(phi)) {
        c("--phi", phi)
      },
      if (!is.null(n_iter)) {
        c("--n_iter", n_iter)
      },
      if (!is.null(n_burnin)) {
        c("--n_burnin", n_burnin)
      },
      if (!is.null(thin)) {
        c("--thin", thin)
      },
      if (!is.null(seed)) {
        c("--seed", seed)
      }
    ),
    echo_cmd = TRUE,
    spinner = TRUE,
    stdout_line_callback = cb,
    stderr_line_callback = cb,
  )
}
