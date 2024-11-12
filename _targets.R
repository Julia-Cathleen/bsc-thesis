options(
  tidyverse.quiet = TRUE
)

library(targets)

tar_option_set(
  packages = c("tidyverse", "tidyr", "dplyr", "xtable"),
  controller = crew.cluster::crew_controller_slurm(
    workers = 32 * 100, slurm_cpus_per_task = 1, slurm_memory_gigabytes_per_cpu = 4
  )
)

tar_source()
source("globals.R")

batches <- max(1, round(n_sim / n_sim_per_batch))


list(

  tarchetypes::tar_map_rep(
    name = tbl_power,
    command = {
        get_power(n_sim_per_batch, sample_size, mu_a1, mu_a2,mu_b1, mu_b2, rho, method, alpha, gamma, corr_estimation)
    },
    batches = batches, # total sims per scenario = batches * n_sim
    values = tbl_scenarios # defined in globals.R
  ),

  targets::tar_target(
    name = tbl_data_summarized,
    command = tbl_power |>
      summarize(
        power_all_in_one_dose = mean(power_all_in_one_dose, na.rm = TRUE),
        power_any = mean(power_any, na.rm = TRUE),
        .by = names(tbl_scenarios)
      ) |>
      pivot_longer(
        cols = c(power_all_in_one_dose, power_any),
        names_to = "event",
        values_to = "power"
      ) |>
      mutate(
        event = stringr::str_remove(event, "power_")
      )
  ),

  targets::tar_target(
    name = tbl_data_diff,
    command = calculate_differences(tbl_data_summarized |> filter(rho == 0.9))
  ),

  targets::tar_target(
    name = tbl_results,
    command = get_latex_table(tbl_data_diff)
  ),

  targets::tar_target(
    name = tbl_effects,
    command = get_latex_table(create_effect_tibble(effect))
  ),

  targets::tar_target(
    name = test_graph,
    command = get_test_graph(alpha, gamma[2])
  ),


  targets::tar_target(
    name = power_plot_absolut_high,
    command = tbl_data_diff |>
      filter(rho == 0.9, effect_name %in% c("II", "IV", "V"), event == "all_in_one_dose") |>
      plot_power_absolut()
  ),

  targets::tar_target(
    name = file_power_plot_absolut_high,
    command = ggsave(filename = "results/power_plot_absolut_high.jpg",
                     plot = power_plot_absolut_high,
                     width = 6)
  ),


  targets::tar_target(
    name = power_plot_absolut_low,
    command = tbl_data_diff |>
      filter(rho == 0.9, effect_name %in% c("I", "III"), event == "all_in_one_dose") |>
      plot_power_absolut()
  ),

  targets::tar_target(
    name = file_power_plot_absolut_low,
    command = ggsave(filename = "results/power_plot_absolut_low.jpg",
                     plot = power_plot_absolut_low,
                     width = 6)
  ),


  targets::tar_target(
    name = power_plot_parametric,
    command = tbl_data_diff |>
      filter(effect_name != "null" & event == "all_in_one_dose", method == "parametric") |>
      plot_power()
  ),

  targets::tar_target(
    name = file_power_plot_parametric,
    command = ggsave(filename = "results/power_plot_parametric.jpg",
                     plot = power_plot_parametric,
                     width = 6)
  ),


  targets::tar_target(
    name = power_plot_null,
    command = tbl_data_diff |>
      filter(effect_name == "null", rho == 0.9, method == "parametric", event == "any") |>
      plot_type_I_error()
  ),

  targets::tar_target(
    name = file_power_plot_absolut_null,
    command = ggsave(filename = "results/power_plot_null.jpg",
                     plot = power_plot_null)
  )


)
