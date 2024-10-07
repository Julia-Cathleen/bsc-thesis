tbl_results <- tbl_scenarios |>
  mutate(
    power = furrr::future_pmap(list(n_sim,sample_size, mu_a1, mu_a2, mu_b1, mu_b2, rho, method, alpha, gamma, estimate),
                               ~get_power(..1, ..2, ..3, ..4, ..5, ..6, ..7, ..8, ..9, ..10, ..11),
                               .options = furrr::furrr_options(seed = TRUE))
  ) |>
  unnest(power)
