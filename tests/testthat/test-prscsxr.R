test_that("reticulate loads python and dependencies are available", {
  library(reticulate)
  expect_true(py_module_available("scipy"))
  expect_true(py_module_available("h5py"))
})

test_that("PRScsx test runs correctly", {
  expect_true(py_module_available("h5py"))
  res <- prscsx(ref_dir = "/scratch/Applications/PRScsx/LD-Reference",
                bim_prefix = "/scratch/Applications/PRScsx/PRScsx/test_data/test",
                sst_file = c('/scratch/Applications/PRScsx/PRScsx/test_data/EUR_sumstats.txt', '/scratch/Applications/PRScsx/PRScsx/test_data/EAS_sumstats.txt'),
                n_gwas = c("200000", "100000"),
                pop = c("EUR", "EAS"),
                out_dir = tempdir(),
                out_name = "r_test",
                chrom = 22,
                prscsx_bin = "/scratch/Applications/PRScsx/PRScsx/PRScsx.py"
  )
  expect_true(res$status == 0)
})
