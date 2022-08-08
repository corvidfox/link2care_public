# Helper function to add the source attribute to each column of a data frame
# Intended to be used during the process of importing and do the initial
# cleaning of each data frame -- before combining them into a single data
# frame for analysis.
add_source_attr <- function(.data, source){
  df_nm <- deparse(substitute(.data))
  for (col in names(.data)) {
    attr(.data[[col]], "source") <- source
  }
  assign(df_nm, .data, envir = .GlobalEnv)
}