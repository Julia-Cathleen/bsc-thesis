plot_power <- function(data){

  plot <- ggplot(data,
                 aes(x = effect_name, y = power, color = corr_estimation)) +
    geom_point(position = position_dodge(width = 0.3), size = 2) +
    geom_hline(yintercept = 0, linetype="dashed", color = "darkgrey") +
    geom_errorbar(aes(
      ymin = lower_ci,
      ymax = upper_ci),
      width = 0.2,
      position = position_dodge(width = 0.3)) +
    theme_bw() +
    labs(x="effect", y="power") +
    scale_color_manual(name = "corr_estimation", values = c("TRUE" = "darkgray", "FALSE" = "black")) +
    theme(legend.position = "bottom", legend.box = "vertical", legend.text = element_text(size = 10),  text = element_text(size = 14)) +
    facet_grid( ~ gamma, labeller = label_both)

  return(plot)
}
