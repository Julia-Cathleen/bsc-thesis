calculate_differences <- function(data){

data_diff <- data |>
  mutate(
    sim_err_any = sqrt(power*(1 - power)/ n_sim)
  ) |>
  group_by(effect_name, gamma) |>
  mutate(
    diff_parametric = if_else(effect_name != "null", power[method == "parametric"] - power, NA),
    sim_err_diff_parametric = if_else(effect_name != "null", sqrt(sim_err_any^2 + sim_err_any[method == "parametric"]^2), NA),
    lower_ci = if_else(effect_name != "null", power - 1.96 * sim_err_diff_parametric, power - 1.96 * sim_err_any),
    upper_ci = if_else(effect_name != "null", power + 1.96 * sim_err_diff_parametric, power + 1.96 * sim_err_any)
  ) |>
  ungroup()

  return(data_diff)
}
