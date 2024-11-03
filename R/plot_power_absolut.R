plot_power_absolut <- function(data){

  plot <- ggplot(data,
                 aes(x = effect_name, y = power, color = estimate)) +
    geom_point(position = position_dodge(width = 0.3), aes(shape = method)) +
    theme_bw() +
    labs(x="effect", y="power") +
    scale_color_manual(name = "Estimate", values = c("TRUE" = "black", "FALSE" = "gray")) +
    theme(legend.position = "bottom", legend.text = element_text(size = 13),  text = element_text(size = 14)) +
    facet_grid(~ gamma, labeller = label_both)

  ggsave("power_results.jpg",
         scale = 1.5,
         plot = plot,
         width = 8.27,
         height = 5.5,
         units = "in")

  return(plot)
}
