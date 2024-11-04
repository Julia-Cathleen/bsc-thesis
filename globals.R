library(tidyverse)

n_sim <- 100000
n_sim_per_batch <- 400
sample_size <- 80
rho <- c(0.5, 0.7, 0.9)

# define tbl_scenarios

effect <- list(
  "effect_in_a" = c(0.4, 0, 0.2, 0),
  "effect_in_a2_b2_b1" = c(0.4, 0.4, 0, 0.2),
  "low_dose" = c(0, 0, 0.4, 0.4),
  "equal_effects" = c(0.4, 0.4, 0.4, 0.4),
  "high_dose" = c(0.4, 0.4, 0, 0),
  "null" = c(0, 0, 0, 0)
)
gamma <- c(0.5, 0.9)
alpha <- 0.025
method <- c("truncHochberg", "Bonferroni", "parametric")
estimate <- c(TRUE, FALSE)

tbl_scenarios <- expand_grid(
  n_sim = n_sim,
  sample_size = sample_size,
  effect = effect,
  rho = rho,
  method = method,
  alpha = alpha,
  gamma = gamma,
  estimate = estimate
) |>
  mutate(
    effect_name = names(effect),
    effect = map(effect_name, ~effect[[.]])
  ) |>
  unnest_wider(effect, names_sep = "_") |>
  rename(
    mu_a2 = effect_1,
    mu_b2 = effect_2,
    mu_a1 = effect_3,
    mu_b1 = effect_4
  )

