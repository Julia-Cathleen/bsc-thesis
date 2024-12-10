# Repository: bsc-thesis

Power comparison of the truncated Hochberg procedure vs. graphical approach with GMCPLite using whether a weighted parametric or Bonferroni test.

This repository contains a set of functions for performing statistical power calculations using the main function get_power. This function uses either the truncated Hochberg or the graphical multiple comparison procedures (gMCP).

## Function Description
The simulate_data function needs the sample_size, effect matrix and the correlation between the considered endpoints, to generate a tibble (sample_size x 3) with columns dose and one for each endpoint. This matrix contains multivariate normal distributed random variables which represent the response per patient and endpoint.

Summarize_data needs the data tibble of simulate_data and the sample_size. This function calculates four p-values, one for each combination of dose group and endpoint, with a one-sided Z-test and an estimator for the correlation between the endpoints. The correlation is calculated with the Pearson correlation coefficient.

Apply_mcp takes as input a tibble of p-values, the correlation between the endpoints rho, the method, the significance level alpha and the truncation parameter gamma. It calculates the adjusted p-values with the respective method and returns a tibble of them.

Simulate_scenario_once expects the sample_size, the mean values for a1, a2, b1, b2, the correlation parameter for the endpoints rho, the method, the significance level alpha, the truncation parameter gamma. In addition it needs the information whether the rho should be estimated or not, which is saved in corr_estimation. The function calls first simulate_data to be able to call summarize_data and afterwards to call apply_mcp. In total the function creates a tibble of adjusted p-values for specific parameter combinations.

The get_power function takes as input the number of simulations n_sim, the sample_size, the mean values for a1, a2, b1, b2, the correlation parameter for the endpoints rho, the method, the significance level alpha, the truncation parameter gamma. In addition it needs the information whether the rho should be estimated or not, which is saved in corr_estimation. This function calls n_sim times simulate_scenario_once and calculates two power values. Power_all_in_one_dose represents the power in case that all endpoints in one dose are significant and the second power is called power_any, where any endpoint is significant. Power_any in the null scenario represents the type one error rate in the null scenario.

Create_effect_tibble generates a tibble of the different effects. Therefore it expects the mean values and the name of the effect scenarios.

Get_latex_table takes as input a tibble and returns the latex code for this tibble.

Calculate_differences expects a tibble of power values and calculates the difference between the power, where the method “parametric” was used, and all the other power values. In addition to that the confidence intervals are calculated.

Get_test_graph generates an illustration of the test graph with the respective alpha and gamma.

There are some functions to plot the power. Plot_power_absolut plots the absolut values of the power. It differentiates between the trunctation parameter gamma and if the correlation of the endpoint was estimated or not. Plot_type_I_error plots the power and differentiates between the truncation parameters and the values for the correlation between the endpoints.

The targets pipeline executes all of these functions and saves the plots in the results folder.

## Usage
```
apply_mcp(pval, rho, method = c("truncHochberg", "Bonferroni", "parametric"), alpha, gamma)

calculate_differences(data)

get_latex_table(data)

get_power(n_sim, sample_size, mu_a1,mu_a2, mu_b1, mu_b2, rho, method, alpha, gamma, corr_estimation)

get_test_graph(alpha, gamma)

plot_power_absolut(data)

plot_power(data)

plot_type_I_error(data)

simulate_data(sample_size, effects, rho)

simulate_scenario_one(sample_size, mu_a1,mu_a2, mu_b1, mu_b2, rho, method, alpha, gamma, corr_estimation)

summarize_data(data, sample_size)
```

## Dependencies
The get_power function depends on the following R packages:

- tidyverse
- mvtnorm
- furrr
- future
- Mediana
- gMCPLite
- targets
- crew

The plot functions depend on the following R packages:
- ggplot2


to execute the pipeline:
```
targets::tar_make(reporter = "summary", as_job = TRUE)
```
