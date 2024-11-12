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

  if (method == "Bonferroni") {
    test <- function(pvalues) {
      do.call(what = util_test_gMCP, args = list(c(pvalues),
                                                 alpha = alpha,
                                                 gamma = gamma,
                                                 method = method))
    }
  }

  if (method == "parametric") {
    test <- function(pvalues) {
      do.call(what = util_test_gMCP, args = list(c(pvalues),
                                                 alpha = alpha,
                                                 gamma = gamma,
                                                 method = method,
                                                 corr = util_construct_corr_matrix(rho)))
    }
  }

  tbl_sig_or_not <- pval |>
    tidyr::pivot_longer(c("a_2", "b_2", "a_1", "b_1"), values_to = "pvalue", names_to = "endpoint_group") |>
    nest(data = everything()) |>
    dplyr::mutate(
      p_ad = furrr::future_map(data, ~test(.$pvalue),
                              .options = furrr::furrr_options(
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
      family = Mediana::families(family1 = c(1, 2),
                                 family2 = c(3, 4)),
      proc = Mediana::families(family1 = "HochbergAdj",
                               family2 = "HochbergAdj"),
      gamma = Mediana::families(family1 = gamma,
                                family2 = 1)
    )
  )
  tbl_results <- tibble::tibble(
    endpoint = c("a", "b", "a", "b"),
    group = c(2, 2, 1, 1),
    significant = pvalues_adj <= alpha
  )
  return(tbl_results)

} # tbl: dose, endpoint, rejected

util_test_gMCP <- function(
    pvalues,
    gamma,
    alpha,
    corr = corr,
    method = c("Bonferroni", "parametric")
) {
  if (length(pvalues) != 4) {
    stop("Length of pvalues must equal number of nodes.")
  }
  method <- match.arg(arg = NULL, choices = method)
  if (method == "Bonferroni") {
    significant <- gMCPLite::gMCP(
      graph = util_get_gMCP_graph(gamma),
      pvalues =  pvalues,
      test = method,
      alpha = alpha,
      verbose = FALSE
    )@rejected
  } else {
    significant <- gMCPLite::gMCP(
      graph = util_get_gMCP_graph(gamma),
      pvalues =  pvalues,
      test = method,
      alpha = alpha,
      verbose = FALSE,
      correlation = corr
    )@rejected
  }
  tbl_results <- tibble::tibble(
    endpoint = c("a", "b", "a", "b"),
    group = c(2, 2, 1, 1),
    significant = significant
  )
  return(tbl_results)
}

util_get_gMCP_graph <- function(gamma){
    m <- matrix(c(0, gamma, (1 - gamma)/2, (1 - gamma)/2,
                  gamma, 0, (1 - gamma)/2, (1 - gamma)/2,
                  0, 0, 0, 1,
                  0, 0, 1, 0), nrow = 4, byrow = TRUE)
    w <- c(0.5, 0.5, 0, 0)

  return(gMCPLite::matrix2graph(m, w))
}

util_construct_corr_matrix <- function(
    rho
) {
  corr <- matrix(c(1, rho, 0.5, 0.5*rho,
                   rho, 1, 0.5*rho, 0.5,
                   0.5, 0.5*rho, 1, rho,
                   0.5*rho, 0.5, rho, 1), nrow = 4, byrow = TRUE)
  return(corr)
} # full corr matrix
