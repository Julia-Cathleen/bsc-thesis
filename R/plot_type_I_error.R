plot_type_I_error <- function(data){

  plot <- ggplot(data,
                 aes(x = effect_name, y = power, color = method)) +
    geom_point(position = position_dodge(width = 0.3)) +
    geom_hline(yintercept = 0, linetype="dashed", color = "darkgrey") +
    geom_errorbar(aes(
      ymin = lower_ci,
      ymax = upper_ci),
      width = 0.2,
      position = position_dodge(width = 0.3)) +
    theme_bw() +
    labs(x="effect", y="type I error rate") +
    scale_color_manual(name = "Method", values = c("truncHochberg" = "black", "Bonferroni" = "darkgray", "parametric" = "gray")) +
    theme(legend.position = "bottom", legend.text = element_text(size = 10),  text = element_text(size = 14)) +
    facet_grid(estimate ~ gamma)

  return(plot)
}
