plot_power_absolut <- function(data){

  plot <- ggplot(data,
                 aes(x = effect_name, y = power, color = corr_estimation)) +
    geom_point(position = position_dodge(width = 0.3), aes(shape = method), size = 2.6) +
    theme_bw() +
    labs(x="effect", y="power") +
    scale_color_manual(name = "Estimate", values = c("TRUE" = "black", "FALSE" = "gray")) +
    theme(legend.position = "bottom", legend.text = element_text(size = 10),  text = element_text(size = 10)) +
    facet_grid(~ gamma, labeller = label_both)

  return(plot)
}
