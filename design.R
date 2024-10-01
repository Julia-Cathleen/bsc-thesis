
simulate_data <- function(
  sample_size, # number subjects overall
  effects, # matrix 2 x 2? dose x endpoint
  rho # correlation between the endpoints
) {} # sample_size x 3 matrix with columns: dosis (0, 1, 2), a, b

summarize_data <- function(
  data
) {} #list: 4 p_values, rho_hat --> list_data

util_construct_corr_matrix <- function(
  rho
) {} # full corr matrix

apply_mcp <- function(
    pval,
    rho,
    method,
    alpha,
    gamma
) {} # tbl: dose, endpoint, rejected

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

get_power <- function(n_sim, ...) {
  tbl_results <- tibble(iter = 1:n_sim) |>
    mutate(
      res = furrr::future_map(1:n_sim, .f = simulate_scenario_once, ...)
    ) |>
    unnest(res)
  #calculate power of tbl_results
}

