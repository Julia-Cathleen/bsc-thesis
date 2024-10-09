library(targets)

tar_option_set(
  packages = c("tidyverse", "tidyr", "dplyr"),
  controller = crew.cluster::crew_controller_slurm(
    workers = 32 * 100, slurm_cpus_per_task = 1, slurm_memory_gigabytes_per_cpu = 4
  )
)

tar_source()
source("globals.R")

n_sims <- 500
n_sim_per_batch <- 10
batches <- max(1, round(n_sims / n_sim_per_batch))


list(

  tarchetypes::tar_map_rep(
    name = tbl_power,
    command = {
      #get_power(n_sim, sample_size, mu_a1, mu_a2,mu_b1, mu_b2, rho, method, alpha, gamma, estimate)
      get_results(tbl_scenarios)
    },
    batches = batches, # total sims per scenario = batches * n_sim
    values = tbl_scenarios # defined in globals.R
  ),

  targets::tar_target(
    name = tbl_power_summarized,
    command = tbl_power |>
      summarize(
        power = mean(power, na.rm = TRUE),
        .by = names(tbl_scenarios)
      )
  )
)
