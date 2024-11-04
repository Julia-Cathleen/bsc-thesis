plot_power <- function(data){

  plot <- ggplot(data,
                 aes(x = effect_name, y = power, color = estimate)) +
    geom_point(position = position_dodge(width = 0.3), size = 2.6) +
    geom_hline(yintercept = 0, linetype="dashed", color = "darkgrey") +
    geom_errorbar(aes(
      ymin = lower_ci,
      ymax = upper_ci),
      width = 0.2,
      position = position_dodge(width = 0.3)) +
    theme_bw() +
    labs(x="effect", y="power") +
    scale_color_manual(name = "estimate", values = c("TRUE" = "darkgray", "FALSE" = "black")) +
    theme(legend.position = "bottom", legend.text = element_text(size = 10),  text = element_text(size = 14)) +
    facet_grid( ~ gamma, labeller = label_both)

  ggsave("power_results.jpg",
         scale = 1.5,
         plot = plot,
         width = 8.27,
         height = 5.5,
         units = "in")

  return(plot)
}
