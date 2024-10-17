
a_1 <- runif(1000)
a_2 <- runif(1000)
b_1 <- runif(1000)
b_2 <- runif(1000)

data <- tibble(a_2, b_2, a_1, b_1)

hochberg <- function(data, gamma = 0.9){
  Mediana::AdjustPvalues(
    as.numeric(data),
    proc = "ParallelGatekeepingAdj",
    par = Mediana::parameters(
      family = Mediana::families(family1 = c(1, 2),
                                 family2 = c(3, 4)),
      proc = Mediana::families(family1 = "HochbergAdj",
                               family2 = "HochbergAdj"),
      gamma = Mediana::families(family1 = gamma,
                                family2 = 1)
    )
  )
}

graphical <- function(data, gamma = 0.9, alpha = 0.025){
  m <- matrix(c(0, gamma, (1 - gamma)/2, (1 - gamma)/2,
                gamma, 0, (1 - gamma)/2, (1 - gamma)/2,
                0, 0, 0, 1,
                0, 0, 1, 0), nrow = 4, byrow = TRUE)
  w <- c(0.5, 0.5, 0, 0)

  significant <- gMCPLite::gMCP(
    graph = gMCPLite::matrix2graph(m, w),
    pvalues = data,
    test = "Bonferroni",
    alpha = alpha,
    verbose = FALSE
  )@rejected

  return(significant)
}

temp <- mean(apply(data, 1, hochberg) <= 0.025)
temp1 <- mean(apply(data, 1, apply_mcp))

list_of_tibbles <- apply(data, MARGIN = 1, function(x) {
  # Konvertieren Sie den numerischen Vektor in einen Datenrahmen
  df <- as.data.frame(t(x))
  # Wenden Sie die apply_mcp Funktion an
  apply_mcp(df, rho = 0.9, method = "Bonferroni", alpha = 0.025, gamma = 0.9)
})

# Fügen Sie alle Tibbles in der Liste zu einem großen Tibble zusammen
big_tibble <- bind_rows(list_of_tibbles)
