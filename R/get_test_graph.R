get_test_graph <- function(alpha, gamma){
  m <- matrix(c(0, gamma, (1 - gamma)/2, (1 - gamma)/2,
                gamma, 0, (1 - gamma)/2, (1 - gamma)/2,
                0, 0, 0, 1,
                0, 0, 1, 0), nrow = 4, byrow = TRUE)
  w <- c(0.5, 0.5, 0, 0)
  graph <- gMCPLite::hGraph(
    nHypotheses = 4,
    m = m,
    alphaHypotheses = alpha*w,
    nameHypotheses = c("a_high", "b_high", "a_low", "b_low")
  )
  return(graph)
}
