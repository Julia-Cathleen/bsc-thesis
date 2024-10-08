
n_sim <- 10000
sample_size <- 80
rho <- 0.9

# define tbl_scenarios

effect <- list(
  "just_a" = c(0.4, 0, 0.2, 0),
  "except_a_1" = c(0.4, 0.4, 0, 0.2),
  "low" = c(0, 0, 0.4, 0.4),
  "equal" = c(0.4, 0.4, 0.4, 0.4),
  "high" = c(0.4, 0.4, 0, 0),
  "null" = c(0, 0, 0, 0)
)
gamma <- c(0.5, 0.9)
alpha <- 0.05
method <- c("truncHochberg", "Bonferroni", "parametric")

tbl_scenarios <- tidyr::expand_grid(
  n_sim = n_sim,
  sample_size = sample_size,
  effect = effect,
  rho = rho,
  method = method,
  alpha = alpha,
  gamma = gamma
) |>
  mutate(
    effect_name = names(effect),
    effect = map(effect_name, ~effect[[.]]),
    estimate = TRUE
  ) |>
  tidyr::unnest_wider(effect, names_sep = "_") |>
  rename(
    mu_a2 = effect_1,
    mu_b2 = effect_2,
    mu_a1 = effect_3,
    mu_b1 = effect_4
  )
