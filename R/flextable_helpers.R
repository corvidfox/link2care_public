# =============================================================================
# flextable helpers
# 2021-05-10

# These formats and functions are to help with flextable styling 
# If you want to autonumber tables see here: 
# https://stackoverflow.com/questions/63530204/is-there-a-way-to-bold-part-of-a-character-string-being-passed-to-add-header-lin. 
# I didn't think it was necessary. 

# Eventually, add this stuff to R Notes.
# =============================================================================


# Use for bolding chunks of text
# ------------------------------
header_fmt <- fp_text(font.size = 11, bold = TRUE, font.family = "Times New Roman")

# Example
# head(mtcars) %>% 
#   flextable() %>% 
#   merge_at(i = 1, part = "header") %>%
#   compose(
#     part = "header",
#     value = as_paragraph(
#       as_chunk("Table 1. ", props = header_fmt),
#       "Part of mtcars."
#     )
#   )


# Create my own flextable theme
# -----------------------------
my_ft_theme <- function(ft, ...) {
  # Remove vertical cell padding
  ft <- padding(ft, padding.top = 0, padding.bottom = 0, part = "all")
  
  # Change font to TNR 11
  ft <- font(ft, fontname = "Times New Roman", part = "all")
  ft <- fontsize(ft, part = "all", size = 11)
  
  # Column width
  # Set initial width to be the equivalent of opening word and clicking
  # "fit to window", which is 6.3 divided by the number of columns.
  ft <- width(ft, width = (6.30 / ncol_keys(ft)))
}