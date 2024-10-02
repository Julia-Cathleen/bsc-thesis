get_power <- function(n_sim, ...) {
  tbl_results <- tibble(iter = 1:n_sim) |>
    mutate(
      res = furrr::future_map(1:n_sim, .f = simulate_scenario_once, ...)
    ) |>
    unnest(res)
  #calculate power of tbl_results
}
