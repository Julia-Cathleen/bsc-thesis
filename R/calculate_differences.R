calculate_differences <- function(data){

  data_diff <- data %>%
    mutate(
      sim_err_any = sqrt(power*(1 - power)/ n_sim)
    ) %>%
    group_by(effect_name, gamma) %>%
    mutate(
      diff_para_any = power - power[method == "parametric"],
      sim_err_diff_para_any = sqrt(sim_err_any^2 + sim_err_any[method == "parametric"]^2),
      lower_ci = diff_para_any - 1.96 * sim_err_diff_para_any,
      upper_ci = diff_para_any + 1.96 * sim_err_diff_para_any
    ) |>
    ungroup()

  return(data_diff)
}
