plot_type_I_error <- function(data){

  mean_power <- mean(data$power, na.rm = TRUE)

  ymin <- mean_power - 0.04
  ymax <- mean_power + 0.04

  plot <- ggplot(data,
                 aes(x = corr_estimation, y = power)) +
    geom_point(position = position_dodge(width = 0.3), size = 2.6) +
    geom_hline(yintercept = 0.025, linetype="dashed", color = "darkgrey") +
    geom_errorbar(aes(
      ymin = lower_ci,
      ymax = upper_ci),
      width = 0.2,
      position = position_dodge(width = 0.3)) +
    theme_bw() +
    labs(x="corr_estimation", y="type I error rate") +
    theme(legend.position = "bottom", legend.text = element_text(size = 10),  text = element_text(size = 14)) +
    facet_grid( ~ gamma, labeller = label_both) +
    coord_cartesian(ylim = c(ymin, ymax))

  return(plot)
}
