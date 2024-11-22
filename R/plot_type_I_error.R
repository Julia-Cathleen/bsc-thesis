plot_type_I_error <- function(data){

  plot <- ggplot(data,
                 aes(x = corr_estimation, y = power)) +
    geom_point(position = position_dodge(width = 0.3), size = 2) +
    geom_hline(yintercept = 0.025, linetype="dashed", color = "darkgrey") +
    geom_errorbar(aes(
      ymin = lower_ci,
      ymax = upper_ci),
      width = 0.2,
      position = position_dodge(width = 0.3)) +
    theme_bw() +
    labs(x="corr_estimation", y="FWER") +
    theme(legend.position = "bottom", legend.text = element_text(size = 10),  text = element_text(size = 14)) +
    facet_grid( ~ gamma, labeller = label_both) +
    coord_cartesian(ylim = c(0, 0.03)) +
    scale_y_continuous(labels = scales::percent)

  return(plot)
}
