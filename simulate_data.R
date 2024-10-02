simulate_data <- function(
    sample_size, # number subjects per dosegroup
    effects, # matrix 2 x 2? dose x endpoint
    rho # correlation between the endpoints
) {
    corr_mat_endpoints <- matrix(c(
      1, rho,
      rho, 1
    ),2, byrow = TRUE)

    m <- nrow(mu) # number of dosegroups

    tbl_data <- expand_grid(
      group = 0:(m-1)
    ) |>
      mutate(
        y = purrr::map(
          group,
          function(g) {
            res <- MASS::mvrnorm(n, mu[g + 1,], corr_mat_endpoints)
            colnames(res) <- c("a", "b")
            as_tibble(res)
          }
        )
      ) |>
      unnest(y)
    return(tbl_data)

} # sample_size x 3 matrix with columns: dose (0, 1, 2), a, b

#####
n <- 5
mu <- matrix(c(0, 0,
               0, 0,
               0, 0), nrow = 3, ncol = 2) # Mittelwert-Matrix (Zeilen entsprechen Dosisgruppen)
rho <- 0.5

temp <- simulate_data(n, mu, rho)
