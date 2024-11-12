library(tidyverse)

n_sim <- 100000
n_sim_per_batch <- 2000
sample_size <- 80
rho <- c(0.5, 0.7, 0.9)

# define tbl_scenarios

effect <- list(
  "I" = c(0.4, 0, 0.2, 0),
  "II" = c(0.4, 0.4, 0, 0.2),
  "III" = c(0, 0, 0.4, 0.4),
  "IV" = c(0.4, 0.4, 0.4, 0.4),
  "V" = c(0.4, 0.4, 0, 0),
  "null" = c(0, 0, 0, 0)
)
gamma <- c(0.5, 0.9)
alpha <- 0.025
method <- c("truncHochberg", "Bonferroni", "parametric")
corr_estimation <- c(TRUE, FALSE)

tbl_scenarios <- expand_grid(
  n_sim = n_sim,
  sample_size = sample_size,
  effect = effect,
  rho = rho,
  method = method,
  alpha = alpha,
  gamma = gamma,
  corr_estimation = corr_estimation
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

