get_latex_table <- function(data){
  table <- as_latex(gt(data))
  return(table)
}
