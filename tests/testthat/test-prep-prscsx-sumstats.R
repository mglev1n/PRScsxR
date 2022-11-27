test_that("preparing sumstats works", {
  temp_file <- fs::file_temp()

  sumstats_prepped <- PRScsxR::prep_prscsx_sumstats(
    file = "/scratch/Applications/PRScsx/PRScsx/test_data/EUR_sumstats.txt",
    outfile = temp_file,
    snp_col = "SNP",
    effect_allele_col = "A1",
    other_allele_col = "A2",
    effect_col = "BETA",
    pval_col = "P"
  )

  sumstats_prepped_df <- data.table::fread(temp_file)
  unprepped_sumstats <- data.table::fread("/scratch/Applications/PRScsx/PRScsx/test_data/EUR_sumstats.txt")

  expect_equal(sumstats_prepped_df, unprepped_sumstats)
})
