summarize_data <- function(
    data,
    sample_size
) {
    tbl_pval <- data |>
      pivot_longer(
        a:b,
        names_to = "endpoint",
        values_to = "y"
      ) |>
      group_by(
        group,
        endpoint
      ) |>
      summarize(
        mean = mean(y),
        .groups = "drop"
      ) |>
      pivot_wider(
        names_from = group,
        values_from = mean,
        names_prefix = "mean_group_"
      ) |>
      mutate( #create the test - statistics
        mean_diff_1 = mean_group_1 - mean_group_0,
        mean_diff_2 = mean_group_2 - mean_group_0,
        z_1 = mean_diff_1 / (sqrt((2 / sample_size))),
        z_2 = mean_diff_2 / (sqrt((2 / sample_size)))
      ) |>
      select(
        endpoint, starts_with("z_")
      ) |>
      pivot_longer(
        starts_with("z_"),
        names_to = "group",
        values_to = "z"
      ) |>
      mutate(
        group = as.integer(
          str_extract(
            group, "(?<=z_).+"
          )
        ),
        p = 1 - pnorm(z, lower.tail = FALSE)
      )  |>
      select(-z) |>
      unite("endpoint_group", endpoint, group, sep = "_") |>
      pivot_wider(
        names_from = endpoint_group,
        values_from = p
      ) |>
      select(c("a_2", "b_2", "a_1", "b_1"))


    rho_hat <- cor(data$a, data$b, method = "pearson")

    return(list(tbl_pval = tbl_pval, rho_hat = rho_hat))


} #list: 4 p_values, rho_hat --> list_data
