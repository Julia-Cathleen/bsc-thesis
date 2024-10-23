calculate_differences <- function(data){

data_diff <- data |>
  mutate(
    sim_err_any = sqrt(power*(1 - power)/ n_sim)
  ) |>
  group_by(effect_name, gamma) |>
  mutate(
    diff_para_any = ifelse(effect_name != "null", power - power[method == "parametric"], NA),
    sim_err_diff_para_any = ifelse(effect_name != "null", sqrt(sim_err_any^2 + sim_err_any[method == "parametric"]^2), NA),
    lower_ci = ifelse(effect_name != "null", diff_para_any - 1.96 * sim_err_diff_para_any, power - 1.96 * sim_err_any),
    upper_ci = ifelse(effect_name != "null", diff_para_any + 1.96 * sim_err_diff_para_any, power + 1.96 * sim_err_any)
  ) |>
  ungroup()

  return(data_diff)
}
