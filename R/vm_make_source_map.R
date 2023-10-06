vm_make_source_map <- function(source_list, dropping_list, num, col_name,
                            incl_keys, excl_keys){
  # Get source name for indexing
  source_name <- names(source_list)[[num]]
  
  # Extract variables. Exclude variables with known drop.
  vars <- source_list[[source_name]] %>%
    select(all_of(starts_with(incl_keys$starts_with)),
           all_of(contains(incl_keys$contains))
    ) %>%
    select(-c(
      all_of(starts_with(excl_keys$starts_with)),
      all_of(contains(excl_keys$contains))
      )
    ) %>%
    select(-any_of(dropping[[source_name]])
    ) %>%
    names()
  
  # Make output tibble
  source_map <- tibble::tibble(
    'new_col' = vars,
    'variable' = standardize_col_names(vars)
  ) %>%
    rename_at('new_col', ~col_name)
  
  # Return output tibble
  source_map
}