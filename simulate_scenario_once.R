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
  effects <- matrix (c(mu_a1, mu_a2,
                       mu_b1, mu_b2), nrow = 2, by.row = TRUE)
  res <- simultate_data(sample_size, effects, rho) |> summarize_data()
  if (estimate == TRUE) {
    rho <- res$rho_hat
  }
  apply_mcp(res, rho, method, alpha, gamma)
}
