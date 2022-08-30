# =============================================================================
# get_mean_sd
# 2021-05-10

# NOTES: I'm creating a custom function below for analyzing age (and possibly 
# other continuous variables below). I'm doing so for two reasons: 
# 1. mean_tables doesn't calculate standard deviation, and 
# 2. The column names from mean_table and freq_table don't align well. 
# I've added both to these as issues in the meantables package (#11 and #12).
# =============================================================================

# Helper function for analyzing continuous variables (age) for Table 1 and 
# Table 2
# -----------------------------------------------------------------------------
get_mean_sd <- function(.data, .x, digits) {
  .data %>% 
    filter(!is.na({{.x}})) %>% 
    summarize(
      var  = !!quo_name(enquo(.x)),
      # Do this for easier row binding below
      cat  = NA_character_,
      mean = mean({{.x}}) %>% round(digits),
      sd   = sd({{.x}}) %>% round(digits),
      formatted_stats = paste0(mean, " (", sd, ")")
    ) %>% 
    select(var, cat, formatted_stats)
}

# For testing
# demographics %>% 
#   get_mean_sd(age, "Age in years, mean (sd)", 1)