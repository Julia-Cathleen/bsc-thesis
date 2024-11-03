plot_type_I_error <- function(data){

  plot <- ggplot(data,
                 aes(x = estimate, y = power)) +
    geom_point(position = position_dodge(width = 0.3)) +
    geom_hline(yintercept = 0.025, linetype="dashed", color = "darkgrey") +
    geom_errorbar(aes(
      ymin = lower_ci,
      ymax = upper_ci),
      width = 0.2,
      position = position_dodge(width = 0.3)) +
    theme_bw() +
    labs(x="estimate", y="type I error rate") +
    theme(legend.position = "bottom", legend.text = element_text(size = 10),  text = element_text(size = 14)) +
    facet_grid( ~ gamma, labeller = label_both)

  return(plot)
}
