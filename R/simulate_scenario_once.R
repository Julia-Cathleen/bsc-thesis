simulate_scenario_once <- function(
    sample_size,
    mu_a1,
    mu_a2,
    mu_b1,
    mu_b2,
    rho,
    method,
    alpha,
    gamma,
    estimate
) {
   effects <- matrix (c(0, 0,
                        mu_a1, mu_b1,
                        mu_a2, mu_b2), nrow = 3, byrow = TRUE)


  res <- summarize_data(simulate_data(sample_size, effects, rho), sample_size)
  if (estimate == TRUE) {
    rho <- res$rho_hat
  }
  res <- apply_mcp(res$tbl_pval, rho, method, alpha, gamma)

  return(res)
}
