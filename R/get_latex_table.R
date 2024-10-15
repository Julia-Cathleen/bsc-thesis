get_latex_table <- function(data){
  table <- xtable(data)
  print.xtable(table, type = "latex")
}
