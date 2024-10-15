plot_power <- function(data){

  plot <- ggplot(data
                 %>% filter(method %in% c("truncHochberg", "Bonferroni")),
                 aes(x = effect_name, y = diff_para_any, color = method)) +
    geom_point(position = position_dodge(width = 0.3)) +
    geom_hline(yintercept = 0, linetype="dashed", color = "darkgrey") +
    geom_errorbar(aes(
      ymin = diff_para_any - sim_err_diff_para_any,
      ymax = diff_para_any + sim_err_diff_para_any),
      width = 0.2,
      position = position_dodge(width = 0.3)) +
    theme_bw() +
    labs(x="effect", y="power difference") +
    scale_color_manual(name = "Method", values = c("truncHochberg" = "darkgray", "Bonferroni" = "black")) +
    theme(legend.position = "bottom", legend.text = element_text(size = 10),  text = element_text(size = 14)) +
    facet_grid(estimate ~ gamma)

  ggsave("power_results.jpg",
         scale = 1.5,
         plot = plot,
         width = 8.27,
         height = 5.5,
         units = "in")

  return(plot)
}
