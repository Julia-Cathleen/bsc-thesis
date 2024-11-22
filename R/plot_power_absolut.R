plot_power_absolut <- function(data){

  mean_power <- mean(data$power, na.rm = TRUE)

  ymin <- mean_power - 0.04
  ymax <- mean_power + 0.04
  if ("effect_name" == "null"){
    ymin <- 0
  ymax <- 0.03}

  new_labels <- c("Bonferroni" = "Bonf.",
                  "parametric" = "Param.",
                  "truncHochberg" = "TruncHB")

  plot <- ggplot(data,
                 aes(x = method, y = power, color = corr_estimation)) +
    geom_point(position = position_dodge(width = 0.3), size = 2) +
    geom_errorbar(aes(
      ymin = lower_ci,
      ymax = upper_ci),
      width = 0.1,
      position = position_dodge(0.3)) +
    theme_bw() +
    labs(x="", y="power") +
    scale_color_manual(name = "corr_estimation", values = c("TRUE" = "darkgray", "FALSE" = "black"), breaks = c("TRUE", "FALSE")) +
    theme(legend.position = "bottom", legend.box = "vertical", legend.text = element_text(size = 10),  text = element_text(size = 14)) +
    facet_grid(effect_name ~ gamma, labeller = label_both) +
    coord_cartesian(ylim = c(ymin, ymax)) +
    scale_x_discrete(labels = new_labels) +
    scale_y_continuous(labels = scales::percent)

  return(plot)
}
