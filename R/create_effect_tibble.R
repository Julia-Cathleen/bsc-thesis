create_effect_tibble <- function(data) {
  mat <- do.call(rbind, data)

  df <- data.frame(mat)

  colnames(df) <- c("mu_a2", "mu_b2", "mu_a1", "mu_b1")

  df$scenario_name <- rownames(df)

  df <- df[, c("mu_a2", "mu_b2", "mu_a1", "mu_b1")]

  return(df)
}
