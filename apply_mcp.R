apply_mcp <- function(
    pval,
    rho,
    method = c("truncHochberg", "Bonferroni", "parametric"),
    alpha,
    gamma
) {
  method <- match.arg(arg = NULL, choices = method)
  if (method == "truncHochberg") {
    test <- function(pval) {
      util_test_truncHochberg(pval, gamma, alpha)
    }
  }

  tbl_sig_or_not <- pval |>
    tidyr::pivot_longer(c("a_2", "b_2", "a_1", "b_1"), values_to = "pvalue", names_to = "endpoint_group") |>
    nest(data = everything()) |>
    dplyr::mutate(
      p_ad = furrr::future_map(data, ~test(.$pvalue),
                              .options = furrr::furrr_options(
                                seed = TRUE,
                                scheduling = 5,
                                packages = "Mediana"
                              )
      ),
      .keep = "unused"
    ) |>
    tidyr::unnest(p_ad) |>
    tidyr::pivot_wider(
      names_from = c("endpoint", "group"),
      values_from = "significant",
      names_glue = "{endpoint}_{group}"
    )
  return(tbl_sig_or_not)
}

util_test_truncHochberg <- function(pval, gamma, alpha) {
  # use adjustment procedure
  pvalues_adj <- Mediana::AdjustPvalues(
    as.numeric(pval),
    proc = "ParallelGatekeepingAdj",
    par = Mediana::parameters(
      family = Mediana::families(family1 = c(1, 2), family2 = c(3, 4)),
      proc = Mediana::families(family1 = "HochbergAdj", family2 = "HochbergAdj"),
      gamma = Mediana::families(family1 = gamma, family2 = 1)
    )
  )
  tbl_results <- tibble::tibble(
    endpoint = c("a", "b", "a", "b"),
    group = c(2, 2, 1, 1),
    significant = pvalues_adj <= alpha
  )
  return(tbl_results)

} # tbl: dose, endpoint, rejected


util_construct_corr_matrix <- function(
    rho
) {
  corr <- matrix(c(1, rho, 0.5, 0.5*rho,
                   rho, 1, 0.5*rho, 0.5,
                   0.5, 0.5*rho, 1, rho,
                   0.5*rho, 0.5, rho, 1), nrow = 4, byrow = TRUE)
  return(corr)
} # full corr matrix
