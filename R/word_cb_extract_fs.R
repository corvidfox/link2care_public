# =============================================================================
# This script contains some functions that are intended to help with the 
# process of extracting section and column names from the Word versions of the
# QDS codebooks
# 2021-07-13
# =============================================================================

# =============================================================================
# get_sec_and_col_names_from_word_cb
# When we read in the Word codebook, we get ALL the content. This function
# helps us filter that content down to just section and column names.
# 
# .data = The result of officer::read_docx("codebook") %>% officer::docx_summary()
# =============================================================================

get_sec_and_col_names_from_word_cb <- function(.data) {
  .data %>%
    filter(style_name %in% c("section_name", "cb_col_name", "col_name")) %>% 
    select(doc_index, style_name:text) %>% 
    pivot_wider(
      names_from = "style_name",
      values_from = "text"
    )
}

# =============================================================================
# clean_word_cb_sec_names
# For example, convert "Sect-0.*****Admin*****" to "Admin"
# 
# .data = The result of get_sec_and_col_names_from_word_cb()
# =============================================================================

clean_word_cb_sec_names <- function(.data) {
  .data %>%
    mutate(
      # Remove "Sect-number."
      section_name = str_remove(section_name, "Sect-\\d{1,}."),
      # Remove asterisks
      section_name = str_remove_all(section_name, "\\*"),
      # Remove empty spaces
      section_name = str_trim(section_name),
      # Clean " (SQ_7 - SQ_11)" from exclusion criteria
      section_name = str_remove(section_name, " \\(SQ_7 - SQ_11\\)")
    )
}

# =============================================================================
# create_copy_paste_col
# Create a new column in the new_name = old_name format that we can copy and 
# paste into `select()` later.
# 
# .data = The result of clean_word_cb_sec_names()
# =============================================================================

create_copy_paste_col <- function(.data) {
  .data %>% 
    # Add underscores to the new column names 
    # (the ones I added to the Word codebook). For example, mms5 to mms_5.
    mutate(
      col_name = str_replace_all(col_name, " ", "_"),
      col_name = str_replace(col_name, "([a-z])(\\d)", "\\1_\\2")
    ) %>% 
    # Fill section name down across rows
    fill(section_name) %>% 
    # Spread cb_col_name across rows
    fill(cb_col_name) %>% 
    # Spread col_name across rows within cb_col_name
    group_by(cb_col_name) %>% 
    fill(col_name, .direction = "up") %>% 
    group_by(cb_col_name) %>% 
    filter(row_number() == 1) %>% 
    # cb_col_name is currently NA for the first row of each section.
    # Drop those rows.
    filter(!is.na(cb_col_name)) %>% 
    # Add the copy and paste values to the data frame
    mutate(
      copy_and_paste = if_else(
        is.na(col_name), cb_col_name, 
        paste(col_name, cb_col_name, sep = " = ")
      )
    )
}

