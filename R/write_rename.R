# =============================================================================
# write_rename
# 2021-07-12
# =============================================================================

# Used to do an initial cleaning of the QDS column names. So that you don’t 
# have to type it out by hand. Ideally, you only have to run this code once, 
# copy and paste into the rename code chunk below, and then just make small 
# updates to the rename code chunk if changes are made to QDS.

write_rename <- function(.data, .new_names) {
  new_old_name_pairs <- paste(.new_names, names(.data), sep = " = ")
  new_old_name_pairs <- paste(new_old_name_pairs, collapse = ", \n")
  cat(new_old_name_pairs)
}

# For testing
# v1 <- tibble(
#   SUBJECT  = c(2001, 2002),
#   TODAY_V1 = as.Date(c("2018-04-07", "2018-05-03")),
#   VISIT_V1 = 1,
#   SQ_2     = c(1, 0),
#   WEIGHT   = c(179, 194),
#   DEMO16G  = c(0, 1),
#   DEM15V1  = c(1, 0),
#   T26A_V1  = c(2, 4),
#   T26A_V1A = c(0, 0),
#   T26A_V1B = c(1, 0)
# )
# new_names <- standardize_col_names(v1)
# write_rename(v1, new_names)