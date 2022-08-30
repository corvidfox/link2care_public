# =============================================================================
# spss_to_fs
# 2021-04-14
# =============================================================================

# Use SPSS labels as factor levels for categorical variables

# For use inside across()
spss_to_fs <- function(x) {
  levs <- attr(x, "labels")
  labs <- names(levs)
  x_f <- factor(x, levs, labs)
  x_f
}

# For testing
# all_visits %>%
#   select(SQ_2, SQ_3) %>%
#   mutate(
#     across(
#       everything(),
#       spss_to_fs,
#       .names = "{col}_f"
#     )
#   )