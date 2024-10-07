get_power <- function(
    n_sim,
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

  vec <- list(sample_size = sample_size,
           mu_a1 = mu_a1,
           mu_a2 = mu_a2,
           mu_b1 = mu_b1,
           mu_b2 = mu_b2,
           rho = rho,
           method = method,
           alpha = alpha,
           gamma = gamma,
           estimate = estimate)

  params <- as_tibble(t(replicate(n_sim, vec)))

  tbl_results <- tibble(iter = 1:n_sim) |>
    mutate(
      res = furrr::future_pmap(params,
                               ~simulate_scenario_once(..1, ..2, ..3, ..4, ..5, ..6, ..7, ..8, ..9, ..10),
                               .options = furrr::furrr_options(seed = TRUE))
    ) |>
    unnest(res) |>
    dplyr::summarize(
      power = mean(a_1 & b_1 | a_2 & b_2))


  return(tbl_results)
  #calculate power of tbl_results
}
