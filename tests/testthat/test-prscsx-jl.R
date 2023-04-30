test_that("PRScsx test runs correctly", {
  res <- prscsx_jl(
    ref_dir = "/scratch/Applications/PRScsx/LD-Reference",
    bim_prefix = "/scratch/Applications/PRScsx/PRScsx/test_data/test",
    sst_file = c("/scratch/Applications/PRScsx/PRScsx/test_data/EUR_sumstats.txt", "/scratch/Applications/PRScsx/PRScsx/test_data/EAS_sumstats.txt"),
    n_gwas = c(
      as.character(594613 - 20570), # Effective
      as.character(71386 - 7013) # Effective
    ),
    pop = c("EUR", "EAS"),
    out_dir = tempdir(),
    chrom = 22,
    julia_bin = "/appl/julia-1.8.5/bin/julia"
  )
  expect_true(res$status == 0)
})
