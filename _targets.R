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
        get_power(n_sim_per_batch, sample_size, mu_a1, mu_a2,mu_b1, mu_b2, rho, method, alpha, gamma, estimate)
    },
    batches = batches, # total sims per scenario = batches * n_sim
    values = tbl_scenarios # defined in globals.R
  ),

  targets::tar_target(
    name = tbl_data_summarized,
    command = tbl_power |>
      summarize(
        power = mean(power, na.rm = TRUE),
        .by = names(tbl_scenarios)
      )
  ),

  targets::tar_target(
    name = tbl_results,
    command = code_table(tbl_data_summarized)
  ),

  targets::tar_target(
    name = tbl_effects,
    command = code_table(create_data_frame(effect))
  ),

  targets::tar_target(
    name = test_graph,
    command = get_test_graph(alpha, gamma[2])
  ),

  targets::tar_target(
    name = power_plot,
    command = tbl_data_summarized |>
      filter(effect_name != "null") |>
      plot_power()
  ),

  targets::tar_target(
    name = power_plot_null,
    command = tbl_data_summarized |>
      filter(effect_name == "null") |>
      plot_power()
  )
)
