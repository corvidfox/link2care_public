# =============================================================================
# standardize_col_names
# 2021-07-12
# =============================================================================

# Used to do an initial cleaning of the QDS column names.
#   * Remove _v{1, 2, 3} and v{1, 2, 3} from column names
#   * Replace spaces with underscores
#   * Convert to lower case
#   * Add underscore in-between the abbreviated tool name and question number
# This won’t be perfect, but it will drastically reduce the number of manual changes we have to make.

standardize_col_names <- function(.data) {
  # Get the existing column names
  old_names <- names(.data)
  # Create a string that contains _V1 through _V5 and V1 through V5 to pass to
  # the regular expression below
  v_num <- paste0("_V", 1:5, collapse = "|")
  vnum <- paste0("V", 1:5, collapse = "|")
  v_pattern <- paste(paste(v_num, vnum, sep = "|"), collapse = "|")
  # Remove _v{1, 2, 3} from column name
  # Remove v{1, 2, 3} at end of column name (e.g., DEM1v3)
  new_names <- stringr::str_replace(old_names, v_pattern, "")
  # Replace spaces with underscores
  new_names <- stringr::str_replace_all(new_names, " ", "_")
  # Convert to lower case
  new_names <- stringr::str_to_lower(new_names)
  # Add underscore in-between the abbreviated tool name and question number
  new_names <- stringr::str_replace(new_names, "([a-z])(\\d)", "\\1_\\2")
  # Return character vector of standardized column names
  new_names
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
# standardize_col_names(v1)

test_that("standardize_col_names produces the expected column names.", {
  v1_test <- tibble(
    SUBJECT  = c(2001, 2002),
    TODAY_V1 = as.Date(c("2018-04-07", "2018-05-03")),
    VISIT_V1 = 1,
    SQ_2     = c(1, 0),
    WEIGHT   = c(179, 194),
    DEMO16G  = c(0, 1),
    DEM15V1  = c(1, 0),
    T26A_V1  = c(2, 4),
    T26A_V1A = c(0, 0),
    T26A_V1B = c(1, 0),
    TEST_V8 = 0
  )
  new_names <- standardize_col_names(v1_test)
  expceted_new_names <- c(
    "subject", "today", "visit", "sq_2", "weight", "demo_16g", "dem_15", 
    "t_26a", "t_26aa", "t_26ab", "test_v_8"
  )
  expect_equal(new_names, expceted_new_names)
})